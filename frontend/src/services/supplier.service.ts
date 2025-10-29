import api from './api'

export interface Supplier {
  id?: number
  nama: string
  kontak_person: string
  telepon: string
  email: string
  alamat?: string
  created_at?: string
  updated_at?: string
}

export interface ApiResponse<T> {
  success: boolean
  message?: string
  data: T
}

const supplierService = {
  // Get all suppliers (supports both admin and staff)
  async getAll(role: 'admin' | 'staff' = 'admin'): Promise<ApiResponse<Supplier[]>> {
    const endpoint = role === 'admin' ? '/admin/supplier' : '/staff/supplier'
    const response = await api.get(endpoint)
    return response.data
  },

  // Get supplier by ID (supports both admin and staff)
  async getById(id: number, role: 'admin' | 'staff' = 'admin'): Promise<ApiResponse<Supplier>> {
    const endpoint = role === 'admin' ? `/admin/supplier/${id}` : `/staff/supplier/${id}`
    const response = await api.get(endpoint)
    return response.data
  },

  // Create new supplier (admin only)
  async create(supplierData: Supplier): Promise<ApiResponse<Supplier>> {
    const response = await api.post('/admin/supplier', supplierData)
    return response.data
  },

  // Update supplier (admin only)
  async update(id: number, supplierData: Supplier): Promise<ApiResponse<Supplier>> {
    const response = await api.put(`/admin/supplier/${id}`, supplierData)
    return response.data
  },

  // Delete supplier (admin only)
  async delete(id: number): Promise<ApiResponse<null>> {
    const response = await api.delete(`/admin/supplier/${id}`)
    return response.data
  }
}

export default supplierService
