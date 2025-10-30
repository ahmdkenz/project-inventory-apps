<template>
  <div class="flex h-screen bg-gray-100">
    <AdminNavigation :current-path="$route.path" />
    
    <div class="flex-1 flex flex-col lg:ml-64">
      <!-- Header -->
      <header class="bg-white shadow-sm p-4 flex items-center justify-between print-hidden">
        <button @click="toggleSidebar" class="text-gray-600 lg:hidden">
          <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
          </svg>
        </button>
        <div class="flex-1"></div>
      </header>

      <!-- Main Content -->
      <main class="flex-1 p-6 overflow-y-auto">
        <div v-if="loading" class="flex justify-center items-center py-12">
          <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
        </div>

        <div v-else-if="salesOrder">
          <!-- Tombol Aksi Atas -->
          <div class="flex items-center justify-between mb-6 print-hidden">
            <h1 class="text-3xl font-bold text-gray-900">Detail Sales Order</h1>
            <div class="flex space-x-3">
              <button @click="goBack" class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150">
                <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5L8.25 12l7.5-7.5" />
                </svg>
                <span>Kembali</span>
              </button>
              <button @click="printDocument" class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150">
                <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M6.72 13.829c-.24.03-.48.062-.72.096m.72-.096a42.415 42.415 0 0110.56 0m-10.56 0L6.34 18m10.94-4.171c.24.03.48.062.72.096m-.72-.096L17.66 18m0 0l.229 2.523a1.125 1.125 0 01-1.12 1.227H7.23a1.125 1.125 0 01-1.12-1.227L6.34 18m11.319 0H6.34m11.319 0l.044.506A1.125 1.125 0 0117.003 20H6.997a1.125 1.125 0 01-1.122-1.494l.044-.506M6.34 18v-4.172c0-.224.03-.447.086-.665A41.4 41.4 0 0112 3c1.83 0 3.597.133 5.28.362.057.218.086.44.086.665v4.172M6.34 18L4.26 7.5h15.48L17.66 18" />
                </svg>
                <span>Cetak SO</span>
              </button>
            </div>
          </div>
          
          <!-- Layout 2 Kolom -->
          <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">

            <!-- Kolom Kiri: Dokumen SO (Area Cetak) -->
            <div class="lg:col-span-8" id="printable-area-container">
              <div class="bg-white p-8 rounded-lg shadow-lg border border-gray-200" id="printable-area-content">
                <!-- Header Dokumen -->
                <div class="flex justify-between items-start pb-6 border-b-2 border-gray-900">
                  <div>
                    <h2 class="text-3xl font-bold text-gray-900">SALES ORDER</h2>
                    <p class="text-lg font-semibold text-blue-600">{{ salesOrder.no_so }}</p>
                  </div>
                  <div class="text-right">
                    <img src="https://placehold.co/150x50/000000/FFFFFF?text=LOGO+PERUSAHAAN" alt="Logo Perusahaan" class="h-12 mb-2 ml-auto">
                    <p class="text-sm font-semibold text-gray-800">Nama Perusahaan Anda</p>
                    <p class="text-sm text-gray-600">Jl. Jend. Sudirman No. 1, Jakarta</p>
                    <p class="text-sm text-gray-600">Telepon: (021) 123456</p>
                  </div>
                </div>

                <!-- Info Penerima dan Tanggal -->
                <div class="grid grid-cols-2 gap-8 my-6">
                  <div>
                    <p class="text-sm font-semibold text-gray-500 uppercase mb-2">PENERIMA / TUJUAN:</p>
                    <p class="text-lg font-bold text-gray-900">{{ salesOrder.customer_name }}</p>
                    <p v-if="salesOrder.customer_address" class="text-sm text-gray-600">{{ salesOrder.customer_address }}</p>
                    <p v-if="salesOrder.customer_phone" class="text-sm text-gray-600">Telp: {{ salesOrder.customer_phone }}</p>
                  </div>
                  <div class="text-right">
                    <div class="mb-2">
                      <span class="text-sm font-semibold text-gray-500 uppercase">Tanggal SO: </span>
                      <span class="text-sm font-medium text-gray-800">{{ formatDate(salesOrder.tgl_order) }}</span>
                    </div>
                    <div>
                      <span class="text-sm font-semibold text-gray-500 uppercase">Status: </span>
                      <span :class="['text-sm font-medium', getStatusColor(salesOrder.status)]">
                        {{ getStatusLabel(salesOrder.status) }}
                      </span>
                    </div>
                  </div>
                </div>

                <!-- Tabel Item -->
                <div class="overflow-x-auto border rounded-lg mb-6">
                  <table class="w-full min-w-max">
                    <thead class="bg-gray-100 text-gray-700">
                      <tr>
                        <th class="px-6 py-3 text-left text-xs font-bold uppercase tracking-wider">No.</th>
                        <th class="px-6 py-3 text-left text-xs font-bold uppercase tracking-wider">Nama Barang</th>
                        <th class="px-6 py-3 text-center text-xs font-bold uppercase tracking-wider">Jumlah Diminta</th>
                        <th class="px-6 py-3 text-left text-xs font-bold uppercase tracking-wider">Catatan Item</th>
                      </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-200">
                      <tr v-for="(item, index) in salesOrder.items" :key="item.id">
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{{ index + 1 }}.</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ item.barang?.nama || '-' }}</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600 text-center">{{ item.qty }}</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">-</td>
                      </tr>
                    </tbody>
                    <tfoot class="bg-gray-50 font-medium print-no-break">
                      <tr>
                        <td colspan="4" class="px-6 py-3">
                          <p class="text-xs text-gray-500 uppercase font-semibold">Catatan SO:</p>
                          <p class="text-sm text-gray-600">{{ salesOrder.catatan || '-' }}</p>
                        </td>
                      </tr>
                    </tfoot>
                  </table>
                </div>

                <!-- Tanda Tangan -->
                <div class="grid grid-cols-3 gap-8 pt-6 border-t border-gray-200 print-no-break">
                  <div>
                    <p class="text-sm text-gray-700 mb-16">Diajukan oleh,</p>
                    <p class="text-sm font-medium text-gray-900 border-t border-gray-400 pt-1">({{ salesOrder.creator?.name || '-' }})</p>
                    <p class="text-xs text-gray-500">Staff</p>
                  </div>
                  <div class="text-center">
                    <p class="text-sm text-gray-700 mb-16">Disetujui oleh,</p>
                    <p class="text-sm font-medium text-gray-900 border-t border-gray-400 pt-1">({{ salesOrder.approver?.name || 'Nama Admin' }})</p>
                    <p class="text-xs text-gray-500">Manajer Logistik</p>
                  </div>
                  <div class="text-center">
                    <p class="text-sm text-gray-700 mb-16">Diserahkan oleh,</p>
                    <p class="text-sm font-medium text-gray-900 border-t border-gray-400 pt-1">(Staff Gudang)</p>
                    <p class="text-xs text-gray-500">Staff Gudang</p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Kolom Kanan: Info & Riwayat (Non-Cetak) -->
            <div class="lg:col-span-4 space-y-6 print-hidden">
              
              <!-- Status SO -->
              <div class="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
                <h3 class="text-lg font-semibold text-gray-900 mb-4">Status SO</h3>
                <span :class="[getStatusBadgeClass(salesOrder.status), 'px-4 py-1.5 inline-flex text-base font-medium rounded-full']">
                  {{ getStatusLabel(salesOrder.status) }}
                </span>
                <p class="text-sm text-gray-500 mt-2">
                  Diajukan oleh {{ salesOrder.creator?.name || '-' }} pada {{ formatDate(salesOrder.created_at) }}.
                </p>
                
                <!-- Tombol Aksi Admin -->
                <div v-if="salesOrder.status === 'pending'" class="mt-6 flex space-x-3">
                  <button @click="openApproveModal" class="w-full flex-1 bg-green-600 hover:bg-green-700 text-white font-medium py-2 px-4 rounded-lg transition duration-150">
                    Setujui
                  </button>
                  <button @click="openRejectModal" class="w-full flex-1 bg-red-600 hover:bg-red-700 text-white font-medium py-2 px-4 rounded-lg transition duration-150">
                    Tolak
                  </button>
                </div>
              </div>

              <!-- Riwayat Status -->
              <div class="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
                <h3 class="text-lg font-semibold text-gray-900 mb-4">Riwayat Status</h3>
                <ol class="relative border-l border-gray-200">
                  <li class="ml-4">
                    <div class="absolute w-3 h-3 bg-blue-600 rounded-full mt-1.5 -left-1.5 border border-white"></div>
                    <time class="mb-1 text-sm font-normal leading-none text-gray-500">{{ formatDate(salesOrder.created_at) }}</time>
                    <h3 class="text-base font-semibold text-gray-900">Dibuat & Diajukan</h3>
                    <p class="text-sm font-normal text-gray-500">
                      SO dibuat oleh {{ salesOrder.creator?.name || '-' }} dan menunggu persetujuan Admin.
                    </p>
                  </li>
                  <li v-if="salesOrder.approved_at" class="ml-4 mt-4">
                    <div class="absolute w-3 h-3 bg-green-600 rounded-full mt-1.5 -left-1.5 border border-white"></div>
                    <time class="mb-1 text-sm font-normal leading-none text-gray-500">{{ formatDate(salesOrder.approved_at) }}</time>
                    <h3 class="text-base font-semibold text-gray-900">Disetujui</h3>
                    <p class="text-sm font-normal text-gray-500">
                      SO disetujui oleh {{ salesOrder.approver?.name || 'Admin' }}.
                    </p>
                  </li>
                </ol>
              </div>

              <!-- Informasi Penerima -->
              <div class="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
                <h3 class="text-lg font-semibold text-gray-900 mb-4">Info Penerima</h3>
                <dl>
                  <dt class="text-sm font-medium text-gray-500">Nama/Divisi</dt>
                  <dd class="text-base text-gray-900 font-medium mb-2">{{ salesOrder.customer_name }}</dd>
                  <dt v-if="salesOrder.customer_phone" class="text-sm font-medium text-gray-500">Kontak</dt>
                  <dd v-if="salesOrder.customer_phone" class="text-base text-gray-900 font-medium mb-2">{{ salesOrder.customer_phone }}</dd>
                  <dt v-if="salesOrder.customer_address" class="text-sm font-medium text-gray-500">Lokasi</dt>
                  <dd v-if="salesOrder.customer_address" class="text-base text-gray-900 font-medium">{{ salesOrder.customer_address }}</dd>
                </dl>
              </div>
              
            </div>
          </div>
        </div>

        <div v-else class="text-center py-8">
          <p class="text-gray-600">Data tidak ditemukan</p>
        </div>
      </main>
    </div>

    <!-- Modal Approve -->
    <div
      v-if="showApproveModal"
      class="fixed inset-0 bg-gray-600 bg-opacity-75 flex items-center justify-center p-4 z-50 transition-opacity duration-300"
      @click.self="closeApproveModal"
    >
      <div class="bg-white rounded-lg shadow-xl w-full max-w-md transform transition-all">
        <div class="p-6 border-b border-gray-200">
          <h3 class="text-lg font-medium leading-6 text-gray-900">Setujui Sales Order</h3>
        </div>
        <div class="p-6">
          <p class="text-sm text-gray-600">
            Apakah Anda yakin ingin menyetujui Sales Order <strong>{{ salesOrder?.no_so }}</strong>?
          </p>
          <p class="text-sm text-gray-600 mt-2">
            Stok barang akan dikurangi setelah disetujui.
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
            @click="confirmApprove"
            type="button"
            class="bg-green-600 hover:bg-green-700 text-white font-medium py-2 px-4 rounded-lg transition duration-150"
          >
            Ya, Setujui
          </button>
        </div>
      </div>
    </div>

    <!-- Modal Reject -->
    <div
      v-if="showRejectModal"
      class="fixed inset-0 bg-gray-600 bg-opacity-75 flex items-center justify-center p-4 z-50 transition-opacity duration-300"
      @click.self="closeRejectModal"
    >
      <div class="bg-white rounded-lg shadow-xl w-full max-w-md transform transition-all">
        <div class="p-6 border-b border-gray-200">
          <h3 class="text-lg font-medium leading-6 text-gray-900">Tolak Sales Order</h3>
        </div>
        <div class="p-6">
          <p class="text-sm text-gray-600 mb-4">
            Anda akan menolak Sales Order <strong>{{ salesOrder?.no_so }}</strong>.
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
            @click="confirmReject"
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
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import AdminNavigation from '@/components/AdminNavigation.vue'
import salesOrderService from '@/services/salesOrder.service'

