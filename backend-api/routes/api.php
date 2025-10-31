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
use App\Http\Controllers\Api\Admin\ReportController;
use App\Http\Controllers\Api\Staff\StaffReportController;
use App\Http\Controllers\NonPoController;

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
        Route::get('/purchase-order/{id}/print', [PurchaseOrderController::class, 'getPrintData']);
        Route::post('/purchase-order/{id}/approve', [PurchaseOrderController::class, 'approve']);
        Route::post('/purchase-order/{id}/reject', [PurchaseOrderController::class, 'reject']);
        Route::post('/purchase-order/{id}/receive', [PurchaseOrderController::class, 'receive']);
        
        // Sales Order routes (admin - approval)
        Route::get('/sales-order', [SalesOrderController::class, 'adminIndex']);
        Route::get('/sales-order/{id}', [SalesOrderController::class, 'adminShow']);
        Route::post('/sales-order/{id}/approve', [SalesOrderController::class, 'approve']);
        Route::post('/sales-order/{id}/reject', [SalesOrderController::class, 'reject']);
        Route::post('/sales-order/{id}/process', [SalesOrderController::class, 'process']);
        
        // Received Items (Barang Masuk) routes
        Route::get('/received-items', [PurchaseOrderController::class, 'receivedItems']);
        Route::get('/received-items/{id}', [PurchaseOrderController::class, 'receivedItemDetail']);
        
        // Outgoing Items (Barang Keluar) routes
        Route::get('/outgoing-items', [SalesOrderController::class, 'outgoingItems']);
        Route::get('/outgoing-items/{id}', [SalesOrderController::class, 'outgoingItemDetail']);
        
        // Non-PO routes (admin)
        Route::post('/non-po/receipt', [NonPoController::class, 'storeReceipt']);
        Route::get('/non-po/receipt/{id}/print', [NonPoController::class, 'getReceiptPrintData']);
        Route::post('/non-po/issue', [NonPoController::class, 'storeIssue']);
        Route::get('/non-po/issue/{id}/print', [NonPoController::class, 'getIssuePrintData']);
        
        // Report routes
        Route::prefix('reports')->group(function () {
            Route::get('/users', [ReportController::class, 'users']);
            Route::get('/stock', [ReportController::class, 'stock']);
            Route::get('/incoming', [ReportController::class, 'incoming']);
            Route::get('/outgoing', [ReportController::class, 'outgoing']);
        });
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
        
        // Staff Report routes
        Route::prefix('reports')->group(function () {
            Route::get('/dashboard', [StaffReportController::class, 'dashboard']);
            Route::get('/stock', [StaffReportController::class, 'stock']);
            Route::get('/incoming', [StaffReportController::class, 'incoming']);
            Route::get('/outgoing', [StaffReportController::class, 'outgoing']);
        });
    });
});