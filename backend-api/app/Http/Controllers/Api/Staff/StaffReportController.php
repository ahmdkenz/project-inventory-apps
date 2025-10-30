<?php

namespace App\Http\Controllers\Api\Staff;

use App\Http\Controllers\Controller;
use App\Models\Barang;
use App\Models\PurchaseOrder;
use App\Models\PurchaseOrderItem;
use App\Models\SalesOrder;
use App\Models\SalesOrderItem;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class StaffReportController extends Controller
{
    /**
     * Dashboard Laporan - Statistik umum
     */
    public function dashboard()
    {
        try {
            // Statistik Umum
            $totalInventoryValue = Barang::selectRaw('SUM(stok * harga_beli) as total')
                ->value('total') ?? 0;

            // Total pembelian 30 hari terakhir
            $totalPurchase30Days = PurchaseOrderItem::join('purchase_orders', 'purchase_order_items.purchase_order_id', '=', 'purchase_orders.id')
                ->whereDate('purchase_orders.tgl_pesan', '>=', now()->subDays(30))
                ->sum('purchase_order_items.subtotal') ?? 0;

            // Total penjualan 30 hari terakhir
            $totalSales30Days = SalesOrderItem::join('sales_orders', 'sales_order_items.sales_order_id', '=', 'sales_orders.id')
                ->whereDate('sales_orders.tgl_order', '>=', now()->subDays(30))
                ->sum('sales_order_items.subtotal') ?? 0;

            // Stok menipis - barang dengan stok < 10 atau stok < stok_minimum
            $lowStockCount = Barang::where('stok', '>', 0)
                ->where(function($query) {
                    $query->where('stok', '<', 10)
                          ->orWhereColumn('stok', '<', 'stok_minimum');
                })
                ->count();

            // Top 5 Barang Keluar
            $topItems = SalesOrderItem::select('barang.nama', DB::raw('SUM(sales_order_items.qty) as total_qty'))
                ->join('barang', 'sales_order_items.barang_id', '=', 'barang.id')
                ->join('sales_orders', 'sales_order_items.sales_order_id', '=', 'sales_orders.id')
                ->whereDate('sales_orders.tgl_order', '>=', now()->subDays(30))
                ->groupBy('barang.id', 'barang.nama')
                ->orderBy('total_qty', 'desc')
                ->limit(5)
                ->get();

            return response()->json([
                'success' => true,
                'data' => [
                    'stats' => [
                        'totalInventoryValue' => $totalInventoryValue,
                        'totalPurchase30Days' => $totalPurchase30Days,
                        'totalSales30Days' => $totalSales30Days,
                        'lowStockCount' => $lowStockCount
                    ],
                    'topItems' => $topItems
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error fetching dashboard data',
                'errors' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Laporan Stok Barang
     */
    public function stock(Request $request)
    {
        try {
            $query = Barang::with('kategori');

            // Filter berdasarkan kategori
            if ($request->filled('kategori_id')) {
                $query->where('kategori_id', $request->kategori_id);
            }

            // Filter berdasarkan status stok
            if ($request->filled('status')) {
                switch ($request->status) {
                    case 'tersedia':
                        $query->whereColumn('stok', '>=', 'min_stok');
                        break;
                    case 'menipis':
                        $query->where('stok', '>', 0)
                              ->where(function($q) {
                                  $q->where('stok', '<', 10)
                                    ->orWhereColumn('stok', '<', 'stok_minimum');
                              });
                        break;
                    case 'habis':
                        $query->where('stok', '<=', 0);
                        break;
                }
            }

            $items = $query->orderBy('nama')->get();

            // Hitung summary
            $summary = [
                'totalItems' => $items->count(),
                'totalValue' => $items->sum(function ($item) {
                    return $item->stok * $item->harga_beli;
                }),
                'lowStock' => Barang::where('stok', '>', 0)
                    ->where(function($q) {
                        $q->where('stok', '<', 10)
                          ->orWhereColumn('stok', '<', 'stok_minimum');
                    })
                    ->count(),
                'outOfStock' => Barang::where('stok', '<=', 0)->count()
            ];

            return response()->json([
                'success' => true,
                'data' => [
                    'items' => $items,
                    'summary' => $summary
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error fetching stock data',
                'errors' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Laporan Barang Masuk
     */
    public function incoming(Request $request)
    {
        try {
            $query = PurchaseOrderItem::select(
                    'purchase_order_items.*',
                    'purchase_orders.no_po',
                    'purchase_orders.tgl_pesan',
                    'purchase_orders.supplier_id'
                )
                ->join('purchase_orders', 'purchase_order_items.purchase_order_id', '=', 'purchase_orders.id')
                ->with(['barang', 'purchaseOrder.supplier']);

            // Filter berdasarkan tanggal
            if ($request->filled('start_date')) {
                $query->whereDate('purchase_orders.tgl_pesan', '>=', $request->start_date);
            }

            if ($request->filled('end_date')) {
                $query->whereDate('purchase_orders.tgl_pesan', '<=', $request->end_date);
            }

            // Filter berdasarkan supplier
            if ($request->filled('supplier_id')) {
                $query->where('purchase_orders.supplier_id', $request->supplier_id);
            }

            $data = $query->orderBy('purchase_orders.tgl_pesan', 'desc')->get();

            // Transform data untuk menambahkan info tambahan
            $data = $data->map(function ($item) {
                return [
                    'id' => $item->id,
                    'no_po' => $item->purchaseOrder->no_po,
                    'tgl_pesan' => $item->purchaseOrder->tgl_pesan,
                    'supplier' => $item->purchaseOrder->supplier,
                    'barang' => $item->barang,
                    'qty' => $item->qty,
                    'harga_satuan' => $item->harga_satuan,
                    'subtotal' => $item->subtotal
                ];
            });

            return response()->json([
                'success' => true,
                'data' => $data
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error fetching incoming data',
                'errors' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Laporan Barang Keluar
     */
    public function outgoing(Request $request)
    {
        try {
            $query = SalesOrderItem::select(
                    'sales_order_items.*',
                    'sales_orders.no_so',
                    'sales_orders.tgl_order',
                    'sales_orders.customer_name',
                    'sales_orders.created_by'
                )
                ->join('sales_orders', 'sales_order_items.sales_order_id', '=', 'sales_orders.id')
                ->with(['barang', 'salesOrder.creator']);

            // Filter berdasarkan tanggal
            if ($request->filled('start_date')) {
                $query->whereDate('sales_orders.tgl_order', '>=', $request->start_date);
            }

            if ($request->filled('end_date')) {
                $query->whereDate('sales_orders.tgl_order', '<=', $request->end_date);
            }

            // Filter berdasarkan customer/penerima
            if ($request->filled('customer')) {
                $query->where('sales_orders.customer_name', 'like', '%' . $request->customer . '%');
            }

            $data = $query->orderBy('sales_orders.tgl_order', 'desc')->get();

            // Transform data
            $data = $data->map(function ($item) {
                return [
                    'id' => $item->id,
                    'no_so' => $item->salesOrder->no_so,
                    'tgl_order' => $item->salesOrder->tgl_order,
                    'customer_name' => $item->salesOrder->customer_name,
                    'barang' => $item->barang,
                    'qty' => $item->qty,
                    'creator' => $item->salesOrder->creator
                ];
            });

            return response()->json([
                'success' => true,
                'data' => $data
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error fetching outgoing data',
                'errors' => $e->getMessage()
            ], 500);
        }
    }
}
