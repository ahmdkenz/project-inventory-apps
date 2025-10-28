import api from '../api'
import type { Supplier, ApiResponse } from '../supplier.service'

class StaffSupplierService {
  /**
   * Get all supplier (read-only for staff)
   */
  async getAll(): Promise<ApiResponse<Supplier[]>> {
    const response = await api.get('/staff/supplier')
    return response.data
  }

  /**
   * Get single supplier by ID (read-only for staff)
   */
  async getById(id: number): Promise<ApiResponse<Supplier>> {
    const response = await api.get(`/staff/supplier/${id}`)
    return response.data
  }
}

export default new StaffSupplierService()
