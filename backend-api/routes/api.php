<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;

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