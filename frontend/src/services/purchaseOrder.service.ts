import api from './api'

export interface PurchaseOrderItem {
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

export interface PurchaseOrder {
  id?: number
  no_po?: string
  supplier_id: number
  supplier?: {
    id: number
    nama: string
    kontak_person: string
    telepon: string
  }
  tgl_pesan: string
  tgl_estimasi: string
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
  items: PurchaseOrderItem[]
  created_at?: string
  updated_at?: string
}

export interface PurchaseOrderResponse {
  success: boolean
  message: string
  data: PurchaseOrder | PurchaseOrder[]
  errors?: any
}

class PurchaseOrderService {
  /**
   * Get all purchase orders (staff view)
   */
  async getAll(): Promise<PurchaseOrderResponse> {
    const response = await api.get('/staff/purchase-order')
    return response.data
  }

  /**
   * Get single purchase order by ID
   */
  async getById(id: number): Promise<PurchaseOrderResponse> {
    const response = await api.get(`/staff/purchase-order/${id}`)
    return response.data
  }

  /**
   * Create new purchase order
   */
  async create(data: PurchaseOrder): Promise<PurchaseOrderResponse> {
    const response = await api.post('/staff/purchase-order', data)
    return response.data
  }

  /**
   * Update existing purchase order (only if status is pending)
   */
  async update(id: number, data: PurchaseOrder): Promise<PurchaseOrderResponse> {
    const response = await api.put(`/staff/purchase-order/${id}`, data)
    return response.data
  }

  /**
   * Delete purchase order (only if status is pending)
   */
  async delete(id: number): Promise<PurchaseOrderResponse> {
    const response = await api.delete(`/staff/purchase-order/${id}`)
    return response.data
  }

  /**
   * Get all purchase orders for admin approval
   */
  async getAllForAdmin(): Promise<PurchaseOrderResponse> {
    const response = await api.get('/admin/purchase-order')
    return response.data
  }

  /**
   * Get all purchase orders with filters (admin)
   */
  async adminGetAll(params?: any): Promise<PurchaseOrderResponse> {
    const response = await api.get('/admin/purchase-order', { params })
    return response.data
  }

  /**
   * Get single purchase order by ID (admin)
   */
  async adminGetById(id: number): Promise<PurchaseOrderResponse> {
    const response = await api.get(`/admin/purchase-order/${id}`)
    return response.data
  }

  /**
   * Approve purchase order (admin only)
   */
  async approve(id: number): Promise<PurchaseOrderResponse> {
    const response = await api.post(`/admin/purchase-order/${id}/approve`)
    return response.data
  }

  /**
   * Reject purchase order (admin only)
   */
  async reject(id: number, reason?: string): Promise<PurchaseOrderResponse> {
    const response = await api.post(`/admin/purchase-order/${id}/reject`, { reason })
    return response.data
  }

  /**
   * Receive purchase order (admin only) - terima barang
   */
  async receive(id: number, data: { no_surat_jalan: string, items: any[] }): Promise<PurchaseOrderResponse> {
    const response = await api.post(`/admin/purchase-order/${id}/receive`, data)
    return response.data
  }
}

export default new PurchaseOrderService()
