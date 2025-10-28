<?php

namespace App\Http\Controllers;

use App\Models\Barang;
use App\Models\Kategori;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Http\Controllers\AuditLogController;

class BarangController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        try {
            $barang = Barang::with('kategori')->get();
            
            return response()->json([
                'success' => true,
                'message' => 'Data barang berhasil diambil',
                'data' => $barang
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data barang',
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
            'nama' => 'required|string|max:255',
            'kode' => 'required|string|unique:barang,kode',
            'kategori_id' => 'required|exists:kategori,id',
            'satuan' => 'required|string|max:50',
            'harga_beli' => 'required|numeric|min:0',
            'harga_jual' => 'required|numeric|min:0',
            'stok' => 'nullable|integer|min:0',
            'stok_minimum' => 'nullable|integer|min:0',
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
            $barang = Barang::create([
                'nama' => $request->nama,
                'kode' => $request->kode,
                'kategori_id' => $request->kategori_id,
                'satuan' => $request->satuan,
                'harga_beli' => $request->harga_beli,
                'harga_jual' => $request->harga_jual,
                'stok' => $request->stok ?? 0,
                'stok_minimum' => $request->stok_minimum ?? 0,
                'deskripsi' => $request->deskripsi,
                'status' => true,
            ]);

            // Log activity
            AuditLogController::log(
                'create',
                'menambahkan barang: ' . $barang->nama . ' (' . $barang->kode . ')',
                'Barang',
                $barang->id
            );

            return response()->json([
                'success' => true,
                'message' => 'Barang berhasil ditambahkan',
                'data' => $barang->load('kategori')
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menambahkan barang',
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
            $barang = Barang::with('kategori')->findOrFail($id);
            
            return response()->json([
                'success' => true,
                'message' => 'Detail barang berhasil diambil',
                'data' => $barang
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Barang tidak ditemukan',
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
            'nama' => 'required|string|max:255',
            'kode' => 'required|string|unique:barang,kode,' . $id,
            'kategori_id' => 'required|exists:kategori,id',
            'satuan' => 'required|string|max:50',
            'harga_beli' => 'required|numeric|min:0',
            'harga_jual' => 'required|numeric|min:0',
            'stok' => 'nullable|integer|min:0',
            'stok_minimum' => 'nullable|integer|min:0',
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
            $barang = Barang::findOrFail($id);
            
            $oldNama = $barang->nama;
            $barang->update($request->all());

            // Log activity
            AuditLogController::log(
                'update',
                'mengedit barang: ' . $oldNama . ' (' . $barang->kode . ')',
                'Barang',
                $barang->id
            );

            return response()->json([
                'success' => true,
                'message' => 'Barang berhasil diperbarui',
                'data' => $barang->load('kategori')
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal memperbarui barang',
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
            $barang = Barang::findOrFail($id);
            $namaBarang = $barang->nama;
            $kodeBarang = $barang->kode;
            
            $barang->delete();

            // Log activity
            AuditLogController::log(
                'delete',
                'menghapus barang: ' . $namaBarang . ' (' . $kodeBarang . ')',
                'Barang',
                $id
            );

            return response()->json([
                'success' => true,
                'message' => 'Barang berhasil dihapus'
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menghapus barang',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
