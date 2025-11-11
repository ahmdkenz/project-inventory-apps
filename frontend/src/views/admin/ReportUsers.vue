<template>
  <div class="flex h-screen bg-gray-100">
    <!-- Sidebar -->
    <aside class="fixed top-0 left-0 h-full w-64 bg-gray-900 text-gray-300 shadow-lg z-30 transform -translate-x-full lg:translate-x-0 transition-transform duration-300 ease-in-out" id="sidebar">
      <div class="p-6 flex items-center space-x-3">
        <svg class="h-10 w-10 text-blue-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" d="M21 7.5l-9-5.25L3 7.5m18 0l-9 5.25m9-5.25v9l-9 5.25M3 7.5l9 5.25M3 7.5v9l9 5.25m0-9v9" />
        </svg>
        <span class="text-white text-2xl font-semibold">Inventori</span>
      </div>
      
      <AdminNavigation :current-path="$route.path" />
      
      <div class="absolute bottom-0 left-0 w-full p-4 border-t border-gray-700">
        <div class="flex items-center space-x-3">
          <img class="h-10 w-10 rounded-full" src="https://placehold.co/100x100/EBF4FF/4299E1?text=A" alt="Avatar">
          <div>
            <p class="text-sm font-medium text-white">{{ currentUser.name || 'Admin' }}</p>
            <p class="text-xs text-gray-400">Administrator</p>
          </div>
        </div>
      </div>
    </aside>

    <div class="fixed inset-0 bg-black bg-opacity-50 z-20 hidden" id="overlay" @click="toggleSidebar"></div>
    
    <div class="flex-1 flex flex-col transition-all duration-300 ease-in-out lg:ml-64" id="main-content">
      <Header @toggle-sidebar="toggleSidebar" />

      <main class="flex-1 p-6 overflow-y-auto">
        <div class="print:hidden mb-4">
          <router-link to="/admin/laporan" class="text-blue-600 hover:text-blue-800 flex items-center">
            <svg class="h-5 w-5 mr-1" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M10.5 19.5L3 12m0 0l7.5-7.5M3 12h18" />
            </svg>
            Kembali ke Pusat Laporan
          </router-link>
        </div>

        <div class="flex justify-between items-center mb-6">
          <h1 class="text-3xl font-bold text-gray-900">Laporan Pengguna</h1>
          <button @click="printReport" class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 print:hidden">
            <svg class="h-5 w-5 inline-block mr-2" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M6.72 13.829c-.24.03-.48.062-.72.096m.72-.096a42.415 42.415 0 0110.56 0m-10.56 0L6.34 18m10.94-4.171c.24.03.48.062.72.096m-.72-.096L17.66 18m0 0l.229 2.523a1.125 1.125 0 01-1.12 1.227H7.231c-.662 0-1.18-.568-1.12-1.227L6.34 18m11.318 0h1.091A2.25 2.25 0 0021 15.75V9.456c0-1.081-.768-2.015-1.837-2.175a48.055 48.055 0 00-1.913-.247M6.34 18H5.25A2.25 2.25 0 013 15.75V9.456c0-1.081.768-2.015 1.837-2.175a48.041 48.041 0 011.913-.247m10.5 0a48.536 48.536 0 00-10.5 0m10.5 0V3.375c0-.621-.504-1.125-1.125-1.125h-8.25c-.621 0-1.125.504-1.125 1.125v3.659M18 10.5h.008v.008H18V10.5zm-3 0h.008v.008H15V10.5z" />
            </svg>
            Cetak Laporan
          </button>
        </div>

        <!-- Filter Section -->
        <div class="bg-white p-4 rounded-lg shadow mb-6 print:hidden">
          <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Filter Berdasarkan Role</label>
              <select v-model="filters.role" class="w-full border border-gray-300 rounded-lg p-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                <option value="">Semua Role</option>
                <option value="admin">Admin</option>
                <option value="staff">Staff</option>
              </select>
            </div>
            <div class="flex items-end">
              <button @click="loadUsers" class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 w-full">
                <svg class="h-5 w-5 inline-block mr-2" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M21 21l-5.197-5.197m0 0A7.5 7.5 0 105.196 5.196a7.5 7.5 0 0010.607 10.607z" />
                </svg>
                Terapkan Filter
              </button>
            </div>
          </div>
        </div>

        <!-- Summary Cards -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
          <div class="bg-white p-6 rounded-lg shadow-sm">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-sm font-medium text-gray-600">Total Pengguna</p>
                <p class="text-3xl font-bold text-gray-900">{{ stats.totalUsers }}</p>
              </div>
              <div class="p-3 rounded-full bg-blue-100 text-blue-600">
                <svg class="h-8 w-8" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M15 19.128a9.38 9.38 0 002.625.372 9.337 9.337 0 004.121-.952 4.125 4.125 0 00-7.533-2.493M15 19.128v-.003c0-1.113-.285-2.16-.786-3.07M15 19.128v.106A12.318 12.318 0 018.624 21c-2.331 0-4.512-.645-6.374-1.766l-.001-.109a6.375 6.375 0 0111.964-3.07M12 6.375a3.375 3.375 0 11-6.75 0 3.375 3.375 0 016.75 0zm8.25 2.25a2.625 2.625 0 11-5.25 0 2.625 2.625 0 015.25 0z" />
                </svg>
              </div>
            </div>
          </div>

          <div class="bg-white p-6 rounded-lg shadow-sm">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-sm font-medium text-gray-600">Administrator</p>
                <p class="text-3xl font-bold text-gray-900">{{ stats.adminCount }}</p>
              </div>
              <div class="p-3 rounded-full bg-green-100 text-green-600">
                <svg class="h-8 w-8" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75L11.25 15 15 9.75m-3-7.036A11.959 11.959 0 013.598 6 11.99 11.99 0 003 9.749c0 5.592 3.824 10.29 9 11.623 5.176-1.332 9-6.03 9-11.622 0-1.31-.21-2.571-.598-3.751h-.152c-3.196 0-6.1-1.248-8.25-3.285z" />
                </svg>
              </div>
            </div>
          </div>

          <div class="bg-white p-6 rounded-lg shadow-sm">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-sm font-medium text-gray-600">Staff</p>
                <p class="text-3xl font-bold text-gray-900">{{ stats.staffCount }}</p>
              </div>
              <div class="p-3 rounded-full bg-orange-100 text-orange-600">
                <svg class="h-8 w-8" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z" />
                </svg>
              </div>
            </div>
          </div>
        </div>

        <!-- User Table -->
        <div class="bg-white rounded-lg shadow overflow-hidden">
          <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
              <thead class="bg-gray-50">
                <tr>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nama</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Username</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Role</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tanggal Bergabung</th>
                </tr>
              </thead>
              <tbody class="bg-white divide-y divide-gray-200">
                <tr v-for="user in users" :key="user.id">
                  <td class="px-6 py-4 whitespace-nowrap">
                    <div class="text-sm font-medium text-gray-900">{{ user.name }}</div>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <div class="text-sm text-gray-900">{{ user.username }}</div>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <span v-if="user.role === 'admin'" class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                      Administrator
                    </span>
                    <span v-else class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-blue-100 text-blue-800">
                      Staff
                    </span>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {{ formatDate(user.created_at) }}
                  </td>
                </tr>
                <tr v-if="users.length === 0">
                  <td colspan="4" class="px-6 py-4 text-center text-sm text-gray-500">
                    Tidak ada data pengguna
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </main>
      <Footer />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import AdminNavigation from '@/components/AdminNavigation.vue'
