<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rule;
use Illuminate\Support\Facades\Validator;
use App\Http\Controllers\AuditLogController;

class UserController extends Controller
{
    /**
     * Display a listing of users
     */
    public function index()
    {
        try {
            $users = User::select('id', 'name', 'username', 'email', 'role', 'created_at', 'updated_at')
                ->orderBy('created_at', 'desc')
                ->get()
                ->map(function ($user) {
                    $user->status = 'active'; // Default status, bisa disesuaikan jika ada kolom status
                    return $user;
                });
            
            return response()->json([
                'success' => true,
                'data' => $users
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal memuat data pengguna',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Store a newly created user
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'username' => 'required|string|max:255|unique:users',
            'email' => 'required|string|email|max:255|unique:users',
            'role' => ['required', Rule::in(['admin', 'staff'])],
            'password' => 'required|string|min:6|confirmed',
        ], [
            'name.required' => 'Nama lengkap harus diisi',
            'username.required' => 'Username harus diisi',
            'username.unique' => 'Username sudah digunakan',
            'email.required' => 'Email harus diisi',
            'email.email' => 'Format email tidak valid',
            'email.unique' => 'Email sudah digunakan',
            'role.required' => 'Peran pengguna harus dipilih',
            'role.in' => 'Peran pengguna tidak valid',
            'password.required' => 'Password harus diisi',
            'password.min' => 'Password minimal 6 karakter',
            'password.confirmed' => 'Konfirmasi password tidak cocok',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $user = User::create([
                'name' => $request->name,
                'username' => $request->username,
                'email' => $request->email,
                'role' => $request->role,
                'password' => Hash::make($request->password),
            ]);

            $user->status = 'active';

            // Log activity
            AuditLogController::log(
                'create',
                'menambahkan pengguna: ' . $user->name . ' (' . $user->username . ') sebagai ' . $user->role,
                'User',
                $user->id
            );

            return response()->json([
                'success' => true,
                'message' => 'Pengguna berhasil ditambahkan',
                'data' => $user
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menambahkan pengguna',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Display the specified user
     */
    public function show($id)
    {
        try {
            $user = User::findOrFail($id);
            $user->status = 'active';
            
            return response()->json([
                'success' => true,
                'data' => $user
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Pengguna tidak ditemukan'
            ], 404);
        }
    }

    /**
     * Update the specified user
     */
    public function update(Request $request, $id)
    {
        try {
            $user = User::findOrFail($id);

            $validator = Validator::make($request->all(), [
                'name' => 'required|string|max:255',
                'username' => ['required', 'string', 'max:255', Rule::unique('users')->ignore($id)],
                'email' => ['required', 'string', 'email', 'max:255', Rule::unique('users')->ignore($id)],
                'role' => ['required', Rule::in(['admin', 'staff'])],
                'password' => 'nullable|string|min:6|confirmed',
            ], [
                'name.required' => 'Nama lengkap harus diisi',
                'username.required' => 'Username harus diisi',
                'username.unique' => 'Username sudah digunakan',
                'email.required' => 'Email harus diisi',
                'email.email' => 'Format email tidak valid',
                'email.unique' => 'Email sudah digunakan',
                'role.required' => 'Peran pengguna harus dipilih',
                'role.in' => 'Peran pengguna tidak valid',
                'password.min' => 'Password minimal 6 karakter',
                'password.confirmed' => 'Konfirmasi password tidak cocok',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validasi gagal',
                    'errors' => $validator->errors()
                ], 422);
            }

            $user->name = $request->name;
            $user->username = $request->username;
            $user->email = $request->email;
            $user->role = $request->role;

            // Only update password if provided
            if ($request->filled('password')) {
                $user->password = Hash::make($request->password);
            }

            $user->save();
            $user->status = 'active';

            // Log activity
            AuditLogController::log(
                'update',
                'mengedit pengguna: ' . $user->name . ' (' . $user->username . ')',
                'User',
                $user->id
            );

            return response()->json([
                'success' => true,
                'message' => 'Data pengguna berhasil diperbarui',
                'data' => $user
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal memperbarui data pengguna',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Remove the specified user
     */
    public function destroy($id)
    {
        try {
            $user = User::findOrFail($id);
            
            // Prevent deleting own account
            if ($user->id === auth()->id()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Tidak dapat menghapus akun Anda sendiri'
                ], 403);
            }

            $userName = $user->name;
            $userUsername = $user->username;
            $user->delete();

            // Log activity
            AuditLogController::log(
                'delete',
                'menghapus pengguna: ' . $userName . ' (' . $userUsername . ')',
                'User',
                $id
            );

            return response()->json([
                'success' => true,
                'message' => 'Pengguna berhasil dihapus',
                'data' => null
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menghapus pengguna',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Toggle user status
     */
    public function toggleStatus($id)
    {
        try {
            $user = User::findOrFail($id);
            
            // This is a placeholder method
            // You can implement actual status toggle if you have a status column
            $user->status = 'active';

            return response()->json([
                'success' => true,
                'message' => 'Status pengguna berhasil diubah',
                'data' => $user
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengubah status pengguna',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
