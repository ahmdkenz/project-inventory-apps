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
            <h1 class="text-3xl font-bold text-gray-900">Purchase Order / Barang Masuk</h1>
            <router-link
              to="/admin/purchase-orders/create"
              class="w-full md:w-auto bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150"
            >
              <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
              </svg>
              <span>Catat Barang Masuk</span>
            </router-link>
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
                  @change="fetchOrders"
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
                  placeholder="No. PO / Supplier..."
                  @input="handleSearch"
                />
              </div>
              <div>
                <label for="filter-date-start" class="block text-sm font-medium text-gray-700 mb-1">Tanggal Mulai</label>
                <input
                  v-model="filters.dateStart"
                  type="date"
                  id="filter-date-start"
                  class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                  @change="fetchOrders"
                />
              </div>
              <div>
                <label for="filter-date-end" class="block text-sm font-medium text-gray-700 mb-1">Tanggal Selesai</label>
                <input
                  v-model="filters.dateEnd"
                  type="date"
                  id="filter-date-end"
                  class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                  @change="fetchOrders"
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
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">No. PO</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tanggal Pesan</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Supplier</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Total</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Dibuat Oleh</th>
                    <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Aksi</th>
                  </tr>
                </thead>
                <tbody class="divide-y divide-gray-200">
                  <tr v-if="orders.length === 0">
                    <td colspan="7" class="px-6 py-8 text-center text-gray-500">
                      Tidak ada data purchase order.
                    </td>
                  </tr>
                  <tr v-for="order in orders" :key="order.id">
                    <td class="px-6 py-4 whitespace-nowrap">
                      <div class="text-sm font-medium text-gray-900">{{ order.no_po }}</div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ formatDate(order.tgl_pesan) }}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ order.supplier?.nama || '-' }}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ formatCurrency(order.total) }}</td>
                    <td class="px-6 py-4 whitespace-nowrap">
                      <span :class="getStatusBadgeClass(order.status)" class="px-2 py-1 text-xs font-semibold rounded-full">
                        {{ getStatusLabel(order.status) }}
                      </span>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ order.creator?.name || '-' }}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium space-x-2">
                      <!-- Tombol Approve (hanya untuk status pending) -->
                      <button 
                        v-if="order.status === 'pending'"
                        @click="confirmApprove(order)" 
                        class="text-green-600 hover:text-green-900 font-medium"
                      >
                        Approve
                      </button>
                      
                      <!-- Tombol Reject (hanya untuk status pending) -->
                      <button 
                        v-if="order.status === 'pending'"
                        @click="openRejectModal(order)" 
                        class="text-red-600 hover:text-red-900 font-medium"
                      >
                        Reject
                      </button>
                      
                      <!-- Tombol Detail -->
                      <button 
                        @click="viewDetail(order)" 
                        class="text-blue-600 hover:text-blue-900 font-medium"
                      >
                        Detail
                      </button>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

          <!-- Modal Konfirmasi Hapus -->
          <div
            v-if="showDeleteModal"
            class="fixed inset-0 bg-gray-600 bg-opacity-75 flex items-center justify-center p-4 z-50 transition-opacity duration-300"
            @click.self="closeDeleteModal"
          >
            <div class="bg-white rounded-lg shadow-xl w-full max-w-md transform transition-all">
              <div class="p-6 border-b border-gray-200">
                <h3 class="text-lg font-medium leading-6 text-gray-900">Hapus Transaksi</h3>
              </div>
              <div class="p-6">
                <p class="text-sm text-gray-600">
                  Apakah Anda yakin ingin menghapus transaksi <strong>{{ orderToDelete?.invoice_number }}</strong>? 
                  Stok barang yang terkait akan dikembalikan (dibatalkan). Tindakan ini tidak dapat dibatalkan.
                </p>
              </div>
              <div class="px-6 py-4 bg-gray-50 rounded-b-lg flex justify-end space-x-3">
                <button
                  @click="closeDeleteModal"
                  type="button"
                  class="bg-white hover:bg-gray-100 text-gray-700 font-medium py-2 px-4 rounded-lg border border-gray-300 transition duration-150"
                >
                  Batal
                </button>
                <button
                  @click="deleteOrder"
                  type="button"
                  class="bg-red-600 hover:bg-red-700 text-white font-medium py-2 px-4 rounded-lg transition duration-150"
                >
                  Ya, Hapus
                </button>
              </div>
            </div>
          </div>

          <!-- Modal Konfirmasi Approve -->
          <div
            v-if="showApproveModal"
            class="fixed inset-0 bg-gray-600 bg-opacity-75 flex items-center justify-center p-4 z-50 transition-opacity duration-300"
            @click.self="closeApproveModal"
          >
            <div class="bg-white rounded-lg shadow-xl w-full max-w-md transform transition-all">
              <div class="p-6 border-b border-gray-200">
                <h3 class="text-lg font-medium leading-6 text-gray-900">Approve Purchase Order</h3>
              </div>
              <div class="p-6">
                <p class="text-sm text-gray-600">
                  Apakah Anda yakin ingin menyetujui Purchase Order <strong>{{ orderToApprove?.no_po }}</strong>?
                  Stok barang akan ditambahkan sesuai dengan item di PO ini.
                </p>
              </div>
              <div class="px-6 py-4 bg-gray-50 rounded-b-lg flex justify-end space-x-3">
                <button
                  @click="closeApproveModal"
                  type="button"
                  class="bg-white hover:bg-gray-100 text-gray-700 font-medium py-2 px-4 rounded-lg border border-gray-300 transition duration-150"
                >
                  Batal
                </button>
                <button
                  @click="approveOrder"
                  type="button"
                  class="bg-green-600 hover:bg-green-700 text-white font-medium py-2 px-4 rounded-lg transition duration-150"
                >
                  Ya, Approve
                </button>
              </div>
            </div>
          </div>

          <!-- Modal Reject PO -->
          <div
            v-if="showRejectModal"
            class="fixed inset-0 bg-gray-600 bg-opacity-75 flex items-center justify-center p-4 z-50 transition-opacity duration-300"
            @click.self="closeRejectModal"
          >
            <div class="bg-white rounded-lg shadow-xl w-full max-w-md transform transition-all">
              <div class="p-6 border-b border-gray-200">
                <h3 class="text-lg font-medium leading-6 text-gray-900">Reject Purchase Order</h3>
              </div>
              <div class="p-6">
                <p class="text-sm text-gray-600 mb-4">
                  Anda akan menolak Purchase Order <strong>{{ orderToReject?.no_po }}</strong>.
                  Silakan berikan alasan penolakan:
                </p>
                <textarea
                  v-model="rejectReason"
                  rows="4"
                  class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                  placeholder="Alasan penolakan..."
                ></textarea>
                <span v-if="rejectReasonError" class="text-red-500 text-xs mt-1 block">{{ rejectReasonError }}</span>
              </div>
              <div class="px-6 py-4 bg-gray-50 rounded-b-lg flex justify-end space-x-3">
                <button
                  @click="closeRejectModal"
                  type="button"
                  class="bg-white hover:bg-gray-100 text-gray-700 font-medium py-2 px-4 rounded-lg border border-gray-300 transition duration-150"
                >
                  Batal
                </button>
                <button
                  @click="rejectOrder"
                  type="button"
                  class="bg-red-600 hover:bg-red-700 text-white font-medium py-2 px-4 rounded-lg transition duration-150"
                >
                  Ya, Reject
                </button>
              </div>
            </div>
          </div>

          <!-- Modal Detail PO -->
          <div
            v-if="showDetailModal"
            class="fixed inset-0 bg-gray-600 bg-opacity-75 flex items-center justify-center p-4 z-50 transition-opacity duration-300"
            @click.self="closeDetailModal"
          >
            <div class="bg-white rounded-lg shadow-xl w-full max-w-3xl transform transition-all max-h-[90vh] overflow-y-auto">
              <div class="p-6 border-b border-gray-200 sticky top-0 bg-white">
                <div class="flex justify-between items-center">
                  <h3 class="text-lg font-medium leading-6 text-gray-900">Detail Purchase Order</h3>
                  <button @click="closeDetailModal" class="text-gray-400 hover:text-gray-600">
                    <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                  </button>
                </div>
              </div>
              <div v-if="selectedOrder" class="p-6">
                <!-- Info PO -->
                <div class="grid grid-cols-2 gap-4 mb-6">
                  <div>
                    <p class="text-sm text-gray-500">No. PO</p>
                    <p class="font-medium">{{ selectedOrder.no_po }}</p>
                  </div>
                  <div>
                    <p class="text-sm text-gray-500">Status</p>
                    <span :class="getStatusBadgeClass(selectedOrder.status)" class="px-2 py-1 text-xs font-semibold rounded-full">
                      {{ getStatusLabel(selectedOrder.status) }}
                    </span>
                  </div>
                  <div>
                    <p class="text-sm text-gray-500">Supplier</p>
                    <p class="font-medium">{{ selectedOrder.supplier?.nama || '-' }}</p>
                  </div>
                  <div>
                    <p class="text-sm text-gray-500">Tanggal Pesan</p>
                    <p class="font-medium">{{ formatDate(selectedOrder.tgl_pesan) }}</p>
                  </div>
                  <div>
                    <p class="text-sm text-gray-500">Estimasi Tiba</p>
                    <p class="font-medium">{{ formatDate(selectedOrder.tgl_estimasi) }}</p>
                  </div>
                  <div>
                    <p class="text-sm text-gray-500">Dibuat Oleh</p>
                    <p class="font-medium">{{ selectedOrder.creator?.name || '-' }}</p>
                  </div>
                  <div v-if="selectedOrder.approved_by" class="col-span-2">
                    <p class="text-sm text-gray-500">Disetujui Oleh</p>
                    <p class="font-medium">{{ selectedOrder.approver?.name || '-' }} pada {{ formatDate(selectedOrder.approved_at) }}</p>
                  </div>
                  <div v-if="selectedOrder.reject_reason" class="col-span-2">
                    <p class="text-sm text-gray-500">Alasan Ditolak</p>
                    <p class="font-medium text-red-600">{{ selectedOrder.reject_reason }}</p>
                  </div>
                  <div v-if="selectedOrder.catatan" class="col-span-2">
                    <p class="text-sm text-gray-500">Catatan</p>
                    <p class="font-medium">{{ selectedOrder.catatan }}</p>
                  </div>
                </div>

                <!-- Items -->
                <div class="border-t pt-4">
                  <h4 class="font-medium mb-3">Detail Barang</h4>
                  <table class="w-full text-sm">
                    <thead class="bg-gray-50">
                      <tr>
                        <th class="px-4 py-2 text-left">Nama Barang</th>
                        <th class="px-4 py-2 text-center">Qty</th>
                        <th class="px-4 py-2 text-right">Harga Satuan</th>
                        <th class="px-4 py-2 text-right">Subtotal</th>
                      </tr>
                    </thead>
                    <tbody class="divide-y">
                      <tr v-for="item in selectedOrder.items" :key="item.id">
                        <td class="px-4 py-2">{{ item.barang?.nama || '-' }}</td>
                        <td class="px-4 py-2 text-center">{{ item.qty }}</td>
                        <td class="px-4 py-2 text-right">{{ formatCurrency(item.harga_satuan) }}</td>
                        <td class="px-4 py-2 text-right">{{ formatCurrency(item.subtotal) }}</td>
                      </tr>
                    </tbody>
                    <tfoot class="bg-gray-50 font-medium">
                      <tr>
                        <td colspan="3" class="px-4 py-2 text-right">Total</td>
                        <td class="px-4 py-2 text-right">{{ formatCurrency(selectedOrder.total) }}</td>
                      </tr>
                    </tfoot>
                  </table>
                </div>
              </div>
            </div>
          </div>

          <!-- Message Box -->
          <div
            v-if="message.show"
            :class="['fixed top-5 right-5 p-4 rounded-md shadow-lg text-white transition-all duration-300 z-50', message.isError ? 'bg-red-500' : 'bg-green-500']"
          >
            {{ message.text }}
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
import purchaseOrderService from '@/services/purchaseOrder.service'

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
const orders = ref<any[]>([])
const loading = ref(false)
const showDeleteModal = ref(false)
const showApproveModal = ref(false)
const showRejectModal = ref(false)
const showDetailModal = ref(false)
const orderToDelete = ref<any>(null)
const orderToApprove = ref<any>(null)
const orderToReject = ref<any>(null)
const selectedOrder = ref<any>(null)
const rejectReason = ref('')
const rejectReasonError = ref('')

