import api from '../api'
import type { Barang, BarangResponse } from '../barang.service'

class StaffBarangService {
  /**
   * Get all barang (read-only for staff)
   */
  async getAll(): Promise<BarangResponse> {
    const response = await api.get('/staff/barang')
    return response.data
  }

  /**
   * Get single barang by ID (read-only for staff)
   */
  async getById(id: number): Promise<BarangResponse> {
    const response = await api.get(`/staff/barang/${id}`)
    return response.data
  }
}

export default new StaffBarangService()
