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
      
      <!-- Menu Navigasi Admin -->
      <AdminNavigation :current-path="$route.path" />
      
      <!-- User Info di Bawah Sidebar -->
      <div class="absolute bottom-0 left-0 w-full p-4 border-t border-gray-700">
        <div class="flex items-center space-x-3">
          <img class="h-10 w-10 rounded-full" src="https://placehold.co/100x100/EBF8FF/3182CE?text=A" alt="Avatar Pengguna">
          <div>
            <p class="text-sm font-medium text-white">{{ user?.name || 'Admin' }}</p>
            <p class="text-xs text-gray-400">Administrator</p>
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
          <div class="relative" v-click-outside="closeProfileMenu">
            <button @click="toggleProfileMenu" class="flex items-center space-x-2">
              <img class="h-9 w-9 rounded-full" src="https://placehold.co/100x100/EBF8FF/3182CE?text=A" alt="Avatar Pengguna">
              <span class="hidden md:block text-sm font-medium text-gray-700">{{ user?.name || 'Admin' }}</span>
            </button>
            <div v-show="showProfileMenu" class="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg py-1 z-20">
              <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Profil Saya</a>
              <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Pengaturan</a>
              <hr class="my-1">
              <a href="#" @click.prevent="handleLogout" class="block px-4 py-2 text-sm text-red-600 hover:bg-gray-100">Logout</a>
            </div>
          </div>
        </div>
      </header>

      <!-- Konten Halaman -->
      <main class="flex-1 p-6 overflow-y-auto">
        <!-- Preserve original page content -->
        <div class="p-6">
          <!-- Header Halaman -->
          <div class="flex flex-col md:flex-row justify-between md:items-center mb-6 gap-4">
            <h1 class="text-3xl font-bold text-gray-900">Sales Order / Barang Keluar</h1>
          </div>

          <!-- Kontrol Filter -->
          <div class="mb-6 bg-white p-4 rounded-lg shadow-sm">
            <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
              <div>
                <label for="filter-status" class="block text-sm font-medium text-gray-700 mb-1">Status</label>
                <select
                  v-model="filters.status"
                  id="filter-status"
                  class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                  @change="fetchSalesOrders"
                >
                  <option value="">Semua Status</option>
                  <option value="pending">Pending</option>
                  <option value="approved">Approved</option>
                  <option value="rejected">Rejected</option>
                  <option value="completed">Completed</option>
                </select>
              </div>
              <div>
                <label for="filter-search" class="block text-sm font-medium text-gray-700 mb-1">Cari</label>
                <input
                  v-model="filters.search"
                  type="text"
                  id="filter-search"
                  class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                  placeholder="No. SO / Customer..."
                  @input="handleSearch"
                />
              </div>
              <div>
                <label for="filter-date-start" class="block text-sm font-medium text-gray-700 mb-1">Dari Tanggal</label>
                <input
                  v-model="filters.dateFrom"
                  type="date"
                  id="filter-date-start"
                  class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                  @change="fetchSalesOrders"
                />
              </div>
              <div>
                <label for="filter-date-end" class="block text-sm font-medium text-gray-700 mb-1">Sampai Tanggal</label>
                <input
                  v-model="filters.dateTo"
                  type="date"
                  id="filter-date-end"
                  class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                  @change="fetchSalesOrders"
                />
              </div>
            </div>
          </div>

          <!-- Loading State -->
          <div v-if="loading" class="flex justify-center items-center py-12">
            <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
          </div>

          <!-- Tabel Data -->
          <div v-else class="bg-white rounded-lg shadow-md overflow-hidden">
            <div class="overflow-x-auto">
              <table class="w-full min-w-max">
                <thead class="bg-gray-50 border-b border-gray-200">
                  <tr>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">No. SO</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Customer</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tgl Order</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Total</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Dibuat Oleh</th>
                    <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Aksi</th>
                  </tr>
                </thead>
                <tbody class="divide-y divide-gray-200">
                  <tr v-if="salesOrders.length === 0">
                    <td colspan="7" class="px-6 py-8 text-center text-gray-500">
                      Tidak ada data sales order.
                    </td>
                  </tr>
                  <tr v-for="so in salesOrders" :key="so.id">
                    <td class="px-6 py-4 whitespace-nowrap">
                      <div class="text-sm font-medium text-gray-900">{{ so.no_so }}</div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ so.customer_name }}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ formatDate(so.tgl_order) }}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ formatCurrency(so.total || 0) }}</td>
                    <td class="px-6 py-4 whitespace-nowrap">
                      <span :class="getStatusBadgeClass(so.status)" class="px-2 py-1 text-xs font-semibold rounded-full">
                        {{ getStatusLabel(so.status) }}
                      </span>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ so.creator?.name || '-' }}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium space-x-2">
                      <button v-if="so.status === 'pending'" @click="openApproveModal(so)" class="text-green-600 hover:text-green-900">Approve</button>
                      <button v-if="so.status === 'pending'" @click="openRejectModal(so)" class="text-red-600 hover:text-red-900">Reject</button>
                      <button @click="openDetailModal(so)" class="text-blue-600 hover:text-blue-900">Detail</button>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

          <!-- Message Box -->
          <div
            v-if="message.show"
            :class="['fixed top-5 right-5 p-4 rounded-md shadow-lg text-white transition-all duration-300 z-50', message.isError ? 'bg-red-500' : 'bg-green-500']"
          >
            {{ message.text }}
          </div>

          <!-- Modal Approve -->
          <div v-if="showApproveModal" class="fixed inset-0 bg-gray-600 bg-opacity-75 flex items-center justify-center p-4 z-50" @click.self="closeApproveModal">
            <div class="bg-white rounded-lg shadow-xl w-full max-w-md">
              <div class="p-6 border-b border-gray-200">
                <h3 class="text-lg font-medium text-gray-900">Approve Sales Order</h3>
              </div>
              <div class="p-6">
                <p class="text-sm text-gray-600">Apakah Anda yakin ingin approve Sales Order <strong>{{ selectedSO?.no_so }}</strong>?</p>
                <p class="text-sm text-gray-600 mt-2">Stok barang akan dikurangi setelah di-approve.</p>
              </div>
              <div class="px-6 py-4 bg-gray-50 rounded-b-lg flex justify-end space-x-3">
                <button @click="closeApproveModal" class="bg-white hover:bg-gray-100 text-gray-700 font-medium py-2 px-4 rounded-lg border border-gray-300">Batal</button>
                <button @click="confirmApprove" class="bg-green-600 hover:bg-green-700 text-white font-medium py-2 px-4 rounded-lg">Ya, Approve</button>
              </div>
            </div>
          </div>

          <!-- Modal Reject -->
          <div v-if="showRejectModal" class="fixed inset-0 bg-gray-600 bg-opacity-75 flex items-center justify-center p-4 z-50" @click.self="closeRejectModal">
            <div class="bg-white rounded-lg shadow-xl w-full max-w-md">
              <div class="p-6 border-b border-gray-200">
                <h3 class="text-lg font-medium text-gray-900">Reject Sales Order</h3>
              </div>
              <div class="p-6">
                <p class="text-sm text-gray-600 mb-4">Apakah Anda yakin ingin menolak Sales Order <strong>{{ selectedSO?.no_so }}</strong>?</p>
                <label class="block text-sm font-medium text-gray-700 mb-2">Alasan Penolakan <span class="text-red-500">*</span></label>
                <textarea 
                  v-model="rejectReason"
                  rows="4"
                  class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                  placeholder="Masukkan alasan penolakan..."
                ></textarea>
              </div>
              <div class="px-6 py-4 bg-gray-50 rounded-b-lg flex justify-end space-x-3">
                <button @click="closeRejectModal" class="bg-white hover:bg-gray-100 text-gray-700 font-medium py-2 px-4 rounded-lg border border-gray-300">Batal</button>
                <button @click="confirmReject" class="bg-red-600 hover:bg-red-700 text-white font-medium py-2 px-4 rounded-lg">Ya, Reject</button>
              </div>
            </div>
          </div>

          <!-- Modal Detail -->
          <div v-if="showDetailModal" class="fixed inset-0 bg-gray-600 bg-opacity-75 flex items-center justify-center p-4 z-50 overflow-y-auto" @click.self="closeDetailModal">
            <div class="bg-white rounded-lg shadow-xl w-full max-w-3xl my-8">
              <div class="p-6 border-b border-gray-200 sticky top-0 bg-white">
                <div class="flex justify-between items-center">
                  <h3 class="text-lg font-medium text-gray-900">Detail Sales Order</h3>
                  <button @click="closeDetailModal" class="text-gray-400 hover:text-gray-600">
                    <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                  </button>
                </div>
              </div>
              <div v-if="selectedSO" class="p-6">
                <div class="grid grid-cols-2 gap-4 mb-6">
                  <div>
                    <p class="text-sm text-gray-500">No. SO</p>
                    <p class="font-medium">{{ selectedSO.no_so }}</p>
                  </div>
                  <div>
                    <p class="text-sm text-gray-500">Status</p>
                    <span :class="getStatusBadgeClass(selectedSO.status)" class="px-2 py-1 text-xs font-semibold rounded-full">
                      {{ getStatusLabel(selectedSO.status) }}
                    </span>
                  </div>
                  <div>
                    <p class="text-sm text-gray-500">Customer</p>
                    <p class="font-medium">{{ selectedSO.customer_name }}</p>
                  </div>
                  <div>
                    <p class="text-sm text-gray-500">No. Telepon</p>
                    <p class="font-medium">{{ selectedSO.customer_phone || '-' }}</p>
                  </div>
                  <div class="col-span-2">
                    <p class="text-sm text-gray-500">Alamat</p>
                    <p class="font-medium">{{ selectedSO.customer_address || '-' }}</p>
                  </div>
                  <div>
                    <p class="text-sm text-gray-500">Tanggal Order</p>
                    <p class="font-medium">{{ formatDate(selectedSO.tgl_order) }}</p>
                  </div>
                  <div>
                    <p class="text-sm text-gray-500">Tanggal Kirim</p>
                    <p class="font-medium">{{ formatDate(selectedSO.tgl_kirim) }}</p>
                  </div>
                  <div>
                    <p class="text-sm text-gray-500">Dibuat Oleh</p>
                    <p class="font-medium">{{ selectedSO.creator?.name || '-' }}</p>
                  </div>
                  <div v-if="selectedSO.approver">
                    <p class="text-sm text-gray-500">Di-approve Oleh</p>
                    <p class="font-medium">{{ selectedSO.approver?.name || '-' }}</p>
                  </div>
                  <div v-if="selectedSO.catatan" class="col-span-2">
                    <p class="text-sm text-gray-500">Catatan</p>
                    <p class="font-medium">{{ selectedSO.catatan }}</p>
                  </div>
                  <div v-if="selectedSO.reject_reason" class="col-span-2">
                    <p class="text-sm text-gray-500">Alasan Ditolak</p>
                    <p class="font-medium text-red-600">{{ selectedSO.reject_reason }}</p>
                  </div>
                </div>
                <div class="border-t pt-4">
                  <h4 class="font-medium mb-3">Detail Barang</h4>
                  <table class="w-full text-sm">
                    <thead class="bg-gray-50">
                      <tr>
                        <th class="px-4 py-2 text-left">Barang</th>
                        <th class="px-4 py-2 text-center">Qty</th>
                        <th class="px-4 py-2 text-right">Harga</th>
                        <th class="px-4 py-2 text-right">Subtotal</th>
                      </tr>
                    </thead>
                    <tbody class="divide-y">
                      <tr v-for="item in selectedSO.items" :key="item.id">
                        <td class="px-4 py-2">{{ item.barang?.nama || '-' }}</td>
                        <td class="px-4 py-2 text-center">{{ item.qty }}</td>
                        <td class="px-4 py-2 text-right">{{ formatCurrency(item.harga_satuan || 0) }}</td>
                        <td class="px-4 py-2 text-right">{{ formatCurrency(item.subtotal || 0) }}</td>
                      </tr>
                    </tbody>
                    <tfoot class="bg-gray-50 font-medium">
                      <tr>
                        <td colspan="3" class="px-4 py-2 text-right">Subtotal</td>
                        <td class="px-4 py-2 text-right">{{ formatCurrency(selectedSO.subtotal || 0) }}</td>
                      </tr>
                      <tr>
                        <td colspan="3" class="px-4 py-2 text-right">PPN (0%)</td>
                        <td class="px-4 py-2 text-right">{{ formatCurrency(selectedSO.ppn || 0) }}</td>
                      </tr>
                      <tr class="text-lg">
                        <td colspan="3" class="px-4 py-2 text-right">Total</td>
                        <td class="px-4 py-2 text-right text-blue-600">{{ formatCurrency(selectedSO.total || 0) }}</td>
                      </tr>
                    </tfoot>
                  </table>
                </div>
              </div>
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
import { useAuthStore } from '@/stores/auth'
import AdminNavigation from '@/components/AdminNavigation.vue'
import salesOrderService from '@/services/salesOrder.service'
import type { SalesOrder } from '@/services/salesOrder.service'

