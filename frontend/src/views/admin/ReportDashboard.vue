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
            <p class="text-sm font-medium text-white">{{ user.name || 'Admin' }}</p>
            <p class="text-xs text-gray-400">Administrator</p>
          </div>
        </div>
      </div>
    </aside>

    <div class="fixed inset-0 bg-black bg-opacity-50 z-20 hidden" id="overlay" @click="toggleSidebar"></div>
    
    <div class="flex-1 flex flex-col transition-all duration-300 ease-in-out lg:ml-64" id="main-content">
      <header class="bg-white shadow-sm p-4 flex items-center justify-between z-10">
        <button id="hamburger-btn" @click="toggleSidebar" class="text-gray-600 lg:hidden">
          <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5" />
          </svg>
        </button>
        <div class="relative hidden sm:block"></div>
        <div class="flex items-center space-x-4">
          <button class="text-gray-500 hover:text-gray-700 relative">
            <span class="absolute top-0 right-0 h-2 w-2 bg-red-500 rounded-full"></span>
            <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M14.857 17.082a23.848 23.848 0 005.454-1.31A8.967 8.967 0 0118 9.75v-.7V9A6 6 0 006 9v.75a8.967 8.967 0 01-2.312 6.022c1.733.64 3.56 1.085 5.455 1.31m5.714 0a24.255 24.255 0 01-5.714 0m5.714 0a3 3 0 11-5.714 0" />
            </svg>
          </button>
          <div class="relative">
            <button @click="showProfileMenu = !showProfileMenu" class="flex items-center space-x-2">
              <img class="h-9 w-9 rounded-full" src="https://placehold.co/100x100/EBF4FF/4299E1?text=A" alt="Avatar">
              <span class="hidden md:block text-sm font-medium text-gray-700">{{ user.name || 'Admin' }}</span>
            </button>
            <div v-if="showProfileMenu" @click.outside="showProfileMenu = false" class="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg py-1 z-20">
              <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Profil Saya</a>
              <a @click.prevent="handleLogout" href="#" class="block px-4 py-2 text-sm text-red-600 hover:bg-gray-100">Logout</a>
            </div>
          </div>
        </div>
      </header>

      <main class="flex-1 p-6 overflow-y-auto">
        <h1 class="text-3xl font-bold text-gray-900 mb-6">Pusat Laporan</h1>
        
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          
          <!-- Laporan Stok Barang -->
          <router-link to="/admin/laporan/stok" class="block bg-white p-6 rounded-lg shadow-sm hover:shadow-lg transition-shadow duration-200">
            <div class="flex items-center space-x-4">
              <div class="p-3 rounded-full bg-green-100 text-green-600">
                <svg class="h-8 w-8" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M20.25 7.5l-.625 10.632a2.25 2.25 0 01-2.247 2.118H6.622a2.25 2.25 0 01-2.247-2.118L3.75 7.5M10.5 11.25h3M12 15h.008" />
                </svg>
              </div>
              <div>
                <h2 class="text-xl font-semibold text-gray-900">Laporan Stok Barang</h2>
                <p class="text-sm text-gray-600">Lihat ketersediaan dan nilai stok saat ini.</p>
              </div>
            </div>
          </router-link>

          <!-- Laporan Barang Masuk -->
          <router-link to="/admin/laporan/barang-masuk" class="block bg-white p-6 rounded-lg shadow-sm hover:shadow-lg transition-shadow duration-200">
            <div class="flex items-center space-x-4">
              <div class="p-3 rounded-full bg-blue-100 text-blue-600">
                <svg class="h-8 w-8" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75l3 3m0 0l3-3m-3 3v-7.5M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
              </div>
              <div>
                <h2 class="text-xl font-semibold text-gray-900">Laporan Barang Masuk</h2>
                <p class="text-sm text-gray-600">Laporan periodik pembelian dan penerimaan barang.</p>
              </div>
            </div>
          </router-link>

          <!-- Laporan Barang Keluar -->
          <router-link to="/admin/laporan/barang-keluar" class="block bg-white p-6 rounded-lg shadow-sm hover:shadow-lg transition-shadow duration-200">
            <div class="flex items-center space-x-4">
              <div class="p-3 rounded-full bg-orange-100 text-orange-600">
                <svg class="h-8 w-8" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M15 11.25l-3-3m0 0l-3 3m3-3v7.5M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
              </div>
              <div>
                <h2 class="text-xl font-semibold text-gray-900">Laporan Barang Keluar</h2>
                <p class="text-sm text-gray-600">Laporan periodik permintaan dan pengeluaran barang.</p>
              </div>
            </div>
          </router-link>

          <!-- Laporan Pengguna -->
          <router-link to="/admin/laporan/pengguna" class="block bg-white p-6 rounded-lg shadow-sm hover:shadow-lg transition-shadow duration-200">
            <div class="flex items-center space-x-4">
              <div class="p-3 rounded-full bg-indigo-100 text-indigo-600">
                <svg class="h-8 w-8" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z" />
                </svg>
              </div>
              <div>
                <h2 class="text-xl font-semibold text-gray-900">Laporan Pengguna</h2>
                <p class="text-sm text-gray-600">Daftar semua pengguna terdaftar dan perannya.</p>
              </div>
            </div>
          </router-link>

        </div>
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import AdminNavigation from '@/components/AdminNavigation.vue'

const router = useRouter()
const showProfileMenu = ref(false)

const user = ref({
  name: localStorage.getItem('user') ? JSON.parse(localStorage.getItem('user')!).name : 'Admin'
})

const toggleSidebar = () => {
  const sidebar = document.getElementById('sidebar')
  const overlay = document.getElementById('overlay')
  
  if (sidebar && overlay) {
    sidebar.classList.toggle('-translate-x-full')
    overlay.classList.toggle('hidden')
  }
}

const handleLogout = () => {
  localStorage.removeItem('token')
  localStorage.removeItem('user')
  router.push('/login')
}
</script>
