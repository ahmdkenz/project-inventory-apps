<?php

namespace App\Http\Controllers;

use App\Models\AuditLog;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class AuditLogController extends Controller
{
    /**
     * Get all audit logs with pagination and filters
     */
    public function index(Request $request)
    {
        try {
            $query = AuditLog::query()->with('user');

            // Filter by username
            if ($request->has('username') && !empty($request->username)) {
                $query->where('username', 'like', '%' . $request->username . '%');
            }

            // Filter by action
            if ($request->has('action') && !empty($request->action)) {
                $query->where('action', $request->action);
            }

            // Filter by date range
            if ($request->has('date_start') && !empty($request->date_start)) {
                $query->whereDate('created_at', '>=', $request->date_start);
            }

            if ($request->has('date_end') && !empty($request->date_end)) {
                $query->whereDate('created_at', '<=', $request->date_end);
            }

            // Filter by entity type
            if ($request->has('entity_type') && !empty($request->entity_type)) {
                $query->where('entity_type', $request->entity_type);
            }

            // Order by newest first
            $query->orderBy('created_at', 'desc');

            // Pagination
            $perPage = $request->get('per_page', 15);
            $logs = $query->paginate($perPage);

            return response()->json([
                'success' => true,
                'data' => $logs->items(),
                'pagination' => [
                    'current_page' => $logs->currentPage(),
                    'last_page' => $logs->lastPage(),
                    'per_page' => $logs->perPage(),
                    'total' => $logs->total(),
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data audit log',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get recent activities (for dashboard)
     */
    public function recent(Request $request)
    {
        try {
            $limit = $request->get('limit', 10);
            
            $logs = AuditLog::with('user')
                ->orderBy('created_at', 'desc')
                ->limit($limit)
                ->get();

            return response()->json([
                'success' => true,
                'data' => $logs
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data aktivitas terbaru',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Log an activity
     */
    public static function log($action, $description, $entityType = null, $entityId = null)
    {
        try {
            $user = auth()->user();
            
            AuditLog::create([
                'user_id' => $user ? $user->id : null,
                'username' => $user ? $user->username : 'System',
                'action' => $action,
                'description' => $description,
                'entity_type' => $entityType,
                'entity_id' => $entityId,
                'ip_address' => request()->ip(),
                'user_agent' => request()->userAgent(),
            ]);
        } catch (\Exception $e) {
            \Log::error('Failed to log audit: ' . $e->getMessage());
        }
    }
}
