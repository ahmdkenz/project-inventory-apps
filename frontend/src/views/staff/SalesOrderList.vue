<template>
  <div class="flex h-screen">
    <!-- Sidebar -->
    <aside class="fixed top-0 left-0 h-full w-64 bg-gray-900 text-gray-300 shadow-lg z-30 transform -translate-x-full lg:translate-x-0 transition-transform duration-300 ease-in-out" id="sidebar">
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
    
    <div class="flex-1 flex flex-col transition-all duration-300 ease-in-out lg:ml-64">
      <header class="bg-white shadow-sm p-4 flex items-center justify-between z-10">
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

      <div v-if="message.show" :class="message.isError ? 'bg-red-500' : 'bg-green-500'" class="text-white px-6 py-3 text-center">
        {{ message.text }}
      </div>

      <main class="flex-1 p-6 overflow-y-auto">
        <div class="flex items-center justify-between mb-6">
          <h1 class="text-3xl font-bold text-gray-900">Sales Order (Barang Keluar)</h1>
          <router-link 
            to="/staff/sales-order/create" 
            class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150"
          >
            <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
            </svg>
            <span>Buat Permintaan Baru</span>
          </router-link>
        </div>

        <!-- Filter -->
        <div class="bg-white p-4 rounded-lg shadow-sm mb-6">
          <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
              <select v-model="filters.status" @change="fetchSalesOrders" class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500">
                <option value="">Semua Status</option>
                <option value="pending">Pending</option>
                <option value="approved">Approved</option>
                <option value="rejected">Rejected</option>
                <option value="completed">Completed</option>
              </select>
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Cari</label>
              <input 
                v-model="filters.search" 
                @input="handleSearch"
                type="text" 
                placeholder="No. SO / Customer..." 
                class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
              >
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Dari Tanggal</label>
              <input v-model="filters.dateFrom" @change="fetchSalesOrders" type="date" class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500">
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Sampai Tanggal</label>
              <input v-model="filters.dateTo" @change="fetchSalesOrders" type="date" class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500">
            </div>
          </div>
        </div>

        <!-- Loading -->
        <div v-if="loading" class="flex justify-center items-center py-12">
          <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
        </div>

        <!-- Table -->
        <div v-else class="bg-white rounded-lg shadow-md overflow-hidden">
          <table class="w-full">
            <thead class="bg-gray-50 border-b border-gray-200">
              <tr>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">No. SO</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Customer</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tgl Order</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Total</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Aksi</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-200">
              <tr v-if="salesOrders.length === 0">
                <td colspan="6" class="px-6 py-8 text-center text-gray-500">Belum ada sales order</td>
              </tr>
              <tr v-for="so in salesOrders" :key="so.id">
                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ so.no_so }}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ so.customer_name }}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ formatDate(so.tgl_order) }}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ formatCurrency(so.total || 0) }}</td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <span :class="getStatusBadgeClass(so.status)" class="px-2 py-1 text-xs font-semibold rounded-full">
                    {{ getStatusLabel(so.status) }}
                  </span>
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-right text-sm space-x-2">
                  <router-link v-if="so.status === 'pending'" :to="`/staff/sales-order/edit/${so.id}`" class="text-blue-600 hover:text-blue-900 font-medium">Edit</router-link>
                  <button v-if="so.status === 'pending'" @click="confirmDelete(so)" class="text-red-600 hover:text-red-900 font-medium">Hapus</button>
                  <router-link :to="`/staff/sales-order/detail/${so.id}`" class="text-green-600 hover:text-green-900 font-medium">Detail</router-link>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- Modal Delete -->
        <div v-if="showDeleteModal" class="fixed inset-0 bg-gray-600 bg-opacity-75 flex items-center justify-center p-4 z-50" @click.self="closeDeleteModal">
          <div class="bg-white rounded-lg shadow-xl w-full max-w-md">
            <div class="p-6 border-b border-gray-200">
              <h3 class="text-lg font-medium text-gray-900">Hapus Sales Order</h3>
            </div>
            <div class="p-6">
              <p class="text-sm text-gray-600">Apakah Anda yakin ingin menghapus Sales Order <strong>{{ soToDelete?.no_so }}</strong>?</p>
            </div>
            <div class="px-6 py-4 bg-gray-50 rounded-b-lg flex justify-end space-x-3">
              <button @click="closeDeleteModal" class="bg-white hover:bg-gray-100 text-gray-700 font-medium py-2 px-4 rounded-lg border border-gray-300">Batal</button>
              <button @click="deleteSalesOrder" class="bg-red-600 hover:bg-red-700 text-white font-medium py-2 px-4 rounded-lg">Ya, Hapus</button>
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
import salesOrderService from '@/services/salesOrder.service'
import type { SalesOrder } from '@/services/salesOrder.service'

const router = useRouter()
const user = ref<any>(null)
const loading = ref(false)
const salesOrders = ref<SalesOrder[]>([])
const showDeleteModal = ref(false)
const soToDelete = ref<SalesOrder | null>(null)

const filters = ref({
  status: '',
  search: '',
  dateFrom: '',
  dateTo: ''
})

const message = ref({
  show: false,
  text: '',
  isError: false
})

const fetchSalesOrders = async () => {
  loading.value = true
  try {
    const params: any = {}
    if (filters.value.status) params.status = filters.value.status
    if (filters.value.search) params.search = filters.value.search
    if (filters.value.dateFrom) params.date_from = filters.value.dateFrom
    if (filters.value.dateTo) params.date_to = filters.value.dateTo

    const response = await salesOrderService.getAll(params)
    if (response.success && Array.isArray(response.data)) {
      salesOrders.value = response.data
    }
  } catch (error: any) {
    console.error('Error fetching sales orders:', error)
    showMessage('Gagal memuat data sales order', true)
  } finally {
    loading.value = false
  }
}

let searchTimeout: any = null
const handleSearch = () => {
  clearTimeout(searchTimeout)
  searchTimeout = setTimeout(() => {
    fetchSalesOrders()
  }, 500)
}

const confirmDelete = (so: SalesOrder) => {
  soToDelete.value = so
  showDeleteModal.value = true
}

const closeDeleteModal = () => {
  showDeleteModal.value = false
  soToDelete.value = null
}

const deleteSalesOrder = async () => {
  if (!soToDelete.value?.id) return
  
  try {
    const response = await salesOrderService.delete(soToDelete.value.id)
    if (response.success) {
      showMessage('Sales order berhasil dihapus', false)
      closeDeleteModal()
      await fetchSalesOrders()
    }
  } catch (error: any) {
    showMessage(error.response?.data?.message || 'Gagal menghapus sales order', true)
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
    'pending': 'Pending',
    'approved': 'Approved',
    'rejected': 'Rejected',
    'completed': 'Completed'
  }
  return labels[status] || status
}

const formatDate = (dateString: string) => {
  if (!dateString) return '-'
  const date = new Date(dateString)
  return date.toLocaleDateString('id-ID', { day: 'numeric', month: 'short', year: 'numeric' })
}

const formatCurrency = (value: number) => {
  if (!value) return 'Rp 0'
  return new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    minimumFractionDigits: 0
  }).format(value)
}

const showMessage = (text: string, isError: boolean = false) => {
  message.value = { show: true, text, isError }
  setTimeout(() => {
    message.value.show = false
  }, 3000)
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
  fetchSalesOrders()
})
</script>
