import api from './api'

export interface Kategori {
  id: number
  nama: string
  deskripsi?: string
  created_at?: string
  updated_at?: string
}

export interface KategoriResponse {
  success: boolean
  message: string
  data: Kategori | Kategori[]
}

class KategoriService {
  /**
   * Get all kategori
   */
  async getAll(): Promise<KategoriResponse> {
    const response = await api.get('/admin/kategori')
    return response.data
  }
}

export default new KategoriService()
