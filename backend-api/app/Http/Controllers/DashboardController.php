<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use App\Models\Barang;

class DashboardController extends Controller
{
    /**
     * Get dashboard statistics
     */
    public function getStats()
    {
        try {
            // Total pengguna
            $totalUsers = User::count();
            
            // Total jenis barang
            $totalItems = Barang::count();
            
            // Stok menipis (stok < 10)
            $lowStock = Barang::where('stok', '<', 10)
                ->where('stok', '>', 0)
                ->count();
            
            // Stok habis (stok = 0)
            $outOfStock = Barang::where('stok', 0)->count();
            
            return response()->json([
                'totalUsers' => $totalUsers,
                'totalItems' => $totalItems,
                'lowStock' => $lowStock,
                'outOfStock' => $outOfStock
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Gagal memuat data statistik dashboard',
                'message' => $e->getMessage()
            ], 500);
        }
    }
}
