<template>
  <div>
    <!-- Success/Error Message -->
    <div v-if="message.show" :class="message.isError ? 'bg-red-500' : 'bg-green-500'" class="text-white px-6 py-3 text-center mb-6 rounded-lg">
      {{ message.text }}
    </div>

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
                        
                        <!-- Tombol Edit (hanya untuk pending) -->
                        <router-link 
                          v-if="po.status === 'pending'" 
                          :to="`/staff/non-po/receipt/${po.id}/edit`" 
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
import purchaseOrderService from '@/services/purchaseOrder.service'
import api from '@/services/api'
import type { PurchaseOrder } from '@/services/purchaseOrder.service'

interface ExtendedPO extends PurchaseOrder {
  tipe?: 'po' | 'non-po'
  receive_date?: string
}

const router = useRouter()

const user = ref<any | null>(null)

const poList = ref<ExtendedPO[]>([])
const loading = ref(false)
const searchQuery = ref('')
const filterStatus = ref('')
const filterDateFrom = ref('')
const filterDateTo = ref('')

const showDeleteModal = ref(false)
const selectedPO = ref<ExtendedPO | null>(null)

const message = reactive({
  show: false,
  text: '',
  isError: false
})

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
        receive_date: nonPo.receive_date,
        total: nonPo.total_value || 0
      }))
    ]

    console.log('All Orders (merged):', allOrders)

    // Sort by created_at desc
    poList.value = allOrders.sort((a: any, b: any) => {
      return new Date(b.created_at).getTime() - new Date(a.created_at).getTime()
    })

    console.log('Final poList:', poList.value)
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
    let response
    
    // Check if it's Non-PO or regular PO
    if (selectedPO.value.tipe === 'non-po') {
      // Delete Non-PO receipt
      response = await api.delete(`/staff/non-po/receipt/${selectedPO.value.id}`)
    } else {
      // Delete regular PO
      response = await purchaseOrderService.delete(selectedPO.value.id)
    }
    
    if (response.data?.success || response.success) {
      showMessage(selectedPO.value.tipe === 'non-po' ? 'Non-PO berhasil dihapus' : 'Purchase order berhasil dihapus', false)
      await fetchPurchaseOrders()
      showDeleteModal.value = false
    }
  } catch (error: any) {
    console.error('Error deleting:', error)
    showMessage(error.response?.data?.message || 'Gagal menghapus data', true)
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

const showMessage = (text: string, isError: boolean = false) => {
  message.text = text
  message.isError = isError
  message.show = true
  
  setTimeout(() => {
    message.show = false
  }, 3000)
}
</script>

<style scoped>
/* Additional custom styles if needed */
</style>
