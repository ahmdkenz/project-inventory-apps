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
      
      <StaffNavigation :current-path="$route.path" />
      
      <div class="absolute bottom-0 left-0 w-full p-4 border-t border-gray-700">
        <div class="flex items-center space-x-3">
          <img class="h-10 w-10 rounded-full" src="https://placehold.co/100x100/FEF2F2/DC2626?text=S" alt="Avatar Pengguna">
          <div>
            <p class="text-sm font-medium text-white">{{ user.name }}</p>
            <p class="text-xs text-gray-400">Staff Gudang</p>
          </div>
        </div>
      </div>
    </aside>

    <div class="fixed inset-0 bg-black bg-opacity-50 z-20 hidden" id="overlay" @click="toggleSidebar"></div>
    
    <div class="flex-1 flex flex-col transition-all duration-300 ease-in-out lg:ml-64" id="main-content">
      <header class="bg-white shadow-sm p-4 flex items-center justify-between z-10">
        <button id="hamburger-btn" @click="toggleSidebar" class="text-gray-600 lg:hidden">
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
            <span class="absolute top-0 right-0 h-2 w-2 bg-red-500 rounded-full"></span>
            <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M14.857 17.082a23.848 23.848 0 005.454-1.31A8.967 8.967 0 0118 9.75v-.7V9A6 6 0 006 9v.75a8.967 8.967 0 01-2.312 6.022c1.733.64 3.56 1.085 5.455 1.31m5.714 0a24.255 24.255 0 01-5.714 0m5.714 0a3 3 0 11-5.714 0" />
            </svg>
          </button>
          <div class="relative">
            <button @click="showProfileMenu = !showProfileMenu" class="flex items-center space-x-2">
              <img class="h-9 w-9 rounded-full" src="https://placehold.co/100x100/EBF8FF/3182CE?text=S" alt="Avatar Pengguna">
              <span class="hidden md:block text-sm font-medium text-gray-700">{{ user.name }}</span>
            </button>
            <div v-if="showProfileMenu" @click.outside="showProfileMenu = false" class="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg py-1 z-20">
              <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Profil Saya</a>
              <a @click.prevent="handleLogout" href="#" class="block px-4 py-2 text-sm text-red-600 hover:bg-gray-100">Logout</a>
            </div>
          </div>
        </div>
      </header>

      <!-- Success/Error Message -->
      <div v-if="message.show" :class="message.isError ? 'bg-red-500' : 'bg-green-500'" class="text-white px-6 py-3 text-center">
        {{ message.text }}
      </div>

      <main class="flex-1 p-6 overflow-y-auto">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6">
          <h1 class="text-3xl font-bold text-gray-900">Purchase Order (PO)</h1>
          <div class="mt-4 md:mt-0 flex flex-col sm:flex-row gap-3">
            <router-link
              to="/staff/non-po/receipt/create"
              class="bg-green-600 hover:bg-green-700 text-white font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150"
            >
              <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M9 12h3.75M9 15h3.75M9 18h3.75m3 .75H18a2.25 2.25 0 002.25-2.25V6.108c0-1.135-.845-2.098-1.976-2.192a48.424 48.424 0 00-1.123-.08m-5.801 0c-.065.21-.1.433-.1.664 0 .414.336.75.75.75h4.5a.75.75 0 00.75-.75 2.25 2.25 0 00-.1-.664m-5.8 0A2.251 2.251 0 0113.5 2.25H15c1.012 0 1.867.668 2.15 1.586m-5.8 0c-.376.023-.75.05-1.124.08C9.095 4.01 8.25 4.973 8.25 6.108V8.25m0 0H4.875c-.621 0-1.125.504-1.125 1.125v11.25c0 .621.504 1.125 1.125 1.125h9.75c.621 0 1.125-.504 1.125-1.125V9.375c0-.621-.504-1.125-1.125-1.125H8.25zM6.75 12h.008v.008H6.75V12zm0 3h.008v.008H6.75V15zm0 3h.008v.008H6.75V18z" />
              </svg>
              <span>Penerimaan Non PO</span>
            </router-link>
            <router-link
              to="/staff/purchase-order/create"
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
          <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
            <input 
              v-model="searchQuery" 
              @input="handleSearch"
              type="text" 
              placeholder="Cari No. PO / Supplier..." 
              class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
            >
            <select 
              v-model="filterStatus" 
              class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
            >
              <option value="">Semua Status</option>
              <option value="pending">Pending</option>
              <option value="approved">Disetujui</option>
              <option value="rejected">Ditolak</option>
              <option value="completed">Selesai</option>
            </select>
            <input 
              v-model="filterDateFrom"
              type="date" 
              class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500 text-gray-500"
            >
            <input 
              v-model="filterDateTo"
              type="date" 
              class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500 text-gray-500"
            >
          </div>
        </div>

        <!-- Tabel Data PO -->
        <div class="bg-white rounded-lg shadow-sm overflow-hidden">
          <div v-if="loading" class="p-8 text-center text-gray-500">
            Memuat data...
          </div>
          <div v-else class="overflow-x-auto">
            <table class="w-full min-w-max">
              <thead class="bg-gray-50 border-b border-gray-200">
                <tr>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">No. PO</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tipe</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Supplier</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tgl. Pesan</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Estimasi</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                  <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Total</th>
                  <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Aksi</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-gray-200">
                <tr v-if="filteredPurchaseOrders.length === 0">
                  <td colspan="8" class="px-6 py-4 text-center text-sm text-gray-500">
                    Tidak ada data purchase order
                  </td>
                </tr>
                <tr v-for="po in filteredPurchaseOrders" :key="`${po.tipe}-${po.id}`">
                  <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                    <router-link 
                      :to="po.tipe === 'non-po' ? `/staff/non-po/receipt/${po.id}/detail` : `/staff/purchase-order/${po.id}`" 
                      class="text-blue-600 hover:text-blue-800 hover:underline flex items-center"
                    >
                      <svg class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                      </svg>
                      {{ po.no_po }}
                    </router-link>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <span :class="po.tipe === 'non-po' ? 'px-2 py-1 text-xs font-medium rounded bg-purple-100 text-purple-800' : 'px-2 py-1 text-xs font-medium rounded bg-blue-100 text-blue-800'">
                      {{ po.tipe === 'non-po' ? 'Non-PO' : 'PO Reguler' }}
                    </span>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ po.supplier?.nama || '-' }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ formatDate(po.tgl_pesan || po.receive_date) }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ formatDate(po.tgl_estimasi) }}</td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <span :class="getStatusClass(po.status)">
                      {{ getStatusText(po.status) }}
                    </span>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 text-right">{{ formatCurrency(po.total || 0) }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                    <div class="flex items-center justify-end space-x-2">
                      <!-- Non-PO Actions -->
                      <template v-if="po.tipe === 'non-po'">
                        <!-- Detail button -->
                        <router-link 
                          :to="`/staff/non-po/receipt/${po.id}/detail`" 
                          class="inline-flex items-center px-3 py-1.5 bg-blue-50 text-blue-600 hover:bg-blue-100 rounded-lg transition"
                        >
                          <svg class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                          </svg>
                          Detail
                        </router-link>
                        
                        <!-- Print button for completed -->
                        <router-link
                          v-if="po.status === 'completed'"
                          :to="`/staff/non-po/receipt/${po.id}/print`"
                          class="inline-flex items-center px-3 py-1.5 bg-green-600 text-white hover:bg-green-700 rounded-lg transition"
                        >
                          <svg class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v-4a2 2 0 012-2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z" />
                          </svg>
                          Cetak Bukti
                        </router-link>
                      </template>
                      
                      <!-- Regular PO Actions -->
                      <template v-else>
                        <!-- Tombol Detail -->
                        <router-link 
                          :to="`/staff/purchase-order/${po.id}`" 
                          class="inline-flex items-center px-3 py-1.5 bg-blue-50 text-blue-600 hover:bg-blue-100 rounded-lg transition"
                        >
                          <svg class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                          </svg>
                          Detail
                        </router-link>
                        
                        <!-- Tombol Cetak untuk PO yang sudah completed -->
                        <router-link
                          v-if="po.status === 'completed'"
                          :to="`/staff/purchase-orders/${po.id}/print-receipt`"
                          class="inline-flex items-center px-3 py-1.5 bg-green-600 text-white hover:bg-green-700 rounded-lg transition"
                        >
                          <svg class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v-4a2 2 0 012-2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z" />
                          </svg>
                          Cetak Bukti
                        </router-link>
                        
                        <!-- Tombol Edit (hanya untuk pending) -->
                        <router-link 
                          v-if="po.status === 'pending'" 
                          :to="`/staff/purchase-order/edit/${po.id}`" 
                          class="inline-flex items-center px-3 py-1.5 bg-yellow-50 text-yellow-600 hover:bg-yellow-100 rounded-lg transition"
                        >
                          <svg class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                          </svg>
                          Edit
                        </router-link>
                        
                        <!-- Tombol Hapus (hanya untuk pending) -->
                        <button 
                          v-if="po.status === 'pending'" 
                          @click="confirmDelete(po)" 
                          class="inline-flex items-center px-3 py-1.5 bg-red-50 text-red-600 hover:bg-red-100 rounded-lg transition"
                        >
                          <svg class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                          </svg>
                          Hapus
                        </button>
                      </template>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </main>
    </div>

    <!-- Modal Delete Confirmation -->
    <div v-if="showDeleteModal" class="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
      <div class="bg-white rounded-lg shadow-xl max-w-md w-full p-6">
        <h3 class="text-lg font-semibold text-gray-900 mb-4">Konfirmasi Hapus</h3>
        <p class="text-gray-600 mb-6">
          Apakah Anda yakin ingin menghapus PO <strong>{{ selectedPO?.no_po }}</strong>?
        </p>
        <div class="flex justify-end space-x-3">
          <button 
            @click="showDeleteModal = false" 
            class="px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition"
          >
            Batal
          </button>
          <button 
            @click="deletePO" 
            class="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition"
          >
            Hapus
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import StaffNavigation from '@/components/StaffNavigation.vue'
import purchaseOrderService from '@/services/purchaseOrder.service'
import api from '@/services/api'
import type { PurchaseOrder } from '@/services/purchaseOrder.service'

