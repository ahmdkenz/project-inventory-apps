<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;
use App\Http\Controllers\AuditLogController;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        $request->validate([
            'username' => 'required|string',
            'password' => 'required|string',
            'remember' => 'boolean'
        ]);

        if (!Auth::attempt($request->only('username', 'password'), $request->remember)) {
            throw ValidationException::withMessages([
                'message' => 'Username atau password salah'
            ]);
        }

        $user = User::where('username', $request->username)->firstOrFail();
        $token = $user->createToken('auth_token')->plainTextToken;

        // Log activity
        AuditLogController::log(
            'login',
            'telah login ke sistem',
            'Auth',
            $user->id
        );

        return response()->json([
            'message' => 'Login berhasil',
            'token' => $token,
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'username' => $user->username,
                'role' => $user->role,
            ]
        ]);
    }

    public function logout(Request $request)
    {
        // Log activity before deleting token
        AuditLogController::log(
            'logout',
            'telah logout dari sistem',
            'Auth',
            $request->user()->id
        );

        $request->user()->currentAccessToken()->delete();
        
        return response()->json([
            'message' => 'Logout berhasil'
        ]);
    }

    public function me(Request $request)
    {
        return response()->json([
            'user' => $request->user()
        ]);
    }
}