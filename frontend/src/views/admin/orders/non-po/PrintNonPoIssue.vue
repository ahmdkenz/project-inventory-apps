<template>
  <div class="flex h-screen bg-gray-100">
    <!-- Sidebar Admin -->
    <AdminNavigation :currentPath="route.path" />

    <!-- Main Content -->
    <div class="flex-1 flex flex-col lg:ml-64">
      <Header @toggle-sidebar="toggleSidebar" />

      <!-- Main Content -->
      <main class="flex-1 p-6 overflow-y-auto">
        <div class="flex items-center justify-between mb-6 print-hidden">
          <h1 class="text-3xl font-bold text-gray-900">Bukti Pengeluaran (Non-SO)</h1>
          <div class="flex space-x-3">
            <router-link to="/admin/outgoing-items" class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150">
              <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5L8.25 12l7.5-7.5" />
              </svg>
              <span>Kembali ke Riwayat</span>
            </router-link>
            <button @click="printDocument" class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150">
              <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M6.72 13.829c-.24.03-.48.062-.72.096m.72-.096a42.415 42.415 0 0110.56 0m-10.56 0L6.34 18m10.94-4.171c.24.03.48.062.72.096m-.72-.096L17.66 18m0 0l.229 2.523a1.125 1.125 0 01-1.12 1.227H7.23a1.125 1.125 0 01-1.12-1.227L6.34 18m11.319 0H6.34m11.319 0l.044.506A1.125 1.125 0 0117.003 20H6.997a1.125 1.125 0 01-1.122-1.494l.044-.506M6.34 18v-4.172c0-.224.03-.447.086-.665A41.4 41.4 0 0112 3c1.83 0 3.597.133 5.28.362.057.218.086.44.086.665v4.172M6.34 18L4.26 7.5h15.48L17.66 18" />
              </svg>
              <span>Cetak</span>
            </button>
          </div>
        </div>

        <!-- Loading State -->
        <div v-if="isLoading" class="flex justify-center items-center py-12">
          <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
        </div>

        <!-- Error State -->
        <div v-else-if="error" class="max-w-6xl mx-auto bg-white p-8 rounded-lg shadow-sm border border-red-200">
          <div class="text-center py-12">
            <svg class="h-12 w-12 mx-auto text-red-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m9-.75a9 9 0 11-18 0 9 9 0 0118 0zm-9 3.75h.008v.008H12v-.008z" />
            </svg>
            <p class="mt-4 text-red-600 font-semibold">{{ error }}</p>
          </div>
        </div>

        <!-- Area Cetak -->
        <div v-else class="max-w-6xl mx-auto bg-white p-8 rounded-lg shadow-sm border border-gray-200" id="printable-area-container">
          <div id="printable-area">
            <!-- Header Dokumen -->
            <div class="flex justify-between items-start pb-6 border-b-2 border-gray-900">
              <div>
                <h2 class="text-3xl font-bold text-gray-900">BUKTI PENGELUARAN BARANG</h2>
                <p class="text-lg font-semibold text-blue-600">{{ issueData?.no_dokumen }}</p>
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
                <p class="text-sm font-semibold text-gray-500 uppercase mb-2">DIKELUARKAN UNTUK:</p>
                <p class="text-lg font-bold text-gray-900">{{ issueData?.recipient }}</p>
                <p class="text-sm text-gray-600" v-if="issueData?.notes">{{ issueData.notes }}</p>
              </div>
              <div class="text-right">
                <div>
                  <span class="text-sm font-semibold text-gray-500 uppercase">Tanggal Dikeluarkan: </span>
                  <span class="text-sm font-medium text-gray-800">{{ formatDate(issueData?.issue_date) }}</span>
                </div>
                <div>
                  <span class="text-sm font-semibold text-gray-500 uppercase">Dikeluarkan Oleh: </span>
                  <span class="text-sm font-medium text-gray-800">{{ issueData?.creator?.name || '-' }}</span>
                </div>
              </div>
            </div>

            <!-- Tabel Item -->
            <div class="overflow-x-auto border rounded-lg mb-6 print-no-break">
              <table class="w-full min-w-max">
                <thead class="bg-gray-100 text-gray-700">
                  <tr>
                    <th class="px-6 py-3 text-left text-xs font-bold uppercase tracking-wider">No.</th>
                    <th class="px-6 py-3 text-left text-xs font-bold uppercase tracking-wider">Nama Barang</th>
                    <th class="px-6 py-3 text-center text-xs font-bold uppercase tracking-wider">Jumlah Dikeluarkan</th>
                    <th class="px-6 py-3 text-left text-xs font-bold uppercase tracking-wider">Keterangan</th>
                  </tr>
                </thead>
                <tbody class="divide-y divide-gray-200">
                  <tr v-if="!issueData?.items || issueData.items.length === 0">
                    <td colspan="4" class="px-6 py-4 text-center text-sm text-gray-500">
                      Tidak ada data barang
                    </td>
                  </tr>
                  <tr v-else v-for="(item, index) in issueData.items" :key="item.barang_id">
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{{ index + 1 }}.</td>
                    <td class="px-6 py-4 whitespace-nowrap">
                      <div class="text-sm font-medium text-gray-900">{{ item.nama_barang }}</div>
                      <div class="text-sm text-gray-500">{{ item.kode_barang }}</div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-bold text-gray-900 text-center">{{ item.qty }}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">-</td>
                  </tr>
                </tbody>
              </table>
            </div>

            <!-- Tanda Tangan -->
            <div class="pt-6 border-t border-gray-200 print-no-break">
              <div class="grid grid-cols-3 gap-4 text-center">
                <div>
                  <p class="text-sm text-gray-700 mb-16">Diserahkan Oleh,</p>
                  <div class="border-t border-gray-400 pt-1">
                    <p class="text-sm font-semibold text-gray-900">{{ issueData?.creator?.name || '..............................' }}</p>
                    <p class="text-xs text-gray-500">Staff</p>
                  </div>
                </div>
                <div>
                  <p class="text-sm text-gray-700 mb-16">Diterima Oleh,</p>
                  <div class="border-t border-gray-400 pt-1">
                    <p class="text-sm font-semibold text-gray-900">..............................</p>
                    <p class="text-xs text-gray-500">Penerima</p>
                  </div>
                </div>
                <div>
                  <p class="text-sm text-gray-700 mb-16">Disetujui Oleh,</p>
                  <div class="border-t border-gray-400 pt-1">
                    <p class="text-sm font-semibold text-gray-900">..............................</p>
                    <p class="text-xs text-gray-500">Admin</p>
                  </div>
                </div>
              </div>
            </div>

          </div>
        </div>

      </main>
      <Footer />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import api from '@/services/api'
