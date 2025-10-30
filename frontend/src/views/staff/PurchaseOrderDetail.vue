<template>
  <div class="flex h-screen bg-gray-100">
    <!-- Sidebar Staff -->
    <aside class="fixed top-0 left-0 h-full w-64 bg-gray-900 text-gray-300 shadow-lg z-30 transform -translate-x-full lg:translate-x-0 transition-transform duration-300 ease-in-out print-hidden" id="sidebar">
      <div class="p-6 flex items-center space-x-3">
        <svg class="h-10 w-10 text-blue-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" d="M21 7.5l-9-5.25L3 7.5m18 0l-9 5.25m9-5.25v9l-9 5.25M3 7.5l9 5.25M3 7.5v9l9 5.25m0-9v9" />
        </svg>
        <span class="text-white text-2xl font-semibold">Inventori</span>
      </div>
      
      <StaffNavigation :current-path="$route.path" />
    </aside>

    <div class="fixed inset-0 bg-black bg-opacity-50 z-20 hidden print-hidden" id="overlay"></div>
    
    <div class="flex-1 flex flex-col transition-all duration-300 ease-in-out lg:ml-64" id="main-content">
      <header class="bg-white shadow-sm p-4 flex items-center justify-between z-10 print-hidden">
        <button id="hamburger-btn" class="text-gray-600 lg:hidden" @click="toggleSidebar">
          <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5" />
          </svg>
        </button>
        <div class="relative hidden sm:block"></div>
        <div class="flex items-center space-x-4">
          <!-- Profile placeholder -->
        </div>
      </header>

      <main class="flex-1 p-6 overflow-y-auto">
        <div v-if="loading" class="flex justify-center items-center py-12">
          <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
        </div>

        <div v-else-if="purchaseOrder">
          <!-- Tombol Aksi Atas -->
          <div class="flex items-center justify-between mb-6 print-hidden">
            <h1 class="text-3xl font-bold text-gray-900">Detail Purchase Order</h1>
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
                <span>Cetak PO</span>
              </button>
            </div>
          </div>
          
          <!-- Layout 2 Kolom -->
          <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">

            <!-- Kolom Kiri: Dokumen PO (Area Cetak) -->
            <div class="lg:col-span-8" id="printable-area-container">
              <div class="bg-white p-8 rounded-lg shadow-lg border border-gray-200" id="printable-area-content">
                <!-- Header Dokumen -->
                <div class="flex justify-between items-start pb-6 border-b-2 border-gray-900">
                  <div>
                    <h2 class="text-3xl font-bold text-gray-900">PURCHASE ORDER</h2>
                    <p class="text-lg font-semibold text-blue-600">{{ purchaseOrder.no_po }}</p>
                  </div>
                  <div class="text-right">
                    <img src="https://placehold.co/150x50/000000/FFFFFF?text=LOGO+PERUSAHAAN" alt="Logo Perusahaan" class="h-12 mb-2 ml-auto">
                    <p class="text-sm font-semibold text-gray-800">Nama Perusahaan Anda</p>
                    <p class="text-sm text-gray-600">Jl. Jend. Sudirman No. 1, Jakarta</p>
                    <p class="text-sm text-gray-600">Telepon: (021) 123456</p>
                  </div>
                </div>

                <!-- Info Supplier dan Tanggal -->
                <div class="grid grid-cols-2 gap-8 my-6">
                  <div>
                    <p class="text-sm font-semibold text-gray-500 uppercase mb-2">KEPADA YTH:</p>
                    <p class="text-lg font-bold text-gray-900">{{ purchaseOrder.supplier?.nama || 'PT. Supplier Jaya' }}</p>
                    <p class="text-sm text-gray-600">{{ purchaseOrder.supplier?.alamat || 'Jl. Industri Raya No. 12' }}</p>
                    <p class="text-sm text-gray-600">UP: {{ purchaseOrder.supplier?.kontak_person || 'Bpk. Hermawan' }} ({{ purchaseOrder.supplier?.no_telp || '0812xxxxxx' }})</p>
                  </div>
                  <div class="text-right">
                    <div class="mb-2">
                      <span class="text-sm font-semibold text-gray-500 uppercase">Tanggal PO: </span>
                      <span class="text-sm font-medium text-gray-800">{{ formatDate(purchaseOrder.tgl_pesan) }}</span>
                    </div>
                    <div>
                      <span class="text-sm font-semibold text-gray-500 uppercase">Status: </span>
                      <span :class="getStatusColor(purchaseOrder.status)" class="text-sm font-medium">{{ getStatusLabel(purchaseOrder.status) }}</span>
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
                        <th class="px-6 py-3 text-right text-xs font-bold uppercase tracking-wider">Harga Satuan</th>
                        <th class="px-6 py-3 text-right text-xs font-bold uppercase tracking-wider">Subtotal</th>
                      </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-200">
                      <tr v-for="(item, index) in purchaseOrder.items" :key="item.id">
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{{ index + 1 }}.</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ item.barang?.nama || '-' }}</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600 text-center">{{ item.qty }}</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600 text-right">{{ formatCurrency(item.harga_satuan) }}</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900 text-right">{{ formatCurrency(item.subtotal) }}</td>
                      </tr>
                    </tbody>
                    <!-- Footer Total -->
                    <tfoot class="bg-gray-50 font-medium print-no-break">
                      <tr>
                        <td colspan="3" rowspan="3" class="px-6 py-3 align-top">
                          <p class="text-xs text-gray-500 uppercase font-semibold">Catatan:</p>
                          <p class="text-sm text-gray-600">{{ purchaseOrder.catatan || 'Harap sertakan No. PO pada faktur. Pembayaran 30 hari.' }}</p>
                        </td>
                        <td class="px-6 py-3 text-right text-sm text-gray-700 uppercase">Subtotal</td>
                        <td class="px-6 py-3 text-right text-sm text-gray-900">{{ formatCurrency(purchaseOrder.subtotal) }}</td>
                      </tr>
                      <tr>
                        <td class="px-6 py-3 text-right text-sm text-gray-700 uppercase">PPN ({{ ppnPercent }}%)</td>
                        <td class="px-6 py-3 text-right text-sm text-gray-900">{{ formatCurrency(purchaseOrder.ppn) }}</td>
                      </tr>
                      <tr class="text-base font-semibold">
                        <td class="px-6 py-4 text-right text-gray-900 uppercase">Total</td>
                        <td class="px-6 py-4 text-right text-gray-900">{{ formatCurrency(purchaseOrder.total) }}</td>
                      </tr>
                    </tfoot>
                  </table>
                </div>

                <!-- Tanda Tangan -->
                <div class="grid grid-cols-2 gap-8 pt-6 border-t border-gray-200 print-no-break">
                  <div>
                    <p class="text-sm text-gray-700 mb-16">Diajukan oleh,</p>
                    <p class="text-sm font-medium text-gray-900 border-t border-gray-400 pt-1">({{ purchaseOrder.creator?.name || 'Nama Staff' }})</p>
                    <p class="text-xs text-gray-500">Staff Purchasing</p>
                  </div>
                  <div class="text-center">
                    <p class="text-sm text-gray-700 mb-16">Disetujui oleh,</p>
                    <p v-if="purchaseOrder.status === 'pending'" class="text-sm font-medium text-gray-900 border-t border-dashed border-gray-400 pt-1">(Menunggu Persetujuan)</p>
                    <p v-else-if="purchaseOrder.approver" class="text-sm font-medium text-gray-900 border-t border-gray-400 pt-1">({{ purchaseOrder.approver?.name || 'Admin' }})</p>
                    <p v-else class="text-sm font-medium text-gray-900 border-t border-dashed border-gray-400 pt-1">(...........................)</p>
                    <p class="text-xs text-gray-500">Manajer</p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Kolom Kanan: Info & Riwayat (Non-Cetak) -->
            <div class="lg:col-span-4 space-y-6 print-hidden">
              
              <!-- Status PO (Tanpa Tombol untuk Staff) -->
              <div class="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
                <h3 class="text-lg font-semibold text-gray-900 mb-4">Status PO</h3>
                <span :class="getStatusBadgeClass(purchaseOrder.status)" class="px-4 py-1.5 inline-flex text-base font-medium rounded-full">
                  {{ getStatusLabel(purchaseOrder.status) }}
                </span>
                <p class="text-sm text-gray-500 mt-2">
                  Diajukan oleh Anda pada {{ formatDate(purchaseOrder.tgl_pesan) }}.
                </p>
              </div>

              <!-- Riwayat Status -->
              <div class="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
                <h3 class="text-lg font-semibold text-gray-900 mb-4">Riwayat Status</h3>
                <ol class="relative border-l border-gray-200">
                  <!-- Status: Dibuat -->
                  <li class="mb-6 ml-4">
                    <div class="absolute w-3 h-3 bg-blue-600 rounded-full mt-1.5 -left-1.5 border border-white"></div>
                    <time class="mb-1 text-sm font-normal leading-none text-gray-500">{{ formatDate(purchaseOrder.created_at) }}</time>
                    <h3 class="text-base font-semibold text-gray-900">Dibuat & Diajukan</h3>
                    <p class="text-sm font-normal text-gray-500">PO dibuat oleh Anda dan menunggu persetujuan Admin.</p>
                  </li>
                  
                  <!-- Status: Disetujui -->
                  <li v-if="purchaseOrder.status === 'approved' || purchaseOrder.status === 'completed'" class="mb-6 ml-4">
                    <div class="absolute w-3 h-3 bg-green-600 rounded-full mt-1.5 -left-1.5 border border-white"></div>
                    <time v-if="purchaseOrder.approved_at" class="mb-1 text-sm font-normal leading-none text-gray-500">{{ formatDate(purchaseOrder.approved_at) }}</time>
                    <h3 class="text-base font-semibold text-gray-900">Disetujui</h3>
                    <p class="text-sm font-normal text-gray-500">PO disetujui oleh {{ purchaseOrder.approver?.name || 'Admin' }}.</p>
                  </li>
                  
                  <!-- Status: Ditolak -->
                  <li v-if="purchaseOrder.status === 'rejected'" class="mb-6 ml-4">
                    <div class="absolute w-3 h-3 bg-red-600 rounded-full mt-1.5 -left-1.5 border border-white"></div>
                    <time v-if="purchaseOrder.approved_at" class="mb-1 text-sm font-normal leading-none text-gray-500">{{ formatDate(purchaseOrder.approved_at) }}</time>
                    <h3 class="text-base font-semibold text-gray-900">Ditolak oleh Admin</h3>
                    <p v-if="purchaseOrder.reject_reason" class="text-sm font-normal text-gray-500">Alasan: {{ purchaseOrder.reject_reason }}</p>
                  </li>
                  
                  <!-- Status: Selesai -->
                  <li v-if="purchaseOrder.status === 'completed'" class="ml-4">
                    <div class="absolute w-3 h-3 bg-blue-600 rounded-full mt-1.5 -left-1.5 border border-white"></div>
                    <time class="mb-1 text-sm font-normal leading-none text-gray-500">{{ formatDate(purchaseOrder.updated_at) }}</time>
                    <h3 class="text-base font-semibold text-gray-900">Selesai</h3>
                    <p class="text-sm font-normal text-gray-500">PO telah selesai diproses.</p>
                  </li>
                </ol>
              </div>

              <!-- Informasi Supplier -->
              <div class="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
                <h3 class="text-lg font-semibold text-gray-900 mb-4">Info Supplier</h3>
                <dl>
                  <dt class="text-sm font-medium text-gray-500">Nama</dt>
                  <dd class="text-base text-gray-900 font-medium mb-2">{{ purchaseOrder.supplier?.nama || 'PT. Supplier Jaya' }}</dd>
                  <dt class="text-sm font-medium text-gray-500">Kontak</dt>
                  <dd class="text-base text-gray-900 font-medium mb-2">{{ purchaseOrder.supplier?.kontak_person || 'Bpk. Hermawan' }}</dd>
                  <dt class="text-sm font-medium text-gray-500">Telepon</dt>
                  <dd class="text-base text-gray-900 font-medium">{{ purchaseOrder.supplier?.no_telp || '0812-xxxx-xxxx' }}</dd>
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
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import StaffNavigation from '@/components/StaffNavigation.vue'
import purchaseOrderService from '@/services/purchaseOrder.service'

