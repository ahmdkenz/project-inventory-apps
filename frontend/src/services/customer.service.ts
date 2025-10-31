import api from './api'

export interface Customer {
  id: number
  company_name: string
  contact_name: string | null
  email: string
  phone: string
  address: string | null
  city: string | null
  zipcode: string | null
  created_at: string
  updated_at: string
}

export interface CustomerFormData {
  company_name: string
  contact_name?: string
  email: string
  phone: string
  address?: string
  city?: string
  zipcode?: string
}

export interface CustomersResponse {
  data: Customer[]
  current_page: number
  last_page: number
  per_page: number
  total: number
}

const customerService = {
  async getAll(search?: string, page: number = 1, perPage: number = 10): Promise<CustomersResponse> {
    const params = new URLSearchParams()
    if (search) params.append('search', search)
    params.append('page', page.toString())
    params.append('per_page', perPage.toString())

    const response = await api.get(`/admin/customers?${params.toString()}`)
    return response.data
  },

  async getById(id: number): Promise<Customer> {
    const response = await api.get(`/admin/customers/${id}`)
    return response.data.data
  },

  async create(data: CustomerFormData): Promise<Customer> {
    const response = await api.post('/admin/customers', data)
    return response.data.data
  },

  async update(id: number, data: CustomerFormData): Promise<Customer> {
    const response = await api.put(`/admin/customers/${id}`, data)
    return response.data.data
  },

  async delete(id: number): Promise<void> {
    await api.delete(`/admin/customers/${id}`)
  }
}

export default customerService