const router = useRouter()
const route = useRoute()

const loading = ref(false)
const salesOrder = ref<any>(null)
const showApproveModal = ref(false)
const showRejectModal = ref(false)
const rejectReason = ref('')
const rejectReasonError = ref('')

const message = ref({
  show: false,
  text: '',
  isError: false
})

const toggleSidebar = () => {
  const sidebar = document.getElementById('sidebar')
  const overlay = document.getElementById('overlay')
  if (sidebar && overlay) {
    sidebar.classList.toggle('-translate-x-full')
    overlay.classList.toggle('hidden')
  }
}

const goBack = () => {
  router.push('/admin/sales-orders')
}

const printDocument = () => {
  window.print()
}

const formatDate = (date: string) => {
  if (!date) return '-'
  return new Date(date).toLocaleDateString('id-ID', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  })
}

const getStatusLabel = (status: string) => {
  const labels: Record<string, string> = {
    pending: 'Menunggu Persetujuan',
    approved: 'Disetujui (Pending)',
    rejected: 'Ditolak',
    completed: 'Selesai'
  }
  return labels[status] || status
}

const getStatusBadgeClass = (status: string) => {
  const classes: Record<string, string> = {
    pending: 'bg-purple-100 text-purple-800',
    approved: 'bg-yellow-100 text-yellow-800',
    rejected: 'bg-red-100 text-red-800',
    completed: 'bg-green-100 text-green-800'
  }
  return classes[status] || 'bg-gray-100 text-gray-800'
}