interface ExtendedPO extends PurchaseOrder {
  tipe?: 'po' | 'non-po'
  receive_date?: string
}

const router = useRouter()

const user = ref({
  name: 'Staff',
  role: 'staff'
})

const poList = ref<ExtendedPO[]>([])
const loading = ref(false)
const searchQuery = ref('')
const filterStatus = ref('')
const filterDateFrom = ref('')
const filterDateTo = ref('')
const showProfileMenu = ref(false)

const showDeleteModal = ref(false)
const selectedPO = ref<ExtendedPO | null>(null)

const message = reactive({
  show: false,
  text: '',
  isError: false
})

const filteredPurchaseOrders = computed(() => {
  let result = poList.value

  // Filter by search query
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    result = result.filter(po => 
      po.no_po?.toLowerCase().includes(query) ||
      po.supplier?.nama?.toLowerCase().includes(query)
    )
  }

  // Filter by status
  if (filterStatus.value) {
    result = result.filter(po => po.status === filterStatus.value)
  }

  // Filter by date range
  if (filterDateFrom.value) {
    result = result.filter(po => po.tgl_pesan >= filterDateFrom.value)
  }
  if (filterDateTo.value) {
    result = result.filter(po => po.tgl_pesan <= filterDateTo.value)
  }

  return result
})

