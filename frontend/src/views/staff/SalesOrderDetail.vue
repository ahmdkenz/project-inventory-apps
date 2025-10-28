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
        <div class="flex-1"></div>
        <div class="flex items-center space-x-4">
          <button class="text-gray-500 hover:text-gray-700 relative">
            <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M14.857 17.082a23.848 23.848 0 005.454-1.31A8.967 8.967 0 0118 9.75v-.7V9A6 6 0 006 9v.75a8.967 8.967 0 01-2.312 6.022c1.733.64 3.56 1.085 5.455 1.31m5.714 0a24.255 24.255 0 01-5.714 0m5.714 0a3 3 0 11-5.714 0" />
            </svg>
          </button>
        </div>
      </header>

      <main class="flex-1 p-6 overflow-y-auto">
        <div v-if="loading" class="flex justify-center items-center py-12">
          <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
        </div>

        <div v-else-if="salesOrder">
          <div class="flex items-center justify-between mb-6 print-hidden">
            <h1 class="text-3xl font-bold text-gray-900">Detail Permintaan Barang</h1>
            <div class="flex space-x-3">
              <router-link to="/staff/sales-order" class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150">
                <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5L8.25 12l7.5-7.5" />
                </svg>
                <span>Kembali</span>
              </router-link>
              <button @click="printReceipt" class="bg-green-600 hover:bg-green-700 text-white font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150">
                <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M6.72 13.829c-.24.03-.48.062-.72.096m.72-.096a42.415 42.415 0 0110.56 0m-10.56 0L6.34 18m10.94-4.171c.24.03.48.062.72.096m-.72-.096L17.66 18m0 0l.229 2.523a1.125 1.125 0 01-1.12 1.227H7.23a1.125 1.125 0 01-1.12-1.227L6.34 18m11.319 0H6.34m11.319 0l.044.506A1.125 1.125 0 0117.003 20H6.997a1.125 1.125 0 01-1.122-1.494l.044-.506M6.34 18v-4.172c0-.224.03-.447.086-.665A41.4 41.4 0 0112 3c1.83 0 3.597.133 5.28.362.057.218.086.44.086.665v4.172M6.34 18L4.26 7.5h15.48L17.66 18" />
                </svg>
                <span>Cetak Bukti</span>
              </button>
            </div>
          </div>
          
          <div class="max-w-4xl mx-auto bg-white p-8 rounded-lg shadow-lg border border-gray-200" id="printable-area">
            <div class="flex justify-between items-start pb-6 border-b-2 border-gray-900">
              <div>
                <h2 class="text-3xl font-bold text-gray-900">BUKTI PENGELUARAN BARANG</h2>
                <p class="text-lg font-semibold text-blue-600">{{ salesOrder.no_so }}</p>
                <span :class="getStatusBadgeClass(salesOrder.status)" class="inline-block px-3 py-1 text-xs font-semibold rounded-full mt-2">
                  {{ getStatusLabel(salesOrder.status) }}
                </span>
              </div>
              <div class="text-right">
                <img src="https://placehold.co/150x50/000000/FFFFFF?text=LOGO+PERUSAHAAN" alt="Logo Perusahaan" class="h-12 mb-2 ml-auto">
                <p class="text-sm font-semibold text-gray-800">Nama Perusahaan Anda</p>
                <p class="text-sm text-gray-600">Jl. Jend. Sudirman No. 1, Jakarta</p>
                <p class="text-sm text-gray-600">Telepon: (021) 123456</p>
              </div>
            </div>

            <div class="grid grid-cols-2 gap-8 my-6">
              <div>
                <p class="text-sm font-semibold text-gray-500 uppercase mb-2">DITERIMA OLEH:</p>
                <p class="text-lg font-bold text-gray-900">{{ salesOrder.customer_name }}</p>
                <p class="text-sm text-gray-600">{{ salesOrder.customer_phone || '-' }}</p>
                <p class="text-sm text-gray-600">{{ salesOrder.customer_address || '-' }}</p>
              </div>
              <div class="text-right">
                <div class="mb-2">
                  <span class="text-sm font-semibold text-gray-500 uppercase">Tanggal Permintaan: </span>
                  <span class="text-sm font-medium text-gray-800">{{ formatDate(salesOrder.tgl_order) }}</span>
                </div>
                <div>
                  <span class="text-sm font-semibold text-gray-500 uppercase">Tanggal Dikeluarkan: </span>
                  <span class="text-sm font-medium text-gray-800">{{ formatDate(salesOrder.tgl_kirim) }}</span>
                </div>
              </div>
            </div>

            <div class="overflow-x-auto border rounded-lg mb-6">
              <table class="w-full min-w-max">
                <thead class="bg-gray-100 text-gray-700">
                  <tr>
                    <th class="px-6 py-3 text-left text-xs font-bold uppercase tracking-wider">No.</th>
                    <th class="px-6 py-3 text-left text-xs font-bold uppercase tracking-wider">Nama Barang</th>
                    <th class="px-6 py-3 text-center text-xs font-bold uppercase tracking-wider">Jumlah</th>
                    <th class="px-6 py-3 text-right text-xs font-bold uppercase tracking-wider">Harga Satuan</th>
                    <th class="px-6 py-3 text-right text-xs font-bold uppercase tracking-wider">Subtotal</th>
                  </tr>
                </thead>
                <tbody class="divide-y divide-gray-200">
                  <tr v-for="(item, index) in salesOrder.items" :key="item.id">
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{{ index + 1 }}.</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ item.barang?.nama || '-' }}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600 text-center">{{ item.qty }}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600 text-right">{{ formatCurrency(item.harga_satuan) }}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-bold text-gray-900 text-right">{{ formatCurrency(item.subtotal || 0) }}</td>
                  </tr>
                </tbody>
                <tfoot class="bg-gray-50">
                  <tr>
                    <td colspan="4" class="px-6 py-3 text-right text-sm font-semibold text-gray-700">TOTAL:</td>
                    <td class="px-6 py-3 text-right text-lg font-bold text-blue-600">{{ formatCurrency(salesOrder.total || 0) }}</td>
                  </tr>
                </tfoot>
              </table>
            </div>

            <div class="grid grid-cols-2 gap-8 pt-6 border-t border-gray-200">
              <div>
                <p class="text-sm font-semibold text-gray-500 uppercase mb-2">Catatan:</p>
                <p class="text-sm text-gray-600">{{ salesOrder.catatan || '-' }}</p>
                <p v-if="salesOrder.reject_reason" class="text-sm text-red-600 mt-2">
                  <strong>Alasan Ditolak:</strong> {{ salesOrder.reject_reason }}
                </p>
              </div>
              <div class="grid grid-cols-2 gap-4 text-center">
                <div>
                  <p class="text-sm text-gray-700 mb-16">Diserahkan oleh,</p>
                  <p class="text-sm font-medium text-gray-900 border-t border-gray-400 pt-1">{{ salesOrder.creator?.name || '(Staff Gudang)' }}</p>
                  <p class="text-xs text-gray-500">Staff Inventori</p>
                </div>
                <div>
                  <p class="text-sm text-gray-700 mb-16">Diterima oleh,</p>
                  <p class="text-sm font-medium text-gray-900 border-t border-gray-400 pt-1">(Perwakilan)</p>
                  <p class="text-xs text-gray-500">Penerima</p>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div v-else class="text-center py-12">
          <p class="text-gray-500">Sales Order tidak ditemukan</p>
        </div>
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import StaffNavigation from '@/components/StaffNavigation.vue'
import salesOrderService from '@/services/salesOrder.service'
import type { SalesOrder } from '@/services/salesOrder.service'

