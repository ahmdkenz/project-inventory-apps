<!-- StaffDashboard.vue -->
<template>
  <div>
        <div class="flex items-center justify-between mb-6">
          <h1 class="text-3xl font-bold text-gray-900">Dashboard Staff</h1>
          <button @click="fetchDashboardData" :disabled="isRefreshing" class="bg-blue-600 hover:bg-blue-700 disabled:bg-blue-400 text-white font-medium py-2 px-4 rounded-lg flex items-center space-x-2 transition duration-150">
            <svg class="h-5 w-5" :class="{ 'animate-spin': isRefreshing }" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M16.023 9.348h4.992v-.001M2.985 19.644v-4.992m0 0h4.992m-4.993 0l3.181 3.183a8.25 8.25 0 0013.803-3.7M4.031 9.865a8.25 8.25 0 0113.803-3.7l3.181 3.182m0-4.991v4.99" />
            </svg>
            <span>{{ isRefreshing ? 'Memuat...' : 'Refresh' }}</span>
          </button>
        </div>

        <!-- Alert Notifikasi Stock -->
        <div v-if="stats.outOfStock > 0 || stats.lowStock > 0" class="mb-6 space-y-3">
          <!-- Alert Stock Habis -->
          <div v-if="stats.outOfStock > 0" class="bg-red-50 border-l-4 border-red-500 p-4 rounded-lg flex items-start space-x-3">
            <svg class="h-6 w-6 text-red-500 flex-shrink-0 mt-0.5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.008v.008H12v-.008z" />
            </svg>
            <div class="flex-1">
              <h3 class="text-sm font-medium text-red-800">Peringatan: Stock Habis!</h3>
              <p class="text-sm text-red-700 mt-1">Terdapat <strong>{{ stats.outOfStock }} item</strong> dengan stok habis. Segera lakukan pemesanan ulang!</p>
            </div>
          </div>

          <!-- Alert Stock Menipis -->
          <div v-if="stats.lowStock > 0" class="bg-yellow-50 border-l-4 border-yellow-500 p-4 rounded-lg flex items-start space-x-3">
            <svg class="h-6 w-6 text-yellow-500 flex-shrink-0 mt-0.5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.008v.008H12v-.008z" />
            </svg>
            <div class="flex-1">
              <h3 class="text-sm font-medium text-yellow-800">Perhatian: Stock Menipis!</h3>
              <p class="text-sm text-yellow-700 mt-1">Terdapat <strong>{{ stats.lowStock }} item</strong> dengan stok di bawah minimum. Pertimbangkan untuk melakukan pemesanan.</p>
            </div>
          </div>
        </div>

        <!-- Statistik -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          <!-- Stok Menipis -->
          <div class="bg-white p-6 rounded-lg shadow-md flex items-center justify-between border-l-4" :class="stats.lowStock > 0 ? 'border-yellow-500' : 'border-gray-200'">
            <div>
              <p class="text-sm font-medium text-gray-500">Stok Menipis</p>
              <p class="text-3xl font-bold mt-1" :class="stats.lowStock > 0 ? 'text-yellow-600' : 'text-gray-900'">{{ stats.lowStock }}</p>
              <p v-if="stats.lowStock > 0" class="text-xs text-yellow-600 mt-1">⚠️ Perlu perhatian!</p>
            </div>
            <div class="p-3 rounded-full" :class="stats.lowStock > 0 ? 'bg-yellow-100 text-yellow-600' : 'bg-gray-100 text-gray-400'">
              <svg class="h-8 w-8" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.008v.008H12v-.008z" />
              </svg>
            </div>
          </div>

          <!-- Stok Habis -->
          <div class="bg-white p-6 rounded-lg shadow-md flex items-center justify-between border-l-4" :class="stats.outOfStock > 0 ? 'border-red-500' : 'border-gray-200'">
            <div>
              <p class="text-sm font-medium text-gray-500">Stok Habis</p>
              <p class="text-3xl font-bold mt-1" :class="stats.outOfStock > 0 ? 'text-red-600' : 'text-gray-900'">{{ stats.outOfStock }}</p>
              <p v-if="stats.outOfStock > 0" class="text-xs text-red-600 mt-1">🚨 Segera pesan!</p>
            </div>
            <div class="p-3 rounded-full" :class="stats.outOfStock > 0 ? 'bg-red-100 text-red-600' : 'bg-gray-100 text-gray-400'">
              <svg class="h-8 w-8" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728A9 9 0 015.636 5.636m12.728 12.728L5.636 5.636" />
              </svg>
            </div>
          </div>

          <!-- Barang Masuk Hari Ini -->
          <div class="bg-white p-6 rounded-lg shadow-md flex items-center justify-between border-l-4 border-blue-500">
            <div>
              <p class="text-sm font-medium text-gray-500">Barang Masuk (Hari Ini)</p>
              <p class="text-3xl font-bold text-blue-600 mt-1">{{ stats.todayIn }}</p>
              <p class="text-xs text-blue-600 mt-1">📦 Transaksi masuk</p>
            </div>
            <div class="bg-blue-100 text-blue-600 p-3 rounded-full">
              <svg class="h-8 w-8" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
              </svg>
            </div>
          </div>

          <!-- Barang Keluar Hari Ini -->
          <div class="bg-white p-6 rounded-lg shadow-md flex items-center justify-between border-l-4 border-green-500">
            <div>
              <p class="text-sm font-medium text-gray-500">Barang Keluar (Hari Ini)</p>
              <p class="text-3xl font-bold text-green-600 mt-1">{{ stats.todayOut }}</p>
              <p class="text-xs text-green-600 mt-1">📤 Transaksi keluar</p>
            </div>
            <div class="bg-green-100 text-green-600 p-3 rounded-full">
              <svg class="h-8 w-8" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 12h-15" />
              </svg>
            </div>
          </div>
        </div>

        <!-- Shortcut dan Aktivitas -->
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mt-8">
          <!-- Shortcut Aksi -->
          <div class="bg-white p-6 rounded-lg shadow-md">
            <h3 class="text-lg font-medium text-gray-900 mb-4">Aksi Cepat</h3>
            <div class="space-y-4">
              <button class="w-full flex items-center justify-center space-x-2 bg-blue-600 text-white font-medium py-3 px-4 rounded-lg hover:bg-blue-700 transition duration-150">
                <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
                </svg>
                <span>Catat Barang Masuk</span>
              </button>
              <button class="w-full flex items-center justify-center space-x-2 bg-gray-600 text-white font-medium py-3 px-4 rounded-lg hover:bg-gray-700 transition duration-150">
                <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 12h-15" />
                </svg>
                <span>Catat Barang Keluar</span>
              </button>
            </div>
          </div>
          
          <!-- Aktivitas Terbaru -->
          <div class="lg:col-span-2 bg-white p-6 rounded-lg shadow-md">
            <h3 class="text-lg font-medium text-gray-900 mb-4">Aktivitas Terakhir Saya</h3>
            <ul class="space-y-4">
              <li v-for="activity in myActivities" :key="activity.id" class="flex items-center space-x-3">
                <div :class="getActivityIconClass(activity.type)">
                  <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" :d="getActivityIcon(activity.type)" />
                  </svg>
                </div>
                <div>
                  <p class="text-sm font-medium">
                    Anda {{ activity.action }} <strong>{{ activity.item }}</strong>
                  </p>
                  <p class="text-xs text-gray-500">{{ formatTime(activity.timestamp) }}</p>
                </div>
              </li>
            </ul>
          </div>
        </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import axios from 'axios'