onMounted(async () => {
  const storedUser = localStorage.getItem('user')
  if (storedUser) {
    const userData = JSON.parse(storedUser)
    user.value = userData
  }
  
  await fetchPurchaseOrders()
})

const fetchPurchaseOrders = async () => {
  loading.value = true
  try {
    // Fetch both regular PO and Non-PO
    const [poResponse, nonPoResponse] = await Promise.all([
      purchaseOrderService.getAll(),
      api.get('/staff/non-po/receipts')
    ])

    const regularPOs = Array.isArray(poResponse.data) ? poResponse.data : []
    const nonPOs = Array.isArray(nonPoResponse.data.data) ? nonPoResponse.data.data : []

    // Merge and add tipe field
    const allOrders = [
      ...regularPOs.map((po: any) => ({ ...po, tipe: 'po' })),
      ...nonPOs.map((nonPo: any) => ({
        ...nonPo,
        tipe: 'non-po',
        no_po: nonPo.no_dokumen,
        supplier: { nama: nonPo.source || '-' },
        receive_date: nonPo.receive_date,
        total: nonPo.total_value || 0
      }))
    ]

    // Sort by created_at desc
    poList.value = allOrders.sort((a: any, b: any) => {
      return new Date(b.created_at).getTime() - new Date(a.created_at).getTime()
    })
  } catch (error: any) {
    console.error('Error loading purchase orders:', error)
    showMessage(error.response?.data?.message || 'Gagal memuat data purchase order', true)
  } finally {
    loading.value = false
  }
}

