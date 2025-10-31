import api from './api'

export interface ReceivedItem {
  id: number | string
  original_id: number
  no_dokumen: string
  tanggal: string
  tipe: 'po' | 'non-po'
  no_referensi: string | null
  sumber: string
  total_nilai: number
  dicatat_oleh: string
}

export interface ReceivedItemsResponse {
  data: ReceivedItem[]
  meta: {
    current_page: number
    last_page: number
    per_page: number
    total: number
  }
}

export interface ReceivedItemsFilter {
  search?: string
  type?: string
  start_date?: string
  end_date?: string
  page?: number
}

const receivedItemsService = {
  async getAll(filters?: ReceivedItemsFilter, role: 'admin' | 'staff' = 'admin'): Promise<ReceivedItemsResponse> {
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

    const response = await api.get(`/${role}/received-items?${params.toString()}`)
    return response.data
  }
}

export default receivedItemsService
