<template>
  <div class="flex h-screen bg-gray-100">
    <!-- Sidebar Admin -->
    <aside class="fixed top-0 left-0 h-full w-64 bg-gray-900 text-gray-300 shadow-lg z-30 transform -translate-x-full lg:translate-x-0 transition-transform duration-300 ease-in-out print-hidden" id="sidebar">
      <div class="p-6 flex items-center space-x-3">
        <svg class="h-10 w-10 text-blue-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" d="M21 7.5l-9-5.25L3 7.5m18 0l-9 5.25m9-5.25v9l-9 5.25M3 7.5l9 5.25M3 7.5v9l9 5.25m0-9v9" />
        </svg>
        <span class="text-white text-2xl font-semibold">Inventori</span>
      </div>
      
      <AdminNavigation :current-path="$route.path" />
    </aside>

    <div class="fixed inset-0 bg-black bg-opacity-50 z-20 hidden print-hidden" id="overlay"></div>
    
    <div class="flex-1 flex flex-col transition-all duration-300 ease-in-out lg:ml-64" id="main-content">
      <!-- Header -->
      <!-- Header -->
      <Header @toggle-sidebar="toggleSidebar" />

      <!-- Main Content -->
      <main class="flex-1 p-6 overflow-y-auto">
        <!-- Message Alert -->
        <div v-if="message.show" :class="message.isError ? 'bg-red-50 border-red-200 text-red-700' : 'bg-green-50 border-green-200 text-green-700'" class="mb-6 border px-4 py-3 rounded relative">
          <span class="block sm:inline">{{ message.text }}</span>
        </div>

        <div v-if="loading" class="flex justify-center items-center py-12">
          <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
        </div>

        <div v-else-if="receipt">
          <!-- Tombol Aksi Atas -->
          <div class="flex items-center justify-between mb-6 print-hidden">
            <h1 class="text-3xl font-bold text-gray-900">Detail Penerimaan Barang (Non-PO)</h1>
            <div class="flex space-x-3">
              <button @click="goBack" class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150">
                <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5L8.25 12l7.5-7.5" />
                </svg>
                <span>Kembali</span>
              </button>
              <router-link 
                :to="`/admin/non-po/receipt/${receipt.id}/print`"
                class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150"
              >
                <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M6.72 13.829c-.24.03-.48.062-.72.096m.72-.096a42.415 42.415 0 0110.56 0m-10.56 0L6.34 18m10.94-4.171c.24.03.48.062.72.096m-.72-.096L17.66 18m0 0l.229 2.523a1.125 1.125 0 01-1.12 1.227H7.23a1.125 1.125 0 01-1.12-1.227L6.34 18m11.319 0H6.34m11.319 0l.044.506A1.125 1.125 0 0117.003 20H6.997a1.125 1.125 0 01-1.122-1.494l.044-.506M6.34 18v-4.172c0-.224.03-.447.086-.665A41.4 41.4 0 0112 3c1.83 0 3.597.133 5.28.362.057.218.086.44.086.665v4.172M6.34 18L4.26 7.5h15.48L17.66 18" />
                </svg>
                <span>Cetak Bukti</span>
              </router-link>
            </div>
          </div>
          
          <!-- Layout 2 Kolom -->
          <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">

            <!-- Kolom Kiri: Dokumen -->
            <div class="lg:col-span-8">
              <div class="bg-white p-8 rounded-lg shadow-lg border border-gray-200">
                <!-- Header Dokumen -->
                <div class="flex justify-between items-start pb-6 border-b-2 border-gray-900">
                  <div>
                    <h2 class="text-3xl font-bold text-gray-900">PENERIMAAN BARANG (NON-PO)</h2>
                    <p class="text-lg font-semibold text-blue-600">{{ formatNoDokumen(receipt.id, receipt.created_at) }}</p>
                    <span :class="getStatusBadgeClass(receipt.status)" class="inline-block px-3 py-1 text-xs font-medium rounded-full mt-2">
                      {{ getStatusText(receipt.status) }}
                    </span>
                  </div>
                  <div class="text-right">
                    <img src="https://placehold.co/150x50/000000/FFFFFF?text=LOGO+PERUSAHAAN" alt="Logo Perusahaan" class="h-12 mb-2 ml-auto">
                    <p class="text-sm font-semibold text-gray-800">Nama Perusahaan Anda</p>
                    <p class="text-sm text-gray-600">Jl. Jend. Sudirman No. 1, Jakarta</p>
                    <p class="text-sm text-gray-600">Telepon: (021) 123456</p>
                  </div>
                </div>

                <!-- Info Sumber dan Tanggal -->
                <div class="grid grid-cols-2 gap-8 my-6">
                  <div>
                    <p class="text-sm font-semibold text-gray-500 uppercase mb-2">SUMBER BARANG:</p>
                    <p class="text-lg font-bold text-gray-900">{{ receipt.source }}</p>
                    <p v-if="receipt.notes" class="text-sm text-gray-600 mt-2">{{ receipt.notes }}</p>
                  </div>
                  <div class="text-right">
                    <div class="mb-2">
                      <span class="text-sm font-semibold text-gray-500 uppercase">Tanggal Diterima: </span>
                      <span class="text-sm font-medium text-gray-800">{{ formatDate(receipt.receive_date) }}</span>
                    </div>
                    <div>
                      <span class="text-sm font-semibold text-gray-500 uppercase">Status: </span>
                      <span :class="getStatusColor(receipt.status)" class="text-sm font-medium">{{ getStatusText(receipt.status) }}</span>
                    </div>
                  </div>
                </div>

                <!-- Tabel Item -->
                <div class="overflow-x-auto mb-8">
                  <table class="w-full min-w-max">
                    <thead class="border-b border-gray-300">
                      <tr>
                        <th class="px-4 py-3 text-left text-sm font-medium text-gray-600 uppercase">Nama Barang</th>
                        <th class="px-4 py-3 text-center text-sm font-medium text-gray-600 uppercase">Jumlah</th>
                        <th class="px-4 py-3 text-right text-sm font-medium text-gray-600 uppercase">Harga Satuan (Est.)</th>
                        <th class="px-4 py-3 text-right text-sm font-medium text-gray-600 uppercase">Subtotal</th>
                      </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-200">
                      <tr v-for="(item, index) in receipt.items" :key="index">
                        <td class="px-4 py-4 text-sm font-medium text-gray-900">{{ item.barang?.nama || '-' }}</td>
                        <td class="px-4 py-4 text-sm text-gray-800 text-center">{{ item.qty }}</td>
                        <td class="px-4 py-4 text-sm text-gray-800 text-right">{{ formatCurrency(item.price || 0) }}</td>
                        <td class="px-4 py-4 text-sm font-medium text-gray-900 text-right">{{ formatCurrency(item.subtotal || 0) }}</td>
                      </tr>
                    </tbody>
                    <!-- Footer Total -->
                    <tfoot class="border-t-2 border-gray-300">
                      <tr class="bg-gray-50">
                        <td colspan="3" class="px-4 py-3 text-right text-base font-bold text-gray-900 uppercase">Grand Total</td>
                        <td class="px-4 py-3 text-right text-base font-bold text-gray-900">{{ formatCurrency(receipt.total_value || 0) }}</td>
                      </tr>
                    </tfoot>
                  </table>
                </div>

                <!-- Tanda Tangan -->
                <div class="grid grid-cols-3 gap-8 pt-6 border-t border-gray-200">
                  <div class="text-center">
                    <p class="text-sm text-gray-700 mb-16">Diterima oleh,</p>
                    <p class="text-sm font-medium text-gray-900 border-t border-gray-400 pt-1">({{ receipt.creator?.name || 'Staff' }})</p>
                    <p class="text-xs text-gray-500">Staff Inventori</p>
                  </div>
                  <div class="text-center">
                    <p class="text-sm text-gray-700 mb-16">Disetujui oleh,</p>
                    <p class="text-sm font-medium text-gray-900 border-t border-gray-400 pt-1">({{ receipt.approver?.name || 'Admin' }})</p>
                    <p class="text-xs text-gray-500">Admin</p>
                  </div>
                  <div class="text-center">
                    <p class="text-sm text-gray-700 mb-16">Sumber,</p>
                    <p class="text-sm font-medium text-gray-400 border-t border-dashed border-gray-300 pt-1"></p>
                    <p class="text-xs text-gray-700">{{ receipt.source || '-' }}</p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Kolom Kanan: Info & Approval -->
            <div class="lg:col-span-4 space-y-6 print-hidden">
              
              <!-- Status Penerimaan -->
              <div class="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
                <h3 class="text-lg font-semibold text-gray-900 mb-4">Status Penerimaan</h3>
                <span :class="getStatusBadgeClass(receipt.status)" class="px-4 py-1.5 inline-flex text-base font-medium rounded-full">
                  {{ getStatusText(receipt.status) }}
                </span>
                <p class="text-sm text-gray-500 mt-2">
                  Dicatat oleh {{ receipt.creator?.name || '-' }} pada {{ formatDate(receipt.created_at) }}.
                </p>

                <!-- Tombol Aksi Admin -->
                <div v-if="receipt.status === 'pending'" class="mt-6 flex space-x-3">
                  <button @click="openApproveModal" class="w-full flex-1 bg-green-600 hover:bg-green-700 text-white font-medium py-2 px-4 rounded-lg transition duration-150">
                    Setujui
                  </button>
                  <button @click="openRejectModal" class="w-full flex-1 bg-red-600 hover:bg-red-700 text-white font-medium py-2 px-4 rounded-lg transition duration-150">
                    Tolak
                  </button>
                </div>

                <!-- Tombol Terima Barang untuk status approved -->
                <div v-if="receipt.status === 'approved'" class="mt-6">
                  <router-link 
                    :to="`/admin/non-po/receipt/${receipt.id}/receive`" 
                    class="w-full bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg transition duration-150 flex items-center justify-center space-x-2"
                  >
                    <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                    </svg>
                    <span>Terima Barang</span>
                  </router-link>
                  <p class="text-xs text-gray-500 mt-2 text-center">Klik untuk mengisi No. Surat Jalan</p>
                </div>

                <!-- Info penerimaan completed -->
                <div v-if="receipt.status === 'completed' && receipt.no_surat_jalan" class="mt-6 p-4 bg-green-50 border border-green-200 rounded-lg">
                  <p class="text-sm font-medium text-green-900">Barang Sudah Diterima</p>
                  <p class="text-xs text-green-700 mt-1">No. Surat Jalan: {{ receipt.no_surat_jalan }}</p>
                  <p v-if="receipt.received_at" class="text-xs text-green-700">Diterima: {{ formatDate(receipt.received_at) }}</p>
                </div>

                <!-- Info penerimaan ditolak -->
                <div v-if="receipt.status === 'rejected'" class="mt-6 p-4 bg-red-50 border border-red-200 rounded-lg">
                  <p class="text-sm font-medium text-red-900">Penerimaan Ditolak</p>
                  <p class="text-xs text-red-700 mt-1">Alasan: {{ receipt.reject_reason || '-' }}</p>
                </div>
              </div>

              <!-- Riwayat Status -->
              <div class="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
                <h3 class="text-lg font-semibold text-gray-900 mb-4">Riwayat</h3>
                <ol class="relative border-l border-gray-200">
                  <li class="ml-4 mb-4">
                    <div class="absolute w-3 h-3 bg-blue-600 rounded-full mt-1.5 -left-1.5 border border-white"></div>
                    <time class="mb-1 text-sm font-normal leading-none text-gray-500">{{ formatDate(receipt.created_at) }}</time>
                    <h3 class="text-base font-semibold text-gray-900">Penerimaan dibuat</h3>
                    <p class="text-sm font-normal text-gray-500">Oleh {{ receipt.creator?.name || 'Staff' }}</p>
                  </li>
                  <li v-if="receipt.approved_at && receipt.status === 'approved'" class="ml-4 mb-4">
                    <div class="absolute w-3 h-3 bg-yellow-600 rounded-full mt-1.5 -left-1.5 border border-white"></div>
                    <time class="mb-1 text-sm font-normal leading-none text-gray-500">{{ formatDate(receipt.approved_at) }}</time>
                    <h3 class="text-base font-semibold text-gray-900">Penerimaan disetujui</h3>
                    <p class="text-sm font-normal text-gray-500">Oleh {{ receipt.approver?.name || 'Admin' }}</p>
                  </li>
                  <li v-if="receipt.received_at && receipt.status === 'completed'" class="ml-4 mb-4">
                    <div class="absolute w-3 h-3 bg-green-600 rounded-full mt-1.5 -left-1.5 border border-white"></div>
                    <time class="mb-1 text-sm font-normal leading-none text-gray-500">{{ formatDate(receipt.received_at) }}</time>
                    <h3 class="text-base font-semibold text-gray-900">Barang diterima</h3>
                    <p class="text-sm font-normal text-gray-500">Oleh {{ receipt.receiver?.name || 'Admin' }}</p>
                  </li>
                  <li v-if="receipt.approved_at && receipt.status === 'rejected'" class="ml-4">
                    <div class="absolute w-3 h-3 bg-red-600 rounded-full mt-1.5 -left-1.5 border border-white"></div>
                    <time class="mb-1 text-sm font-normal leading-none text-gray-500">{{ formatDate(receipt.approved_at) }}</time>
                    <h3 class="text-base font-semibold text-gray-900">Penerimaan ditolak</h3>
                    <p class="text-sm font-normal text-gray-500">{{ receipt.reject_reason || '-' }}</p>
                  </li>
                </ol>
              </div>

              <!-- Informasi Penerimaan -->
              <div class="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
                <h3 class="text-lg font-semibold text-gray-900 mb-4">Informasi Penerimaan</h3>
                <dl>
                  <dt class="text-sm font-medium text-gray-500">No. Dokumen</dt>
                  <dd class="text-base text-gray-900 font-medium mb-2">{{ formatNoDokumen(receipt.id, receipt.created_at) }}</dd>
                  <dt class="text-sm font-medium text-gray-500">Sumber</dt>
                  <dd class="text-base text-gray-900 font-medium mb-2">{{ receipt.source }}</dd>
                  <dt class="text-sm font-medium text-gray-500">Total Nilai</dt>
                  <dd class="text-base text-gray-900 font-medium">{{ formatCurrency(receipt.total_value || 0) }}</dd>
                </dl>
              </div>
              
            </div>
          </div>
        </div>

        <div v-else class="text-center py-8">
          <p class="text-gray-600">Data tidak ditemukan</p>
        </div>

        <!-- Footer -->
        <Footer />
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
          <h3 class="text-lg font-medium leading-6 text-gray-900">Setujui Penerimaan Non-PO</h3>
        </div>
        <div class="p-6">
          <p class="text-sm text-gray-600">
            Apakah Anda yakin ingin menyetujui penerimaan <strong>{{ receipt ? formatNoDokumen(receipt.id, receipt.created_at) : '-' }}</strong>?
          </p>
          <p class="text-sm text-gray-600 mt-2">
            Stok barang akan ditambahkan setelah disetujui.
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
          <h3 class="text-lg font-medium leading-6 text-gray-900">Tolak Penerimaan Non-PO</h3>
        </div>
        <div class="p-6">
          <p class="text-sm text-gray-600 mb-4">
            Anda akan menolak penerimaan <strong>{{ receipt ? formatNoDokumen(receipt.id, receipt.created_at) : '-' }}</strong>.
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
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import AdminNavigation from '@/components/AdminNavigation.vue'
import Header from '@/components/Header.vue'
import Footer from '@/components/Footer.vue'
import api from '@/services/api'

