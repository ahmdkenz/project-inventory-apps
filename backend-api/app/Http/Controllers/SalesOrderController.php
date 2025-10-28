<?php

namespace App\Http\Controllers;

use App\Models\SalesOrder;
use App\Models\SalesOrderItem;
use App\Models\Barang;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Carbon\Carbon;
use App\Http\Controllers\AuditLogController;

class SalesOrderController extends Controller
{
    // Staff: Get all sales orders
    public function index(Request $request)
    {
        try {
            $query = SalesOrder::with(['items.barang', 'creator', 'approver'])
                ->where('created_by', $request->user()->id);

            // Filter by status
            if ($request->has('status') && $request->status != '') {
                $query->where('status', $request->status);
            }

            // Filter by date range
            if ($request->has('date_from') && $request->date_from != '') {
                $query->whereDate('tgl_order', '>=', $request->date_from);
            }
            if ($request->has('date_to') && $request->date_to != '') {
                $query->whereDate('tgl_order', '<=', $request->date_to);
            }

            // Search
            if ($request->has('search') && $request->search != '') {
                $search = $request->search;
                $query->where(function($q) use ($search) {
                    $q->where('no_so', 'like', "%{$search}%")
                      ->orWhere('customer_name', 'like', "%{$search}%");
                });
            }

            $salesOrders = $query->orderBy('created_at', 'desc')->get();

            return response()->json([
                'success' => true,
                'data' => $salesOrders
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch sales orders: ' . $e->getMessage()
            ], 500);
        }
    }

    // Staff: Get single sales order
    public function show(Request $request, $id)
    {
        try {
            $salesOrder = SalesOrder::with(['items.barang', 'creator', 'approver'])
                ->where('id', $id)
                ->where('created_by', $request->user()->id)
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

    // Admin: Get all sales orders
    public function adminIndex(Request $request)
    {
        try {
            $query = SalesOrder::with(['items.barang', 'creator', 'approver']);

            // Filter by status
            if ($request->has('status') && $request->status != '') {
                $query->where('status', $request->status);
            }

            // Filter by date range
            if ($request->has('date_from') && $request->date_from != '') {
                $query->whereDate('tgl_order', '>=', $request->date_from);
            }
            if ($request->has('date_to') && $request->date_to != '') {
                $query->whereDate('tgl_order', '<=', $request->date_to);
            }

            // Search
            if ($request->has('search') && $request->search != '') {
                $search = $request->search;
                $query->where(function($q) use ($search) {
                    $q->where('no_so', 'like', "%{$search}%")
                      ->orWhere('customer_name', 'like', "%{$search}%");
                });
            }

            $salesOrders = $query->orderBy('created_at', 'desc')->get();

            return response()->json([
                'success' => true,
                'data' => $salesOrders
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch sales orders: ' . $e->getMessage()
            ], 500);
        }
    }

    // Admin: Get single sales order
    public function adminShow($id)
    {
        try {
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
}
