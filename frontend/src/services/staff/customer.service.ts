import api from '../api'

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

export interface CustomersResponse {
  data: Customer[]
  current_page: number
  last_page: number
  per_page: number
  total: number
}

class StaffCustomerService {
  /**
   * Get all customers (read-only for staff)
   */
  async getAll(search?: string, page: number = 1, perPage: number = 10): Promise<CustomersResponse> {
    const params = new URLSearchParams()
    if (search) params.append('search', search)
    params.append('page', page.toString())
    params.append('per_page', perPage.toString())

    const response = await api.get(`/staff/customers?${params.toString()}`)
    return response.data
  }

  /**
   * Get single customer by ID (read-only for staff)
   */
  async getById(id: number): Promise<Customer> {
    const response = await api.get(`/staff/customers/${id}`)
    return response.data.data
  }
}

export default new StaffCustomerService()
