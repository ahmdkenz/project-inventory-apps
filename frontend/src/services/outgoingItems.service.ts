import api from './api'

export interface OutgoingItem {
  id: number | string
  original_id: number
  no_dokumen: string
  tanggal: string
  tipe: 'so' | 'non-so'
  no_referensi: string | null
  penerima: string
  dicatat_oleh: string
}

export interface OutgoingItemsResponse {
  data: OutgoingItem[]
  meta: {
    current_page: number
    last_page: number
    per_page: number
    total: number
  }
}

export interface OutgoingItemsFilter {
  search?: string
  type?: string
  start_date?: string
  end_date?: string
  page?: number
}

const outgoingItemsService = {
  async getAll(filters?: OutgoingItemsFilter): Promise<OutgoingItemsResponse> {
    const params = new URLSearchParams()
    
    if (filters?.search) {
      params.append('search', filters.search)
    }
    if (filters?.type) {
      params.append('type', filters.type)
    }
    if (filters?.start_date) {
      params.append('start_date', filters.start_date)
    }
    if (filters?.end_date) {
      params.append('end_date', filters.end_date)
    }
    if (filters?.page) {
      params.append('page', filters.page.toString())
    }

    const response = await api.get(`/admin/outgoing-items?${params.toString()}`)
    return response.data
  }
}

export default outgoingItemsService