const router = useRouter()
const route = useRoute()

interface ReceiptItem {
  barang_id: number
  barang?: {
    nama: string
    kode: string
  }
  qty: number
  price?: number
  subtotal?: number
}

interface Receipt {
  id: number
  no_dokumen: string
  source: string
  receive_date: string
  notes: string | null
  total_value?: number
  status: string
  creator: {
    name: string
  } | null
  approver?: {
    name: string
  } | null
  receiver?: {
    name: string
  } | null
  approved_at?: string
  received_at?: string
  no_surat_jalan?: string
  reject_reason?: string
  created_at: string
  items: ReceiptItem[]
}

const loading = ref(false)
const receipt = ref<Receipt | null>(null)
const showApproveModal = ref(false)
const showRejectModal = ref(false)
const rejectReason = ref('')
const rejectReasonError = ref('')
const message = ref({ show: false, text: '', isError: false })

const toggleSidebar = () => {
  const sidebar = document.getElementById('sidebar')
  const overlay = document.getElementById('overlay')
  if (sidebar && overlay) {
    sidebar.classList.toggle('-translate-x-full')
    overlay.classList.toggle('hidden')
  }
}

const goBack = () => {
  router.push('/admin/received-items')
}

const formatDate = (date: string) => {
  if (!date) return '-'
  return new Date(date).toLocaleDateString('id-ID', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  })
}