const filters = ref({
  status: '',
  search: '',
  dateStart: '',
  dateEnd: ''
})

const message = ref({
  show: false,
  text: '',
  isError: false
})

// Methods
const fetchOrders = async () => {
  loading.value = true
  try {
    const params: any = {}
    if (filters.value.status) params.status = filters.value.status
    if (filters.value.search) params.search = filters.value.search
    if (filters.value.dateStart) params.date_from = filters.value.dateStart
    if (filters.value.dateEnd) params.date_to = filters.value.dateEnd

    const response = await purchaseOrderService.adminGetAll(params)
    if (response.success && Array.isArray(response.data)) {
      orders.value = response.data
    }
  } catch (error: any) {
    console.error('Error fetching orders:', error)
    showMessage('Gagal memuat data purchase order', true)
  } finally {
    loading.value = false
  }
}

let searchTimeout: any = null
const handleSearch = () => {
  clearTimeout(searchTimeout)
  searchTimeout = setTimeout(() => {
    fetchOrders()
  }, 500)
}

const confirmApprove = (order: any) => {
  orderToApprove.value = order
  showApproveModal.value = true
}

const closeApproveModal = () => {
  showApproveModal.value = false
  orderToApprove.value = null
}

const approveOrder = async () => {
  if (!orderToApprove.value) return
  
  loading.value = true
  try {
    const response = await purchaseOrderService.approve(orderToApprove.value.id)
    if (response.success) {
      showMessage('Purchase Order berhasil disetujui', false)
      closeApproveModal()
      await fetchOrders()
    }
  } catch (error: any) {
    console.error('Error approving order:', error)
    showMessage(error.response?.data?.message || 'Gagal menyetujui purchase order', true)
  } finally {
    loading.value = false
  }
}

