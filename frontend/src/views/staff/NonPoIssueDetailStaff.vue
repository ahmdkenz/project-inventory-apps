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

        <div v-else-if="issueData">
          <!-- Tombol Aksi Atas -->
          <div class="flex items-center justify-between mb-6 print-hidden">
            <h1 class="text-3xl font-bold text-gray-900">Detail Pengeluaran Barang (Non-SO)</h1>
            <div class="flex space-x-3">
              <button @click="goBack" class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150">
                <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5L8.25 12l7.5-7.5" />
                </svg>
                <span>Kembali</span>
              </button>
              <router-link 
                :to="`/staff/non-po/issue/${issueData.id}/print`"
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

            <!-- Kolom Kiri: Dokumen (Area Cetak) -->
            <div class="lg:col-span-8">
              <div class="bg-white p-8 rounded-lg shadow-lg border border-gray-200">
                <!-- Header Dokumen -->
                <div class="flex justify-between items-start pb-6 border-b-2 border-gray-900">
                  <div>
                    <h2 class="text-3xl font-bold text-gray-900">PENGELUARAN BARANG (NON-SO)</h2>
                    <p class="text-lg font-semibold text-blue-600">{{ issueData.no_dokumen }}</p>
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
                    <p class="text-lg font-bold text-gray-900">{{ issueData.recipient }}</p>
                    <p v-if="issueData.notes" class="text-sm text-gray-600">{{ issueData.notes }}</p>
                  </div>
                  <div class="text-right">
                    <div class="mb-2">
                      <span class="text-sm font-semibold text-gray-500 uppercase">Tanggal Dikeluarkan: </span>
                      <span class="text-sm font-medium text-gray-800">{{ formatDate(issueData.issue_date) }}</span>
                    </div>
                    <div>
                      <span class="text-sm font-semibold text-gray-500 uppercase">Dicatat Oleh: </span>
                      <span class="text-sm font-medium text-gray-800">{{ issueData.creator?.name || '-' }}</span>
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
                      <tr v-for="(item, index) in issueData.items" :key="index">
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{{ index + 1 }}.</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ item.nama_barang || '-' }}</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600 text-center">{{ item.qty }} {{ item.satuan || 'pcs' }}</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600 text-right">{{ formatCurrency(item.harga_satuan || 0) }}</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900 text-right">{{ formatCurrency(item.subtotal || 0) }}</td>
                      </tr>
                    </tbody>
                    <!-- Footer Total -->
                    <tfoot class="bg-gray-50 font-medium">
                      <tr>
                        <td colspan="3" rowspan="3" class="px-6 py-3 align-top">
                          <p class="text-xs text-gray-500 uppercase font-semibold">Catatan:</p>
                          <p class="text-sm text-gray-600">{{ issueData.notes || '-' }}</p>
                        </td>
                        <td class="px-6 py-3 text-right text-sm text-gray-700 uppercase">Subtotal</td>
                        <td class="px-6 py-3 text-right text-sm text-gray-900">{{ formatCurrency(issueData.subtotal || 0) }}</td>
                      </tr>
                      <tr>
                        <td class="px-6 py-3 text-right text-sm text-gray-700 uppercase">PPN ({{ ppnPercent }}%)</td>
                        <td class="px-6 py-3 text-right text-sm text-gray-900">{{ formatCurrency(issueData.ppn || 0) }}</td>
                      </tr>
                      <tr class="text-base font-semibold">
                        <td class="px-6 py-4 text-right text-gray-900 uppercase">Total</td>
                        <td class="px-6 py-4 text-right text-gray-900">{{ formatCurrency(issueData.total || 0) }}</td>
                      </tr>
                    </tfoot>
                  </table>
                </div>

                <!-- Tanda Tangan -->
                <div class="grid grid-cols-2 gap-8 pt-6 border-t border-gray-200">
                  <div>
                    <p class="text-sm text-gray-700 mb-16">Diserahkan oleh,</p>
                    <p class="text-sm font-medium text-gray-900 border-t border-gray-400 pt-1">({{ issueData.creator?.name || 'Staff' }})</p>
                    <p class="text-xs text-gray-500">Staff Inventori</p>
                  </div>
                  <div class="text-center">
                    <p class="text-sm text-gray-700 mb-16">Diterima oleh,</p>
                    <p class="text-sm font-medium text-gray-900 border-t border-gray-400 pt-1">(...........................)</p>
                    <p class="text-xs text-gray-500">Penerima</p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Kolom Kanan: Info -->
            <div class="lg:col-span-4 space-y-6 print-hidden">
              
              <!-- Info Pengeluaran -->
              <div class="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
                <h3 class="text-lg font-semibold text-gray-900 mb-4">Informasi Pengeluaran</h3>
                <div class="space-y-3">
                  <div>
                    <dt class="text-sm font-medium text-gray-500">No. Dokumen</dt>
                    <dd class="text-base text-gray-900 font-medium">{{ issueData.no_dokumen }}</dd>
                  </div>
                  <div>
                    <dt class="text-sm font-medium text-gray-500">Tanggal</dt>
                    <dd class="text-base text-gray-900 font-medium">{{ formatDate(issueData.issue_date) }}</dd>
                  </div>
                  <div>
                    <dt class="text-sm font-medium text-gray-500">Dicatat Oleh</dt>
                    <dd class="text-base text-gray-900 font-medium">{{ issueData.creator?.name || '-' }}</dd>
                  </div>
                </div>
              </div>

              <!-- Informasi Penerima -->
              <div class="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
                <h3 class="text-lg font-semibold text-gray-900 mb-4">Info Penerima</h3>
                <dl>
                  <dt class="text-sm font-medium text-gray-500">Nama/Divisi</dt>
                  <dd class="text-base text-gray-900 font-medium mb-2">{{ issueData.recipient }}</dd>
                  <dt v-if="issueData.notes" class="text-sm font-medium text-gray-500">Catatan</dt>
                  <dd v-if="issueData.notes" class="text-base text-gray-900 font-medium">{{ issueData.notes }}</dd>
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
import { useRouter, useRoute } from 'vue-router'
import StaffNavigation from '@/components/StaffNavigation.vue'
import api from '@/services/api'

