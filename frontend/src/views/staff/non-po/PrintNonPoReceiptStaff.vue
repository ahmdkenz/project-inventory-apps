<template>
  <div class="bg-gray-100">
    <div v-if="loading" class="flex justify-center items-center py-12">
          <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
        </div>

        <div v-else-if="receipt">
          <div class="flex items-center justify-between mb-6 print-hidden">
            <h1 class="text-3xl font-bold text-gray-900">Detail Penerimaan (Non-PO)</h1>
            <div class="flex space-x-3">
              <router-link to="/staff/received-items" class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150">
                <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5L8.25 12l7.5-7.5" />
                </svg>
                <span>Kembali ke Riwayat</span>
              </router-link>
              <button @click="printDocument" class="bg-green-600 hover:bg-green-700 text-white font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150">
                <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M6.72 13.829c-.24.03-.48.062-.72.096m.72-.096a42.415 42.415 0 0110.56 0m-10.56 0L6.34 18m10.94-4.171c.24.03.48.062.72.096m-.72-.096L17.66 18m0 0l.229 2.523a1.125 1.125 0 01-1.12 1.227H7.23a1.125 1.125 0 01-1.12-1.227L6.34 18m11.319 0H6.34m11.319 0l.044.506A1.125 1.125 0 0117.003 20H6.997a1.125 1.125 0 01-1.122-1.494l.044-.506M6.34 18v-4.172c0-.224.03-.447.086-.665A41.4 41.4 0 0112 3c1.83 0 3.597.133 5.28.362.057.218.086.44.086.665v4.172M6.34 18L4.26 7.5h15.48L17.66 18" />
                </svg>
                <span>Cetak Bukti</span>
              </button>
            </div>
          </div>
          
          <!-- Area Cetak -->
          <div class="max-w-4xl mx-auto" id="print-area-container">
            <div class="bg-white p-8 rounded-lg shadow-lg border border-gray-200" id="printable-area">
              <!-- Header Dokumen -->
              <div class="flex justify-between items-start pb-6 border-b-2 border-gray-900">
                <div>
                  <h2 class="text-3xl font-bold text-gray-900">BUKTI PENERIMAAN (NON-PO)</h2>
                  <p class="text-gray-600">No. Penerimaan: {{ receipt.no_dokumen }}</p>
                  <p class="text-gray-600">Ref. PO: {{ receipt.no_dokumen.replace('IN-NON-', 'PO-NON-') }}</p>
                </div>
                <div class="text-right">
                  <p class="text-sm font-semibold text-gray-800">PT. NAMA PERUSAHAAN ANDA</p>
                  <p class="text-sm text-gray-600">Jl. Jend. Sudirman No. 1, Jakarta</p>
                  <p class="text-sm text-gray-600">Telepon: (021) 123456</p>
                </div>
              </div>

              <!-- Info Penerima dan Tanggal -->
              <div class="grid grid-cols-2 gap-8 my-6">
                <div>
                  <p class="text-sm font-semibold text-gray-500 uppercase mb-2">SUMBER BARANG:</p>
                  <p class="text-lg font-bold text-gray-900">{{ receipt.source }}</p>
                  <p class="text-sm text-gray-600">Dicatat oleh: {{ receipt.creator?.name || '-' }}</p>
                </div>
                <div class="text-right">
                  <div class="mb-2">
                    <span class="text-sm font-semibold text-gray-500 uppercase">Tipe: </span>
                    <span class="text-sm font-medium text-purple-600">Penerimaan Non-PO</span>
                  </div>
                  <div>
                    <span class="text-sm font-semibold text-gray-500 uppercase">Tanggal Diterima: </span>
                    <span class="text-sm font-medium text-gray-800">{{ formatDate(receipt.receive_date) }}</span>
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
                      <th class="px-6 py-3 text-center text-xs font-bold uppercase tracking-wider">Jumlah Diterima</th>
                      <th class="px-6 py-3 text-right text-xs font-bold uppercase tracking-wider">Harga Satuan (Estimasi)</th>
                      <th class="px-6 py-3 text-right text-xs font-bold uppercase tracking-wider">Subtotal</th>
                    </tr>
                  </thead>
                  <tbody class="divide-y divide-gray-200">
                    <tr v-for="(item, index) in receipt.items" :key="index">
                      <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{{ index + 1 }}.</td>
                      <td class="px-6 py-4 whitespace-nowrap">
                        <div class="text-sm font-medium text-gray-900">{{ item.nama_barang }}</div>
                        <div class="text-sm text-gray-500">{{ item.kode_barang }}</div>
                      </td>
                      <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600 text-center">{{ item.qty }} Pcs</td>
                      <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600 text-right">{{ formatCurrency(item.price) }}</td>
                      <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900 text-right">{{ formatCurrency(item.subtotal) }}</td>
                    </tr>
                  </tbody>
                  <!-- Footer Tabel (Total) -->
                  <tfoot class="bg-gray-50 font-medium">
                    <tr>
                      <td colspan="4" class="px-6 py-3 text-right text-base text-gray-900 uppercase">Grand Total (Nilai)</td>
                      <td class="px-6 py-3 text-right text-base font-bold text-gray-900">{{ formatCurrency(receipt.total_value) }}</td>
                    </tr>
                  </tfoot>
                </table>
              </div>

              <!-- Catatan dan Tanda Tangan -->
              <div class="pt-6 border-t border-gray-200 print-no-break">
                <div class="mb-6">
                  <p class="text-sm font-semibold text-gray-500 uppercase mb-2">Catatan:</p>
                  <p class="text-sm text-gray-600">{{ receipt.notes || '-' }}</p>
                </div>
                <div class="grid grid-cols-3 gap-4 text-center">
                  <div>
                    <p class="text-sm text-gray-700 mb-16">Diserahkan Oleh,</p>
                    <div class="border-t border-gray-400 pt-1">
                      <p class="text-sm font-semibold text-gray-900">..............................</p>
                      <p class="text-xs text-gray-500">Pengirim</p>
                    </div>
                  </div>
                  <div>
                    <p class="text-sm text-gray-700 mb-16">Diterima Oleh,</p>
                    <div class="border-t border-gray-400 pt-1">
                      <p class="text-sm font-semibold text-gray-900">{{ receipt.creator?.name || '..............................' }}</p>
                      <p class="text-xs text-gray-500">Staff</p>
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
        </div>

        <div v-else class="text-center py-12">
          <p class="text-gray-500">Data tidak ditemukan</p>
        </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from 'axios'