import AdminNavigation from '@/components/AdminNavigation.vue'
import Header from '@/components/Header.vue'
import Footer from '@/components/Footer.vue'

const route = useRoute()

interface IssueItem {
  barang_id: number
  nama_barang: string
  kode_barang: string
  qty: number
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
}

const issueData = ref<IssueData | null>(null)
const isLoading = ref(true)
const error = ref('')

const toggleSidebar = () => {
  const sidebar = document.getElementById('sidebar')
  if (sidebar) {
    sidebar.classList.toggle('-translate-x-full')
  }
}

const fetchIssueData = async () => {
  try {
    isLoading.value = true
    error.value = ''
    
    const issueId = route.params.id
    
    console.log('Fetching issue data for ID:', issueId)
    
    const response = await api.get(`/admin/non-po/issue/${issueId}/print`)
    
    console.log('Full response:', response)
    console.log('Response data:', response.data)
    
    if (response.data && response.data.success && response.data.data) {
      const data = response.data.data
      
      // Ensure items is an array
      if (!data.items) {
        data.items = []
      } else if (typeof data.items === 'object' && !Array.isArray(data.items)) {
        // Convert object to array if needed
        data.items = Object.values(data.items)
      }
      
      issueData.value = data
      console.log('Issue data set:', issueData.value)
      console.log('Issue items count:', data.items?.length)
      console.log('Issue items:', data.items)
    } else {
      error.value = 'Format data tidak sesuai'
      console.error('Invalid response format:', response.data)
    }
  } catch (err: any) {
    console.error('Error fetching issue data:', err)
    console.error('Error response:', err.response)
    error.value = err.response?.data?.message || 'Gagal memuat data bukti pengeluaran'
  } finally {
    isLoading.value = false
  }
}

const formatDate = (dateString: string | undefined) => {
  if (!dateString) return '-'
  const date = new Date(dateString)
  return date.toLocaleDateString('id-ID', { 
    day: 'numeric', 
    month: 'long', 
    year: 'numeric' 
  })
}

const printDocument = () => {
  window.print()
}

onMounted(() => {
  fetchIssueData()
})
</script>

<style scoped>
@media print {
  body > * {
    display: none;
  }
  
  .print-hidden {
    display: none !important;
  }
  
  #printable-area-container {
    display: block !important;
    margin: 0;
    padding: 0;
    width: 100%;
    box-shadow: none !important;
    border: none !important;
  }
  
  #printable-area {
    font-size: 12pt;
    color: #000;
  }
  
  .print-no-break {
    page-break-inside: avoid;
  }
  
  thead {
    display: table-header-group;
  }
  
  tr, td, th {
    page-break-inside: avoid;
  }
  
  table {
    page-break-inside: auto;
  }
}
</style>
