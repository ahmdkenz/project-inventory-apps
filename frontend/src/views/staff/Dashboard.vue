<!-- StaffDashboard.vue -->
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
      
      <!-- Menu Navigasi Staff -->
      <StaffNavigation :current-path="$route.path" />
      
      <!-- User Info di Bawah Sidebar -->
      <div class="absolute bottom-0 left-0 w-full p-4 border-t border-gray-700">
        <div class="flex items-center space-x-3">
          <img class="h-10 w-10 rounded-full" src="https://placehold.co/100x100/EBF4FF/4299E1?text=S" alt="Avatar Pengguna">
          <div>
            <p class="text-sm font-medium text-white">{{ user?.name || 'Staff' }}</p>
            <p class="text-xs text-gray-400">Staff Gudang</p>
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
          <div class="relative" v-click-outside:closeProfileMenu>
            <button @click="toggleProfileMenu" class="flex items-center space-x-2">
              <img class="h-9 w-9 rounded-full" src="https://placehold.co/100x100/EBF4FF/4299E1?text=S" alt="Avatar Pengguna">
              <span class="hidden md:block text-sm font-medium text-gray-700">{{ user?.name || 'Staff' }}</span>
            </button>
            <div v-show="showProfileMenu" class="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg py-1 z-20">
              <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Profil Saya</a>
              <hr class="my-1">
              <a href="#" @click.prevent="handleLogout" class="block px-4 py-2 text-sm text-red-600 hover:bg-gray-100">Logout</a>
            </div>
          </div>
        </div>
      </header>

      <!-- Konten Dashboard -->
      <main class="flex-1 p-6 overflow-y-auto">
        <h1 class="text-3xl font-bold text-gray-900 mb-6">Dashboard Staff</h1>

        <!-- Statistik -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
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

          <!-- Barang Masuk Hari Ini -->
          <div class="bg-white p-6 rounded-lg shadow-md flex items-center justify-between">
            <div>
              <p class="text-sm font-medium text-gray-500">Barang Masuk (Hari Ini)</p>
              <p class="text-3xl font-bold text-gray-900 mt-1">{{ stats.todayIn }}</p>
            </div>
            <div class="bg-blue-100 text-blue-600 p-3 rounded-full">
              <svg class="h-8 w-8" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
              </svg>
            </div>
          </div>

          <!-- Barang Keluar Hari Ini -->
          <div class="bg-white p-6 rounded-lg shadow-md flex items-center justify-between">
            <div>
              <p class="text-sm font-medium text-gray-500">Barang Keluar (Hari Ini)</p>
              <p class="text-3xl font-bold text-gray-900 mt-1">{{ stats.todayOut }}</p>
            </div>
            <div class="bg-gray-100 text-gray-600 p-3 rounded-full">
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
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import axios from 'axios'
import StaffNavigation from '@/components/StaffNavigation.vue'

// Router
const router = useRouter()

// State
const showProfileMenu = ref(false)
const user = ref(null)
const stats = ref({
  lowStock: 0,
  outOfStock: 0,
  todayIn: 0,
  todayOut: 0
})
const myActivities = ref([])

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
    await axios.post('http://localhost:8000/api/auth/logout')
    localStorage.removeItem('token')
    localStorage.removeItem('user')
    router.push('/login')
  } catch (error) {
    console.error('Error during logout:', error)
  }
}

const isActiveRoute = (path: string) => {
  return router.currentRoute.value.path === path
}

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
  // Load user data
  const userData = localStorage.getItem('user')
  if (userData) {
    user.value = JSON.parse(userData)
  }

  try {
    // Fetch dashboard data
    const response = await axios.get('http://localhost:8000/api/staff/dashboard/stats')
    stats.value = response.data

    // Fetch my activities
    const activitiesResponse = await axios.get('http://localhost:8000/api/staff/activities/my')
    myActivities.value = activitiesResponse.data
  } catch (error) {
    console.error('Error fetching dashboard data:', error)
  }
})
</script>