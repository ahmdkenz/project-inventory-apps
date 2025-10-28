<!-- AdminDashboard.vue -->
<template>
  <div class="flex h-screen">
    <!-- Sidebar -->
    <aside class="fixed top-0 left-0 h-full w-64 bg-gray-900 text-gray-300 shadow-lg z-30 transform -translate-x-full lg:translate-x-0 transition-transform duration-300 ease-in-out" id="sidebar">
      <!-- Logo/Header Sidebar -->
      <div class="p-6 flex items-center space-x-3">
        <svg class="h-10 w-10 text-blue-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" d="M21 7.5l-9-5.25L3 7.5m18 0l-9 5.25m9-5.25v9l-9 5.25M3 7.5l9 5.25M3 7.5v9l9 5.25m0-9v9" />
        </svg>
        <span class="text-white text-2xl font-semibold">Inventori</span>
      </div>
      
      <!-- Menu Navigasi Admin -->
      <AdminNavigation :current-path="$route.path" />
      
      <!-- User Info di Bawah Sidebar -->
      <div class="absolute bottom-0 left-0 w-full p-4 border-t border-gray-700">
        <div class="flex items-center space-x-3">
          <img class="h-10 w-10 rounded-full" src="https://placehold.co/100x100/EBF8FF/3182CE?text=A" alt="Avatar Pengguna">
          <div>
            <p class="text-sm font-medium text-white">{{ user?.name || 'Admin' }}</p>
            <p class="text-xs text-gray-400">Administrator</p>
          </div>
        </div>
      </div>
    </aside>

    <!-- Latar belakang overlay untuk mobile -->
    <div class="fixed inset-0 bg-black bg-opacity-50 z-20 hidden" id="overlay"></div>
    
    <!-- Konten Utama -->
    <div class="flex-1 flex flex-col transition-all duration-300 ease-in-out lg:ml-64" id="main-content">
      <!-- Header/Navbar Atas -->
      <header class="bg-white shadow-sm p-4 flex items-center justify-between z-10">
        <!-- Tombol Hamburger (Mobile) -->
        <button id="hamburger-btn" class="text-gray-600 lg:hidden" @click="toggleSidebar">
          <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5" />
          </svg>
        </button>
        
        <!-- Search Bar -->
        <div class="relative hidden sm:block">
          <input type="text" class="border border-gray-300 rounded-full py-2 px-4 pl-10" placeholder="Cari...">
          <svg class="h-5 w-5 text-gray-400 absolute left-3 top-2.5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M21 21l-5.197-5.197m0 0A7.5 7.5 0 105.196 5.196a7.5 7.5 0 0010.607 10.607z" />
          </svg>
        </div>
        
        <!-- User Profile dan Notifikasi -->
        <div class="flex items-center space-x-4">
          <!-- Notifikasi -->
          <button class="text-gray-500 hover:text-gray-700 relative">
            <span class="absolute top-0 right-0 h-2 w-2 bg-red-500 rounded-full"></span>
            <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M14.857 17.082a23.848 23.848 0 005.454-1.31A8.967 8.967 0 0118 9.75v-.7V9A6 6 0 006 9v.75a8.967 8.967 0 01-2.312 6.022c1.733.64 3.56 1.085 5.455 1.31m5.714 0a24.255 24.255 0 01-5.714 0m5.714 0a3 3 0 11-5.714 0" />
            </svg>
          </button>
          
          <!-- Profile Dropdown -->
          <div class="relative" v-click-outside="closeProfileMenu">
            <button @click="toggleProfileMenu" class="flex items-center space-x-2">
              <img class="h-9 w-9 rounded-full" src="https://placehold.co/100x100/EBF8FF/3182CE?text=A" alt="Avatar Pengguna">
              <span class="hidden md:block text-sm font-medium text-gray-700">{{ user?.name || 'Admin' }}</span>
            </button>
            <div v-show="showProfileMenu" class="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg py-1 z-20">
              <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Profil Saya</a>
              <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Pengaturan</a>
              <hr class="my-1">
              <a href="#" @click.prevent="handleLogout" class="block px-4 py-2 text-sm text-red-600 hover:bg-gray-100">Logout</a>
            </div>
          </div>
        </div>
      </header>

      <!-- Konten Dashboard -->
      <main class="flex-1 p-6 overflow-y-auto">
        <h1 class="text-3xl font-bold text-gray-900 mb-6">Dashboard Admin</h1>

        <!-- Error Message -->
        <div v-if="errorMessage" class="mb-6 bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded relative" role="alert">
          <strong class="font-bold">Error!</strong>
          <span class="block sm:inline"> {{ errorMessage }}</span>
          <button @click="errorMessage = ''" class="absolute top-0 bottom-0 right-0 px-4 py-3">
            <svg class="fill-current h-6 w-6 text-red-500" role="button" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20">
              <path d="M14.348 14.849a1.2 1.2 0 0 1-1.697 0L10 11.819l-2.651 3.029a1.2 1.2 0 1 1-1.697-1.697l2.758-3.15-2.759-3.152a1.2 1.2 0 1 1 1.697-1.697L10 8.183l2.651-3.031a1.2 1.2 0 1 1 1.697 1.697l-2.758 3.152 2.758 3.15a1.2 1.2 0 0 1 0 1.698z"/>
            </svg>
          </button>
        </div>

        <!-- Loading Indicator -->
        <div v-if="isLoading" class="mb-6 bg-blue-50 border border-blue-200 text-blue-700 px-4 py-3 rounded flex items-center">
          <svg class="animate-spin h-5 w-5 mr-3 text-blue-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
          </svg>
          <span>Memuat data statistik...</span>
        </div>

        <!-- Statistik -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          <!-- Total Pengguna -->
          <div class="bg-white p-6 rounded-lg shadow-md flex items-center justify-between">
            <div>
              <p class="text-sm font-medium text-gray-500">Total Pengguna</p>
              <p class="text-3xl font-bold text-gray-900 mt-1">{{ stats.totalUsers }}</p>
            </div>
            <div class="bg-blue-100 text-blue-600 p-3 rounded-full">
              <svg class="h-8 w-8" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M18 18.72a9.094 9.094 0 003.741-.479 3 3 0 00-4.682-2.72m-4.682 2.72a3 3 0 01-4.682-2.72m-4.682 2.72c.506 1.091 1.658 1.82 2.849 1.82a3 3 0 002.849-1.82m0 0a3 3 0 00-5.698 0m5.698 0a8.96 8.96 0 015.698 0m-11.396 0a8.96 8.96 0 0011.396 0M12 21a9 9 0 100-18 9 9 0 000 18z" />
              </svg>
            </div>
          </div>

          <!-- Total Barang -->
          <div class="bg-white p-6 rounded-lg shadow-md flex items-center justify-between">
            <div>
              <p class="text-sm font-medium text-gray-500">Total Jenis Barang</p>
              <p class="text-3xl font-bold text-gray-900 mt-1">{{ stats.totalItems }}</p>
            </div>
            <div class="bg-green-100 text-green-600 p-3 rounded-full">
              <svg class="h-8 w-8" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M20.25 7.5l-.625 10.632a2.25 2.25 0 01-2.247 2.118H6.622a2.25 2.25 0 01-2.247-2.118L3.75 7.5M10.5 11.25h3M12 15h.008" />
              </svg>
            </div>
          </div>

          <!-- Stok Menipis -->
          <div class="bg-white p-6 rounded-lg shadow-md flex items-center justify-between">
            <div>
              <p class="text-sm font-medium text-gray-500">Stok Menipis</p>
              <p class="text-3xl font-bold text-yellow-600 mt-1">{{ stats.lowStock }}</p>
            </div>
            <div class="bg-yellow-100 text-yellow-600 p-3 rounded-full">
              <svg class="h-8 w-8" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.008v.008H12v-.008z" />
              </svg>
            </div>
          </div>

          <!-- Stok Habis -->
          <div class="bg-white p-6 rounded-lg shadow-md flex items-center justify-between">
            <div>
              <p class="text-sm font-medium text-gray-500">Stok Habis</p>
              <p class="text-3xl font-bold text-red-600 mt-1">{{ stats.outOfStock }}</p>
            </div>
            <div class="bg-red-100 text-red-600 p-3 rounded-full">
              <svg class="h-8 w-8" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728A9 9 0 015.636 5.636m12.728 12.728L5.636 5.636" />
              </svg>
            </div>
          </div>
        </div>

        <!-- Grafik dan Aktivitas -->
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mt-8">
          <!-- Grafik Stok -->
          <div class="lg:col-span-2 bg-white p-6 rounded-lg shadow-md">
            <h3 class="text-lg font-medium text-gray-900 mb-4">Stok per Kategori</h3>
            <div ref="chartContainer" class="h-80"></div>
          </div>
          
          <!-- Aktivitas Terbaru -->
          <div class="bg-white p-6 rounded-lg shadow-md">
            <div class="flex items-center justify-between mb-4">
              <h3 class="text-lg font-medium text-gray-900">Aktivitas Terbaru (Semua)</h3>
              <router-link 
                to="/admin/audit-log" 
                class="text-sm text-blue-600 hover:text-blue-700 font-medium">
                Lihat Semua
              </router-link>
            </div>
            <div v-if="loadingActivities" class="flex justify-center items-center py-8">
              <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
            </div>
            <ul v-else class="space-y-4">
              <li v-if="recentActivities.length === 0" class="text-center py-8 text-gray-500">
                <svg class="mx-auto h-10 w-10 text-gray-400 mb-2" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M12 6v6h4.5m4.5 0a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                <p class="text-sm">Tidak ada aktivitas terbaru</p>
              </li>
              <li v-for="activity in recentActivities" :key="activity.id" class="flex items-start space-x-3">
                <div :class="getActivityIconClass(activity.action)">
                  <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" :d="getActivityIcon(activity.action)" />
                  </svg>
                </div>
                <div class="flex-1 min-w-0">
                  <p class="text-sm font-medium text-gray-800">
                    <strong>{{ activity.username }}</strong> {{ activity.description }}
                  </p>
                  <p class="text-xs text-gray-500">{{ formatActivityTime(activity.created_at) }}</p>
                </div>
              </li>
            </ul>
          </div>
        </div>
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import api from '@/services/api'
import auditLogService, { type AuditLog } from '@/services/auditLog.service'
import ApexCharts from 'apexcharts'
import AdminNavigation from '@/components/AdminNavigation.vue'

