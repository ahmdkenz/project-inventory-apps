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
                    <p class="text-lg font-semibold text-blue-600">{{ receipt.no_dokumen }}</p>
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
                    <p v-if="receipt.notes" class="text-sm text-gray-600">{{ receipt.notes }}</p>
                  </div>
                  <div class="text-right">
                    <div class="mb-2">
                      <span class="text-sm font-semibold text-gray-500 uppercase">Tanggal Diterima: </span>
                      <span class="text-sm font-medium text-gray-800">{{ formatDate(receipt.receive_date) }}</span>
                    </div>
                    <div>
                      <span class="text-sm font-semibold text-gray-500 uppercase">Dicatat Oleh: </span>
                      <span class="text-sm font-medium text-gray-800">{{ receipt.creator?.name || '-' }}</span>
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
                        <th class="px-6 py-3 text-center text-xs font-bold uppercase tracking-wider">Jumlah</th>
                        <th class="px-6 py-3 text-right text-xs font-bold uppercase tracking-wider">Harga Satuan (Est.)</th>
                        <th class="px-6 py-3 text-right text-xs font-bold uppercase tracking-wider">Subtotal</th>
                      </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-200">
                      <tr v-for="(item, index) in receipt.items" :key="index">
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{{ index + 1 }}.</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ item.barang?.nama || '-' }}</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600 text-center">{{ item.qty }}</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600 text-right">{{ formatCurrency(item.price || 0) }}</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900 text-right">{{ formatCurrency(item.subtotal || 0) }}</td>
                      </tr>
                    </tbody>
                    <!-- Footer Total -->
                    <tfoot class="bg-gray-50 font-medium">
                      <tr>
                        <td colspan="3" class="px-6 py-3 align-top">
                          <p class="text-xs text-gray-500 uppercase font-semibold">Catatan:</p>
                          <p class="text-sm text-gray-600">{{ receipt.notes || '-' }}</p>
                        </td>
                        <td class="px-6 py-4 text-right text-base text-gray-900 uppercase font-semibold">Total Nilai</td>
                        <td class="px-6 py-4 text-right text-base text-gray-900 font-semibold">{{ formatCurrency(receipt.total_value || 0) }}</td>
                      </tr>
                    </tfoot>
                  </table>
                </div>

                <!-- Tanda Tangan -->
                <div class="grid grid-cols-2 gap-8 pt-6 border-t border-gray-200">
                  <div>
                    <p class="text-sm text-gray-700 mb-16">Diterima oleh,</p>
                    <p class="text-sm font-medium text-gray-900 border-t border-gray-400 pt-1">({{ receipt.creator?.name || 'Staff' }})</p>
                    <p class="text-xs text-gray-500">Staff Inventori</p>
                  </div>
                  <div class="text-center">
                    <p class="text-sm text-gray-700 mb-16">Disetujui oleh,</p>
                    <p class="text-sm font-medium text-gray-900 border-t border-gray-400 pt-1">({{ receipt.approver?.name || 'Admin' }})</p>
                    <p class="text-xs text-gray-500">Admin</p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Kolom Kanan: Info & Approval -->
            <div class="lg:col-span-4 space-y-6 print-hidden">
              
              <!-- Info Penerimaan -->
              <div class="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
                <h3 class="text-lg font-semibold text-gray-900 mb-4">Informasi Penerimaan</h3>
                <div class="space-y-3">
                  <div>
                    <dt class="text-sm font-medium text-gray-500">No. Dokumen</dt>
                    <dd class="text-base text-gray-900 font-medium">{{ receipt.no_dokumen }}</dd>
                  </div>
                  <div>
                    <dt class="text-sm font-medium text-gray-500">Status</dt>
                    <dd>
                      <span :class="getStatusBadgeClass(receipt.status)" class="inline-block px-3 py-1 text-xs font-medium rounded-full">
                        {{ getStatusText(receipt.status) }}
                      </span>
                    </dd>
                  </div>
                  <div>
                    <dt class="text-sm font-medium text-gray-500">Tanggal</dt>
                    <dd class="text-base text-gray-900 font-medium">{{ formatDate(receipt.receive_date) }}</dd>
                  </div>
                  <div>
                    <dt class="text-sm font-medium text-gray-500">Dicatat Oleh</dt>
                    <dd class="text-base text-gray-900 font-medium">{{ receipt.creator?.name || '-' }}</dd>
                  </div>
                </div>
              </div>

              <!-- Tombol Approval (hanya muncul jika status pending) -->
              <div class="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
                <h3 class="text-lg font-semibold text-gray-900 mb-4">Aksi Admin</h3>
                <div v-if="receipt.status === 'pending'" class="space-y-3">
                  <button @click="openApproveModal" class="w-full bg-green-600 hover:bg-green-700 text-white font-medium py-2 px-4 rounded-lg transition duration-150">
                    ✓ Setujui Penerimaan
                  </button>
                  <button @click="openRejectModal" class="w-full bg-red-600 hover:bg-red-700 text-white font-medium py-2 px-4 rounded-lg transition duration-150">
                    ✕ Tolak Penerimaan
                  </button>
                </div>
                <div v-else-if="receipt.status === 'approved'" class="space-y-3">
                  <div class="text-center py-4">
                    <svg class="mx-auto h-12 w-12 text-green-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                    <p class="mt-2 text-sm text-gray-600">Penerimaan sudah disetujui</p>
                    <p class="text-xs text-gray-500">{{ receipt.approved_at ? formatDate(receipt.approved_at) : '-' }}</p>
                  </div>
                  <router-link 
                    :to="`/admin/non-po/receipt/${receipt.id}/receive`" 
                    class="w-full bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg transition duration-150 flex items-center justify-center space-x-2"
                  >
                    <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                    </svg>
                    <span>Terima Barang</span>
                  </router-link>
                </div>
                <div v-else-if="receipt.status === 'completed'" class="text-center py-4">
                  <svg class="mx-auto h-12 w-12 text-green-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                  <p class="mt-2 text-sm font-medium text-gray-900">Barang Sudah Diterima</p>
                  <p class="text-xs text-gray-500">{{ receipt.received_at ? formatDate(receipt.received_at) : '-' }}</p>
                  <div v-if="receipt.no_surat_jalan" class="mt-3 text-sm text-gray-600">
                    <p class="font-medium">No. Surat Jalan:</p>
                    <p class="text-gray-900">{{ receipt.no_surat_jalan }}</p>
                  </div>
                </div>
                <div v-else-if="receipt.status === 'rejected'" class="text-center py-4">
                  <svg class="mx-auto h-12 w-12 text-red-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                  <p class="mt-2 text-sm text-gray-600">Penerimaan ditolak</p>
                  <p class="text-xs text-gray-500">Alasan: {{ receipt.reject_reason || '-' }}</p>
                </div>
              </div>

              <!-- Timeline / History -->
              <div class="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
                <h3 class="text-lg font-semibold text-gray-900 mb-4">Riwayat</h3>
                <ol class="relative border-l border-gray-300">
                  <li class="ml-4 mb-4">
                    <div class="absolute w-3 h-3 bg-blue-500 rounded-full -left-1.5 border border-white"></div>
                    <time class="mb-1 text-sm font-normal leading-none text-gray-500">{{ formatDate(receipt.created_at) }}</time>
                    <p class="text-sm font-medium text-gray-900">Penerimaan dibuat</p>
                    <p class="text-sm text-gray-600">Oleh {{ receipt.creator?.name || 'Staff' }}</p>
                  </li>
                  <li v-if="receipt.approved_at && receipt.status === 'completed'" class="ml-4">
                    <div class="absolute w-3 h-3 bg-green-500 rounded-full -left-1.5 border border-white"></div>
                    <time class="mb-1 text-sm font-normal leading-none text-gray-500">{{ formatDate(receipt.approved_at) }}</time>
                    <p class="text-sm font-medium text-gray-900">Penerimaan disetujui</p>
                    <p class="text-sm text-gray-600">Oleh {{ receipt.approver?.name || 'Admin' }}</p>
                  </li>
                  <li v-if="receipt.approved_at && receipt.status === 'rejected'" class="ml-4">
                    <div class="absolute w-3 h-3 bg-red-500 rounded-full -left-1.5 border border-white"></div>
                    <time class="mb-1 text-sm font-normal leading-none text-gray-500">{{ formatDate(receipt.approved_at) }}</time>
                    <p class="text-sm font-medium text-gray-900">Penerimaan ditolak</p>
                    <p class="text-sm text-gray-600">Alasan: {{ receipt.reject_reason || '-' }}</p>
                  </li>
                </ol>
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
          <h3 class="text-lg font-medium leading-6 text-gray-900">Setujui Penerimaan Non-PO</h3>
        </div>
        <div class="p-6">
          <p class="text-sm text-gray-600">
            Apakah Anda yakin ingin menyetujui penerimaan <strong>{{ receipt?.no_dokumen }}</strong>?
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
            Anda akan menolak penerimaan <strong>{{ receipt?.no_dokumen }}</strong>.
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

const getStatusText = (status: string) => {
  const statusMap: Record<string, string> = {
    pending: 'Menunggu Persetujuan',
    completed: 'Disetujui',
    rejected: 'Ditolak'
  }
  return statusMap[status] || status
}

const getStatusBadgeClass = (status: string) => {
  const classes: Record<string, string> = {
    pending: 'bg-yellow-100 text-yellow-800',
    completed: 'bg-green-100 text-green-800',
    rejected: 'bg-red-100 text-red-800'
  }
  return classes[status] || 'bg-gray-100 text-gray-800'
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
