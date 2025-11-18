<template>
  <div>
    <div class="flex items-center justify-between mb-6 print-hidden" id="action-buttons">
          <h1 class="text-3xl font-bold text-gray-900">Laporan Stok Barang</h1>
          <div class="flex space-x-3">
            <router-link to="/staff/laporan" class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150">
              <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5L8.25 12l7.5-7.5" />
              </svg>
              <span>Kembali</span>
            </router-link>
            <button @click="printReport" class="bg-green-600 hover:bg-green-700 text-white font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150">
              <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M6.72 13.829c-.24.03-.48.062-.72.096m.72-.096a42.415 42.415 0 0110.56 0m-10.56 0L6.34 18m10.94-4.171c.24.03.48.062.72.096m-.72-.096L17.66 18m0 0l.229 2.523a1.125 1.125 0 01-1.12 1.227H7.23a1.125 1.125 0 01-1.12-1.227L6.34 18m11.319 0H6.34m11.319 0l.044.506A1.125 1.125 0 0117.003 20H6.997a1.125 1.125 0 01-1.122-1.494l.044-.506M6.34 18v-4.172c0-.224.03-.447.086-.665A41.4 41.4 0 0112 3c1.83 0 3.597.133 5.28.362.057.218.086.44.086.665v4.172M6.34 18L4.26 7.5h15.48L17.66 18" />
              </svg>
              <span>Cetak Laporan</span>
            </button>
          </div>
        </div>

        <!-- Card Filter -->
        <div class="bg-white p-4 rounded-lg shadow-sm mb-6 print-hidden" id="filter-card">
          <h2 class="text-lg font-semibold text-gray-800 mb-3">Filter Laporan</h2>
          <div class="grid grid-cols-1 md:grid-cols-4 gap-4 items-end">
            <div>
              <label for="kategori" class="block text-sm font-medium text-gray-700 mb-1">Kategori</label>
              <select v-model="filters.kategori_id" id="kategori" class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500">
                <option value="">Semua Kategori</option>
                <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.nama }}</option>
              </select>
            </div>
            <div>
              <label for="status_stok" class="block text-sm font-medium text-gray-700 mb-1">Status Stok</label>
              <select v-model="filters.status" id="status_stok" class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500">
                <option value="">Semua Status</option>
                <option value="tersedia">Tersedia</option>
                <option value="menipis">Menipis</option>
                <option value="habis">Habis</option>
              </select>
            </div>
            <div class="md:col-span-2">
              <button @click="fetchStockData" class="w-full md:w-auto bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg transition duration-150">
                Tampilkan
              </button>
            </div>
          </div>
        </div>
        
        <!-- Ringkasan Statistik (disembunyikan saat cetak) -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-6 print-hidden" id="summary-cards">
          <div class="bg-white p-5 rounded-lg shadow-sm">
            <div class="flex items-center space-x-4">
              <div class="p-3 rounded-full bg-blue-100 text-blue-600">
                <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M7.5 3.75H6A2.25 2.25 0 003.75 6v1.5M16.5 3.75H18A2.25 2.25 0 0120.25 6v1.5m0 9V18A2.25 2.25 0 0118 20.25h-1.5m-9 0H6A2.25 2.25 0 013.75 18v-1.5M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                </svg>
              </div>
              <div>
                <p class="text-sm text-gray-500 font-medium">Total Jenis Barang</p>
                <p class="text-2xl font-bold text-gray-900">{{ summary.totalItems }}</p>
              </div>
            </div>
          </div>
          <div class="bg-white p-5 rounded-lg shadow-sm">
            <div class="flex items-center space-x-4">
              <div class="p-3 rounded-full bg-green-100 text-green-600">
                <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M12 8.25v-1.875A3.375 3.375 0 008.625 3H5.25A2.25 2.25 0 003 5.25v5.25c0 .28.12.54.32.73l5.22 5.22a2.625 2.625 0 103.712 0l5.22-5.22c.2-.19.32-.45.32-.73V5.25A2.25 2.25 0 0013.5 3H10.125a3.375 3.375 0 00-3.375 3.375v1.875" />
                </svg>
              </div>
              <div>
                <p class="text-sm text-gray-500 font-medium">Total Nilai Inventori</p>
                <p class="text-2xl font-bold text-gray-900">{{ formatCurrency(summary.totalValue) }}</p>
              </div>
            </div>
          </div>
          <div class="bg-white p-5 rounded-lg shadow-sm">
            <div class="flex items-center space-x-4">
              <div class="p-3 rounded-full bg-yellow-100 text-yellow-600">
                <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126z" />
                </svg>
              </div>
              <div>
                <p class="text-sm text-gray-500 font-medium">Stok Menipis</p>
                <p class="text-2xl font-bold text-gray-900">{{ summary.lowStock }}</p>
              </div>
            </div>
          </div>
          <div class="bg-white p-5 rounded-lg shadow-sm">
            <div class="flex items-center space-x-4">
              <div class="p-3 rounded-full bg-red-100 text-red-600">
                <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728A9 9 0 015.636 5.636m12.728 12.728L5.636 5.636" />
                </svg>
              </div>
              <div>
                <p class="text-sm text-gray-500 font-medium">Stok Habis</p>
                <p class="text-2xl font-bold text-gray-900">{{ summary.outOfStock }}</p>
              </div>
            </div>
          </div>
        </div>

        <!-- Area Cetak -->
        <div class="bg-white p-8 rounded-lg shadow-lg border border-gray-200" id="printable-area">
          <!-- Header Laporan (hanya terlihat saat cetak) -->
          <div class="hidden mb-8 print:block" id="report-header">
            <div class="flex justify-between items-start">
              <div>
                <h1 class="text-3xl font-bold text-black">Laporan Stok Barang</h1>
                <p class="text-lg text-gray-700">Per Tanggal: {{ formatDate(new Date()) }}</p>
              </div>
              <div class="text-right">
                <p class="text-lg font-semibold text-black">Nama Perusahaan Anda</p>
                <p class="text-sm text-gray-600">Jl. Jend. Sudirman No. 1, Jakarta</p>
              </div>
            </div>
          </div>
          
          <!-- Tabel Data Laporan -->
          <div class="overflow-x-auto">
            <table class="w-full min-w-max">
              <thead class="bg-gray-50">
                <tr>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Kode</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nama Barang</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Kategori</th>
                  <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">Stok</th>
                  <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Harga Beli</th>
                  <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Nilai Stok</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-gray-200">
                <tr v-for="item in stockData" :key="item.id">
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{{ item.kode }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ item.nama }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{{ item.kategori?.nama || '-' }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600 text-center">
                    <span v-if="item.stok <= 0" class="px-3 py-1 inline-flex text-xs font-medium rounded-full bg-red-100 text-red-800 print:hidden">Habis</span>
                    <span v-else-if="item.stok < item.min_stok" class="px-3 py-1 inline-flex text-xs font-medium rounded-full bg-yellow-100 text-yellow-800 print:hidden">Menipis</span>
                    <span class="font-medium">{{ item.stok }}</span>
                    <span v-if="item.stok <= 0" class="hidden print:inline">(Habis)</span>
                    <span v-else-if="item.stok < item.min_stok" class="hidden print:inline">(Menipis)</span>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600 text-right">{{ formatCurrency(item.harga_beli) }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900 text-right">{{ formatCurrency(item.stok * item.harga_beli) }}</td>
                </tr>
                <tr v-if="stockData.length === 0">
                  <td colspan="6" class="px-6 py-4 text-center text-sm text-gray-500">Tidak ada data</td>
                </tr>
              </tbody>
              <tfoot class="bg-gray-50 border-t-2 border-gray-300">
                <tr>
                  <td colspan="5" class="px-6 py-4 text-right text-base font-bold text-gray-900 uppercase">Total Nilai Inventori</td>
                  <td class="px-6 py-4 text-right text-base font-bold text-gray-900">{{ formatCurrency(summary.totalValue) }}</td>
                </tr>
              </tfoot>
            </table>
          </div>
        </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import api from '@/services/api'

const router = useRouter()

const filters = ref({
  kategori_id: '',
  status: ''
})

const categories = ref<any[]>([])
const stockData = ref<any[]>([])
const summary = ref({
  totalItems: 0,
  totalValue: 0,
  lowStock: 0,
  outOfStock: 0
})

const printReport = () => {
  window.print()
}

const formatCurrency = (value: number) => {
  return new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    minimumFractionDigits: 0
  }).format(value || 0)
}