// Router
const router = useRouter()
const authStore = useAuthStore()

// State
const showProfileMenu = ref(false)
const chartContainer = ref(null)
const user = ref<any>(null)
const stats = ref({
  totalUsers: 0,
  totalItems: 0,
  lowStock: 0,
  outOfStock: 0
})
const recentActivities = ref<AuditLog[]>([])
const loadingActivities = ref(false)
const errorMessage = ref('')
const isLoading = ref(false)
let refreshInterval: number | null = null

// Methods
const toggleProfileMenu = () => {
  showProfileMenu.value = !showProfileMenu.value
}

const closeProfileMenu = () => {
  showProfileMenu.value = false
}

const toggleSidebar = () => {
  const sidebar = document.getElementById('sidebar')
  const overlay = document.getElementById('overlay')
  if (sidebar && overlay) {
    sidebar.classList.toggle('-translate-x-full')
    overlay.classList.toggle('hidden')
  }
}

const handleLogout = async () => {
  try {
    await authStore.logout()
    await router.push('/login')
  } catch (error) {
    console.error('Error during logout:', error)
    // Even if logout fails on server, clear local data and redirect
    localStorage.removeItem('token')
    localStorage.removeItem('user')
    await router.push('/login')
  }
}

const isActiveRoute = (path: string) => {
  return router.currentRoute.value.path === path
}

