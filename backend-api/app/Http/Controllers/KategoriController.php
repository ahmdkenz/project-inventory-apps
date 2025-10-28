<?php

namespace App\Http\Controllers;

use App\Models\Kategori;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Http\Controllers\AuditLogController;

class KategoriController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        try {
            $kategori = Kategori::all();
            
            return response()->json([
                'success' => true,
                'message' => 'Data kategori berhasil diambil',
                'data' => $kategori
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data kategori',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'nama' => 'required|string|max:255|unique:kategori,nama',
            'kode' => 'required|string|unique:kategori,kode',
            'deskripsi' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $kategori = Kategori::create([
                'nama' => $request->nama,
                'kode' => $request->kode,
                'deskripsi' => $request->deskripsi,
            ]);

            // Log activity
            AuditLogController::log(
                'create',
                "Menambahkan kategori baru: {$kategori->nama} ({$kategori->kode})",
                'Kategori',
                $kategori->id
            );

            return response()->json([
                'success' => true,
                'message' => 'Kategori berhasil ditambahkan',
                'data' => $kategori
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menambahkan kategori',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        try {
            $kategori = Kategori::findOrFail($id);
            
            return response()->json([
                'success' => true,
                'message' => 'Detail kategori berhasil diambil',
                'data' => $kategori
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Kategori tidak ditemukan',
                'error' => $e->getMessage()
            ], 404);
        }
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'nama' => 'required|string|max:255|unique:kategori,nama,' . $id,
            'kode' => 'required|string|unique:kategori,kode,' . $id,
            'deskripsi' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $kategori = Kategori::findOrFail($id);
            $kategori->update($request->all());

            // Log activity
            AuditLogController::log(
                'update',
                "Memperbarui kategori: {$kategori->nama} ({$kategori->kode})",
                'Kategori',
                $kategori->id
            );

            return response()->json([
                'success' => true,
                'message' => 'Kategori berhasil diperbarui',
                'data' => $kategori
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal memperbarui kategori',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        try {
            $kategori = Kategori::findOrFail($id);
            $kategoriName = $kategori->nama;
            $kategoriKode = $kategori->kode;
            
            $kategori->delete();

            // Log activity
            AuditLogController::log(
                'delete',
                "Menghapus kategori: {$kategoriName} ({$kategoriKode})",
                'Kategori',
                $id
            );

            return response()->json([
                'success' => true,
                'message' => 'Kategori berhasil dihapus'
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menghapus kategori',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
