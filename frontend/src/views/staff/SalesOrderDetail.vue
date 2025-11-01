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
                        <th class="px-6 py-3 text-center text-xs font-bold uppercase tracking-wider">Jumlah</th>
                        <th class="px-6 py-3 text-right text-xs font-bold uppercase tracking-wider">Harga Satuan</th>
                        <th class="px-6 py-3 text-right text-xs font-bold uppercase tracking-wider">Subtotal</th>
                      </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-200">
                      <tr v-for="(item, index) in salesOrder.items" :key="item.id">
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
                          <p class="text-xs text-gray-500 uppercase font-semibold">Catatan SO:</p>
                          <p class="text-sm text-gray-600">{{ salesOrder.catatan || '-' }}</p>
                        </td>
                        <td class="px-6 py-3 text-right text-sm text-gray-700 uppercase">Subtotal</td>
                        <td class="px-6 py-3 text-right text-sm text-gray-900">{{ formatCurrency(salesOrder.subtotal) }}</td>
                      </tr>
                      <tr>
                        <td class="px-6 py-3 text-right text-sm text-gray-700 uppercase">PPN ({{ ppnPercent }}%)</td>
                        <td class="px-6 py-3 text-right text-sm text-gray-900">{{ formatCurrency(salesOrder.ppn) }}</td>
                      </tr>
                      <tr class="text-base font-semibold">
                        <td class="px-6 py-4 text-right text-gray-900 uppercase">Total</td>
                        <td class="px-6 py-4 text-right text-gray-900">{{ formatCurrency(salesOrder.total) }}</td>
                      </tr>
                    </tfoot>
                  </table>
                </div>

                <!-- Tanda Tangan -->
                <div class="grid grid-cols-2 gap-8 pt-6 border-t border-gray-200 print-no-break">
                  <div>
                    <p class="text-sm text-gray-700 mb-16">Diajukan oleh,</p>
                    <p class="text-sm font-medium text-gray-900 border-t border-gray-400 pt-1">({{ salesOrder.creator?.name || '-' }})</p>
                    <p class="text-xs text-gray-500">Staff</p>
                  </div>
                  <div class="text-center">
                    <p class="text-sm text-gray-700 mb-16">Disetujui oleh,</p>
                    <p class="text-sm font-medium text-gray-900 border-t border-gray-400 pt-1">({{ salesOrder.approver?.name || 'Nama Admin' }})</p>
                    <p class="text-xs text-gray-500">Manajer</p>
                  </div>
                </div>
              </div>

              <!-- Bukti Barang Keluar (jika status completed) -->
              <div v-if="salesOrder.status === 'completed' && salesOrder.outgoing_item" class="bg-white p-8 rounded-lg shadow-lg border border-gray-200 mt-6" id="bukti-barang-keluar">
                <!-- Header Dokumen -->
                <div class="flex justify-between items-start pb-6 border-b-2 border-gray-900">
                  <div>
                    <h2 class="text-3xl font-bold text-gray-900">BUKTI BARANG KELUAR</h2>
                    <p class="text-lg font-semibold text-blue-600">{{ salesOrder.outgoing_item.no_dokumen }}</p>
                  </div>
                  <div class="text-right">
                    <img src="https://placehold.co/150x50/000000/FFFFFF?text=LOGO+PERUSAHAAN" alt="Logo Perusahaan" class="h-12 mb-2 ml-auto">
                    <p class="text-sm font-semibold text-gray-800">Nama Perusahaan Anda</p>
                    <p class="text-sm text-gray-600">Jl. Jend. Sudirman No. 1, Jakarta</p>
                    <p class="text-sm text-gray-600">Telepon: (021) 123456</p>
                  </div>
                </div>

                <!-- Info Transaksi -->
                <div class="grid grid-cols-2 gap-8 my-6">
                  <div>
                    <p class="text-sm font-semibold text-gray-500 uppercase mb-2">DITERIMA OLEH:</p>
                    <p class="text-lg font-bold text-gray-900">{{ salesOrder.customer_name }}</p>
                    <p v-if="salesOrder.customer_address" class="text-sm text-gray-600">{{ salesOrder.customer_address }}</p>
                    <p v-if="salesOrder.customer_phone" class="text-sm text-gray-600">Telp: {{ salesOrder.customer_phone }}</p>
                  </div>
                  <div>
                    <p class="text-sm font-semibold text-gray-500 uppercase mb-2">DETAIL:</p>
                    <p class="text-sm text-gray-700"><span class="font-medium">Tanggal Transaksi:</span> {{ formatDate(salesOrder.outgoing_item.tanggal) }}</p>
                    <p class="text-sm text-gray-700"><span class="font-medium">Referensi SO:</span> {{ salesOrder.no_so }}</p>
                    <p class="text-sm text-gray-700"><span class="font-medium">Dicatat Oleh:</span> {{ salesOrder.outgoing_item.dicatat_oleh || '-' }}</p>
                    <p v-if="salesOrder.outgoing_item.catatan" class="text-sm text-gray-700"><span class="font-medium">Keterangan:</span> {{ salesOrder.outgoing_item.catatan }}</p>
                  </div>
                </div>

                <!-- Tabel Detail Barang -->
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
                      <tr v-for="(item, index) in salesOrder.outgoing_item.items" :key="item.id">
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{{ index + 1 }}.</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ item.barang?.nama || '-' }}</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600 text-center">{{ item.qty_issued }}</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600 text-right">{{ formatCurrency(item.harga_satuan) }}</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900 text-right">{{ formatCurrency(item.subtotal) }}</td>
                      </tr>
                    </tbody>
                    <!-- Footer Total -->
                    <tfoot class="bg-gray-50 font-medium print-no-break">
                      <tr>
                        <td colspan="3" rowspan="3" class="px-6 py-3 align-top">
                          <p class="text-xs text-gray-500 uppercase font-semibold">Catatan:</p>
                          <p class="text-sm text-gray-600">{{ salesOrder.outgoing_item.catatan || '-' }}</p>
                        </td>
                        <td class="px-6 py-3 text-right text-sm text-gray-700 uppercase">Subtotal</td>
                        <td class="px-6 py-3 text-right text-sm text-gray-900">{{ formatCurrency(salesOrder.subtotal) }}</td>
                      </tr>
                      <tr>
                        <td class="px-6 py-3 text-right text-sm text-gray-700 uppercase">PPN ({{ ppnPercent }}%)</td>
                        <td class="px-6 py-3 text-right text-sm text-gray-900">{{ formatCurrency(salesOrder.ppn) }}</td>
                      </tr>
                      <tr class="text-base font-semibold">
                        <td class="px-6 py-4 text-right text-gray-900 uppercase">Total</td>
                        <td class="px-6 py-4 text-right text-gray-900">{{ formatCurrency(salesOrder.total) }}</td>
                      </tr>
                    </tfoot>
                  </table>
                </div>

                <!-- Tanda Tangan -->
                <div class="grid grid-cols-2 gap-8 pt-6 border-t border-gray-200 print-no-break">
                  <div>
                    <p class="text-sm text-gray-700 mb-16">Diserahkan Oleh,</p>
                    <p class="text-sm font-medium text-gray-900 border-t border-gray-400 pt-1">({{ salesOrder.outgoing_item.dicatat_oleh || 'Staff Gudang' }})</p>
                    <p class="text-xs text-gray-500">Staff Inventori</p>
                  </div>
                  <div class="text-center">
                    <p class="text-sm text-gray-700 mb-16">Diketahui Oleh,</p>
                    <p class="text-sm font-medium text-gray-900 border-t border-gray-400 pt-1">({{ salesOrder.approver?.name || 'Nama Admin' }})</p>
                    <p class="text-xs text-gray-500">Manajer</p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Kolom Kanan: Info & Riwayat (Non-Cetak) -->
            <div class="lg:col-span-4 space-y-6 print-hidden">
              
              <!-- Status SO (Tanpa Tombol untuk Staff) -->
              <div class="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
                <h3 class="text-lg font-semibold text-gray-900 mb-4">Status SO</h3>
                <span :class="[getStatusBadgeClass(salesOrder.status), 'px-4 py-1.5 inline-flex text-base font-medium rounded-full']">
                  {{ getStatusLabel(salesOrder.status) }}
                </span>
                <p class="text-sm text-gray-500 mt-2">
                  Diajukan oleh {{ salesOrder.creator?.name || '-' }} pada {{ formatDate(salesOrder.created_at) }}.
                </p>
                <!-- TIDAK ADA TOMBOL APPROVE/REJECT UNTUK STAFF -->
              </div>

              <!-- Riwayat Status -->
              <div class="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
                <h3 class="text-lg font-semibold text-gray-900 mb-4">Riwayat Status</h3>
                <ol class="relative border-l border-gray-200">
                  <!-- Status: Dibuat -->
                  <li class="ml-4">
                    <div class="absolute w-3 h-3 bg-blue-600 rounded-full mt-1.5 -left-1.5 border border-white"></div>
                    <time class="mb-1 text-sm font-normal leading-none text-gray-500">{{ formatDate(salesOrder.created_at) }}</time>
                    <h3 class="text-base font-semibold text-gray-900">Dibuat & Diajukan</h3>
                    <p class="text-sm font-normal text-gray-500">
                      SO dibuat oleh {{ salesOrder.creator?.name || '-' }} dan menunggu persetujuan Admin.
                    </p>
                  </li>
                  
                  <!-- Status: Disetujui -->
                  <li v-if="salesOrder.approved_at" class="ml-4 mt-4">
                    <div class="absolute w-3 h-3 bg-green-600 rounded-full mt-1.5 -left-1.5 border border-white"></div>
                    <time class="mb-1 text-sm font-normal leading-none text-gray-500">{{ formatDate(salesOrder.approved_at) }}</time>
                    <h3 class="text-base font-semibold text-gray-900">Disetujui</h3>
                    <p class="text-sm font-normal text-gray-500">
                      SO disetujui oleh {{ salesOrder.approver?.name || 'Admin' }}.
                    </p>
                  </li>
                  
                  <!-- Status: Selesai -->
                  <li v-if="salesOrder.status === 'completed' && salesOrder.completed_at" class="ml-4 mt-4">
                    <div class="absolute w-3 h-3 bg-purple-600 rounded-full mt-1.5 -left-1.5 border border-white"></div>
                    <time class="mb-1 text-sm font-normal leading-none text-gray-500">{{ formatDate(salesOrder.completed_at) }}</time>
                    <h3 class="text-base font-semibold text-gray-900">Diproses & Diselesaikan</h3>
                    <p class="text-sm font-normal text-gray-500">
                      Barang telah dikeluarkan dan SO selesai. Bukti barang keluar: {{ salesOrder.outgoing_item?.no_dokumen || '-' }}.
                    </p>
                  </li>
                  
                  <!-- Status: Ditolak -->
                  <li v-if="salesOrder.status === 'rejected' && salesOrder.rejected_at" class="ml-4 mt-4">
                    <div class="absolute w-3 h-3 bg-red-600 rounded-full mt-1.5 -left-1.5 border border-white"></div>
                    <time class="mb-1 text-sm font-normal leading-none text-gray-500">{{ formatDate(salesOrder.rejected_at) }}</time>
                    <h3 class="text-base font-semibold text-gray-900">Ditolak</h3>
                    <p class="text-sm font-normal text-gray-500">
                      SO ditolak oleh Admin. Alasan: {{ salesOrder.reject_reason || '-' }}
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
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import StaffNavigation from '@/components/StaffNavigation.vue'
import salesOrderService from '@/services/salesOrder.service'

