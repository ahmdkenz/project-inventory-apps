import api from './api'

export interface Kategori {
  id?: number
  nama: string
  kode?: string
  deskripsi?: string
  created_at?: string
  updated_at?: string
}

export interface KategoriResponse {
  success: boolean
  message: string
  data: Kategori | Kategori[]
  errors?: any
}

class KategoriService {
  /**
   * Get all kategori
   */
  async getAll(): Promise<KategoriResponse> {
    const response = await api.get('/admin/kategori')
    return response.data
  }

  /**
   * Get single kategori by ID
   */
  async getById(id: number): Promise<KategoriResponse> {
    const response = await api.get(`/admin/kategori/${id}`)
    return response.data
  }

  /**
   * Create new kategori
   */
  async create(data: Kategori): Promise<KategoriResponse> {
    const response = await api.post('/admin/kategori', data)
    return response.data
  }

  /**
   * Update existing kategori
   */
  async update(id: number, data: Kategori): Promise<KategoriResponse> {
    const response = await api.put(`/admin/kategori/${id}`, data)
    return response.data
  }

  /**
   * Delete kategori
   */
  async delete(id: number): Promise<KategoriResponse> {
    const response = await api.delete(`/admin/kategori/${id}`)
    return response.data
  }
}

export default new KategoriService()
