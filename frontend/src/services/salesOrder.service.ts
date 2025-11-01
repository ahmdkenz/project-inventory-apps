import api from './api'

export interface SalesOrderItem {
  id?: number
  barang_id: number
  barang?: {
    id: number
    nama: string
    kode: string
  }
  qty: number
  harga_satuan: number
  subtotal?: number
}

export interface SalesOrder {
  id?: number
  no_so?: string
  customer_name: string
  customer_phone?: string
  customer_address?: string
  tgl_order: string
  tgl_kirim: string
  catatan?: string
  status: 'pending' | 'approved' | 'rejected' | 'completed'
  subtotal?: number
  ppn?: number
  total?: number
  created_by?: number
  creator?: {
    id: number
    name: string
    email: string
  }
  approved_by?: number
  approver?: {
    id: number
    name: string
    email: string
  }
  approved_at?: string
  reject_reason?: string
  completed_at?: string
  processor?: {
    id: number
    name: string
    email: string
  }
  no_surat_jalan?: string
  outgoing_item?: {
    id: number
    no_surat_jalan: string
    items: Array<{
      id: number
      barang_id: number
      barang?: {
        id: number
        nama: string
        kode: string
        satuan: string
      }
      qty: number
      qty_issued: number
      harga_satuan: number
      subtotal: number
      keterangan?: string
    }>
  }
  items: SalesOrderItem[]
  created_at?: string
  updated_at?: string
}

export interface SalesOrderResponse {
  success: boolean
  message: string
  data: SalesOrder | SalesOrder[]
  errors?: any
}

class SalesOrderService {
  /**
   * Get all sales orders (staff view)
   */
  async getAll(params?: any): Promise<SalesOrderResponse> {
    const response = await api.get('/staff/sales-order', { params })
    return response.data
  }

  /**
   * Get single sales order by ID
   */
  async getById(id: number): Promise<SalesOrderResponse> {
    const response = await api.get(`/staff/sales-order/${id}`)
    return response.data
  }

  /**
   * Create new sales order
   */
  async create(data: SalesOrder): Promise<SalesOrderResponse> {
    const response = await api.post('/staff/sales-order', data)
    return response.data
  }

  /**
   * Update existing sales order (only if status is pending)
   */
  async update(id: number, data: SalesOrder): Promise<SalesOrderResponse> {
    const response = await api.put(`/staff/sales-order/${id}`, data)
    return response.data
  }

  /**
   * Delete sales order (only if status is pending)
   */
  async delete(id: number): Promise<SalesOrderResponse> {
    const response = await api.delete(`/staff/sales-order/${id}`)
    return response.data
  }

  /**
   * Get all sales orders with filters (admin)
   */
  async adminGetAll(params?: any): Promise<SalesOrderResponse> {
    const response = await api.get('/admin/sales-order', { params })
    return response.data
  }

  /**
   * Get single sales order by ID (admin)
   */
  async adminGetById(id: number): Promise<SalesOrderResponse> {
    const response = await api.get(`/admin/sales-order/${id}`)
    return response.data
  }

  /**
   * Approve sales order (admin only)
   */
  async approve(id: number): Promise<SalesOrderResponse> {
    const response = await api.post(`/admin/sales-order/${id}/approve`)
    return response.data
  }

  /**
   * Reject sales order (admin only)
   */
  async reject(id: number, reason?: string): Promise<SalesOrderResponse> {
    const response = await api.post(`/admin/sales-order/${id}/reject`, { reason })
    return response.data
  }

  /**
   * Process/Issue sales order (admin only)
   */
  async process(id: number, data: { 
    no_surat_jalan: string,
    items: Array<{item_id: number, barang_id: number, qty_issued: number, keterangan?: string}>,
    catatan?: string 
  }): Promise<SalesOrderResponse> {
    const response = await api.post(`/admin/sales-order/${id}/process`, data)
    return response.data
  }
}

export default new SalesOrderService()