const route = useRoute()
const router = useRouter()
const loading = ref(false)
const salesOrder = ref<any>(null)

const toggleSidebar = () => {
  const sidebar = document.getElementById('sidebar')
  const overlay = document.getElementById('overlay')
  if (sidebar && overlay) {
    sidebar.classList.toggle('-translate-x-full')
    overlay.classList.toggle('hidden')
  }
}

const goBack = () => {
  router.push('/staff/sales-order')
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

const formatCurrency = (value: number) => {
  return new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    minimumFractionDigits: 0
  }).format(value || 0)
}

const ppnPercent = computed(() => {
  if (!salesOrder.value || !salesOrder.value.subtotal || salesOrder.value.subtotal === 0) return 0
  return Math.round((salesOrder.value.ppn / salesOrder.value.subtotal) * 100)
})

const getStatusLabel = (status: string) => {
  const labels: any = {
    'pending': 'Approved (Pending)',
    'approved': 'Approved (Pending)',
    'rejected': 'Reject',
    'completed': 'Done'
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

const fetchSalesOrder = async () => {
  loading.value = true
  try {
    const id = route.params.id as string
    const response = await salesOrderService.getById(parseInt(id))
    if (response.success && !Array.isArray(response.data)) {
      salesOrder.value = response.data
    }
  } catch (error: any) {
    console.error('Error fetching sales order:', error)
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