let searchTimeout: any = null
const handleSearch = () => {
  clearTimeout(searchTimeout)
  searchTimeout = setTimeout(() => {
    // Filtering is done by computed property
  }, 300)
}

const confirmDelete = (po: ExtendedPO) => {
  selectedPO.value = po
  showDeleteModal.value = true
}

const deletePO = async () => {
  if (!selectedPO.value?.id) return
  
  try {
    const response = await purchaseOrderService.delete(selectedPO.value.id)
    if (response.success) {
      showMessage('Purchase order berhasil dihapus', false)
      await fetchPurchaseOrders()
      showDeleteModal.value = false
    }
  } catch (error: any) {
    console.error('Error deleting purchase order:', error)
    showMessage(error.response?.data?.message || 'Gagal menghapus purchase order', true)
  }
}

const formatDate = (dateString: string | undefined) => {
  if (!dateString) return '-'
  const date = new Date(dateString)
  return date.toLocaleDateString('id-ID', { day: 'numeric', month: 'short', year: 'numeric' })
}

const formatCurrency = (value: number) => {
  return new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    minimumFractionDigits: 0
  }).format(value)
}

const getStatusClass = (status: string) => {
  const classes = {
    'pending': 'px-3 py-1 inline-flex text-xs font-medium rounded-full bg-yellow-100 text-yellow-800',
    'approved': 'px-3 py-1 inline-flex text-xs font-medium rounded-full bg-green-100 text-green-800',
    'rejected': 'px-3 py-1 inline-flex text-xs font-medium rounded-full bg-red-100 text-red-800',
    'completed': 'px-3 py-1 inline-flex text-xs font-medium rounded-full bg-blue-100 text-blue-800'
  }
  return classes[status as keyof typeof classes] || 'px-3 py-1 inline-flex text-xs font-medium rounded-full bg-gray-100 text-gray-800'
}

const getStatusText = (status: string) => {
  const texts = {
    'pending': 'pending',
    'approved': 'Approved (Pending)',
    'rejected': 'Reject',
    'completed': 'Done'
  }
  return texts[status as keyof typeof texts] || status
}

const toggleSidebar = () => {
  const sidebar = document.getElementById('sidebar')
  const overlay = document.getElementById('overlay')
  
  if (sidebar && overlay) {
    sidebar.classList.toggle('-translate-x-full')
    overlay.classList.toggle('hidden')
  }
}

const showMessage = (text: string, isError: boolean = false) => {
  message.text = text
  message.isError = isError
  message.show = true
  
  setTimeout(() => {
    message.show = false
  }, 3000)
}

const handleLogout = () => {
  localStorage.removeItem('token')
  localStorage.removeItem('user')
  router.push('/login')
}
</script>

<style scoped>
/* Additional custom styles if needed */
</style>
