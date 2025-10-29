<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Barang;
use App\Models\PurchaseOrder;
use App\Models\SalesOrder;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ReportController extends Controller
{
    /**
     * Get users report data
     */
    public function users(Request $request)
    {
        $query = User::query();

        // Filter by role
        if ($request->has('role') && $request->role != '') {
            $query->where('role', $request->role);
        }

        $users = $query->orderBy('created_at', 'desc')->get();

        // Get statistics
        $stats = [
            'total' => User::count(),
            'admin' => User::where('role', 'admin')->count(),
            'staff' => User::where('role', 'staff')->count(),
        ];

        return response()->json([
            'users' => $users,
            'stats' => $stats
        ]);
    }

    /**
     * Get stock report data
     */
    public function stock(Request $request)
    {
        $query = Barang::with('kategori');

        // Filter by category
        if ($request->has('kategori_id') && $request->kategori_id != '') {
            $query->where('kategori_id', $request->kategori_id);
        }

        // Filter by status
        if ($request->has('status') && $request->status != '') {
            switch ($request->status) {
                case 'available':
                    $query->where('stok', '>', 10);
                    break;
                case 'low':
                    $query->where('stok', '>', 0)->where('stok', '<=', 10);
                    break;
                case 'out':
                    $query->where('stok', 0);
                    break;
            }
        }

        $items = $query->orderBy('nama')->get();

        // Calculate statistics
        $stockValue = Barang::selectRaw('SUM(stok * harga_beli) as total')->first()->total ?? 0;
        
        $stats = [
            'total_items' => Barang::count(),
            'stock_value' => $stockValue,
            'low_stock' => Barang::where('stok', '>', 0)->where('stok', '<=', 10)->count(),
            'out_of_stock' => Barang::where('stok', 0)->count(),
        ];

        return response()->json([
            'items' => $items,
            'stats' => $stats
        ]);
    }

    /**
     * Get incoming goods report (Purchase Orders)
     */
    public function incoming(Request $request)
    {
        $query = PurchaseOrder::with(['supplier', 'creator', 'items']);

        // Filter by date range
        if ($request->has('start_date') && $request->start_date != '') {
            $query->whereDate('tgl_pesan', '>=', $request->start_date);
        }

        if ($request->has('end_date') && $request->end_date != '') {
            $query->whereDate('tgl_pesan', '<=', $request->end_date);
        }

        $transactions = $query->orderBy('tgl_pesan', 'desc')->get();

        // Add items count to each transaction
        $transactions->each(function ($transaction) {
            $transaction->items_count = $transaction->items->count();
        });

        return response()->json([
            'transactions' => $transactions
        ]);
    }

    /**
     * Get outgoing goods report (Sales Orders)
     */
    public function outgoing(Request $request)
    {
        $query = SalesOrder::with(['creator', 'items']);

        // Filter by date range
        if ($request->has('start_date') && $request->start_date != '') {
            $query->whereDate('tgl_order', '>=', $request->start_date);
        }

        if ($request->has('end_date') && $request->end_date != '') {
            $query->whereDate('tgl_order', '<=', $request->end_date);
        }

        // Filter by recipient
        if ($request->has('recipient') && $request->recipient != '') {
            $query->where('customer_name', 'like', '%' . $request->recipient . '%');
        }

        $transactions = $query->orderBy('tgl_order', 'desc')->get();

        // Add items count to each transaction
        $transactions->each(function ($transaction) {
            $transaction->items_count = $transaction->items->count();
        });

        return response()->json([
            'transactions' => $transactions
        ]);
    }
}
