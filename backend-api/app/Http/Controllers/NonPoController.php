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

            // Create receipt
            $receipt = NonPoReceipt::create([
                'no_dokumen' => $no_dokumen,
                'source' => $request->source,
                'receive_date' => $request->receive_date,
                'notes' => $request->notes,
                'total_value' => $total_value,
                'created_by' => $request->user()->id
            ]);

            // Create items and update stock
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

                // Update stock barang
                $barang = Barang::findOrFail($item['barang_id']);
                $barang->increment('stok', $item['qty']);
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
                'message' => 'Penerimaan barang Non-PO berhasil disimpan',
                'data' => $receipt
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
     * Get single non-PO receipt for print
     */
    public function getReceiptPrintData($id)
    {
        try {
            $receipt = NonPoReceipt::with(['items.barang', 'creator'])->findOrFail($id);

            $printData = [
                'id' => $receipt->id,
                'no_dokumen' => $receipt->no_dokumen,
                'source' => $receipt->source,
                'receive_date' => $receipt->receive_date,
                'notes' => $receipt->notes,
                'total_value' => $receipt->total_value,
                'creator' => $receipt->creator ? [
                    'name' => $receipt->creator->name
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
            'items' => 'required|array|min:1',
            'items.*.barang_id' => 'required|exists:barang,id',
            'items.*.qty' => 'required|integer|min:1'
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
            // Validate stock availability
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
            $lastIssue = NonPoIssue::whereYear('created_at', date('Y'))
                ->whereMonth('created_at', date('m'))
                ->orderBy('id', 'desc')
                ->first();
            
            $counter = $lastIssue ? (int)substr($lastIssue->no_dokumen, -5) + 1 : 1;
            $no_dokumen = 'OUT-NON-' . date('Ym') . '-' . str_pad($counter, 5, '0', STR_PAD_LEFT);

            // Create issue
            $issue = NonPoIssue::create([
                'no_dokumen' => $no_dokumen,
                'recipient' => $request->recipient,
                'issue_date' => $request->issue_date,
                'notes' => $request->notes,
                'created_by' => $request->user()->id
            ]);

            // Create items and update stock
            foreach ($request->items as $item) {
                NonPoIssueItem::create([
                    'non_po_issue_id' => $issue->id,
                    'barang_id' => $item['barang_id'],
                    'qty' => $item['qty']
                ]);

                // Decrease stock barang
                $barang = Barang::findOrFail($item['barang_id']);
                $barang->decrement('stok', $item['qty']);
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
                'message' => 'Pengeluaran barang Non-PO berhasil disimpan',
                'data' => $issue
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
}
