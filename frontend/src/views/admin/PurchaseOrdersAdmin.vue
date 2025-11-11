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
      <AdminNavigation :current-path="$route.path"></AdminNavigation>
      
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
          <div class="relative" ref="profileRef">
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
        <!-- Header Halaman -->
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6">
          <h1 class="text-3xl font-bold text-gray-900">Manajemen Purchase Order</h1>
          <div class="mt-4 md:mt-0 flex flex-col sm:flex-row gap-3">
            <router-link
              to="/admin/non-po/receipt/create"
              class="bg-green-600 hover:bg-green-700 text-white font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150"
            >
              <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M9 12h3.75M9 15h3.75M9 18h3.75m3 .75H18a2.25 2.25 0 002.25-2.25V6.108c0-1.135-.845-2.098-1.976-2.192a48.424 48.424 0 00-1.123-.08m-5.801 0c-.065.21-.1.433-.1.664 0 .414.336.75.75.75h4.5a.75.75 0 00.75-.75 2.25 2.25 0 00-.1-.664m-5.8 0A2.251 2.251 0 0113.5 2.25H15c1.012 0 1.867.668 2.15 1.586m-5.8 0c-.376.023-.75.05-1.124.08C9.095 4.01 8.25 4.973 8.25 6.108V8.25m0 0H4.875c-.621 0-1.125.504-1.125 1.125v11.25c0 .621.504 1.125 1.125 1.125h9.75c.621 0 1.125-.504 1.125-1.125V9.375c0-.621-.504-1.125-1.125-1.125H8.25zM6.75 12h.008v.008H6.75V12zm0 3h.008v.008H6.75V15zm0 3h.008v.008H6.75V18z" />
              </svg>
              <span>Penerimaan Non PO</span>
            </router-link>
            <router-link
              to="/admin/purchase-orders/create"
              class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150"
            >
              <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
              </svg>
              <span>Buat PO Baru</span>
            </router-link>
          </div>
        </div>

        <!-- Filter dan Pencarian -->
        <div class="mb-6 bg-white p-4 rounded-lg shadow-sm">
          <div class="grid grid-cols-1 md:grid-cols-5 gap-4">
            <input
              v-model="filters.search"
              type="text"
              placeholder="Cari No. PO / Supplier..."
              class="md:col-span-2 w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
              @input="handleSearch"
            />
            <select
              v-model="filters.status"
              class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
              @change="fetchOrders"
            >
              <option value="">Semua Status</option>
              <option value="pending">Menunggu Persetujuan</option>
              <option value="approved">Pending (Disetujui)</option>
              <option value="completed">Selesai</option>
              <option value="rejected">Dibatalkan</option>
            </select>
            <input
              v-model="filters.dateStart"
              type="date"
              class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500 text-gray-500"
              @change="fetchOrders"
            />
            <input
              v-model="filters.dateEnd"
              type="date"
              class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500 text-gray-500"
              @change="fetchOrders"
            />
          </div>
        </div>

        <!-- Loading State -->
        <div v-if="loading" class="flex justify-center items-center py-12">
          <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
        </div>

        <!-- Tabel Data PO -->
        <div v-else class="bg-white rounded-lg shadow-sm overflow-hidden">
          <div class="overflow-x-auto">
            <table class="w-full min-w-max">
              <thead class="bg-gray-50 border-b border-gray-200">
                <tr>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">No. PO</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tipe</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Supplier</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Dibuat Oleh</th>
                  <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Total</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                  <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Aksi</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-gray-200">
                <tr v-if="orders.length === 0">
                  <td colspan="7" class="px-6 py-8 text-center text-gray-500">
                    Tidak ada data purchase order.
                  </td>
                </tr>
                <tr v-for="order in orders" :key="`${order.tipe}-${order.id}`">
                  <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-blue-600 hover:text-blue-800">
                    <router-link :to="order.tipe === 'non-po' ? `/admin/non-po/receipt/${order.id}/detail` : `/admin/purchase-orders/detail/${order.id}`">
                      {{ order.no_po }}
                    </router-link>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <span :class="order.tipe === 'non-po' ? 'px-2 py-1 text-xs font-medium rounded bg-purple-100 text-purple-800' : 'px-2 py-1 text-xs font-medium rounded bg-blue-100 text-blue-800'">
                      {{ order.tipe === 'non-po' ? 'Non-PO' : 'PO Reguler' }}
                    </span>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ order.supplier?.nama || '-' }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ order.creator?.name || '-' }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 text-right">{{ formatCurrency(order.total) }}</td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <span :class="getStatusBadgeClass(order.status)" class="px-3 py-1 inline-flex text-xs font-medium rounded-full">
                      {{ getStatusLabel(order.status) }}
                    </span>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium space-x-2">
                    <!-- Tombol untuk Non-PO -->
                    <template v-if="order.tipe === 'non-po'">
                      <!-- Pending: Approve/Reject -->
                      <template v-if="order.status === 'pending'">
                        <button 
                          @click="confirmApproveNonPo(order)" 
                          class="text-green-600 hover:text-green-800"
                        >
                          Setujui
                        </button>
                        <button 
                          @click="openRejectNonPoModal(order)" 
                          class="text-red-600 hover:text-red-800"
                        >
                          Tolak
                        </button>
                      </template>

                      <!-- Approved: Terima Barang -->
                      <template v-else-if="order.status === 'approved'">
                        <router-link 
                          :to="`/admin/non-po/receipt/${order.id}/receive`" 
                          class="text-blue-600 hover:text-blue-800"
                        >
                          Terima Barang
                        </router-link>
                      </template>
                      
                      <!-- Completed: Cetak -->
                      <template v-else-if="order.status === 'completed'">
                        <router-link 
                          :to="`/admin/non-po/receipt/${order.id}/print`" 
                          class="text-green-600 hover:text-green-800"
                        >
                          Cetak Bukti
                        </router-link>
                      </template>
                      
                      <!-- Detail button -->
                      <router-link 
                        :to="`/admin/non-po/receipt/${order.id}/detail`" 
                        class="text-indigo-600 hover:text-indigo-900"
                      >
                        Detail
                      </router-link>
                    </template>
                    
                    <!-- Tombol untuk PO Reguler -->
                    <template v-else>
                      <!-- Tombol untuk status pending -->
                      <template v-if="order.status === 'pending'">
                        <button 
                          @click="confirmApprove(order)" 
                          class="text-green-600 hover:text-green-800"
                        >
                          Setujui
                        </button>
                        <button 
                          @click="openRejectModal(order)" 
                          class="text-red-600 hover:text-red-800"
                        >
                          Tolak
                        </button>
                      </template>
                      
                      <!-- Tombol untuk status approved -->
                      <template v-else-if="order.status === 'approved'">
                        <router-link 
                          :to="`/admin/purchase-orders/${order.id}/receive`" 
                          class="text-blue-600 hover:text-blue-800"
                        >
                          Terima Barang
                        </router-link>
                      </template>
                      
                      <!-- Tombol untuk status completed -->
                      <template v-else-if="order.status === 'completed'">
                        <router-link 
                          :to="`/admin/purchase-orders/${order.id}/print-receipt`" 
                          class="text-green-600 hover:text-green-800"
                        >
                          Cetak Bukti
                        </router-link>
                      </template>
                      
                      <!-- Tombol Detail (tersedia untuk semua status) -->
                      <router-link 
                        :to="`/admin/purchase-orders/detail/${order.id}`" 
                        class="text-indigo-600 hover:text-indigo-900"
                      >
                        Detail
                      </router-link>
                    </template>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Pagination -->
        <div class="mt-6 flex items-center justify-between">
          <button class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 font-medium py-2 px-4 rounded-lg text-sm transition duration-150" disabled>
            Sebelumnya
          </button>
          <span class="text-sm text-gray-600">
            Halaman <span class="font-medium">1</span> dari <span class="font-medium">1</span>
          </span>
          <button class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 font-medium py-2 px-4 rounded-lg text-sm transition duration-150">
            Berikutnya
          </button>
        </div>

      <!-- Modal Konfirmasi Approve -->
      <div
        v-if="showApproveModal"
        class="fixed inset-0 bg-gray-600 bg-opacity-75 flex items-center justify-center p-4 z-50 transition-opacity duration-300"
        @click.self="closeApproveModal"
      >
        <div class="bg-white rounded-lg shadow-xl w-full max-w-md transform transition-all">
          <div class="p-6 border-b border-gray-200">
            <h3 class="text-lg font-medium leading-6 text-gray-900">Setujui Purchase Order</h3>
          </div>
          <div class="p-6">
            <p class="text-sm text-gray-600">
              Apakah Anda yakin ingin menyetujui Purchase Order <strong>{{ orderToApprove?.no_po }}</strong>?
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
              Ya, Setujui
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
            <h3 class="text-lg font-medium leading-6 text-gray-900">Tolak Purchase Order</h3>
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
              Ya, Tolak
            </button>
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
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onBeforeUnmount } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import AdminNavigation from '@/components/AdminNavigation.vue'
import purchaseOrderService from '@/services/purchaseOrder.service'
import api from '@/services/api'