const formatDate = (date: Date) => {
  return new Intl.DateTimeFormat('id-ID', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  }).format(date)
}

const fetchCategories = async () => {
  try {
    const response = await api.get('/staff/kategori')
    if (response.data.success) {
      categories.value = response.data.data
    }
  } catch (error) {
    console.error('Error fetching categories:', error)
  }
}

const fetchStockData = async () => {
  try {
    const response = await api.get('/staff/reports/stock', { params: filters.value })
    if (response.data.success) {
      stockData.value = response.data.data.items
      summary.value = response.data.data.summary
    }
  } catch (error) {
    console.error('Error fetching stock data:', error)
  }
}

onMounted(() => {
  fetchCategories()
  fetchStockData()
})
</script>

<style scoped>
@media print {
  body { background-color: white; }
  .print-hidden, #sidebar, #main-header, #action-buttons, #filter-card, #summary-cards {
    display: none !important;
  }
  #main-content {
    margin-left: 0 !important;
    padding: 0 !important;
  }
  #printable-area {
    margin: 0 !important;
    padding: 1rem !important;
    box-shadow: none !important;
    border: none !important;
  }
  #report-header {
    display: block !important;
  }
  body, table {
    font-size: 10pt;
    color: #000;
  }
  table {
    width: 100%;
    border-collapse: collapse;
  }
  th, td {
    border: 1px solid #ccc;
    padding: 6px 8px;
  }
  thead {
    display: table-header-group;
    background-color: #f9fafb;
  }
  tfoot {
    display: table-footer-group;
  }
  tr, td, th {
    page-break-inside: avoid;
  }
  a { text-decoration: none; color: #000; }
}
</style>
