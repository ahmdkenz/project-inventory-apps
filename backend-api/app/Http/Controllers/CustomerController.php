<?php

namespace App\Http\Controllers;

use App\Models\Customer;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class CustomerController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = Customer::query();

        // Search functionality
        if ($request->has('search') && $request->search != '') {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('company_name', 'like', "%{$search}%")
                  ->orWhere('contact_name', 'like', "%{$search}%")
                  ->orWhere('email', 'like', "%{$search}%")
                  ->orWhere('phone', 'like', "%{$search}%");
            });
        }

        // Pagination
        $perPage = $request->get('per_page', 10);
        $customers = $query->orderBy('created_at', 'desc')->paginate($perPage);

        return response()->json($customers);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'company_name' => 'required|string|max:255',
            'contact_name' => 'nullable|string|max:255',
            'email' => 'required|email|unique:customers,email',
            'phone' => 'required|string|max:20',
            'address' => 'nullable|string',
            'city' => 'nullable|string|max:100',
            'zipcode' => 'nullable|string|max:10'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        $customer = Customer::create($request->all());

        return response()->json([
            'message' => 'Customer berhasil ditambahkan',
            'data' => $customer
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $customer = Customer::find($id);

        if (!$customer) {
            return response()->json([
                'message' => 'Customer tidak ditemukan'
            ], 404);
        }

        return response()->json([
            'data' => $customer
        ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $customer = Customer::find($id);

        if (!$customer) {
            return response()->json([
                'message' => 'Customer tidak ditemukan'
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'company_name' => 'required|string|max:255',
            'contact_name' => 'nullable|string|max:255',
            'email' => 'required|email|unique:customers,email,' . $id,
            'phone' => 'required|string|max:20',
            'address' => 'nullable|string',
            'city' => 'nullable|string|max:100',
            'zipcode' => 'nullable|string|max:10'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        $customer->update($request->all());

        return response()->json([
            'message' => 'Customer berhasil diperbarui',
            'data' => $customer
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $customer = Customer::find($id);

        if (!$customer) {
            return response()->json([
                'message' => 'Customer tidak ditemukan'
            ], 404);
        }

        $customer->delete();

        return response()->json([
            'message' => 'Customer berhasil dihapus'
        ]);
    }
}
