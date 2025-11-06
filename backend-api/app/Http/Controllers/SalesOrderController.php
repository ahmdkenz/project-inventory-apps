<?php

namespace App\Http\Controllers;

use App\Models\SalesOrder;
use App\Models\SalesOrderItem;
use App\Models\Barang;
use App\Models\NonPoIssue;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Carbon\Carbon;
use App\Http\Controllers\AuditLogController;

class SalesOrderController extends Controller
{
    // Staff: Get all sales orders (including own Non-SO)
    public function index(Request $request)
    {
        try {
            $userId = $request->user()->id;
            $status = $request->get('status', '');
            $search = $request->get('search', '');
            $dateFrom = $request->get('date_from', '');
            $dateTo = $request->get('date_to', '');
            $type = $request->get('type', ''); // '', 'so', 'non-so'

            $allOrders = collect();

            // Get regular Sales Orders (own only)
            if ($type === '' || $type === 'so') {
                $soQuery = SalesOrder::with(['items.barang', 'creator', 'approver'])
                    ->where('created_by', $userId);

                if ($status !== '') {
                    $soQuery->where('status', $status);
                }

                if ($dateFrom !== '') {
                    $soQuery->whereDate('tgl_order', '>=', $dateFrom);
                }

                if ($dateTo !== '') {
                    $soQuery->whereDate('tgl_order', '<=', $dateTo);
                }

                if ($search !== '') {
                    $soQuery->where(function($q) use ($search) {
                        $q->where('no_so', 'like', "%{$search}%")
                          ->orWhere('customer_name', 'like', "%{$search}%");
                    });
                }

                $salesOrders = $soQuery->orderBy('created_at', 'desc')->get();
                $allOrders = $allOrders->merge($salesOrders);
            }

            // Get Non-SO Issues (own only)
            if ($type === '' || $type === 'non-so') {
                $nonSoQuery = NonPoIssue::with(['items.barang', 'creator', 'approver'])
                    ->where('created_by', $userId);

                if ($status !== '') {
                    $nonSoQuery->where('status', $status);
                }

                if ($dateFrom !== '') {
                    $nonSoQuery->whereDate('issue_date', '>=', $dateFrom);
                }

                if ($dateTo !== '') {
                    $nonSoQuery->whereDate('issue_date', '<=', $dateTo);
                }

                if ($search !== '') {
                    $nonSoQuery->where(function($q) use ($search) {
                        $q->where('no_dokumen', 'like', "%{$search}%")
                          ->orWhere('recipient', 'like', "%{$search}%");
                    });
                }

                $nonSoIssues = $nonSoQuery->orderBy('created_at', 'desc')->get()->map(function ($issue) {
                    // Transform Non-SO to match SO structure for frontend
                    // Transform OUT-NON- to SO-NON- for display in Sales Order list
                    $noSo = str_replace('OUT-NON-', 'SO-NON-', $issue->no_dokumen);
                    
                    return (object)[
                        'id' => $issue->id,
                        'type' => 'non-so', // Add type identifier
                        'no_so' => $noSo, // Map no_dokumen to no_so with SO-NON- prefix
                        'customer_name' => $issue->recipient, // Map recipient to customer_name
                        'customer_phone' => null,
                        'customer_address' => null,
                        'tgl_order' => $issue->issue_date, // Map issue_date to tgl_order
                        'tgl_kirim' => null,
                        'catatan' => $issue->notes,
                        'status' => $issue->status,
                        'subtotal' => $issue->subtotal ?? 0,
                        'ppn' => $issue->ppn ?? 0,
                        'total' => $issue->total ?? 0,
                        'created_by' => $issue->created_by,
                        'approved_by' => $issue->approved_by,
                        'approved_at' => $issue->approved_at,
                        'reject_reason' => $issue->reject_reason,
                        'created_at' => $issue->created_at,
                        'updated_at' => $issue->updated_at,
                        'items' => $issue->items,
                        'creator' => $issue->creator,
                        'approver' => $issue->approver
                    ];
                });

                $allOrders = $allOrders->merge($nonSoIssues);
            }

            // Sort by created_at desc
            $allOrders = $allOrders->sortByDesc('created_at')->values();

            return response()->json([
                'success' => true,
                'data' => $allOrders
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch sales orders: ' . $e->getMessage()
            ], 500);
        }
    }

