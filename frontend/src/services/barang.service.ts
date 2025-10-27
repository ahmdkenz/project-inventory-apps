import api from './api'

export interface Barang {
  id?: number
  nama: string
  kode: string
  kategori_id: number
  deskripsi?: string
  stok: number
  stok_minimum?: number
  harga_beli: number
  harga_jual: number
  satuan: string
  foto?: string
  status?: boolean
  created_at?: string
  updated_at?: string
  kategori?: {
    id: number
    nama: string
  }
}

export interface BarangResponse {
  success: boolean
  message: string
  data: Barang | Barang[]
  errors?: any
}

class BarangService {
  /**
   * Get all barang
   */
  async getAll(): Promise<BarangResponse> {
    const response = await api.get('/admin/barang')
    return response.data
  }

  /**
   * Get single barang by ID
   */
  async getById(id: number): Promise<BarangResponse> {
    const response = await api.get(`/admin/barang/${id}`)
    return response.data
  }

  /**
   * Create new barang
   */
  async create(data: Barang): Promise<BarangResponse> {
    const response = await api.post('/admin/barang', data)
    return response.data
  }

  /**
   * Update existing barang
   */
  async update(id: number, data: Barang): Promise<BarangResponse> {
    const response = await api.put(`/admin/barang/${id}`, data)
    return response.data
  }

  /**
   * Delete barang
   */
  async delete(id: number): Promise<BarangResponse> {
    const response = await api.delete(`/admin/barang/${id}`)
    return response.data
  }
}

export default new BarangService()