const getStatusColor = (status: string) => {
  const colors: Record<string, string> = {
    pending: 'text-purple-700',
    approved: 'text-yellow-700',
    rejected: 'text-red-700',
    completed: 'text-green-700'
  }
  return colors[status] || 'text-gray-700'
}

const openApproveModal = () => {
  showApproveModal.value = true
}

const closeApproveModal = () => {
  showApproveModal.value = false
}

const confirmApprove = async () => {
  if (!salesOrder.value?.id) return
  
  loading.value = true
  try {
    const response = await salesOrderService.approve(salesOrder.value.id)
    if (response.success) {
      showMessage('Sales order berhasil disetujui', false)
      closeApproveModal()
      await fetchSalesOrder()
    }
  } catch (error: any) {
    console.error('Error approving order:', error)
    showMessage(error.response?.data?.message || 'Gagal menyetujui sales order', true)
  } finally {
    loading.value = false
  }
}

const openRejectModal = () => {
  rejectReason.value = ''
  rejectReasonError.value = ''
  showRejectModal.value = true
}

const closeRejectModal = () => {
  showRejectModal.value = false
  rejectReason.value = ''
  rejectReasonError.value = ''
}

const confirmReject = async () => {
  if (!salesOrder.value?.id) return
  
  if (!rejectReason.value.trim()) {
    rejectReasonError.value = 'Alasan penolakan harus diisi'
    return
  }
  
  loading.value = true
  try {
    const response = await salesOrderService.reject(salesOrder.value.id, rejectReason.value)
    if (response.success) {
      showMessage('Sales order berhasil ditolak', false)
      closeRejectModal()
      await fetchSalesOrder()
    }
  } catch (error: any) {
    console.error('Error rejecting order:', error)
    showMessage(error.response?.data?.message || 'Gagal menolak sales order', true)
  } finally {
    loading.value = false
  }
}

const showMessage = (text: string, isError: boolean = false) => {
  message.value = { show: true, text, isError }
  setTimeout(() => {
    message.value.show = false
  }, 3000)
}

const fetchSalesOrder = async () => {
  loading.value = true
  try {
    const id = route.params.id as string
    const response = await salesOrderService.adminGetById(parseInt(id))
    if (response.success && !Array.isArray(response.data)) {
      salesOrder.value = response.data
    }
  } catch (error: any) {
    console.error('Error fetching sales order:', error)
    showMessage('Gagal memuat data sales order', true)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchSalesOrder()
})
</script>

<style scoped>
@media print {
  body > * { display: none; }
  .print-hidden { display: none !important; }
  #main-content { margin-left: 0 !important; }
  #printable-area-container {
    display: block !important;
    width: 100%;
    margin: 0;
    padding: 0;
  }
  #printable-area-content {
    box-shadow: none !important;
    border: none !important;
    font-size: 10pt;
    color: #000;
  }
  .print-no-break { page-break-inside: avoid; }
  thead { display: table-header-group; }
  tr, td, th { page-break-inside: avoid; }
}
</style>
