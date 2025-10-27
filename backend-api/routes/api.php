<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\BarangController;
use App\Http\Controllers\KategoriController;

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
        Route::get('/dashboard', function () {
            return response()->json([
                'message' => 'Admin Dashboard Data'
            ]);
        });
        
        // Kategori routes
        Route::get('kategori', [KategoriController::class, 'index']);
        
        // Barang routes
        Route::apiResource('barang', BarangController::class);
    });
    
    // Staff routes
    Route::middleware('role:staff')->prefix('staff')->group(function () {
        Route::get('/dashboard', function () {
            return response()->json([
                'message' => 'Staff Dashboard Data'
            ]);
        });
    });
});