// Router & auth
const router = useRouter()
const authStore = useAuthStore()

// Header/Profile state
const showProfileMenu = ref(false)
const user = ref<any>(null)

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
    await authStore.logout()
    await router.push('/login')
  } catch (error) {
    console.error('Error during logout:', error)
    localStorage.removeItem('token')
    localStorage.removeItem('user')
    await router.push('/login')
  }
}

// State
const salesOrders = ref<SalesOrder[]>([])
const loading = ref(false)
const showApproveModal = ref(false)
const showRejectModal = ref(false)
const showDetailModal = ref(false)
const selectedSO = ref<SalesOrder | null>(null)
const rejectReason = ref('')

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

// Methods
const fetchSalesOrders = async () => {
  loading.value = true
  try {
    const params: any = {}
    if (filters.value.status) params.status = filters.value.status
    if (filters.value.search) params.search = filters.value.search
    if (filters.value.dateFrom) params.date_from = filters.value.dateFrom
    if (filters.value.dateTo) params.date_to = filters.value.dateTo

    const response = await salesOrderService.adminGetAll(params)
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

const openApproveModal = (so: SalesOrder) => {
  selectedSO.value = so
  showApproveModal.value = true
}

const closeApproveModal = () => {
  showApproveModal.value = false
  selectedSO.value = null
}

const confirmApprove = async () => {
  if (!selectedSO.value?.id) return
  
  try {
    const response = await salesOrderService.approve(selectedSO.value.id)
    if (response.success) {
      showMessage('Sales order berhasil di-approve', false)
      closeApproveModal()
      await fetchSalesOrders()
    }
  } catch (error: any) {
    showMessage(error.response?.data?.message || 'Gagal approve sales order', true)
  }
}

const openRejectModal = (so: SalesOrder) => {
  selectedSO.value = so
  rejectReason.value = ''
  showRejectModal.value = true
}

const closeRejectModal = () => {
  showRejectModal.value = false
  selectedSO.value = null
  rejectReason.value = ''
}

const confirmReject = async () => {
  if (!selectedSO.value?.id || !rejectReason.value.trim()) {
    showMessage('Alasan penolakan harus diisi', true)
    return
  }
  
  try {
    const response = await salesOrderService.reject(selectedSO.value.id, rejectReason.value)
    if (response.success) {
      showMessage('Sales order berhasil ditolak', false)
      closeRejectModal()
      await fetchSalesOrders()
    }
  } catch (error: any) {
    showMessage(error.response?.data?.message || 'Gagal reject sales order', true)
  }
}

const openDetailModal = async (so: SalesOrder) => {
  loading.value = true
  try {
    const response = await salesOrderService.adminGetById(so.id!)
    if (response.success && !Array.isArray(response.data)) {
      selectedSO.value = response.data
      showDetailModal.value = true
    }
  } catch (error: any) {
    showMessage('Gagal memuat detail sales order', true)
  } finally {
    loading.value = false
  }
}

const closeDetailModal = () => {
  showDetailModal.value = false
  selectedSO.value = null
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

// Lifecycle
onMounted(() => {
  const userData = localStorage.getItem('user')
  if (userData) {
    user.value = JSON.parse(userData)
  }
  fetchSalesOrders()
})
</script>
