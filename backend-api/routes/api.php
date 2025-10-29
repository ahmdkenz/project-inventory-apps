<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\BarangController;
use App\Http\Controllers\KategoriController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\SupplierController;
use App\Http\Controllers\PurchaseOrderController;
use App\Http\Controllers\SalesOrderController;
use App\Http\Controllers\AuditLogController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

// Public routes
Route::post('/auth/login', [AuthController::class, 'login']);

// Protected routes
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/auth/logout', [AuthController::class, 'logout']);
    Route::get('/auth/me', [AuthController::class, 'me']);
    
    // Admin routes
    Route::middleware('role:admin')->prefix('admin')->group(function () {
        // Dashboard stats
        Route::get('/dashboard/stats', [DashboardController::class, 'getStats']);
        
        Route::get('/dashboard', function () {
            return response()->json([
                'message' => 'Admin Dashboard Data'
            ]);
        });
        
        // Audit Log routes
        Route::get('/audit-logs', [AuditLogController::class, 'index']);
        Route::get('/audit-logs/recent', [AuditLogController::class, 'recent']);
        
        // Kategori routes
        Route::apiResource('kategori', KategoriController::class);
        
        // Barang routes
        Route::apiResource('barang', BarangController::class);
        
        // User management routes
        Route::apiResource('users', UserController::class);
        Route::patch('/users/{id}/toggle-status', [UserController::class, 'toggleStatus']);
        
        // Supplier routes
        Route::apiResource('supplier', SupplierController::class);
        
        // Purchase Order routes (admin - approval)
        Route::get('/purchase-order', [PurchaseOrderController::class, 'adminIndex']);
        Route::get('/purchase-order/{id}', [PurchaseOrderController::class, 'adminShow']);
        Route::post('/purchase-order/{id}/approve', [PurchaseOrderController::class, 'approve']);
        Route::post('/purchase-order/{id}/reject', [PurchaseOrderController::class, 'reject']);
        
        // Sales Order routes (admin - approval)
        Route::get('/sales-order', [SalesOrderController::class, 'adminIndex']);
        Route::get('/sales-order/{id}', [SalesOrderController::class, 'adminShow']);
        Route::post('/sales-order/{id}/approve', [SalesOrderController::class, 'approve']);
        Route::post('/sales-order/{id}/reject', [SalesOrderController::class, 'reject']);
    });
    
    // Staff routes
    Route::middleware('role:staff')->prefix('staff')->group(function () {
        // Dashboard stats for staff
        Route::get('/dashboard/stats', [DashboardController::class, 'getStaffStats']);
        Route::get('/activities/my', [DashboardController::class, 'getMyActivities']);
        
        Route::get('/dashboard', function () {
            return response()->json([
                'message' => 'Staff Dashboard Data'
            ]);
        });
        
        // Read-only routes for staff
        Route::get('/barang', [BarangController::class, 'index']);
        Route::get('/barang/{id}', [BarangController::class, 'show']);
        Route::get('/kategori', [KategoriController::class, 'index']);
        Route::get('/kategori/{id}', [KategoriController::class, 'show']);
        Route::get('/supplier', [SupplierController::class, 'index']);
        Route::get('/supplier/{id}', [SupplierController::class, 'show']);
        
        // Purchase Order routes (staff - create/manage own PO)
        Route::apiResource('purchase-order', PurchaseOrderController::class);
        
        // Sales Order routes (staff - create/manage own SO)
        Route::apiResource('sales-order', SalesOrderController::class);
    });
});