const getActivityIconClass = (action: string) => {
  const classes: any = {
    'login': 'bg-green-100 text-green-600 p-2 rounded-full',
    'logout': 'bg-gray-100 text-gray-600 p-2 rounded-full',
    'create': 'bg-blue-100 text-blue-600 p-2 rounded-full',
    'update': 'bg-yellow-100 text-yellow-600 p-2 rounded-full',
    'delete': 'bg-red-100 text-red-600 p-2 rounded-full',
    'approve': 'bg-green-100 text-green-600 p-2 rounded-full',
    'reject': 'bg-red-100 text-red-600 p-2 rounded-full'
  }
  return classes[action] || 'bg-gray-100 text-gray-600 p-2 rounded-full'
}

const getActivityIcon = (action: string) => {
  const icons: any = {
    'login': 'M15.75 9V5.25A2.25 2.25 0 0013.5 3h-6a2.25 2.25 0 00-2.25 2.25v13.5A2.25 2.25 0 007.5 21h6a2.25 2.25 0 002.25-2.25V15m3 0l3-3m0 0l-3-3m3 3H9',
    'logout': 'M15.75 9V5.25A2.25 2.25 0 0013.5 3h-6a2.25 2.25 0 00-2.25 2.25v13.5A2.25 2.25 0 007.5 21h6a2.25 2.25 0 002.25-2.25V15M12 9l-3 3m0 0l3 3m-3-3h12.75',
    'create': 'M12 4.5v15m7.5-7.5h-15',
    'update': 'M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L10.582 16.07a4.5 4.5 0 01-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 011.13-1.897l8.932-8.931z',
    'delete': 'M14.74 9l-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 01-2.244 2.077H8.084a2.25 2.25 0 01-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 00-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 013.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 00-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 00-7.5 0',
    'approve': 'M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z',
    'reject': 'M9.75 9.75l4.5 4.5m0-4.5l-4.5 4.5M21 12a9 9 0 11-18 0 9 9 0 0118 0z'
  }
  return icons[action] || 'M12 6v6h4.5m4.5 0a9 9 0 11-18 0 9 9 0 0118 0z'
}