    // Staff: Get single sales order or non-so detail (own only)
    public function show(Request $request, $id)
    {
        try {
            $userId = $request->user()->id;
            $type = $request->get('type', 'so'); // default 'so', pass 'non-so' for Non-SO Issue

            if ($type === 'non-so') {
                $issue = NonPoIssue::with(['items.barang', 'creator', 'approver'])
                    ->where('id', $id)
                    ->where('created_by', $userId)
                    ->firstOrFail();

                // Transform Non-SO to match SO structure for frontend
                // Transform OUT-NON- to SO-NON- for display
                $noSo = str_replace('OUT-NON-', 'SO-NON-', $issue->no_dokumen);
                
                $detail = [
                    'id' => $issue->id,
                    'type' => 'non-so',
                    'no_so' => $noSo,
                    'customer_name' => $issue->recipient,
                    'customer_phone' => null,
                    'customer_address' => null,
                    'tgl_order' => $issue->issue_date,
                    'tgl_kirim' => null,
                    'catatan' => $issue->notes,
                    'catatan_pengeluaran' => $issue->notes,
                    'no_surat_jalan' => null,
                    'status' => $issue->status,
                    'subtotal' => $issue->subtotal ?? 0,
                    'ppn' => $issue->ppn ?? 0,
                    'total' => $issue->total ?? 0,
                    'created_by' => $issue->created_by,
                    'approved_by' => $issue->approved_by,
                    'approved_at' => $issue->approved_at,
                    'completed_at' => $issue->approved_at,
                    'reject_reason' => $issue->reject_reason,
                    'created_at' => $issue->created_at,
                    'updated_at' => $issue->updated_at,
                    'items' => $issue->items->map(function($item) {
                        return [
                            'id' => $item->id,
                            'sales_order_id' => $item->non_po_issue_id,
                            'barang_id' => $item->barang_id,
                            'qty' => $item->qty,
                            'qty_issued' => $item->qty,
                            'harga_satuan' => $item->harga_satuan ?? 0,
                            'subtotal' => $item->subtotal ?? 0,
                            'barang' => $item->barang,
                            'created_at' => $item->created_at,
                            'updated_at' => $item->updated_at
                        ];
                    }),
                    'creator' => $issue->creator,
                    'approver' => $issue->approver
                ];

                return response()->json([
                    'success' => true,
                    'data' => $detail
                ]);
            }

            // Default: regular Sales Order
            $salesOrder = SalesOrder::with(['items.barang', 'creator', 'approver'])
                ->where('id', $id)
                ->where('created_by', $userId)
                ->firstOrFail();

            return response()->json([
                'success' => true,
                'data' => $salesOrder
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Sales order not found'
            ], 404);
        }
    }