const formatCurrency = (value: number) => {
  return new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    minimumFractionDigits: 0
  }).format(value || 0)
}

// Format No. Dokumen menjadi PO-NON-YYYYMMDD-0001
const formatNoDokumen = (id: number, createdAt: string) => {
  if (!createdAt) return '-'
  const date = new Date(createdAt)
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  const sequence = String(id).padStart(4, '0')
  return `PO-NON-${year}${month}${day}-${sequence}`
}

const getStatusText = (status: string) => {
  const statusMap: Record<string, string> = {
    pending: 'Menunggu Persetujuan',
    approved: 'Disetujui',
    completed: 'Selesai',
    rejected: 'Ditolak'
  }
  return statusMap[status] || status
}

const getStatusBadgeClass = (status: string) => {
  const classes: Record<string, string> = {
    pending: 'bg-yellow-100 text-yellow-800',
    approved: 'bg-blue-100 text-blue-800',
    completed: 'bg-green-100 text-green-800',
    rejected: 'bg-red-100 text-red-800'
  }
  return classes[status] || 'bg-gray-100 text-gray-800'
}

const getStatusColor = (status: string) => {
  const colors: Record<string, string> = {
    pending: 'text-yellow-600',
    approved: 'text-blue-600',
    completed: 'text-green-600',
    rejected: 'text-red-600'
  }
  return colors[status] || 'text-gray-600'
}

