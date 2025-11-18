<template>
  <div>
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
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import api from '@/services/api'

const router = useRouter()
const showDateFilter = ref(false)
const selectedRange = ref('30 Hari Terakhir')

const stats = ref({
  totalInventoryValue: 0,
  totalPurchase30Days: 0,
  totalSales30Days: 0,
  lowStockCount: 0
})

const topItems = ref<any[]>([])

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
