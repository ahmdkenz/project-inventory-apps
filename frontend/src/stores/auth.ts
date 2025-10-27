import { defineStore } from 'pinia'
import { ref } from 'vue'
import type { User } from '@/services/auth'
import authService from '@/services/auth'

export const useAuthStore = defineStore('auth', () => {
  const user = ref<User | null>(null)
  const isAuthenticated = ref(false)

  // Initialize state from localStorage
  const initialize = () => {
    const storedUser = localStorage.getItem('user')
    if (storedUser) {
      user.value = JSON.parse(storedUser)
      isAuthenticated.value = true
    }
  }

  // Login
  const login = async (username: string, password: string, remember: boolean) => {
    const response = await authService.login({ username, password, remember })
    user.value = response.user
    isAuthenticated.value = true
    localStorage.setItem('token', response.token)
    localStorage.setItem('user', JSON.stringify(response.user))
  }

  // Logout
  const logout = async () => {
    await authService.logout()
    user.value = null
    isAuthenticated.value = false
  }

  // Get user role
  const role = () => user.value?.role

  // Check if user is admin
  const isAdmin = () => user.value?.role === 'admin'

  // Check if user is staff
  const isStaff = () => user.value?.role === 'staff'

  return {
    user,
    isAuthenticated,
    initialize,
    login,
    logout,
    role,
    isAdmin,
    isStaff
  }
})