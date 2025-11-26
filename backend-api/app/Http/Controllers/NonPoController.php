<?php

namespace App\Http\Controllers;

use App\Models\NonPoReceipt;
use App\Models\NonPoReceiptItem;
use App\Models\NonPoIssue;
use App\Models\NonPoIssueItem;
use App\Models\Barang;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use App\Http\Controllers\AuditLogController;

class NonPoController extends Controller
{
    /**
     * Get all non-PO receipts for staff (own receipts only)
     * For admin, get all receipts
     */
    public function getStaffReceipts(Request $request)
    {
        try {
            $query = NonPoReceipt::with(['items.barang', 'creator', 'approver', 'receiver']);
            
            // If user is staff, only show their own receipts
            // If user is admin, show all receipts
            if ($request->user()->role === 'staff') {
                $query->where('created_by', $request->user()->id);
            }

            // Filter by status
            if ($request->has('status') && $request->status != '') {
                $query->where('status', $request->status);
            }

            // Search
            if ($request->has('search') && $request->search != '') {
                $search = $request->search;
                $query->where(function($q) use ($search) {
                    $q->where('no_dokumen', 'like', "%{$search}%")
                      ->orWhere('source', 'like', "%{$search}%");
                });
            }

            $receipts = $query->orderBy('created_at', 'desc')->get();

            return response()->json([
                'success' => true,
                'data' => $receipts
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get all non-SO issues for staff (own issues only)
     * For admin, get all issues
     */
    public function getStaffIssues(Request $request)
    {
        try {
            $query = NonPoIssue::with(['items.barang', 'creator', 'approver']);
            
            // If user is staff, only show their own issues
            // If user is admin, show all issues
            if ($request->user()->role === 'staff') {
                $query->where('created_by', $request->user()->id);
            }

            // Filter by status
            if ($request->has('status') && $request->status != '') {
                $query->where('status', $request->status);
            }

            // Search
            if ($request->has('search') && $request->search != '') {
                $search = $request->search;
                $query->where(function($q) use ($search) {
                    $q->where('no_dokumen', 'like', "%{$search}%")
                      ->orWhere('recipient', 'like', "%{$search}%");
                });
            }

            $issues = $query->orderBy('created_at', 'desc')->get();

            return response()->json([
                'success' => true,
                'data' => $issues
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Store non-PO receipt (Penerimaan Barang Non-PO)
     */
    public function storeReceipt(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'source' => 'required|string',
            'receive_date' => 'required|date',
            'notes' => 'required|string',
            'items' => 'required|array|min:1',
            'items.*.barang_id' => 'required|exists:barang,id',
            'items.*.qty' => 'required|integer|min:1',
            'items.*.price' => 'nullable|numeric|min:0'
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
            $currentUser = $request->user();
            
            // Log untuk debugging - pastikan user yang benar
            \Log::info('NON-PO Receipt dibuat oleh:', [
                'user_id' => $currentUser->id,
                'username' => $currentUser->username,
                'name' => $currentUser->name,
                'role' => $currentUser->role
            ]);
            
            // Generate nomor dokumen
            $lastReceipt = NonPoReceipt::whereYear('created_at', date('Y'))
                ->whereMonth('created_at', date('m'))
                ->orderBy('id', 'desc')
                ->first();
            
            $counter = $lastReceipt ? (int)substr($lastReceipt->no_dokumen, -5) + 1 : 1;
            $no_dokumen = 'GR-NON-' . date('Ym') . '-' . str_pad($counter, 5, '0', STR_PAD_LEFT);

            // Calculate total value
            $total_value = 0;
            foreach ($request->items as $item) {
                $price = $item['price'] ?? 0;
                $total_value += $item['qty'] * $price;
            }

            // Create receipt with pending status
            $receipt = NonPoReceipt::create([
                'no_dokumen' => $no_dokumen,
                'source' => $request->source,
                'receive_date' => $request->receive_date,
                'notes' => $request->notes,
                'total_value' => $total_value,
                'created_by' => $currentUser->id, // Gunakan user yang sedang login
                'status' => 'pending'
            ]);

            // Create items (don't update stock yet, wait for approval)
            foreach ($request->items as $item) {
                $price = $item['price'] ?? 0;
                $subtotal = $item['qty'] * $price;

                NonPoReceiptItem::create([
                    'non_po_receipt_id' => $receipt->id,
                    'barang_id' => $item['barang_id'],
                    'qty' => $item['qty'],
                    'price' => $price,
                    'subtotal' => $subtotal
                ]);
            }

            DB::commit();

            // Log activity
            AuditLogController::log(
                'create',
                'membuat penerimaan barang Non-PO: ' . $no_dokumen . ' (Sumber: ' . $request->source . ')',
                'NonPoReceipt',
                $receipt->id
            );

            $receipt->load(['items.barang', 'creator']);

            return response()->json([
                'success' => true,
                'message' => 'Penerimaan barang Non-PO berhasil dibuat dan menunggu persetujuan admin',
                'data' => $receipt,
                'debug_info' => [ // Tambahkan info debug
                    'created_by_id' => $receipt->created_by,
                    'created_by_name' => $receipt->creator->name ?? 'Unknown',
                    'created_by_role' => $receipt->creator->role ?? 'Unknown'
                ]
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Gagal menyimpan penerimaan barang: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get single non-PO receipt detail (for admin review)
     */
    public function getReceiptDetail($id)
    {
        try {
            $receipt = NonPoReceipt::with(['items.barang', 'creator', 'approver', 'receiver'])->findOrFail($id);

            return response()->json([
                'success' => true,
                'data' => $receipt
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Data tidak ditemukan: ' . $e->getMessage()
            ], 404);
        }
    }

    /**
     * Get single non-PO receipt for print
     */
    public function getReceiptPrintData($id)
    {
        try {
            $receipt = NonPoReceipt::with(['items.barang', 'creator', 'receiver'])->findOrFail($id);

            $printData = [
                'id' => $receipt->id,
                'no_dokumen' => $receipt->no_dokumen,
                'source' => $receipt->source,
                'receive_date' => $receipt->receive_date,
                'notes' => $receipt->notes,
                'no_surat_jalan' => $receipt->no_surat_jalan,
                'total_value' => $receipt->total_value,
                'approved_at' => $receipt->approved_at,
                'creator' => $receipt->creator ? [
                    'name' => $receipt->creator->name
                ] : null,
                'receiver' => $receipt->receiver ? [
                    'name' => $receipt->receiver->name
                ] : null,
                'items' => $receipt->items->map(function ($item) {
                    return [
                        'barang_id' => $item->barang_id,
                        'nama_barang' => $item->barang->nama ?? '-',
                        'kode_barang' => $item->barang->kode ?? '-',
                        'qty' => $item->qty,
                        'price' => $item->price,
                        'subtotal' => $item->subtotal
                    ];
                })
            ];

            return response()->json([
                'success' => true,
                'data' => $printData
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Data tidak ditemukan: ' . $e->getMessage()
            ], 404);
        }
    }

    /**
     * Store non-PO issue (Pengeluaran Barang Non-PO)
     */
    public function storeIssue(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'recipient' => 'required|string',
            'issue_date' => 'required|date',
            'notes' => 'nullable|string',
            'subtotal' => 'required|numeric|min:0',
            'ppn' => 'required|numeric|min:0',
            'total' => 'required|numeric|min:0',
            'items' => 'required|array|min:1',
            'items.*.barang_id' => 'required|exists:barang,id',
            'items.*.qty' => 'required|integer|min:1',
            'items.*.harga_satuan' => 'required|numeric|min:0',
            'items.*.subtotal' => 'required|numeric|min:0'
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
            $currentUser = $request->user();
            
            // Log untuk debugging - pastikan user yang benar
            \Log::info('NON-PO Issue dibuat oleh:', [
                'user_id' => $currentUser->id,
                'username' => $currentUser->username,
                'name' => $currentUser->name,
                'role' => $currentUser->role
            ]);
            
            // Validate stock availability (untuk validasi awal)
            foreach ($request->items as $item) {
                $barang = Barang::findOrFail($item['barang_id']);
                if ($barang->stok < $item['qty']) {
                    return response()->json([
                        'success' => false,
                        'message' => "Stok {$barang->nama} tidak mencukupi. Stok tersedia: {$barang->stok}, diminta: {$item['qty']}"
                    ], 400);
                }
            }

            // Generate nomor dokumen
            $lastIssue = NonPoIssue::whereDate('created_at', date('Y-m-d'))
                ->orderBy('id', 'desc')
                ->first();
            
            $counter = $lastIssue ? (int)substr($lastIssue->no_dokumen, -4) + 1 : 1;
            $no_dokumen = 'OUT-NON-' . date('Ymd') . '-' . str_pad($counter, 4, '0', STR_PAD_LEFT);

            // Create issue with pending status
            $issue = NonPoIssue::create([
                'no_dokumen' => $no_dokumen,
                'recipient' => $request->recipient,
                'issue_date' => $request->issue_date,
                'notes' => $request->notes,
                'subtotal' => $request->subtotal,
                'ppn' => $request->ppn,
                'total' => $request->total,
                'created_by' => $currentUser->id, // Gunakan user yang sedang login
                'status' => 'pending'
            ]);

            // Create items (don't update stock yet, wait for approval)
            foreach ($request->items as $item) {
                NonPoIssueItem::create([
                    'non_po_issue_id' => $issue->id,
                    'barang_id' => $item['barang_id'],
                    'qty' => $item['qty'],
                    'harga_satuan' => $item['harga_satuan'],
                    'subtotal' => $item['subtotal']
                ]);
            }

            DB::commit();

            // Log activity
            AuditLogController::log(
                'create',
                'membuat pengeluaran barang Non-PO: ' . $no_dokumen . ' (Penerima: ' . $request->recipient . ')',
                'NonPoIssue',
                $issue->id
            );

            $issue->load(['items.barang', 'creator']);

            return response()->json([
                'success' => true,
                'message' => 'Pengeluaran barang Non-SO berhasil dibuat dan menunggu persetujuan admin',
                'data' => $issue,
                'debug_info' => [ // Tambahkan info debug
                    'created_by_id' => $issue->created_by,
                    'created_by_name' => $issue->creator->name ?? 'Unknown',
                    'created_by_role' => $issue->creator->role ?? 'Unknown'
                ]
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Gagal menyimpan pengeluaran barang: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get single non-PO issue detail (for admin review)
     */
    public function getIssueDetail($id)
    {
        try {
            $issue = NonPoIssue::with(['items.barang', 'creator', 'approver'])->findOrFail($id);

            return response()->json([
                'success' => true,
                'data' => $issue
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Data tidak ditemukan: ' . $e->getMessage()
            ], 404);
        }
    }

    /**
     * Get single non-PO issue for print
     */
    public function getIssuePrintData($id)
    {
        try {
            $issue = NonPoIssue::with(['items.barang', 'creator'])->findOrFail($id);

            $printData = [
                'id' => $issue->id,
                'no_dokumen' => $issue->no_dokumen,
                'recipient' => $issue->recipient,
                'issue_date' => $issue->issue_date,
                'notes' => $issue->notes,
                'creator' => $issue->creator ? [
                    'name' => $issue->creator->name
                ] : null,
                'items' => $issue->items->map(function ($item) {
                    return [
                        'barang_id' => $item->barang_id,
                        'nama_barang' => $item->barang->nama ?? '-',
                        'kode_barang' => $item->barang->kode ?? '-',
                        'qty' => $item->qty
                    ];
                })
            ];

            return response()->json([
                'success' => true,
                'data' => $printData
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Data tidak ditemukan: ' . $e->getMessage()
            ], 404);
        }
    }

    /**
     * Approve Non-PO Receipt (admin only)
     */
    public function approveReceipt(Request $request, $id)
    {
        DB::beginTransaction();
        try {
            $receipt = NonPoReceipt::with('items.barang')->findOrFail($id);

            if ($receipt->status !== 'pending') {
                return response()->json([
                    'success' => false,
                    'message' => 'Penerimaan Non-PO sudah diproses sebelumnya'
                ], 400);
            }

            // Update receipt status to 'approved' (DON'T update stock yet, wait for receive)
            $receipt->update([
                'status' => 'approved',
                'approved_by' => $request->user()->id,
                'approved_at' => now(),
            ]);

            DB::commit();

            // Log activity
            AuditLogController::log(
                'approve',
                'menyetujui Penerimaan Non-PO: ' . $receipt->no_dokumen . ' (Sumber: ' . $receipt->source . ')',
                'NonPoReceipt',
                $receipt->id
            );

            return response()->json([
                'success' => true,
                'message' => 'Penerimaan Non-PO berhasil disetujui. Silakan terima barang untuk memperbarui stok.'
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Gagal menyetujui penerimaan Non-PO: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Receive Non-PO Receipt - update stock (admin only)
     */
    public function receiveReceipt(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'no_surat_jalan' => 'required|string',
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
            $receipt = NonPoReceipt::with('items.barang')->findOrFail($id);

            if ($receipt->status !== 'approved') {
                return response()->json([
                    'success' => false,
                    'message' => 'Penerimaan Non-PO harus disetujui terlebih dahulu sebelum dapat diterima'
                ], 400);
            }

            // Update stock barang
            foreach ($receipt->items as $item) {
                $barang = Barang::findOrFail($item->barang_id);
                $barang->increment('stok', $item->qty);
            }

            // Update receipt status to 'completed' and save no_surat_jalan
            $receipt->update([
                'status' => 'completed',
                'no_surat_jalan' => $request->no_surat_jalan,
                'received_by' => $request->user()->id,
                'received_at' => now(),
            ]);

            DB::commit();

            // Log activity
            AuditLogController::log(
                'receive',
                'menerima barang Non-PO: ' . $receipt->no_dokumen . ' dengan No. Surat Jalan: ' . $request->no_surat_jalan,
                'NonPoReceipt',
                $receipt->id
            );

            return response()->json([
                'success' => true,
                'message' => 'Barang Non-PO berhasil diterima dan stok telah diperbarui'
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Gagal menerima barang Non-PO: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Reject Non-PO Receipt (admin only)
     */
    public function rejectReceipt(Request $request, $id)
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
            $receipt = NonPoReceipt::findOrFail($id);

            if ($receipt->status !== 'pending') {
                return response()->json([
                    'success' => false,
                    'message' => 'Penerimaan Non-PO sudah diproses sebelumnya'
                ], 400);
            }

            $receipt->update([
                'status' => 'rejected',
                'approved_by' => $request->user()->id,
                'approved_at' => now(),
                'reject_reason' => $request->reason,
            ]);

            DB::commit();

            // Log activity
            AuditLogController::log(
                'reject',
                'menolak Penerimaan Non-PO: ' . $receipt->no_dokumen . ($request->reason ? ' - Alasan: ' . $request->reason : ''),
                'NonPoReceipt',
                $receipt->id
            );

            return response()->json([
                'success' => true,
                'message' => 'Penerimaan Non-PO berhasil ditolak'
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Gagal menolak penerimaan Non-PO: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Approve Non-SO Issue (admin only)
     */
    public function approveIssue(Request $request, $id)
    {
        DB::beginTransaction();
        try {
            $issue = NonPoIssue::with('items.barang')->findOrFail($id);

            if ($issue->status !== 'pending') {
                return response()->json([
                    'success' => false,
                    'message' => 'Pengeluaran Non-SO sudah diproses sebelumnya'
                ], 400);
            }

            // Validate stock availability before approval
            foreach ($issue->items as $item) {
                $barang = Barang::findOrFail($item->barang_id);
                if ($barang->stok < $item->qty) {
                    throw new \Exception("Stok {$barang->nama} tidak mencukupi. Stok tersedia: {$barang->stok}");
                }
            }

            // Update issue status to 'approved' (DON'T update stock yet)
            $issue->update([
                'status' => 'approved',
                'approved_by' => $request->user()->id,
                'approved_at' => now(),
            ]);

            DB::commit();

            // Log activity
            AuditLogController::log(
                'approve',
                'menyetujui Pengeluaran Non-SO: ' . $issue->no_dokumen . ' (Penerima: ' . $issue->recipient . ')',
                'NonPoIssue',
                $issue->id
            );

            return response()->json([
                'success' => true,
                'message' => 'Pengeluaran Non-SO berhasil disetujui'
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Gagal menyetujui pengeluaran Non-SO: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Process Non-SO Issue - keluarkan barang dan update stok (admin only)
     */
    public function processIssue(Request $request, $id)
    {
        DB::beginTransaction();
        try {
            $issue = NonPoIssue::with('items.barang')->findOrFail($id);

            if ($issue->status !== 'approved') {
                return response()->json([
                    'success' => false,
                    'message' => 'Pengeluaran Non-SO harus disetujui terlebih dahulu sebelum diproses'
                ], 400);
            }

            // Validate stock availability again before processing
            foreach ($issue->items as $item) {
                $barang = Barang::findOrFail($item->barang_id);
                if ($barang->stok < $item->qty) {
                    throw new \Exception("Stok {$barang->nama} tidak mencukupi. Stok tersedia: {$barang->stok}");
                }
            }

            // Update stock barang
            foreach ($issue->items as $item) {
                $barang = Barang::findOrFail($item->barang_id);
                $barang->decrement('stok', $item->qty);
            }

            // Update issue status to 'completed'
            $issue->update([
                'status' => 'completed'
            ]);

            DB::commit();

            // Log activity
            AuditLogController::log(
                'process',
                'memproses/mengeluarkan barang Non-SO: ' . $issue->no_dokumen . ' (Penerima: ' . $issue->recipient . ')',
                'NonPoIssue',
                $issue->id
            );

            return response()->json([
                'success' => true,
                'message' => 'Pengeluaran Non-SO berhasil diproses dan stok telah dikurangi'
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Gagal memproses pengeluaran Non-SO: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Reject Non-SO Issue (admin only)
     */
    public function rejectIssue(Request $request, $id)
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
            $issue = NonPoIssue::findOrFail($id);

            if ($issue->status !== 'pending') {
                return response()->json([
                    'success' => false,
                    'message' => 'Pengeluaran Non-SO sudah diproses sebelumnya'
                ], 400);
            }

            $issue->update([
                'status' => 'rejected',
                'approved_by' => $request->user()->id,
                'approved_at' => now(),
                'reject_reason' => $request->reason,
            ]);

            DB::commit();

            // Log activity
            AuditLogController::log(
                'reject',
                'menolak Pengeluaran Non-SO: ' . $issue->no_dokumen . ($request->reason ? ' - Alasan: ' . $request->reason : ''),
                'NonPoIssue',
                $issue->id
            );

            return response()->json([
                'success' => true,
                'message' => 'Pengeluaran Non-SO berhasil ditolak'
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Gagal menolak pengeluaran Non-SO: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Update Non-PO Receipt (staff only - only if status is pending)
     */
    public function updateReceipt(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'source' => 'required|string',
            'receive_date' => 'required|date',
            'notes' => 'required|string',
            'items' => 'required|array|min:1',
            'items.*.barang_id' => 'required|exists:barang,id',
            'items.*.qty' => 'required|integer|min:1',
            'items.*.price' => 'nullable|numeric|min:0'
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
            $receipt = NonPoReceipt::with('items')->findOrFail($id);

            // Check if receipt belongs to current user
            if ($receipt->created_by !== $request->user()->id) {
                return response()->json([
                    'success' => false,
                    'message' => 'Anda tidak memiliki akses untuk mengedit penerimaan Non-PO ini'
                ], 403);
            }

            // Only allow update if status is pending
            if ($receipt->status !== 'pending') {
                return response()->json([
                    'success' => false,
                    'message' => 'Penerimaan Non-PO yang sudah diproses tidak dapat diubah'
                ], 400);
            }

            // Calculate total value
            $total_value = 0;
            foreach ($request->items as $item) {
                $price = $item['price'] ?? 0;
                $total_value += $item['qty'] * $price;
            }

            // Update receipt
            $receipt->update([
                'source' => $request->source,
                'receive_date' => $request->receive_date,
                'notes' => $request->notes,
                'total_value' => $total_value,
            ]);

            // Delete old items
            NonPoReceiptItem::where('non_po_receipt_id', $receipt->id)->delete();

            // Create new items
            foreach ($request->items as $item) {
                $price = $item['price'] ?? 0;
                $subtotal = $item['qty'] * $price;

                NonPoReceiptItem::create([
                    'non_po_receipt_id' => $receipt->id,
                    'barang_id' => $item['barang_id'],
                    'qty' => $item['qty'],
                    'price' => $price,
                    'subtotal' => $subtotal
                ]);
            }

            DB::commit();

            // Log activity
            AuditLogController::log(
                'update',
                'mengupdate penerimaan barang Non-PO: ' . $receipt->no_dokumen,
                'NonPoReceipt',
                $receipt->id
            );

            $receipt->load(['items.barang', 'creator']);

            return response()->json([
                'success' => true,
                'message' => 'Penerimaan barang Non-PO berhasil diupdate',
                'data' => $receipt
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengupdate penerimaan barang: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Delete Non-PO Receipt (staff only - only if status is pending)
     */
    public function deleteReceipt(Request $request, $id)
    {
        DB::beginTransaction();
        try {
            $receipt = NonPoReceipt::findOrFail($id);

            // Check if receipt belongs to current user
            if ($receipt->created_by !== $request->user()->id) {
                return response()->json([
                    'success' => false,
                    'message' => 'Anda tidak memiliki akses untuk menghapus penerimaan Non-PO ini'
                ], 403);
            }

            // Only allow delete if status is pending
            if ($receipt->status !== 'pending') {
                return response()->json([
                    'success' => false,
                    'message' => 'Penerimaan Non-PO yang sudah diproses tidak dapat dihapus'
                ], 400);
            }

            $no_dokumen = $receipt->no_dokumen;

            // Delete items first
            NonPoReceiptItem::where('non_po_receipt_id', $receipt->id)->delete();

            // Delete receipt
            $receipt->delete();

            DB::commit();

            // Log activity
            AuditLogController::log(
                'delete',
                'menghapus penerimaan barang Non-PO: ' . $no_dokumen,
                'NonPoReceipt',
                $id
            );

            return response()->json([
                'success' => true,
                'message' => 'Penerimaan barang Non-PO berhasil dihapus'
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Gagal menghapus penerimaan barang: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Delete Non-PO Issue (staff only - only if status is pending)
     */
    public function deleteIssue(Request $request, $id)
    {
        DB::beginTransaction();
        try {
            $issue = NonPoIssue::findOrFail($id);

            // Check if issue belongs to current user
            if ($issue->created_by !== $request->user()->id) {
                return response()->json([
                    'success' => false,
                    'message' => 'Anda tidak memiliki akses untuk menghapus pengeluaran Non-SO ini'
                ], 403);
            }

            // Only allow delete if status is pending
            if ($issue->status !== 'pending') {
                return response()->json([
                    'success' => false,
                    'message' => 'Pengeluaran Non-SO yang sudah diproses tidak dapat dihapus'
                ], 400);
            }

            $no_dokumen = $issue->no_dokumen;

            // Delete items first
            NonPoIssueItem::where('non_po_issue_id', $issue->id)->delete();

            // Delete issue
            $issue->delete();

            DB::commit();

            // Log activity
            AuditLogController::log(
                'delete',
                'menghapus pengeluaran barang Non-SO: ' . $no_dokumen,
                'NonPoIssue',
                $id
            );

            return response()->json([
                'success' => true,
                'message' => 'Pengeluaran barang Non-SO berhasil dihapus'
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Gagal menghapus pengeluaran barang: ' . $e->getMessage()
            ], 500);
        }
    }
}