import Header from '@/components/Header.vue'
import Footer from '@/components/Footer.vue'
import axios from 'axios'

const router = useRouter()

const currentUser = ref({
  name: localStorage.getItem('user') ? JSON.parse(localStorage.getItem('user')!).name : 'Admin'
})

interface User {
  id: number
  name: string
  username: string
  role: string
  created_at: string
}

const users = ref<User[]>([])
const filters = ref({
  role: ''
})

const stats = ref({
  totalUsers: 0,
  adminCount: 0,
  staffCount: 0
})

const toggleSidebar = () => {
  const sidebar = document.getElementById('sidebar')
  const overlay = document.getElementById('overlay')
  
  if (sidebar && overlay) {
    sidebar.classList.toggle('-translate-x-full')
    overlay.classList.toggle('hidden')
  }
}

const loadUsers = async () => {
  try {
    const token = localStorage.getItem('token')
    const params: any = {}
    if (filters.value.role) {
      params.role = filters.value.role
    }

    const response = await axios.get('http://localhost:8000/api/admin/reports/users', {
      headers: { Authorization: `Bearer ${token}` },
      params
    })

    users.value = response.data.users
    stats.value = {
      totalUsers: response.data.stats.total,
      adminCount: response.data.stats.admin,
      staffCount: response.data.stats.staff
    }
  } catch (error) {
    console.error('Error loading users:', error)
  }
}

const formatDate = (dateString: string) => {
  const date = new Date(dateString)
  const options: Intl.DateTimeFormatOptions = { 
    year: 'numeric', 
    month: 'long', 
    day: 'numeric' 
  }
  return date.toLocaleDateString('id-ID', options)
}

const printReport = () => {
  window.print()
}

onMounted(() => {
  loadUsers()
})
</script>

<style>
@media print {
  #sidebar, header, .print\:hidden {
    display: none !important;
  }
  
  #main-content {
    margin-left: 0 !important;
  }
  
  body {
    background: white;
  }
}
</style>