    // Staff: Create sales order
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'customer_name' => 'required|string|max:255',
            'customer_phone' => 'nullable|string|max:20',
            'customer_address' => 'nullable|string',
            'tgl_order' => 'required|date',
            'tgl_kirim' => 'required|date|after_or_equal:tgl_order',
            'catatan' => 'nullable|string',
            'items' => 'required|array|min:1',
            'items.*.barang_id' => 'required|exists:barang,id',
            'items.*.qty' => 'required|integer|min:1',
            'items.*.harga_satuan' => 'required|numeric|min:0',
            'subtotal' => 'required|numeric',
            'ppn' => 'required|numeric',
            'total' => 'required|numeric',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        DB::beginTransaction();
        try {
            // Check stock availability
            foreach ($request->items as $item) {
                $barang = Barang::find($item['barang_id']);
                if (!$barang) {
                    throw new \Exception("Barang dengan ID {$item['barang_id']} tidak ditemukan");
                }
                if ($barang->stok < $item['qty']) {
                    throw new \Exception("Stok {$barang->nama} tidak mencukupi. Stok tersedia: {$barang->stok}");
                }
            }

            // Generate SO number
            $noSO = $this->generateSONumber();

            // Create sales order
            $salesOrder = SalesOrder::create([
                'no_so' => $noSO,
                'customer_name' => $request->customer_name,
                'customer_phone' => $request->customer_phone,
                'customer_address' => $request->customer_address,
                'tgl_order' => $request->tgl_order,
                'tgl_kirim' => $request->tgl_kirim,
                'catatan' => $request->catatan,
                'status' => 'pending',
                'subtotal' => $request->subtotal,
                'ppn' => $request->ppn,
                'total' => $request->total,
                'created_by' => $request->user()->id,
            ]);

            // Create sales order items
            foreach ($request->items as $item) {
                SalesOrderItem::create([
                    'sales_order_id' => $salesOrder->id,
                    'barang_id' => $item['barang_id'],
                    'qty' => $item['qty'],
                    'harga_satuan' => $item['harga_satuan'],
                    'subtotal' => $item['qty'] * $item['harga_satuan'],
                ]);
            }

            DB::commit();

            $salesOrder->load(['items.barang', 'creator']);

            // Log activity
            AuditLogController::log(
                'create',
                "Membuat Sales Order baru {$salesOrder->no_so} untuk customer {$salesOrder->customer_name}",
                'SalesOrder',
                $salesOrder->id
            );

            return response()->json([
                'success' => true,
                'message' => 'Sales order created successfully',
                'data' => $salesOrder
            ], 201);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    // Staff: Update sales order (only if pending)
    public function update(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'customer_name' => 'required|string|max:255',
            'customer_phone' => 'nullable|string|max:20',
            'customer_address' => 'nullable|string',
            'tgl_order' => 'required|date',
            'tgl_kirim' => 'required|date|after_or_equal:tgl_order',
            'catatan' => 'nullable|string',
            'items' => 'required|array|min:1',
            'items.*.barang_id' => 'required|exists:barang,id',
            'items.*.qty' => 'required|integer|min:1',
            'items.*.harga_satuan' => 'required|numeric|min:0',
            'subtotal' => 'required|numeric',
            'ppn' => 'required|numeric',
            'total' => 'required|numeric',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        DB::beginTransaction();
        try {
            $salesOrder = SalesOrder::where('id', $id)
                ->where('created_by', $request->user()->id)
                ->firstOrFail();

            // Only allow update if status is pending
            if ($salesOrder->status !== 'pending') {
                return response()->json([
                    'success' => false,
                    'message' => 'Cannot update sales order. Status is not pending.'
                ], 403);
            }

            // Check stock availability
            foreach ($request->items as $item) {
                $barang = Barang::find($item['barang_id']);
                if (!$barang) {
                    throw new \Exception("Barang dengan ID {$item['barang_id']} tidak ditemukan");
                }
                if ($barang->stok < $item['qty']) {
                    throw new \Exception("Stok {$barang->nama} tidak mencukupi. Stok tersedia: {$barang->stok}");
                }
            }

            // Update sales order
            $salesOrder->update([
                'customer_name' => $request->customer_name,
                'customer_phone' => $request->customer_phone,
                'customer_address' => $request->customer_address,
                'tgl_order' => $request->tgl_order,
                'tgl_kirim' => $request->tgl_kirim,
                'catatan' => $request->catatan,
                'subtotal' => $request->subtotal,
                'ppn' => $request->ppn,
                'total' => $request->total,
            ]);

            // Delete old items and create new ones
            $salesOrder->items()->delete();
            foreach ($request->items as $item) {
                SalesOrderItem::create([
                    'sales_order_id' => $salesOrder->id,
                    'barang_id' => $item['barang_id'],
                    'qty' => $item['qty'],
                    'harga_satuan' => $item['harga_satuan'],
                    'subtotal' => $item['qty'] * $item['harga_satuan'],
                ]);
            }

            DB::commit();

            $salesOrder->load(['items.barang', 'creator']);

            return response()->json([
                'success' => true,
                'message' => 'Sales order updated successfully',
                'data' => $salesOrder
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    // Staff: Delete sales order (only if pending)
    public function destroy(Request $request, $id)
    {
        try {
            $salesOrder = SalesOrder::where('id', $id)
                ->where('created_by', $request->user()->id)
                ->firstOrFail();

            // Only allow delete if status is pending
            if ($salesOrder->status !== 'pending') {
                return response()->json([
                    'success' => false,
                    'message' => 'Cannot delete sales order. Status is not pending.'
                ], 403);
            }

            $salesOrder->delete();

            return response()->json([
                'success' => true,
                'message' => 'Sales order deleted successfully'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Sales order not found'
            ], 404);
        }
    }

    // Admin: Get all sales orders (including Non-SO Issues)
    public function adminIndex(Request $request)
    {
        try {
            $status = $request->get('status', '');
            $search = $request->get('search', '');
            $dateFrom = $request->get('date_from', '');
            $dateTo = $request->get('date_to', '');
            $type = $request->get('type', ''); // '', 'so', 'non-so'

            $allOrders = collect();

            // Get regular Sales Orders
            if ($type === '' || $type === 'so') {
                $soQuery = SalesOrder::with(['items.barang', 'creator', 'approver']);

                if ($status !== '') {
                    $soQuery->where('status', $status);
                }

                if ($dateFrom !== '') {
                    $soQuery->whereDate('tgl_order', '>=', $dateFrom);
                }

                if ($dateTo !== '') {
                    $soQuery->whereDate('tgl_order', '<=', $dateTo);
                }

                if ($search !== '') {
                    $soQuery->where(function($q) use ($search) {
                        $q->where('no_so', 'like', "%{$search}%")
                          ->orWhere('customer_name', 'like', "%{$search}%");
                    });
                }

                $salesOrders = $soQuery->orderBy('created_at', 'desc')->get();
                $allOrders = $allOrders->merge($salesOrders);
            }

            // Get Non-SO Issues
            if ($type === '' || $type === 'non-so') {
                $nonSoQuery = NonPoIssue::with(['items.barang', 'creator', 'approver']);

                if ($status !== '') {
                    $nonSoQuery->where('status', $status);
                }

                if ($dateFrom !== '') {
                    $nonSoQuery->whereDate('issue_date', '>=', $dateFrom);
                }

                if ($dateTo !== '') {
                    $nonSoQuery->whereDate('issue_date', '<=', $dateTo);
                }

                if ($search !== '') {
                    $nonSoQuery->where(function($q) use ($search) {
                        $q->where('no_dokumen', 'like', "%{$search}%")
                          ->orWhere('recipient', 'like', "%{$search}%");
                    });
                }

                $nonSoIssues = $nonSoQuery->orderBy('created_at', 'desc')->get()->map(function ($issue) {
                    // Transform Non-SO to match SO structure for frontend
                    // Transform OUT-NON- to SO-NON- for display in Sales Order list
                    $noSo = str_replace('OUT-NON-', 'SO-NON-', $issue->no_dokumen);
                    
                    return (object)[
                        'id' => $issue->id,
                        'type' => 'non-so', // Add type identifier
                        'no_so' => $noSo, // Map no_dokumen to no_so with SO-NON- prefix
                        'customer_name' => $issue->recipient, // Map recipient to customer_name
                        'customer_phone' => null,
                        'customer_address' => null,
                        'tgl_order' => $issue->issue_date, // Map issue_date to tgl_order
                        'tgl_kirim' => null,
                        'catatan' => $issue->notes,
                        'status' => $issue->status,
                        'subtotal' => $issue->subtotal ?? 0,
                        'ppn' => $issue->ppn ?? 0,
                        'total' => $issue->total ?? 0,
                        'created_by' => $issue->created_by,
                        'approved_by' => $issue->approved_by,
                        'approved_at' => $issue->approved_at,
                        'reject_reason' => $issue->reject_reason,
                        'created_at' => $issue->created_at,
                        'updated_at' => $issue->updated_at,
                        'items' => $issue->items,
                        'creator' => $issue->creator,
                        'approver' => $issue->approver
                    ];
                });

                $allOrders = $allOrders->merge($nonSoIssues);
            }

            // Sort by created_at desc
            $allOrders = $allOrders->sortByDesc('created_at')->values();

            return response()->json([
                'success' => true,
                'data' => $allOrders
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch sales orders: ' . $e->getMessage()
            ], 500);
        }
    }

    // Admin: Get single sales order or non-so detail
    public function adminShow(Request $request, $id)
    {
        try {
            $type = $request->get('type', 'so'); // default 'so', pass 'non-so' for Non-SO Issue

            if ($type === 'non-so') {
                $issue = NonPoIssue::with(['items.barang', 'creator', 'approver'])
                    ->findOrFail($id);

                // Transform Non-SO to match SO structure for frontend
                // Transform OUT-NON- to SO-NON- for display
                $noSo = str_replace('OUT-NON-', 'SO-NON-', $issue->no_dokumen);
                
                $detail = [
                    'id' => $issue->id,
                    'type' => 'non-so',
                    'no_so' => $noSo,
                    'customer_name' => $issue->recipient,
                    'customer_phone' => null,
                    'customer_address' => null,
                    'tgl_order' => $issue->issue_date,
                    'tgl_kirim' => null,
                    'catatan' => $issue->notes,
                    'catatan_pengeluaran' => $issue->notes,
                    'no_surat_jalan' => null,
                    'status' => $issue->status,
                    'subtotal' => $issue->subtotal ?? 0,
                    'ppn' => $issue->ppn ?? 0,
                    'total' => $issue->total ?? 0,
                    'created_by' => $issue->created_by,
                    'approved_by' => $issue->approved_by,
                    'approved_at' => $issue->approved_at,
                    'completed_at' => $issue->approved_at,
                    'reject_reason' => $issue->reject_reason,
                    'created_at' => $issue->created_at,
                    'updated_at' => $issue->updated_at,
                    'items' => $issue->items->map(function($item) {
                        return [
                            'id' => $item->id,
                            'sales_order_id' => $item->non_po_issue_id,
                            'barang_id' => $item->barang_id,
                            'qty' => $item->qty,
                            'qty_issued' => $item->qty,
                            'harga_satuan' => $item->harga_satuan ?? 0,
                            'subtotal' => $item->subtotal ?? 0,
                            'barang' => $item->barang,
                            'created_at' => $item->created_at,
                            'updated_at' => $item->updated_at
                        ];
                    }),
                    'creator' => $issue->creator,
                    'approver' => $issue->approver
                ];

                return response()->json([
                    'success' => true,
                    'data' => $detail
                ]);
            }

            // Default: regular Sales Order
            $salesOrder = SalesOrder::with(['items.barang', 'creator', 'approver'])
                ->findOrFail($id);

            return response()->json([
                'success' => true,
                'data' => $salesOrder
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Sales order not found'
            ], 404);
        }
    }

    // Admin: Approve sales order
    public function approve(Request $request, $id)
    {
        DB::beginTransaction();
        try {
            $salesOrder = SalesOrder::with('items.barang')->findOrFail($id);

            if ($salesOrder->status !== 'pending') {
                return response()->json([
                    'success' => false,
                    'message' => 'Sales order is not in pending status'
                ], 400);
            }

            // Check stock availability again before approval
            foreach ($salesOrder->items as $item) {
                if ($item->barang->stok < $item->qty) {
                    throw new \Exception("Stok {$item->barang->nama} tidak mencukupi. Stok tersedia: {$item->barang->stok}");
                }
            }

            // Update sales order status
            $salesOrder->update([
                'status' => 'approved',
                'approved_by' => $request->user()->id,
                'approved_at' => now(),
                'reject_reason' => null,
            ]);

            // Reduce stock
            foreach ($salesOrder->items as $item) {
                $item->barang->decrement('stok', $item->qty);
            }

            DB::commit();

            $salesOrder->load(['items.barang', 'creator', 'approver']);

            // Log activity
            AuditLogController::log(
                'approve',
                "Menyetujui Sales Order {$salesOrder->no_so} untuk customer {$salesOrder->customer_name}",
                'SalesOrder',
                $salesOrder->id
            );

            return response()->json([
                'success' => true,
                'message' => 'Sales order approved successfully',
                'data' => $salesOrder
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    // Admin: Reject sales order
    public function reject(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'reject_reason' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Reject reason is required',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $salesOrder = SalesOrder::findOrFail($id);

            if ($salesOrder->status !== 'pending') {
                return response()->json([
                    'success' => false,
                    'message' => 'Sales order is not in pending status'
                ], 400);
            }

            $salesOrder->update([
                'status' => 'rejected',
                'reject_reason' => $request->reject_reason,
                'approved_by' => $request->user()->id,
                'approved_at' => now(),
            ]);

            $salesOrder->load(['items.barang', 'creator', 'approver']);

            // Log activity
            $reason = $request->reject_reason ? ": {$request->reject_reason}" : '';
            AuditLogController::log(
                'reject',
                "Menolak Sales Order {$salesOrder->no_so} untuk customer {$salesOrder->customer_name}{$reason}",
                'SalesOrder',
                $salesOrder->id
            );

            return response()->json([
                'success' => true,
                'message' => 'Sales order rejected',
                'data' => $salesOrder
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Sales order not found'
            ], 404);
        }
    }

    // Admin: Process sales order (issue goods)
    public function process(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'no_surat_jalan' => 'required|string',
            'items' => 'required|array|min:1',
            'items.*.item_id' => 'required|integer',
            'items.*.barang_id' => 'required|exists:barang,id',
            'items.*.qty_issued' => 'required|integer|min:1',
            'catatan' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        DB::beginTransaction();
        try {
            $salesOrder = SalesOrder::with('items.barang')->findOrFail($id);

            if ($salesOrder->status !== 'approved') {
                return response()->json([
                    'success' => false,
                    'message' => 'Sales order is not in approved status'
                ], 400);
            }

            // Update stock and items
            foreach ($request->items as $item) {
                $barang = Barang::findOrFail($item['barang_id']);
                
                // Check stock availability
                if ($barang->stok < $item['qty_issued']) {
                    throw new \Exception("Stok {$barang->nama} tidak mencukupi. Stok tersedia: {$barang->stok}");
                }

                // Reduce stock
                $barang->decrement('stok', $item['qty_issued']);

                // Update SO item
                $soItem = SalesOrderItem::where('sales_order_id', $salesOrder->id)
                    ->where('id', $item['item_id'])
                    ->first();
                    
                if ($soItem) {
                    $soItem->update([
                        'qty_issued' => $item['qty_issued']
                    ]);
                }
            }

            // Update sales order status
            $salesOrder->update([
                'status' => 'completed',
                'completed_at' => now(),
                'no_surat_jalan' => $request->no_surat_jalan,
                'catatan_pengeluaran' => $request->catatan,
            ]);

            DB::commit();

            $salesOrder->load(['items.barang', 'creator', 'approver']);

            // Log activity
            AuditLogController::log(
                'process',
                "Memproses pengeluaran barang untuk Sales Order {$salesOrder->no_so}",
                'SalesOrder',
                $salesOrder->id
            );

            return response()->json([
                'success' => true,
                'message' => 'Sales order processed successfully',
                'data' => $salesOrder
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    // Get outgoing items (completed SO) - for both Admin and Staff
    public function outgoingItems(Request $request)
    {
        try {
            $perPage = $request->get('per_page', 10);
            $page = $request->get('page', 1);
            $search = $request->get('search', '');
            $type = $request->get('type', '');
            $startDate = $request->get('start_date', '');
            $endDate = $request->get('end_date', '');
            $user = $request->user();

            // Collect all outgoing items (SO + Non-SO)
            $allItems = collect();

            // Get SO outgoing items (if not filtering for non-so only)
            if ($type === '' || $type === 'so') {
                $soQuery = SalesOrder::with(['creator'])
                    ->where('status', 'completed');

                // If staff, only show their own SO
                if ($user->role === 'staff') {
                    $soQuery->where('created_by', $user->id);
                }

                // Apply filters
                if ($startDate) {
                    $soQuery->whereDate('completed_at', '>=', $startDate);
                }
                if ($endDate) {
                    $soQuery->whereDate('completed_at', '<=', $endDate);
                }
                if ($search) {
                    $soQuery->where(function($q) use ($search) {
                        $q->where('no_so', 'like', "%{$search}%")
                          ->orWhere('customer_name', 'like', "%{$search}%");
                    });
                }

                $soItems = $soQuery->get()->map(function ($so) {
                    return [
                        'id' => 'so_' . $so->id,
                        'original_id' => $so->id,
                        'no_dokumen' => $this->generateOutDocNumber($so),
                        'tanggal' => $so->completed_at ? $so->completed_at->format('Y-m-d') : $so->approved_at->format('Y-m-d'),
                        'tanggal_sort' => $so->completed_at ? $so->completed_at : $so->approved_at,
                        'tipe' => 'so',
                        'no_referensi' => $so->no_so,
                        'penerima' => $so->customer_name,
                        'dicatat_oleh' => $so->creator->name ?? '-'
                    ];
                });

                $allItems = $allItems->merge($soItems);
            }

            // Get Non-SO outgoing items (if not filtering for so only)
            if ($type === '' || $type === 'non-so') {
                $nonSoQuery = NonPoIssue::with(['creator'])
                    ->where('status', 'completed'); // Only show completed Non-SO

                // If staff, only show their own Non-SO
                if ($user->role === 'staff') {
                    $nonSoQuery->where('created_by', $user->id);
                }

                // Apply filters
                if ($startDate) {
                    $nonSoQuery->whereDate('issue_date', '>=', $startDate);
                }
                if ($endDate) {
                    $nonSoQuery->whereDate('issue_date', '<=', $endDate);
                }
                if ($search) {
                    $nonSoQuery->where(function($q) use ($search) {
                        $q->where('no_dokumen', 'like', "%{$search}%")
                          ->orWhere('recipient', 'like', "%{$search}%");
                    });
                }

                $nonSoItems = $nonSoQuery->get()->map(function ($issue) {
                    return [
                        'id' => 'non_so_' . $issue->id,
                        'original_id' => $issue->id,
                        'no_dokumen' => $issue->no_dokumen,
                        'tanggal' => $issue->issue_date,
                        'tanggal_sort' => Carbon::parse($issue->issue_date),
                        'tipe' => 'non-so',
                        'no_referensi' => $issue->no_dokumen,
                        'penerima' => $issue->recipient ?? '-',
                        'dicatat_oleh' => $issue->creator->name ?? '-'
                    ];
                });

                $allItems = $allItems->merge($nonSoItems);
            }

            // Sort by date (newest first)
            $allItems = $allItems->sortByDesc('tanggal_sort')->values();

            // Manual pagination
            $total = $allItems->count();
            $lastPage = ceil($total / $perPage);
            $offset = ($page - 1) * $perPage;
            $paginatedItems = $allItems->slice($offset, $perPage)->values();

            return response()->json([
                'success' => true,
                'data' => $paginatedItems,
                'meta' => [
                    'current_page' => (int) $page,
                    'last_page' => (int) $lastPage,
                    'per_page' => (int) $perPage,
                    'total' => $total
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan: ' . $e->getMessage()
            ], 500);
        }
    }

    // Admin: Get outgoing item detail
    public function outgoingItemDetail($id)
    {
        try {
            $salesOrder = SalesOrder::with(['items.barang', 'creator', 'approver'])
                ->where('status', 'completed')
                ->findOrFail($id);

            // Add outgoing_item structure
            $salesOrder->outgoing_item = [
                'no_dokumen' => $this->generateOutDocNumber($salesOrder),
                'tanggal' => $salesOrder->completed_at ? $salesOrder->completed_at->format('Y-m-d') : $salesOrder->approved_at->format('Y-m-d'),
                'dicatat_oleh' => $salesOrder->creator->name ?? '-',
                'catatan' => $salesOrder->catatan_pengeluaran,
                'items' => $salesOrder->items
            ];

            return response()->json([
                'success' => true,
                'message' => 'Data barang keluar berhasil diambil',
                'data' => $salesOrder
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Data tidak ditemukan'
            ], 404);
        }
    }

    // Generate SO number
    private function generateSONumber()
    {
        $prefix = 'SO-';
        $yearMonth = Carbon::now()->format('Ym');
        
        $lastSO = SalesOrder::where('no_so', 'like', $prefix . $yearMonth . '%')
            ->orderBy('no_so', 'desc')
            ->first();

        if ($lastSO) {
            $lastNumber = intval(substr($lastSO->no_so, -4));
            $newNumber = $lastNumber + 1;
        } else {
            $newNumber = 1;
        }

        return $prefix . $yearMonth . '-' . str_pad($newNumber, 4, '0', STR_PAD_LEFT);
    }

    // Generate OUT document number
    private function generateOutDocNumber($salesOrder)
    {
        $date = $salesOrder->completed_at ? $salesOrder->completed_at : now();
        $yearMonth = $date->format('Ym');
        return 'OUT-' . $yearMonth . '-' . str_pad($salesOrder->id, 4, '0', STR_PAD_LEFT);
    }
}
