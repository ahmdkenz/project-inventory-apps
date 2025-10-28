<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\BarangController;
use App\Http\Controllers\KategoriController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\SupplierController;

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
        
        // Kategori routes
        Route::apiResource('kategori', KategoriController::class);
        
        // Barang routes
        Route::apiResource('barang', BarangController::class);
        
        // User management routes
        Route::apiResource('users', UserController::class);
        Route::patch('/users/{id}/toggle-status', [UserController::class, 'toggleStatus']);
        
        // Supplier routes
        Route::apiResource('supplier', SupplierController::class);
    });
    
    // Staff routes
    Route::middleware('role:staff')->prefix('staff')->group(function () {
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
    });
});