// Router & auth
const router = useRouter()
const authStore = useAuthStore()

// Header/Profile state
const showProfileMenu = ref(false)
const user = ref<any>(null)
const profileRef = ref<HTMLElement | null>(null)

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

// Handle click outside profile menu
const handleClickOutside = (event: MouseEvent) => {
  const target = event.target as Node
  if (showProfileMenu.value && profileRef.value && !profileRef.value.contains(target)) {
    closeProfileMenu()
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
const orderToDelete = ref<any>(null)
const orderToApprove = ref<any>(null)
const orderToReject = ref<any>(null)
const rejectReason = ref('')
const rejectReasonError = ref('')

// Format No. Dokumen untuk Non-PO menjadi PO-NON-YYYYMMDD-0001
const formatNonPoNumber = (id: number, createdAt: string) => {
  if (!createdAt) return '-'
  const date = new Date(createdAt)
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  const sequence = String(id).padStart(4, '0')
  return `PO-NON-${year}${month}${day}-${sequence}`
}

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

    // Fetch both regular PO and Non-PO
    const [poResponse, nonPoResponse] = await Promise.all([
      purchaseOrderService.adminGetAll(params),
      api.get('/admin/non-po/receipts', { params })
    ])

    console.log('PO Response:', poResponse)
    console.log('Non-PO Response:', nonPoResponse)

    const regularPOs = Array.isArray(poResponse.data) ? poResponse.data : []
    const nonPOs = Array.isArray(nonPoResponse.data.data) ? nonPoResponse.data.data : []

    console.log('Regular POs:', regularPOs)
    console.log('Non-POs:', nonPOs)

    // Merge and add tipe field
    const allOrders = [
      ...regularPOs.map((po: any) => ({ ...po, tipe: 'po' })),
      ...nonPOs.map((nonPo: any) => ({
        ...nonPo,
        tipe: 'non-po',
        no_po: formatNonPoNumber(nonPo.id, nonPo.created_at),
        supplier: { nama: nonPo.source || '-' },
        total: nonPo.total_value || 0
      }))
    ]

    console.log('All Orders (merged):', allOrders)

    // Sort by created_at desc
    orders.value = allOrders.sort((a: any, b: any) => {
      return new Date(b.created_at).getTime() - new Date(a.created_at).getTime()
    })
    
    console.log('Final orders:', orders.value)
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
  
  // Check if it's Non-PO
  if (orderToApprove.value.tipe === 'non-po') {
    await approveNonPo()
    return
  }
  
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

const rejectOrder = async () => {
  if (!orderToReject.value) return
  
  if (!rejectReason.value.trim()) {
    rejectReasonError.value = 'Alasan penolakan harus diisi'
    return
  }
  
  // Check if it's Non-PO
  if (orderToReject.value.tipe === 'non-po') {
    await rejectNonPo()
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
    'pending': 'bg-purple-100 text-purple-800',
    'approved': 'bg-yellow-100 text-yellow-800',
    'rejected': 'bg-red-100 text-red-800',
    'completed': 'bg-green-100 text-green-800'
  }
  return classes[status] || 'bg-gray-100 text-gray-800'
}

const getStatusLabel = (status: string) => {
  const labels: any = {
    'pending': 'Approved (Pending)',
    'approved': 'Approved (Pending)',
    'rejected': 'Reject',
    'completed': 'Done'
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

const confirmApproveNonPo = (order: any) => {
  orderToApprove.value = order
  showApproveModal.value = true
}

const openRejectNonPoModal = (order: any) => {
  orderToReject.value = order
  rejectReason.value = ''
  rejectReasonError.value = ''
  showRejectModal.value = true
}

const approveNonPo = async () => {
  if (!orderToApprove.value) return
  
  loading.value = true
  try {
    const response = await api.post(`/admin/non-po/receipt/${orderToApprove.value.id}/approve`)
    if (response.data.success) {
      showMessage('Non-PO Receipt berhasil disetujui', false)
      closeApproveModal()
      await fetchOrders()
    }
  } catch (error: any) {
    console.error('Error approving non-po:', error)
    showMessage(error.response?.data?.message || 'Gagal menyetujui Non-PO receipt', true)
  } finally {
    loading.value = false
  }
}

const rejectNonPo = async () => {
  if (!orderToReject.value) return
  
  if (!rejectReason.value.trim()) {
    rejectReasonError.value = 'Alasan penolakan harus diisi'
    return
  }
  
  loading.value = true
  try {
    const response = await api.post(`/admin/non-po/receipt/${orderToReject.value.id}/reject`, {
      reason: rejectReason.value
    })
    if (response.data.success) {
      showMessage('Non-PO Receipt berhasil ditolak', false)
      closeRejectModal()
      await fetchOrders()
    }
  } catch (error: any) {
    console.error('Error rejecting non-po:', error)
    showMessage(error.response?.data?.message || 'Gagal menolak Non-PO receipt', true)
  } finally {
    loading.value = false
  }
}

// Lifecycle
onMounted(() => {
  // load user for sidebar/profile
  const userData = localStorage.getItem('user')
  if (userData) {
    user.value = JSON.parse(userData)
  }

  // Add click outside listener
  document.addEventListener('click', handleClickOutside)

  fetchOrders()
})

onBeforeUnmount(() => {
  // Remove click outside listener
  document.removeEventListener('click', handleClickOutside)
})
</script>