const route = useRoute()
const router = useRouter()
const user = ref<any>(null)
const loading = ref(false)
const salesOrder = ref<SalesOrder | null>(null)

const fetchSalesOrder = async () => {
  const id = parseInt(route.params.id as string)
  if (!id) {
    router.push('/staff/sales-order')
    return
  }

  loading.value = true
  try {
    const response = await salesOrderService.getById(id)
    if (response.success && !Array.isArray(response.data)) {
      salesOrder.value = response.data
    } else {
      router.push('/staff/sales-order')
    }
  } catch (error: any) {
    console.error('Error fetching sales order:', error)
    router.push('/staff/sales-order')
  } finally {
    loading.value = false
  }
}

const getStatusBadgeClass = (status: string) => {
  const classes: any = {
    'pending': 'bg-yellow-100 text-yellow-800',
    'approved': 'bg-green-100 text-green-800',
    'rejected': 'bg-red-100 text-red-800',
    'completed': 'bg-blue-100 text-blue-800'
  }
  return classes[status] || 'bg-gray-100 text-gray-800'
}

const getStatusLabel = (status: string) => {
  const labels: any = {
    'pending': 'Menunggu Persetujuan',
    'approved': 'Disetujui',
    'rejected': 'Ditolak',
    'completed': 'Selesai'
  }
  return labels[status] || status
}

const formatDate = (dateString: string) => {
  if (!dateString) return '-'
  const date = new Date(dateString)
  return date.toLocaleDateString('id-ID', { day: 'numeric', month: 'long', year: 'numeric' })
}

const formatCurrency = (value: number) => {
  if (!value) return 'Rp 0'
  return new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    minimumFractionDigits: 0
  }).format(value)
}

const printReceipt = () => {
  window.print()
}

const toggleSidebar = () => {
  const sidebar = document.getElementById('sidebar')
  const overlay = document.getElementById('overlay')
  if (sidebar && overlay) {
    sidebar.classList.toggle('-translate-x-full')
    overlay.classList.toggle('hidden')
  }
}

onMounted(() => {
  const userData = localStorage.getItem('user')
  if (userData) {
    user.value = JSON.parse(userData)
  }
  fetchSalesOrder()
})
</script>

<style scoped>
@media print {
  body > * {
    display: none;
  }
  
  .print-hidden {
    display: none !important;
  }
  
  #printable-area {
    display: block !important;
    margin: 0;
    padding: 0;
    width: 100%;
    font-size: 12pt;
    color: #000;
  }
  
  .print-no-break {
    page-break-inside: avoid;
  }
  
  thead {
    display: table-header-group;
  }
  
  tfoot {
    display: table-footer-group;
  }
  
  tr, td, th {
    page-break-inside: avoid;
  }
  
  table {
    page-break-inside: auto;
  }
}
</style>
