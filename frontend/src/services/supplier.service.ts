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
  // Get all suppliers
  async getAll(): Promise<ApiResponse<Supplier[]>> {
    const response = await api.get('/admin/supplier')
    return response.data
  },

  // Get supplier by ID
  async getById(id: number): Promise<ApiResponse<Supplier>> {
    const response = await api.get(`/admin/supplier/${id}`)
    return response.data
  },

  // Create new supplier
  async create(supplierData: Supplier): Promise<ApiResponse<Supplier>> {
    const response = await api.post('/admin/supplier', supplierData)
    return response.data
  },

  // Update supplier
  async update(id: number, supplierData: Supplier): Promise<ApiResponse<Supplier>> {
    const response = await api.put(`/admin/supplier/${id}`, supplierData)
    return response.data
  },

  // Delete supplier
  async delete(id: number): Promise<ApiResponse<null>> {
    const response = await api.delete(`/admin/supplier/${id}`)
    return response.data
  }
}

export default supplierService
