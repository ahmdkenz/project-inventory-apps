<?php

namespace App\Http\Controllers;

use App\Models\PurchaseOrder;
use App\Models\PurchaseOrderItem;
use App\Models\Barang;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use App\Http\Controllers\AuditLogController;

class PurchaseOrderController extends Controller
{
    /**
     * Display a listing of purchase orders (Staff)
     */
    public function index(Request $request)
    {
        try {
            $query = PurchaseOrder::with(['supplier', 'items.barang', 'creator'])
                ->where('created_by', $request->user()->id);

            // Filter by status
            if ($request->has('status') && $request->status != '') {
                $query->where('status', $request->status);
            }

            // Filter by date range
            if ($request->has('date_from')) {
                $query->whereDate('tgl_pesan', '>=', $request->date_from);
            }
            if ($request->has('date_to')) {
                $query->whereDate('tgl_pesan', '<=', $request->date_to);
            }

            // Search
            if ($request->has('search')) {
                $search = $request->search;
                $query->where(function($q) use ($search) {
                    $q->where('no_po', 'like', "%{$search}%")
                      ->orWhereHas('supplier', function($sq) use ($search) {
                          $sq->where('nama', 'like', "%{$search}%");
                      });
                });
            }

            $purchaseOrders = $query->orderBy('created_at', 'desc')->get();

            return response()->json([
                'success' => true,
                'message' => 'Data purchase orders berhasil diambil',
                'data' => $purchaseOrders
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Store a newly created purchase order
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'supplier_id' => 'required|exists:suppliers,id',
            'tgl_pesan' => 'required|date',
            'tgl_estimasi' => 'required|date|after_or_equal:tgl_pesan',
            'catatan' => 'nullable|string',
            'items' => 'required|array|min:1',
            'items.*.barang_id' => 'required|exists:barang,id',
            'items.*.qty' => 'required|integer|min:1',
            'items.*.harga_satuan' => 'required|numeric|min:0',
            'subtotal' => 'required|numeric|min:0',
            'total' => 'required|numeric|min:0',
        ], [
            'supplier_id.required' => 'Supplier harus dipilih',
            'supplier_id.exists' => 'Supplier tidak valid',
            'tgl_pesan.required' => 'Tanggal pesan harus diisi',
            'tgl_estimasi.required' => 'Tanggal estimasi harus diisi',
            'tgl_estimasi.after_or_equal' => 'Tanggal estimasi harus setelah atau sama dengan tanggal pesan',
            'items.required' => 'Minimal harus ada 1 barang',
            'items.min' => 'Minimal harus ada 1 barang',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        DB::beginTransaction();
        try {
            // Generate PO number
            $noPO = PurchaseOrder::generatePONumber();

            // Create purchase order
            $purchaseOrder = PurchaseOrder::create([
                'no_po' => $noPO,
                'supplier_id' => $request->supplier_id,
                'tgl_pesan' => $request->tgl_pesan,
                'tgl_estimasi' => $request->tgl_estimasi,
                'catatan' => $request->catatan,
                'status' => 'pending',
                'subtotal' => $request->subtotal,
                'ppn' => 0,
                'total' => $request->total,
                'created_by' => $request->user()->id,
            ]);

            // Create purchase order items
            foreach ($request->items as $item) {
                PurchaseOrderItem::create([
                    'purchase_order_id' => $purchaseOrder->id,
                    'barang_id' => $item['barang_id'],
                    'qty' => $item['qty'],
                    'harga_satuan' => $item['harga_satuan'],
                    'subtotal' => $item['qty'] * $item['harga_satuan'],
                ]);
            }

            DB::commit();

            // Log activity
            AuditLogController::log(
                'create',
                'membuat Purchase Order: ' . $purchaseOrder->no_po . ' untuk supplier ' . $purchaseOrder->supplier->nama,
                'PurchaseOrder',
                $purchaseOrder->id
            );

            $purchaseOrder->load(['supplier', 'items.barang']);

            return response()->json([
                'success' => true,
                'message' => 'Purchase order berhasil dibuat dan menunggu persetujuan admin',
                'data' => $purchaseOrder
            ], 201);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Gagal membuat purchase order: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Display the specified purchase order
     */
    public function show(Request $request, $id)
    {
        try {
            $purchaseOrder = PurchaseOrder::with(['supplier', 'items.barang', 'creator', 'approver'])
                ->where('created_by', $request->user()->id)
                ->findOrFail($id);

            return response()->json([
                'success' => true,
                'message' => 'Data purchase order berhasil diambil',
                'data' => $purchaseOrder
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Purchase order tidak ditemukan'
            ], 404);
        }
    }

    /**
     * Update the specified purchase order (only if status is pending)
     */
    public function update(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'supplier_id' => 'required|exists:suppliers,id',
            'tgl_pesan' => 'required|date',
            'tgl_estimasi' => 'required|date|after_or_equal:tgl_pesan',
            'catatan' => 'nullable|string',
            'items' => 'required|array|min:1',
            'items.*.barang_id' => 'required|exists:barang,id',
            'items.*.qty' => 'required|integer|min:1',
            'items.*.harga_satuan' => 'required|numeric|min:0',
            'subtotal' => 'required|numeric|min:0',
            'total' => 'required|numeric|min:0',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        DB::beginTransaction();
        try {
            $purchaseOrder = PurchaseOrder::where('created_by', $request->user()->id)
                ->where('status', 'pending')
                ->findOrFail($id);

            // Update purchase order
            $purchaseOrder->update([
                'supplier_id' => $request->supplier_id,
                'tgl_pesan' => $request->tgl_pesan,
                'tgl_estimasi' => $request->tgl_estimasi,
                'catatan' => $request->catatan,
                'subtotal' => $request->subtotal,
                'ppn' => 0,
                'total' => $request->total,
            ]);

            // Delete existing items
            $purchaseOrder->items()->delete();

            // Create new items
            foreach ($request->items as $item) {
                PurchaseOrderItem::create([
                    'purchase_order_id' => $purchaseOrder->id,
                    'barang_id' => $item['barang_id'],
                    'qty' => $item['qty'],
                    'harga_satuan' => $item['harga_satuan'],
                    'subtotal' => $item['qty'] * $item['harga_satuan'],
                ]);
            }

            DB::commit();

            $purchaseOrder->load(['supplier', 'items.barang']);

            return response()->json([
                'success' => true,
                'message' => 'Purchase order berhasil diupdate',
                'data' => $purchaseOrder
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengupdate purchase order: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Remove the specified purchase order (only if status is pending)
     */
    public function destroy(Request $request, $id)
    {
        try {
            $purchaseOrder = PurchaseOrder::where('created_by', $request->user()->id)
                ->where('status', 'pending')
                ->findOrFail($id);

            $purchaseOrder->delete();

            return response()->json([
                'success' => true,
                'message' => 'Purchase order berhasil dihapus'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menghapus purchase order: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get all purchase orders for admin
     */
    public function adminIndex(Request $request)
    {
        try {
            $query = PurchaseOrder::with(['supplier', 'items.barang', 'creator']);

            // Filter by status
            if ($request->has('status') && $request->status != '') {
                $query->where('status', $request->status);
            }

            // Search
            if ($request->has('search')) {
                $search = $request->search;
                $query->where(function($q) use ($search) {
                    $q->where('no_po', 'like', "%{$search}%")
                      ->orWhereHas('supplier', function($sq) use ($search) {
                          $sq->where('nama', 'like', "%{$search}%");
                      });
                });
            }

            $purchaseOrders = $query->orderBy('created_at', 'desc')->get();

            return response()->json([
                'success' => true,
                'message' => 'Data purchase orders berhasil diambil',
                'data' => $purchaseOrders
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get single purchase order for admin
     */
    public function adminShow($id)
    {
        try {
            $purchaseOrder = PurchaseOrder::with(['supplier', 'items.barang', 'creator', 'approver'])
                ->findOrFail($id);

            return response()->json([
                'success' => true,
                'message' => 'Data purchase order berhasil diambil',
                'data' => $purchaseOrder
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Approve purchase order (admin only)
     */
    public function approve(Request $request, $id)
    {
        DB::beginTransaction();
        try {
            $purchaseOrder = PurchaseOrder::with('items.barang')->findOrFail($id);

            if ($purchaseOrder->status !== 'pending') {
                return response()->json([
                    'success' => false,
                    'message' => 'Purchase order sudah diproses sebelumnya'
                ], 400);
            }

            $purchaseOrder->update([
                'status' => 'approved',
                'approved_by' => $request->user()->id,
                'approved_at' => now(),
            ]);

            // Log activity
            AuditLogController::log(
                'approve',
                'menyetujui Purchase Order: ' . $purchaseOrder->no_po,
                'PurchaseOrder',
                $purchaseOrder->id
            );

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Purchase order berhasil disetujui'
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Gagal menyetujui purchase order: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Reject purchase order (admin only)
     */
    public function reject(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'reason' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        DB::beginTransaction();
        try {
            $purchaseOrder = PurchaseOrder::findOrFail($id);

            if ($purchaseOrder->status !== 'pending') {
                return response()->json([
                    'success' => false,
                    'message' => 'Purchase order sudah diproses sebelumnya'
                ], 400);
            }

            $purchaseOrder->update([
                'status' => 'rejected',
                'approved_by' => $request->user()->id,
                'approved_at' => now(),
                'reject_reason' => $request->reason,
            ]);

            // Log activity
            AuditLogController::log(
                'reject',
                'menolak Purchase Order: ' . $purchaseOrder->no_po . ($request->reason ? ' - Alasan: ' . $request->reason : ''),
                'PurchaseOrder',
                $purchaseOrder->id
            );

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Purchase order berhasil ditolak'
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Gagal menolak purchase order: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get received items (completed PO) for admin
     */
    public function receivedItems(Request $request)
    {
        try {
            $query = PurchaseOrder::with(['supplier', 'creator'])
                ->where('status', 'completed');

            // Filter by type
            if ($request->has('type') && $request->type != '') {
                if ($request->type === 'po') {
                    // Already filtered by PO
                } elseif ($request->type === 'non-po') {
                    // For future: handle non-PO received items
                    // Currently we only return empty for non-po
                    return response()->json([
                        'success' => true,
                        'data' => [],
                        'meta' => [
                            'current_page' => 1,
                            'last_page' => 1,
                            'per_page' => 10,
                            'total' => 0
                        ]
                    ]);
                }
            }

            // Filter by date range
            if ($request->has('start_date') && $request->start_date) {
                $query->whereDate('completed_at', '>=', $request->start_date);
            }
            if ($request->has('end_date') && $request->end_date) {
                $query->whereDate('completed_at', '<=', $request->end_date);
            }

            // Search
            if ($request->has('search') && $request->search) {
                $search = $request->search;
                $query->where(function($q) use ($search) {
                    $q->where('no_po', 'like', "%{$search}%")
                      ->orWhereHas('supplier', function($sq) use ($search) {
                          $sq->where('nama', 'like', "%{$search}%");
                      });
                });
            }

            // Paginate
            $perPage = $request->get('per_page', 10);
            $receivedItems = $query->orderBy('completed_at', 'desc')->paginate($perPage);

            // Transform data to match frontend interface
            $transformedData = $receivedItems->map(function ($po) {
                return [
                    'id' => $po->id,
                    'no_dokumen' => $po->no_po,
                    'tanggal' => $po->completed_at ? $po->completed_at->format('Y-m-d') : $po->approved_at->format('Y-m-d'),
                    'tipe' => 'po',
                    'no_referensi' => $po->no_po,
                    'sumber' => $po->supplier->nama ?? '-',
                    'total_nilai' => $po->total ?? 0,
                    'dicatat_oleh' => $po->creator->name ?? '-'
                ];
            });

            return response()->json([
                'success' => true,
                'data' => $transformedData,
                'meta' => [
                    'current_page' => $receivedItems->currentPage(),
                    'last_page' => $receivedItems->lastPage(),
                    'per_page' => $receivedItems->perPage(),
                    'total' => $receivedItems->total()
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get received item detail
     */
    public function receivedItemDetail($id)
    {
        try {
            $purchaseOrder = PurchaseOrder::with(['supplier', 'items.barang', 'creator', 'approver'])
                ->where('status', 'completed')
                ->findOrFail($id);

            return response()->json([
                'success' => true,
                'message' => 'Data barang masuk berhasil diambil',
                'data' => $purchaseOrder
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Data tidak ditemukan'
            ], 404);
        }
    }

    /**
     * Receive purchase order (admin only) - terima barang
     */
    public function receive(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'no_surat_jalan' => 'required|string',
            'items' => 'required|array|min:1',
            'items.*.item_id' => 'required|integer',
            'items.*.barang_id' => 'required|exists:barang,id',
            'items.*.received_qty' => 'required|integer|min:0',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        DB::beginTransaction();
        try {
            $purchaseOrder = PurchaseOrder::with('items.barang')->findOrFail($id);

            if ($purchaseOrder->status !== 'approved') {
                return response()->json([
                    'success' => false,
                    'message' => 'Purchase order belum disetujui atau sudah diproses sebelumnya'
                ], 400);
            }

            // Update stock and items
            foreach ($request->items as $item) {
                $barang = Barang::findOrFail($item['barang_id']);
                
                // Add stock
                $barang->increment('stok', $item['received_qty']);

                // Update PO item
                $poItem = PurchaseOrderItem::where('purchase_order_id', $purchaseOrder->id)
                    ->where('id', $item['item_id'])
                    ->first();
                    
                if ($poItem) {
                    $poItem->update([
                        'qty_received' => $item['received_qty']
                    ]);
                }
            }

            // Update purchase order status
            $purchaseOrder->update([
                'status' => 'completed',
                'completed_at' => now(),
                'no_surat_jalan' => $request->no_surat_jalan,
            ]);

            DB::commit();

            // Log activity
            AuditLogController::log(
                'receive',
                'menerima barang untuk Purchase Order: ' . $purchaseOrder->no_po . ' (Surat Jalan: ' . $request->no_surat_jalan . ')',
                'PurchaseOrder',
                $purchaseOrder->id
            );

            $purchaseOrder->load(['supplier', 'items.barang', 'creator', 'approver']);

            return response()->json([
                'success' => true,
                'message' => 'Penerimaan barang berhasil disimpan',
                'data' => $purchaseOrder
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Gagal menyimpan penerimaan barang: ' . $e->getMessage()
            ], 500);
        }
    }
}