const openRejectModal = (order: any) => {
  orderToReject.value = order
  rejectReason.value = ''
  rejectReasonError.value = ''
  showRejectModal.value = true
}

const closeRejectModal = () => {
  showRejectModal.value = false
  orderToReject.value = null
  rejectReason.value = ''
  rejectReasonError.value = ''
}

const rejectOrder = async () => {
  if (!orderToReject.value) return
  
  if (!rejectReason.value.trim()) {
    rejectReasonError.value = 'Alasan penolakan harus diisi'
    return
  }
  
  loading.value = true
  try {
    const response = await purchaseOrderService.reject(orderToReject.value.id, rejectReason.value)
    if (response.success) {
      showMessage('Purchase Order berhasil ditolak', false)
      closeRejectModal()
      await fetchOrders()
    }
  } catch (error: any) {
    console.error('Error rejecting order:', error)
    showMessage(error.response?.data?.message || 'Gagal menolak purchase order', true)
  } finally {
    loading.value = false
  }
}

const viewDetail = async (order: any) => {
  loading.value = true
  try {
    const response = await purchaseOrderService.adminGetById(order.id)
    if (response.success && !Array.isArray(response.data)) {
      selectedOrder.value = response.data
      showDetailModal.value = true
    }
  } catch (error: any) {
    console.error('Error fetching order detail:', error)
    showMessage('Gagal memuat detail purchase order', true)
  } finally {
    loading.value = false
  }
}

const closeDetailModal = () => {
  showDetailModal.value = false
  selectedOrder.value = null
}

const confirmDelete = (order: any) => {
  orderToDelete.value = order
  showDeleteModal.value = true
}

const closeDeleteModal = () => {
  showDeleteModal.value = false
  orderToDelete.value = null
}

const deleteOrder = async () => {
  try {
    // TODO: Implement delete if needed
    showMessage('Fitur hapus belum diimplementasikan', true)
    closeDeleteModal()
  } catch (error) {
    showMessage('Gagal menghapus transaksi', true)
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

// Lifecycle
onMounted(() => {
  // load user for sidebar/profile
  const userData = localStorage.getItem('user')
  if (userData) {
    user.value = JSON.parse(userData)
  }

  fetchOrders()
})
</script>
