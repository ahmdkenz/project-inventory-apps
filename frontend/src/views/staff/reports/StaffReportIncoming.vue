<template>
  <div>
    <div class="flex items-center justify-between mb-6 print-hidden" id="action-buttons">
          <h1 class="text-3xl font-bold text-gray-900">Laporan Barang Masuk</h1>
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
              <label for="start_date" class="block text-sm font-medium text-gray-700 mb-1">Tanggal Mulai</label>
              <input type="date" v-model="filters.start_date" id="start_date" class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500">
            </div>
            <div>
              <label for="end_date" class="block text-sm font-medium text-gray-700 mb-1">Tanggal Selesai</label>
              <input type="date" v-model="filters.end_date" id="end_date" class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500">
            </div>
            <div>
              <label for="supplier" class="block text-sm font-medium text-gray-700 mb-1">Supplier</label>
              <select v-model="filters.supplier_id" id="supplier" class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500">
                <option value="">Semua Supplier</option>
                <option v-for="supplier in suppliers" :key="supplier.id" :value="supplier.id">{{ supplier.nama }}</option>
              </select>
            </div>
            <div>
              <button @click="fetchIncomingData" class="w-full bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg transition duration-150">
                Tampilkan
              </button>
            </div>
          </div>
        </div>
        
        <!-- Area Cetak -->
        <div class="bg-white p-8 rounded-lg shadow-lg border border-gray-200" id="printable-area">
          <!-- Header Laporan (hanya terlihat saat cetak) -->
          <div class="hidden mb-8 print:block" id="report-header">
            <div class="flex justify-between items-start">
              <div>
                <h1 class="text-3xl font-bold text-black">Laporan Barang Masuk</h1>
                <p class="text-lg text-gray-700">Periode: {{ formatDate(filters.start_date) }} s/d {{ formatDate(filters.end_date) }}</p>
              </div>
              <div class="text-right">
                <p class="text-lg font-semibold text-black">Nama Perusahaan Anda</p>
                <p class="text-sm text-gray-600">Jl. Jend. Sudirman No. 1, Jakarta</p>
                <p class="text-sm text-gray-600">Dicetak pada: {{ formatDate(new Date().toISOString().split('T')[0] || '') }}</p>
              </div>
            </div>
          </div>
          
          <!-- Tabel Data Laporan -->
          <div class="overflow-x-auto">
            <table class="w-full min-w-max">
              <thead class="bg-gray-50">
                <tr>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tgl. Terima</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">No. PO</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Supplier</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Barang</th>
                  <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">Jml</th>
                  <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Harga Beli</th>
                  <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Subtotal</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-gray-200">
                <tr v-for="item in incomingData" :key="item.id">
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{{ formatDate(item.tgl_pesan) }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ item.no_po }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{{ item.supplier?.nama || '-' }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{{ item.barang?.nama || '-' }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600 text-center">{{ item.qty }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600 text-right">{{ formatCurrency(item.harga_satuan) }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900 text-right">{{ formatCurrency(item.subtotal) }}</td>
                </tr>
                <tr v-if="incomingData.length === 0">
                  <td colspan="7" class="px-6 py-4 text-center text-sm text-gray-500">Tidak ada data</td>
                </tr>
              </tbody>
              <tfoot class="bg-gray-50 border-t-2 border-gray-300">
                <tr>
                  <td colspan="6" class="px-6 py-4 text-right text-base font-bold text-gray-900 uppercase">Total Pembelian</td>
                  <td class="px-6 py-4 text-right text-base font-bold text-gray-900">{{ formatCurrency(totalPurchase) }}</td>
                </tr>
              </tfoot>
            </table>
          </div>
        </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import api from '@/services/api'

const router = useRouter()

const filters = ref({
  start_date: getFirstDayOfMonth(),
  end_date: getTodayDate(),
  supplier_id: ''
})

const suppliers = ref<any[]>([])
const incomingData = ref<any[]>([])

const totalPurchase = computed(() => {
  return incomingData.value.reduce((sum, item) => sum + (item.subtotal || 0), 0)
})

function getFirstDayOfMonth() {
  const date = new Date()
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-01`
}

function getTodayDate() {
  const date = new Date()
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`
}

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

const formatDate = (dateString: string) => {
  if (!dateString) return '-'
  const date = new Date(dateString)
  return new Intl.DateTimeFormat('id-ID', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  }).format(date)
}

const fetchSuppliers = async () => {
  try {
    const response = await api.get('/staff/supplier')
    if (response.data.success) {
      suppliers.value = response.data.data
    }
  } catch (error) {
    console.error('Error fetching suppliers:', error)
  }
}

const fetchIncomingData = async () => {
  try {
    const response = await api.get('/staff/reports/incoming', { params: filters.value })
    if (response.data.success) {
      incomingData.value = response.data.data
    }
  } catch (error) {
    console.error('Error fetching incoming data:', error)
  }
}

onMounted(() => {
  fetchSuppliers()
  fetchIncomingData()
})
</script>

<style scoped>
@media print {
  body { background-color: white; }
  .print-hidden, #sidebar, #main-header, #action-buttons, #filter-card {
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