const openApproveModal = () => {
  showApproveModal.value = true
}

const closeApproveModal = () => {
  showApproveModal.value = false
}

const confirmApprove = async () => {
  if (!receipt.value?.id) return
  
  loading.value = true
  try {
    const response = await api.post(`/admin/non-po/receipt/${receipt.value.id}/approve`)
    if (response.data.success) {
      showMessage('Penerimaan berhasil disetujui', false)
      closeApproveModal()
      await fetchReceipt()
    }
  } catch (error: any) {
    console.error('Error approving receipt:', error)
    showMessage(error.response?.data?.message || 'Gagal menyetujui penerimaan', true)
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
  if (!receipt.value?.id) return
  
  if (!rejectReason.value.trim()) {
    rejectReasonError.value = 'Alasan penolakan harus diisi'
    return
  }
  
  loading.value = true
  try {
    const response = await api.post(`/admin/non-po/receipt/${receipt.value.id}/reject`, {
      reason: rejectReason.value
    })
    if (response.data.success) {
      showMessage('Penerimaan berhasil ditolak', false)
      closeRejectModal()
      await fetchReceipt()
    }
  } catch (error: any) {
    console.error('Error rejecting receipt:', error)
    showMessage(error.response?.data?.message || 'Gagal menolak penerimaan', true)
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

const fetchReceipt = async () => {
  loading.value = true
  try {
    const id = route.params.id as string
    const response = await api.get(`/admin/non-po/receipt/${id}`)
    
    if (response.data && response.data.success && response.data.data) {
      const data = response.data.data
      
      // Ensure items is an array
      if (!data.items) {
        data.items = []
      } else if (typeof data.items === 'object' && !Array.isArray(data.items)) {
        data.items = Object.values(data.items)
      }
      
      receipt.value = data
    }
  } catch (error: any) {
    console.error('Error fetching receipt:', error)
    showMessage('Gagal memuat data penerimaan', true)
    setTimeout(() => router.push('/admin/received-items'), 2000)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchReceipt()
})
</script>

<style scoped>
@media print {
  .print-hidden {
    display: none !important;
  }
}
</style>