const router = useRouter()
const route = useRoute()

const loading = ref(false)
const purchaseOrder = ref<any>(null)

const ppnPercent = computed(() => {
  if (!purchaseOrder.value || !purchaseOrder.value.subtotal || purchaseOrder.value.subtotal === 0) return 0
  return Math.round((purchaseOrder.value.ppn / purchaseOrder.value.subtotal) * 100)
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
  router.push('/staff/purchase-orders')
}

const printDocument = () => {
  window.print()
}

const formatCurrency = (value: number) => {
  return new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    minimumFractionDigits: 0
  }).format(value || 0)
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
  const labels: any = {
    'pending': 'Menunggu Persetujuan',
    'approved': 'Disetujui (Pending)',
    'rejected': 'Ditolak',
    'completed': 'Selesai'
  }
  return labels[status] || status
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

const getStatusColor = (status: string) => {
  const colors: any = {
    'pending': 'text-purple-700',
    'approved': 'text-yellow-700',
    'rejected': 'text-red-700',
    'completed': 'text-green-700'
  }
  return colors[status] || 'text-gray-700'
}

const fetchPurchaseOrder = async () => {
  loading.value = true
  try {
    const id = route.params.id as string
    const response = await purchaseOrderService.getById(parseInt(id))
    if (response.success && !Array.isArray(response.data)) {
      purchaseOrder.value = response.data
    }
  } catch (error: any) {
    console.error('Error fetching purchase order:', error)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchPurchaseOrder()
})
</script>

<style scoped>
@media print {
  body > * {
    display: none;
  }
  
  /* Sembunyikan elemen yang tidak perlu dicetak */
  .print-hidden {
    display: none !important;
  }
  
  #main-content {
    margin-left: 0 !important;
  }
  
  /* Pastikan area cetak ditampilkan */
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
  
  .print-no-break {
    page-break-inside: avoid;
  }
  
  /* Hindari tabel terpotong */
  thead {
    display: table-header-group;
  }
  
  tr, td, th {
    page-break-inside: avoid;
  }
}
</style>
