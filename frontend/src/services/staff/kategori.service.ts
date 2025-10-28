import api from '../api'
import type { Kategori, KategoriResponse } from '../kategori.service'

class StaffKategoriService {
  /**
   * Get all kategori (read-only for staff)
   */
  async getAll(): Promise<KategoriResponse> {
    const response = await api.get('/staff/kategori')
    return response.data
  }

  /**
   * Get single kategori by ID (read-only for staff)
   */
  async getById(id: number): Promise<KategoriResponse> {
    const response = await api.get(`/staff/kategori/${id}`)
    return response.data
  }
}

export default new StaffKategoriService()