const router = useRouter()
const route = useRoute()

interface IssueItem {
  barang_id: number
  nama_barang: string
  kode_barang: string
  qty: number
  harga_satuan?: number
  subtotal?: number
  satuan?: string
}

interface IssueData {
  id: number
  no_dokumen: string
  recipient: string
  issue_date: string
  notes: string | null
  creator: {
    name: string
  } | null
  items: IssueItem[]
  subtotal?: number
  ppn?: number
  total?: number
}

const loading = ref(false)
const issueData = ref<IssueData | null>(null)

const ppnPercent = computed(() => {
  if (!issueData.value || !issueData.value.subtotal || issueData.value.subtotal === 0) return 0
  return Math.round(((issueData.value.ppn || 0) / issueData.value.subtotal) * 100)
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
  router.push('/staff/outgoing-items')
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

const fetchIssueData = async () => {
  loading.value = true
  try {
    const id = route.params.id as string
    const response = await api.get(`/staff/non-po/issue/${id}/print`)
    
    if (response.data && response.data.success && response.data.data) {
      const data = response.data.data
      
      // Ensure items is an array
      if (!data.items) {
        data.items = []
      } else if (typeof data.items === 'object' && !Array.isArray(data.items)) {
        data.items = Object.values(data.items)
      }
      
      issueData.value = data
    }
  } catch (error: any) {
    console.error('Error fetching issue data:', error)
    alert('Gagal memuat data pengeluaran barang')
    router.push('/staff/outgoing-items')
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchIssueData()
})
</script>

<style scoped>
@media print {
  .print-hidden {
    display: none !important;
  }
}
</style>
