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
      <header class="bg-white shadow-sm p-4 flex items-center justify-between z-10 print:hidden">
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
              <span class="hidden md:block text-sm font-medium text-gray-700">{{ currentUser.name || 'Admin' }}</span>
            </button>
            <div v-if="showProfileMenu" class="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg py-1 z-20">
              <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Profil Saya</a>
              <a @click.prevent="handleLogout" href="#" class="block px-4 py-2 text-sm text-red-600 hover:bg-gray-100">Logout</a>
            </div>
          </div>
        </div>
      </header>

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
          <h1 class="text-3xl font-bold text-gray-900">Laporan Barang Masuk</h1>
          <button @click="printReport" class="bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 print:hidden">
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
              <label class="block text-sm font-medium text-gray-700 mb-2">Tanggal Mulai</label>
              <input type="date" v-model="filters.start_date" class="w-full border border-gray-300 rounded-lg p-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Tanggal Selesai</label>
              <input type="date" v-model="filters.end_date" class="w-full border border-gray-300 rounded-lg p-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
            </div>
            <div class="flex items-end">
              <button @click="loadData" class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 w-full">
                <svg class="h-5 w-5 inline-block mr-2" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M21 21l-5.197-5.197m0 0A7.5 7.5 0 105.196 5.196a7.5 7.5 0 0010.607 10.607z" />
                </svg>
                Terapkan Filter
              </button>
            </div>
          </div>
        </div>

        <!-- Print Area -->
        <div class="bg-white rounded-lg shadow-md p-8 md:p-12">
          <!-- Header Document -->
          <div class="border-b-2 border-gray-900 pb-4 mb-8">
            <h2 class="text-xl font-semibold text-gray-800">Sistem Inventori</h2>
            <h1 class="text-3xl font-bold text-gray-900 mt-2">Laporan Transaksi Barang Masuk</h1>
            <p class="text-gray-600">Periode: {{ formatDate(filters.start_date || '') }} - {{ formatDate(filters.end_date || '') }}</p>
          </div>

          <!-- Table -->
          <div class="overflow-x-auto">
            <table class="w-full min-w-max">
              <thead class="border-b border-gray-300">
                <tr>
                  <th class="px-4 py-3 text-left text-sm font-medium text-gray-600 uppercase">No. Transaksi</th>
                  <th class="px-4 py-3 text-left text-sm font-medium text-gray-600 uppercase">Tanggal</th>
                  <th class="px-4 py-3 text-left text-sm font-medium text-gray-600 uppercase">Distributor</th>
                  <th class="px-4 py-3 text-center text-sm font-medium text-gray-600 uppercase">Total Item</th>
                  <th class="px-4 py-3 text-right text-sm font-medium text-gray-600 uppercase">Total Biaya</th>
                  <th class="px-4 py-3 text-left text-sm font-medium text-gray-600 uppercase">Dicatat Oleh</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-gray-200">
                <tr v-for="transaction in transactions" :key="transaction.id" class="print-no-break">
                  <td class="px-4 py-4 text-sm text-gray-800">{{ transaction.no_po }}</td>
                  <td class="px-4 py-4 text-sm text-gray-800">{{ formatDate(transaction.tgl_pesan) }}</td>
                  <td class="px-4 py-4 text-sm font-medium text-gray-900">{{ transaction.supplier?.nama || '-' }}</td>
                  <td class="px-4 py-4 text-sm text-gray-800 text-center">{{ transaction.items_count }} Jenis</td>
                  <td class="px-4 py-4 text-sm text-gray-800 text-right">Rp {{ formatCurrency(transaction.total) }}</td>
                  <td class="px-4 py-4 text-sm text-gray-800">{{ transaction.creator?.name || '-' }}</td>
                </tr>
                <tr v-if="transactions.length === 0">
                  <td colspan="6" class="px-4 py-4 text-center text-sm text-gray-500">
                    Tidak ada data transaksi
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import AdminNavigation from '@/components/AdminNavigation.vue'
import axios from 'axios'

const router = useRouter()
const showProfileMenu = ref(false)

const currentUser = ref({
  name: localStorage.getItem('user') ? JSON.parse(localStorage.getItem('user')!).name : 'Admin'
})

interface PurchaseOrder {
  id: number
  no_po: string
  tgl_pesan: string
  total: number
  items_count: number
  supplier?: {
    nama: string
  }
  creator?: {
    name: string
  }
}

const transactions = ref<PurchaseOrder[]>([])
const filters = ref({
  start_date: '',
  end_date: ''
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

const loadData = async () => {
  try {
    const token = localStorage.getItem('token')
    const params: any = {}
    if (filters.value.start_date) {
      params.start_date = filters.value.start_date
    }
    if (filters.value.end_date) {
      params.end_date = filters.value.end_date
    }

    const response = await axios.get('http://localhost:8000/api/admin/reports/incoming', {
      headers: { Authorization: `Bearer ${token}` },
      params
    })

    transactions.value = response.data.transactions
  } catch (error) {
    console.error('Error loading data:', error)
  }
}

const formatDate = (dateString: string) => {
  if (!dateString) return '-'
  const date = new Date(dateString)
  const options: Intl.DateTimeFormatOptions = { 
    year: 'numeric', 
    month: 'long', 
    day: 'numeric' 
  }
  return date.toLocaleDateString('id-ID', options)
}

const formatCurrency = (value: number) => {
  return new Intl.NumberFormat('id-ID').format(value)
}

const printReport = () => {
  window.print()
}

onMounted(() => {
  // Set default dates (last 30 days)
  const endDate = new Date()
  const startDate = new Date()
  startDate.setDate(startDate.getDate() - 30)
  
  filters.value.end_date = endDate.toISOString().split('T')[0] || ''
  filters.value.start_date = startDate.toISOString().split('T')[0] || ''
  
  loadData()
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
  
  .print-no-break {
    page-break-inside: avoid;
  }
}
</style>