const formatActivityTime = (timestamp: string) => {
  if (!timestamp) return '-'
  const date = new Date(timestamp)
  const now = new Date()
  const diffInMinutes = Math.floor((now.getTime() - date.getTime()) / (1000 * 60))
  
  if (diffInMinutes < 1) return 'Baru saja'
  if (diffInMinutes < 60) return `${diffInMinutes} menit lalu`
  
  const diffInHours = Math.floor(diffInMinutes / 60)
  if (diffInHours < 24) return `${diffInHours} jam lalu`
  
  const diffInDays = Math.floor(diffInHours / 24)
  if (diffInDays < 7) return `${diffInDays} hari lalu`
  
  return date.toLocaleDateString('id-ID', { day: 'numeric', month: 'short', year: 'numeric' })
}

// Fetch dashboard stats
const fetchDashboardStats = async () => {
  try {
    isLoading.value = true
    errorMessage.value = ''
    
    const response = await api.get('/admin/dashboard/stats')
    stats.value = response.data
  } catch (error: any) {
    console.error('Error fetching dashboard stats:', error)
    errorMessage.value = error.response?.data?.error || 'Gagal memuat data statistik dashboard'
  } finally {
    isLoading.value = false
  }
}

// Lifecycle hooks
onMounted(async () => {
  // Load user data
  const userData = localStorage.getItem('user')
  if (userData) {
    user.value = JSON.parse(userData)
  }

  // Initial fetch
  await fetchDashboardStats()

  // Set interval untuk update setiap 10 detik
  refreshInterval = window.setInterval(() => {
    fetchDashboardStats()
  }, 10000) // 10 seconds

  try {
    // Fetch recent activities
    loadingActivities.value = true
    const activitiesResponse = await auditLogService.getRecent(5)
    if (activitiesResponse.success) {
      recentActivities.value = activitiesResponse.data
    }
  } catch (error) {
    console.error('Error fetching activities:', error)
  } finally {
    loadingActivities.value = false
  }

  // Initialize chart
  if (chartContainer.value) {
    const options = {
      chart: {
        type: 'bar',
        height: 320
      },
      series: [{
        name: 'Stok',
        data: [30, 40, 45, 50, 49, 60, 70, 91, 125]
      }],
      xaxis: {
        categories: ['ATK', 'Elektronik', 'Furniture', 'Komputer', 'Printer', 'Jaringan', 'Software', 'Lain-lain']
      }
    }
    
    const chart = new ApexCharts(chartContainer.value, options)
    chart.render()
  }
})

// Clear interval ketika component di-unmount
onUnmounted(() => {
  if (refreshInterval) {
    clearInterval(refreshInterval)
  }
})
</script>