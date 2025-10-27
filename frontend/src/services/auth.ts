import api from './api'

export interface LoginCredentials {
  username: string
  password: string
  remember?: boolean
}

export interface User {
  id: number
  name: string
  username: string
  role: 'admin' | 'staff'
}

export interface LoginResponse {
  token: string
  user: User
}

class AuthService {
  async login(credentials: LoginCredentials): Promise<LoginResponse> {
    const response = await api.post<LoginResponse>('/auth/login', credentials)
    return response.data
  }

  async logout(): Promise<void> {
    await api.post('/auth/logout')
    localStorage.removeItem('token')
    localStorage.removeItem('user')
  }

  getUser(): User | null {
    const userStr = localStorage.getItem('user')
    return userStr ? JSON.parse(userStr) : null
  }

  isAuthenticated(): boolean {
    return !!localStorage.getItem('token')
  }

  isAdmin(): boolean {
    const user = this.getUser()
    return user?.role === 'admin'
  }

  isStaff(): boolean {
    const user = this.getUser()
    return user?.role === 'staff'
  }
}

export default new AuthService()