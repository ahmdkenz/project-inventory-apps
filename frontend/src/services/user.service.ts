import api from './api'

export interface User {
  id?: number
  name: string
  username: string
  email: string
  role: 'admin' | 'staff'
  status?: 'active' | 'inactive'
  created_at?: string
  updated_at?: string
}

export interface UserFormData {
  name: string
  username: string
  email: string
  role: 'admin' | 'staff'
  password?: string
  password_confirmation?: string
}

export interface ApiResponse<T> {
  success: boolean
  message?: string
  data: T
}

const userService = {
  // Get all users
  async getAll(): Promise<ApiResponse<User[]>> {
    const response = await api.get('/admin/users')
    return response.data
  },

  // Get user by ID
  async getById(id: number): Promise<ApiResponse<User>> {
    const response = await api.get(`/admin/users/${id}`)
    return response.data
  },

  // Create new user
  async create(userData: UserFormData): Promise<ApiResponse<User>> {
    const response = await api.post('/admin/users', userData)
    return response.data
  },

  // Update user
  async update(id: number, userData: Partial<UserFormData>): Promise<ApiResponse<User>> {
    const response = await api.put(`/admin/users/${id}`, userData)
    return response.data
  },

  // Delete user
  async delete(id: number): Promise<ApiResponse<null>> {
    const response = await api.delete(`/admin/users/${id}`)
    return response.data
  },

  // Toggle user status
  async toggleStatus(id: number): Promise<ApiResponse<User>> {
    const response = await api.patch(`/admin/users/${id}/toggle-status`)
    return response.data
  }
}

export default userService
