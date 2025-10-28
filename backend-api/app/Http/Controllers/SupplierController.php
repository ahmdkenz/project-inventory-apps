<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Supplier;
use Illuminate\Support\Facades\Validator;
use App\Http\Controllers\AuditLogController;

class SupplierController extends Controller
{
    /**
     * Display a listing of suppliers
     */
    public function index()
    {
        try {
            $suppliers = Supplier::orderBy('created_at', 'desc')->get();
            
            return response()->json([
                'success' => true,
                'data' => $suppliers
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal memuat data supplier',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Store a newly created supplier
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'nama' => 'required|string|max:255',
            'kontak_person' => 'required|string|max:255',
            'telepon' => 'required|string|max:20',
            'email' => 'required|string|email|max:255',
            'alamat' => 'nullable|string',
        ], [
            'nama.required' => 'Nama supplier harus diisi',
            'kontak_person.required' => 'Kontak person harus diisi',
            'telepon.required' => 'No. telepon harus diisi',
            'email.required' => 'Email harus diisi',
            'email.email' => 'Format email tidak valid',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $supplier = Supplier::create([
                'nama' => $request->nama,
                'kontak_person' => $request->kontak_person,
                'telepon' => $request->telepon,
                'email' => $request->email,
                'alamat' => $request->alamat,
            ]);

            // Log activity
            AuditLogController::log(
                'create',
                'menambahkan supplier: ' . $supplier->nama,
                'Supplier',
                $supplier->id
            );

            return response()->json([
                'success' => true,
                'message' => 'Supplier berhasil ditambahkan',
                'data' => $supplier
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menambahkan supplier',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Display the specified supplier
     */
    public function show($id)
    {
        try {
            $supplier = Supplier::findOrFail($id);
            
            return response()->json([
                'success' => true,
                'data' => $supplier
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Supplier tidak ditemukan'
            ], 404);
        }
    }

    /**
     * Update the specified supplier
     */
    public function update(Request $request, $id)
    {
        try {
            $supplier = Supplier::findOrFail($id);

            $validator = Validator::make($request->all(), [
                'nama' => 'required|string|max:255',
                'kontak_person' => 'required|string|max:255',
                'telepon' => 'required|string|max:20',
                'email' => 'required|string|email|max:255',
                'alamat' => 'nullable|string',
            ], [
                'nama.required' => 'Nama supplier harus diisi',
                'kontak_person.required' => 'Kontak person harus diisi',
                'telepon.required' => 'No. telepon harus diisi',
                'email.required' => 'Email harus diisi',
                'email.email' => 'Format email tidak valid',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validasi gagal',
                    'errors' => $validator->errors()
                ], 422);
            }

            $supplier->update([
                'nama' => $request->nama,
                'kontak_person' => $request->kontak_person,
                'telepon' => $request->telepon,
                'email' => $request->email,
                'alamat' => $request->alamat,
            ]);

            // Log activity
            AuditLogController::log(
                'update',
                'mengedit supplier: ' . $supplier->nama,
                'Supplier',
                $supplier->id
            );

            return response()->json([
                'success' => true,
                'message' => 'Data supplier berhasil diperbarui',
                'data' => $supplier
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal memperbarui data supplier',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Remove the specified supplier
     */
    public function destroy($id)
    {
        try {
            $supplier = Supplier::findOrFail($id);
            $supplierNama = $supplier->nama;
            
            $supplier->delete();

            // Log activity
            AuditLogController::log(
                'delete',
                'menghapus supplier: ' . $supplierNama,
                'Supplier',
                $id
            );

            return response()->json([
                'success' => true,
                'message' => 'Supplier berhasil dihapus',
                'data' => null
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menghapus supplier',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
