<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use App\Models\Barang;
use App\Models\PurchaseOrder;
use App\Models\SalesOrder;
use Carbon\Carbon;

class DashboardController extends Controller
{
    /**
     * Get dashboard statistics (Admin)
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

    /**
     * Get dashboard statistics for Staff
     */
    public function getStaffStats()
    {
        try {
            $today = Carbon::today();
            
            // Stok habis (stok = 0 atau null)
            $outOfStock = Barang::where('stok', '<=', 0)
                ->orWhereNull('stok')
                ->count();
            
            // Stok menipis - ambil semua barang lalu filter
            $allBarang = Barang::where('stok', '>', 0)->get();
            $lowStock = 0;
            
            foreach ($allBarang as $barang) {
                $threshold = $barang->stok_minimum > 0 ? $barang->stok_minimum : 10;
                if ($barang->stok <= $threshold) {
                    $lowStock++;
                }
            }
            
            // Barang masuk hari ini (Purchase Orders yang approved/completed hari ini)
            $todayIn = PurchaseOrder::whereIn('status', ['approved', 'completed'])
                ->whereDate('created_at', $today)
                ->count();
            
            // Barang keluar hari ini (Sales Orders yang approved/completed hari ini)
            $todayOut = SalesOrder::whereIn('status', ['approved', 'completed'])
                ->whereDate('created_at', $today)
                ->count();
            
            return response()->json([
                'lowStock' => $lowStock,
                'outOfStock' => $outOfStock,
                'todayIn' => $todayIn,
                'todayOut' => $todayOut
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Gagal memuat data statistik dashboard staff',
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get my recent activities (Staff)
     */
    public function getMyActivities(Request $request)
    {
        try {
            $userId = $request->user()->id;
            $activities = [];
            
            // Get recent Purchase Orders created by this user
            $recentPOs = PurchaseOrder::where('created_by', $userId)
                ->orderBy('created_at', 'desc')
                ->limit(5)
                ->get();
            
            foreach ($recentPOs as $po) {
                $activities[] = [
                    'id' => 'po-' . $po->id,
                    'type' => 'add',
                    'action' => 'membuat Purchase Order',
                    'item' => $po->no_po,
                    'timestamp' => $po->created_at->toIso8601String()
                ];
            }
            
            // Get recent Sales Orders created by this user
            $recentSOs = SalesOrder::where('created_by', $userId)
                ->orderBy('created_at', 'desc')
                ->limit(5)
                ->get();
            
            foreach ($recentSOs as $so) {
                $activities[] = [
                    'id' => 'so-' . $so->id,
                    'type' => 'remove',
                    'action' => 'membuat Sales Order',
                    'item' => $so->no_so,
                    'timestamp' => $so->created_at->toIso8601String()
                ];
            }
            
            // Sort by timestamp desc and limit to 10
            usort($activities, function($a, $b) {
                return strtotime($b['timestamp']) - strtotime($a['timestamp']);
            });
            
            return response()->json(array_slice($activities, 0, 10));
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Gagal memuat aktivitas',
                'message' => $e->getMessage()
            ], 500);
        }
    }
}