// Types
interface Activity {
  id: number
  type: string
  action: string
  item: string
  timestamp: string
}

// Router
const router = useRouter()
const authStore = useAuthStore()

// State
const stats = ref({
  lowStock: 0,
  outOfStock: 0,
  todayIn: 0,
  todayOut: 0
})
const myActivities = ref<Activity[]>([])
const isRefreshing = ref(false)
let refreshInterval: number | null = null

// Methods
const getActivityIconClass = (type: string) => {
  const classes = {
    add: 'bg-green-100 text-green-600',
    remove: 'bg-red-100 text-red-600',
    edit: 'bg-blue-100 text-blue-600'
  }
  return `${classes[type as keyof typeof classes]} p-2 rounded-full`
}

const getActivityIcon = (type: string) => {
  const icons = {
    add: 'M12 4.5v15m7.5-7.5h-15',
    remove: 'M19.5 12h-15',
    edit: 'M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L10.582 16.07a4.5 4.5 0 01-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 011.13-1.897l8.932-8.931z'
  }
  return icons[type as keyof typeof icons]
}

const formatTime = (timestamp: string) => {
  const date = new Date(timestamp)
  const now = new Date()
  const diffInHours = Math.floor((now.getTime() - date.getTime()) / (1000 * 60 * 60))
  
  if (diffInHours < 24) {
    return `${diffInHours} jam lalu`
  }
  return `${Math.floor(diffInHours / 24)} hari lalu`
}

// Lifecycle hooks
onMounted(async () => {
  // Fetch dashboard stats
  await fetchDashboardData()
  
  // Refresh data every 30 seconds
  refreshInterval = window.setInterval(() => {
    fetchDashboardData()
  }, 30000) // 30 detik
})

// Cleanup on component unmount
onUnmounted(() => {
  if (refreshInterval) {
    clearInterval(refreshInterval)
  }
})

const fetchDashboardData = async () => {
  isRefreshing.value = true
  try {
    const token = localStorage.getItem('token')
    
    console.log('Fetching staff dashboard stats...', { token: token ? 'exists' : 'missing' })
    
    // Fetch dashboard stats
    const statsResponse = await axios.get('http://localhost:8000/api/staff/dashboard/stats', {
      headers: {
        Authorization: `Bearer ${token}`
      }
    })
    
    console.log('Stats Response:', statsResponse.data)
    
    if (statsResponse.data) {
      stats.value = {
        lowStock: statsResponse.data.lowStock || 0,
        outOfStock: statsResponse.data.outOfStock || 0,
        todayIn: statsResponse.data.todayIn || 0,
        todayOut: statsResponse.data.todayOut || 0
      }
      console.log('Stats updated:', stats.value)
    }

    // Fetch my activities
    const activitiesResponse = await axios.get('http://localhost:8000/api/staff/activities/my', {
      headers: {
        Authorization: `Bearer ${token}`
      }
    })
    
    console.log('Activities Response:', activitiesResponse.data)
    
    if (activitiesResponse.data) {
      myActivities.value = activitiesResponse.data
    }
  } catch (error: any) {
    console.error('Error fetching dashboard data:', error)
    console.error('Error details:', error.response?.data || error.message)
    // Set default values on error
    stats.value = {
      lowStock: 0,
      outOfStock: 0,
      todayIn: 0,
      todayOut: 0
    }
    myActivities.value = []
  } finally {
    isRefreshing.value = false
  }
}
</script>