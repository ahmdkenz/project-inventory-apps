<template>
  <div class="flex h-screen">
    <!-- Sidebar -->
    <aside class="fixed top-0 left-0 h-full w-64 bg-gray-900 text-gray-300 shadow-lg z-30 transform -translate-x-full lg:translate-x-0 transition-transform duration-300 ease-in-out print-hidden" id="sidebar">
      <div class="p-6 flex items-center space-x-3">
        <svg class="h-10 w-10 text-blue-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" d="M21 7.5l-9-5.25L3 7.5m18 0l-9 5.25m9-5.25v9l-9 5.25M3 7.5l9 5.25M3 7.5v9l9 5.25m0-9v9" />
        </svg>
        <span class="text-white text-2xl font-semibold">Inventori</span>
      </div>
      <StaffNavigation :current-path="$route.path" />
      <div class="absolute bottom-0 left-0 w-full p-4 border-t border-gray-700">
        <div class="flex items-center space-x-3">
          <img class="h-10 w-10 rounded-full" src="https://placehold.co/100x100/EBF8FF/3182CE?text=S" alt="Avatar">
          <div>
            <p class="text-sm font-medium text-white">{{ user?.name || 'Staff' }}</p>
            <p class="text-xs text-gray-400">Staff Gudang</p>
          </div>
        </div>
      </div>
    </aside>

    <div class="fixed inset-0 bg-black bg-opacity-50 z-20 hidden" id="overlay" @click="toggleSidebar"></div>
    
    <div class="flex-1 flex flex-col transition-all duration-300 ease-in-out lg:ml-64" id="main-content">
      <header class="bg-white shadow-sm p-4 flex items-center justify-between z-10 print-hidden">
        <button class="text-gray-600 lg:hidden" @click="toggleSidebar">
          <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5" />
          </svg>
        </button>
        <div class="relative hidden sm:block">
          <input type="text" class="border border-gray-300 rounded-full py-2 px-4 pl-10" placeholder="Cari...">
          <svg class="h-5 w-5 text-gray-400 absolute left-3 top-2.5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M21 21l-5.197-5.197m0 0A7.5 7.5 0 105.196 5.196a7.5 7.5 0 0010.607 10.607z" />
          </svg>
        </div>
        <div class="flex items-center space-x-4">
          <button class="text-gray-500 hover:text-gray-700 relative">
            <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M14.857 17.082a23.848 23.848 0 005.454-1.31A8.967 8.967 0 0118 9.75v-.7V9A6 6 0 006 9v.75a8.967 8.967 0 01-2.312 6.022c1.733.64 3.56 1.085 5.455 1.31m5.714 0a24.255 24.255 0 01-5.714 0m5.714 0a3 3 0 11-5.714 0" />
            </svg>
          </button>
          <div class="relative">
            <button @click="showProfileMenu = !showProfileMenu" class="flex items-center space-x-2">
              <img class="h-9 w-9 rounded-full" src="https://placehold.co/100x100/EBF8FF/3182CE?text=S" alt="Avatar Pengguna">
              <span class="hidden md:block text-sm font-medium text-gray-700">{{ user?.name || 'Staff' }}</span>
            </button>
            <div v-if="showProfileMenu" @click.outside="showProfileMenu = false" class="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg py-1 z-20">
              <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Profil Saya</a>
              <a @click.prevent="handleLogout" href="#" class="block px-4 py-2 text-sm text-red-600 hover:bg-gray-100">Logout</a>
            </div>
          </div>
        </div>
      </header>

      <main class="flex-1 p-6 overflow-y-auto">
        <!-- Header dan Filter Tanggal -->
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6">
          <h1 class="text-3xl font-bold text-gray-900">Dashboard Laporan</h1>
          <div class="mt-4 md:mt-0">
            <div class="relative">
              <button @click="showDateFilter = !showDateFilter" class="flex items-center justify-between w-48 bg-white border border-gray-300 rounded-md shadow-sm px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                <span>{{ selectedRange }}</span>
                <svg class="ml-2 -mr-1 h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                  <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
                </svg>
              </button>
              <div v-if="showDateFilter" @click.outside="showDateFilter = false" class="absolute right-0 mt-2 w-48 rounded-md shadow-lg bg-white ring-1 ring-black ring-opacity-5 z-20">
                <div class="py-1">
                  <a href="#" @click.prevent="selectRange('Hari Ini')" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Hari Ini</a>
                  <a href="#" @click.prevent="selectRange('7 Hari Terakhir')" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">7 Hari Terakhir</a>
                  <a href="#" @click.prevent="selectRange('30 Hari Terakhir')" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">30 Hari Terakhir</a>
                  <a href="#" @click.prevent="selectRange('Bulan Ini')" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Bulan Ini</a>
                  <a href="#" @click.prevent="selectRange('Tahun Ini')" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Tahun Ini</a>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 1. KPI Cards -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-6">
          <div class="bg-white p-5 rounded-lg shadow-sm">
            <p class="text-sm text-gray-500 font-medium">Total Nilai Inventori</p>
            <p class="text-3xl font-bold text-gray-900 mt-1">{{ formatCurrency(stats.totalInventoryValue) }}</p>
          </div>
          <div class="bg-white p-5 rounded-lg shadow-sm">
            <p class="text-sm text-gray-500 font-medium">Pembelian (30 Hari)</p>
            <p class="text-3xl font-bold text-gray-900 mt-1">{{ formatCurrency(stats.totalPurchase30Days) }}</p>
          </div>
          <div class="bg-white p-5 rounded-lg shadow-sm">
            <p class="text-sm text-gray-500 font-medium">Pengeluaran (30 Hari)</p>
            <p class="text-3xl font-bold text-gray-900 mt-1">{{ formatCurrency(stats.totalSales30Days) }}</p>
          </div>
          <div class="bg-white p-5 rounded-lg shadow-sm">
            <p class="text-sm text-gray-500 font-medium">Stok Menipis</p>
            <p class="text-3xl font-bold text-yellow-600 mt-1">{{ stats.lowStockCount }} <span class="text-lg text-gray-500">barang</span></p>
          </div>
        </div>

        <!-- 2. Top 5 Barang dan Link Laporan -->
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <!-- Top 5 Barang Keluar -->
          <div class="lg:col-span-2 bg-white p-6 rounded-lg shadow-sm">
            <h2 class="text-xl font-semibold text-gray-900 mb-4">Top 5 Barang Keluar (30 Hari)</h2>
            <div class="overflow-x-auto">
              <table class="w-full min-w-max">
                <thead class="bg-gray-50">
                  <tr>
                    <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Barang</th>
                    <th class="px-4 py-2 text-center text-xs font-medium text-gray-500 uppercase">Jml Keluar</th>
                  </tr>
                </thead>
                <tbody class="divide-y divide-gray-200">
                  <tr v-for="item in topItems" :key="item.id">
                    <td class="px-4 py-3 whitespace-nowrap text-sm font-medium text-gray-900">{{ item.nama }}</td>
                    <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-600 text-center">{{ item.total_qty }}</td>
                  </tr>
                  <tr v-if="topItems.length === 0">
                    <td colspan="2" class="px-4 py-3 text-center text-sm text-gray-500">Tidak ada data</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

          <!-- Link Laporan Detail -->
          <div class="bg-white p-6 rounded-lg shadow-sm">
            <h2 class="text-xl font-semibold text-gray-900 mb-4">Laporan Detail</h2>
            <div class="space-y-4">
              <router-link to="/staff/laporan/stok" class="block bg-gray-50 p-4 rounded-lg hover:bg-gray-100 transition-colors duration-150">
                <h3 class="text-base font-semibold text-gray-800">Laporan Stok Barang</h3>
                <p class="text-sm text-gray-600">Lihat rincian stok dan nilai inventori.</p>
              </router-link>
              <router-link to="/staff/laporan/barang-masuk" class="block bg-gray-50 p-4 rounded-lg hover:bg-gray-100 transition-colors duration-150">
                <h3 class="text-base font-semibold text-gray-800">Laporan Barang Masuk</h3>
                <p class="text-sm text-gray-600">Rincian pembelian barang per periode.</p>
              </router-link>
              <router-link to="/staff/laporan/barang-keluar" class="block bg-gray-50 p-4 rounded-lg hover:bg-gray-100 transition-colors duration-150">
                <h3 class="text-base font-semibold text-gray-800">Laporan Barang Keluar</h3>
                <p class="text-sm text-gray-600">Rincian pengeluaran barang per periode.</p>
              </router-link>
            </div>
          </div>
        </div>
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import StaffNavigation from '@/components/StaffNavigation.vue'
import api from '@/services/api'

const router = useRouter()
const user = ref<any>(null)
const showProfileMenu = ref(false)
const showDateFilter = ref(false)
const selectedRange = ref('30 Hari Terakhir')

const stats = ref({
  totalInventoryValue: 0,
  totalPurchase30Days: 0,
  totalSales30Days: 0,
  lowStockCount: 0
})

const topItems = ref<any[]>([])

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

const selectRange = (range: string) => {
  selectedRange.value = range
  showDateFilter.value = false
  fetchDashboardData()
}

const formatCurrency = (value: number) => {
  return new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    minimumFractionDigits: 0,
    maximumFractionDigits: 0
  }).format(value || 0)
}

const fetchDashboardData = async () => {
  try {
    const response = await api.get('/staff/reports/dashboard')
    if (response.data.success) {
      stats.value = response.data.data.stats
      topItems.value = response.data.data.topItems || []
    }
  } catch (error) {
    console.error('Error fetching dashboard data:', error)
  }
}

onMounted(() => {
  const userData = localStorage.getItem('user')
  if (userData) {
    user.value = JSON.parse(userData)
  }
  fetchDashboardData()
})
</script>

<style scoped>
@media print {
  .print-hidden {
    display: none !important;
  }
}
</style>