const route = useRoute()
const router = useRouter()

const loading = ref(true)
const receipt = ref<any>(null)

const fetchPrintData = async () => {
  loading.value = true
  try {
    const id = route.params.id as string
    const token = localStorage.getItem('token')
    
    const response = await axios.get(
      `http://localhost:8000/api/staff/non-po/receipt/${id}/print`,
      {
        headers: {
          'Authorization': `Bearer ${token}`,
          'Accept': 'application/json'
        }
      }
    )
    
    if (response.data.success) {
      receipt.value = response.data.data
    }
  } catch (error: any) {
    console.error('Error fetching print data:', error)
    alert('Gagal memuat data untuk cetak')
    router.push('/staff/received-items')
  } finally {
    loading.value = false
  }
}

const formatCurrency = (value: number) => {
  return new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    minimumFractionDigits: 0
  }).format(value || 0)
}

const formatDate = (date: Date | string) => {
  if (!date) return '-'
  return new Date(date).toLocaleDateString('id-ID', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  })
}

const printDocument = () => {
  window.print()
}

onMounted(() => {
  fetchPrintData()
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
  
  #main-content {
    margin-left: 0 !important;
  }
  
  #print-area-container {
    display: block !important;
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
  }
  
  #printable-area {
    display: block !important;
    margin: 0;
    padding: 0;
    width: 100%;
    font-size: 12pt;
    color: #000;
    box-shadow: none !important;
    border: none !important;
  }
  
  .print-no-break {
    page-break-inside: avoid;
  }
  
  thead {
    display: table-header-group;
  }
  
  tfoot {
    display: table-footer-group;
  }
  
  tr, td, th {
    page-break-inside: avoid;
  }
  
  table {
    page-break-inside: auto;
  }
}
</style>
