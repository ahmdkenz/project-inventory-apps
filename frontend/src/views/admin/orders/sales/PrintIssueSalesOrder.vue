<template>
  <div class="print-container">
    <div v-if="loading" class="flex justify-center items-center py-12">
      <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
    </div>

    <div v-else-if="salesOrder" id="printable-area">
      <div class="bg-white p-8 md:p-12">
        <!-- Header Dokumen -->
        <div class="flex justify-between items-center border-b-2 border-gray-900 pb-4 mb-8">
          <div>
            <h1 class="text-3xl font-bold text-gray-900">BUKTI PENGELUARAN BARANG</h1>
            <p class="text-gray-600">No. Pengeluaran: {{ generateIssueNumber(salesOrder.id, salesOrder.completed_at || new Date()) }}</p>
            <p class="text-gray-600">Ref. SO: {{ salesOrder.no_so }}</p>
          </div>
          <div>
            <h2 class="text-xl font-semibold text-gray-800">Nama Perusahaan Anda</h2>
            <p class="text-sm text-gray-600">Jl. Alamat Kantor No. 123</p>
            <p class="text-sm text-gray-600">Jakarta, Indonesia</p>
          </div>
        </div>

        <!-- Info Transaksi -->
        <div class="grid grid-cols-2 gap-8 mb-8">
          <div>
            <h3 class="text-sm font-medium text-gray-500 uppercase mb-2">DISERAHKAN KEPADA:</h3>
            <p class="text-lg font-semibold text-gray-900">{{ salesOrder.customer_name || '-' }}</p>
            <p class="text-gray-600">{{ salesOrder.customer_address || '-' }}</p>
          </div>
          <div>
            <h3 class="text-sm font-medium text-gray-500 uppercase mb-2">DETAIL:</h3>
            <p class="text-gray-700"><span class="font-medium">Tanggal Keluar:</span> {{ formatDate(salesOrder.completed_at || new Date()) }}</p>
            <p class="text-gray-700"><span class="font-medium">Dicatat Oleh:</span> {{ salesOrder.processor?.name || salesOrder.approver?.name || 'Admin' }}</p>
            <p class="text-gray-700"><span class="font-medium">No. Surat Jalan:</span> {{ getNoSuratJalan() }}</p>
          </div>
        </div>

        <!-- Tabel Detail Barang -->
        <div class="overflow-x-auto mb-8">
          <table class="w-full min-w-max">
            <thead class="border-b border-gray-300">
              <tr>
                <th class="px-4 py-3 text-left text-sm font-medium text-gray-600 uppercase">Nama Barang</th>
                <th class="px-4 py-3 text-center text-sm font-medium text-gray-600 uppercase">Dipesan</th>
                <th class="px-4 py-3 text-center text-sm font-medium text-gray-600 uppercase">Dikeluarkan</th>
                <th class="px-4 py-3 text-right text-sm font-medium text-gray-600 uppercase">Harga Satuan</th>
                <th class="px-4 py-3 text-right text-sm font-medium text-gray-600 uppercase">Subtotal</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-200">
              <tr v-for="(item, index) in salesOrder.outgoing_item?.items || salesOrder.items" :key="index">
                <td class="px-4 py-4 text-sm font-medium text-gray-900">{{ item.barang?.nama || '-' }}</td>
                <td class="px-4 py-4 text-sm text-gray-800 text-center">{{ item.qty }}</td>
                <td class="px-4 py-4 text-sm font-bold text-gray-900 text-center">
                  {{ item.qty_issued || item.qty }}
                </td>
                <td class="px-4 py-4 text-sm text-gray-800 text-right">{{ formatCurrency(item.harga_satuan) }}</td>
                <td class="px-4 py-4 text-sm font-medium text-gray-900 text-right">{{ formatCurrency(item.subtotal || 0) }}</td>
              </tr>
            </tbody>
            <!-- Total -->
            <tfoot class="border-t-2 border-gray-300">
              <tr>
                <td colspan="4" class="px-4 py-3 text-right text-sm font-medium text-gray-600 uppercase">Subtotal</td>
                <td class="px-4 py-3 text-right text-sm font-semibold text-gray-900">{{ formatCurrency(salesOrder.subtotal || 0) }}</td>
              </tr>
              <tr>
                <td colspan="4" class="px-4 py-3 text-right text-sm font-medium text-gray-600 uppercase">PPN ({{ ppnPercent }}%)</td>
                <td class="px-4 py-3 text-right text-sm font-semibold text-gray-900">{{ formatCurrency(salesOrder.ppn || 0) }}</td>
              </tr>
              <tr class="bg-gray-50">
                <td colspan="4" class="px-4 py-3 text-right text-base font-bold text-gray-900 uppercase">Grand Total</td>
                <td class="px-4 py-3 text-right text-base font-bold text-gray-900">{{ formatCurrency(salesOrder.total || 0) }}</td>
              </tr>
            </tfoot>
          </table>
        </div>

        <!-- Tanda Tangan -->
        <div class="grid grid-cols-3 gap-8 pt-12">
          <div class="text-center">
            <p class="text-sm text-gray-700 mb-16">Diserahkan Oleh,</p>
            <p class="text-sm font-medium text-gray-900">({{ salesOrder.processor?.name || salesOrder.approver?.name || 'Admin' }})</p>
            <p class="text-sm text-gray-600">Staff Inventori</p>
          </div>
          <div class="text-center">
            <p class="text-sm text-gray-700 mb-16">Diterima Oleh,</p>
            <p class="text-sm font-medium text-gray-900">(...........................)</p>
            <p class="text-sm text-gray-600">Penerima</p>
          </div>
          <div class="text-center">
            <p class="text-sm text-gray-700 mb-16">Diketahui Oleh,</p>
            <p class="text-sm font-medium text-gray-900">(...........................)</p>
            <p class="text-sm text-gray-600">Manajer / Owner</p>
          </div>
        </div>

        <!-- Footer -->
        <div class="mt-8 pt-4 border-t border-gray-300 text-center text-xs text-gray-500">
          <p>Dokumen ini dicetak pada: {{ formatDateTime(new Date()) }}</p>
          <p>Dokumen ini sah tanpa tanda tangan basah</p>
        </div>
      </div>

      <!-- Print Controls -->
      <div class="print-controls fixed bottom-8 right-8 flex gap-4">
        <button @click="goBack" class="bg-gray-600 hover:bg-gray-700 text-white font-medium py-3 px-6 rounded-lg shadow-lg transition duration-150">
          <svg class="h-5 w-5 inline mr-2" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7" />
          </svg>
          Kembali
        </button>
        <button @click="printDocument" class="bg-green-600 hover:bg-green-700 text-white font-medium py-3 px-6 rounded-lg shadow-lg transition duration-150">
          <svg class="h-5 w-5 inline mr-2" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M6.72 13.829c-.24.03-.48.062-.72.096m.72-.096a42.415 42.415 0 0110.56 0m-10.56 0L6.34 18m10.94-4.171c.24.03.48.062.72.096m-.72-.096L17.66 18m0 0l.229 2.523a1.125 1.125 0 01-1.12 1.227H7.23a1.125 1.125 0 01-1.12-1.227L6.34 18m11.319 0H6.34m11.319 0l.044.506A1.125 1.125 0 0117.003 20H6.997a1.125 1.125 0 01-1.122-1.494l.044-.506M6.34 18v-4.172c0-.224.03-.447.086-.665A41.4 41.4 0 0112 3c1.83 0 3.597.133 5.28.362.057.218.086.44.086.665v4.172M6.34 18L4.26 7.5h15.48L17.66 18" />
          </svg>
          Cetak Bukti
        </button>
      </div>
    </div>

    <div v-else class="text-center py-12">
      <p class="text-gray-500">Data tidak ditemukan</p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import salesOrderService from '@/services/salesOrder.service'

const route = useRoute()
const router = useRouter()

const loading = ref(true)
const salesOrder = ref<any>(null)

const ppnPercent = computed(() => {
  if (!salesOrder.value || !salesOrder.value.subtotal || salesOrder.value.subtotal === 0) return 0
  return Math.round((salesOrder.value.ppn / salesOrder.value.subtotal) * 100)
})

// Generate No. Pengeluaran dengan format OUT-YYYYMMDD-{SO_ID}
const generateIssueNumber = (soId: number, completedDate: Date | string) => {
  const date = new Date(completedDate)
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  return `OUT-${year}${month}${day}-${soId}`
}

// Generate No. Surat Jalan jika tidak ada
const generateSuratJalanNumber = (soId: number, completedDate: Date | string) => {
  const date = new Date(completedDate)
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  return `SJ-OUT-${year}${month}${day}-${soId}`
}

// Get No. Surat Jalan (dari database atau generate jika tidak ada)
const getNoSuratJalan = () => {
  if (!salesOrder.value) return '-'
  
  // Jika ada di database, gunakan itu
  if (salesOrder.value.no_surat_jalan) {
    return salesOrder.value.no_surat_jalan
  }
  
  // Jika tidak ada, generate otomatis berdasarkan completed_at
  if (salesOrder.value.completed_at && salesOrder.value.id) {
    return generateSuratJalanNumber(salesOrder.value.id, salesOrder.value.completed_at)
  }
  
  return '-'
}

const fetchPrintData = async () => {
  loading.value = true
  try {
    const id = route.params.id as string
    const response = await salesOrderService.adminGetById(parseInt(id))
    
    if (response.success && !Array.isArray(response.data)) {
      salesOrder.value = response.data
    } else {
      throw new Error('Data tidak ditemukan')
    }
  } catch (error: any) {
    console.error('Error fetching print data:', error)
    alert('Gagal memuat data untuk cetak')
    router.back()
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

const formatDateTime = (date: Date | string) => {
  if (!date) return '-'
  return new Date(date).toLocaleString('id-ID', {
    day: 'numeric',
    month: 'long',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
}

const printDocument = () => {
  window.print()
}

const goBack = () => {
  router.back()
}

onMounted(() => {
  fetchPrintData()
})
</script>

<style scoped>
.print-container {
  min-height: 100vh;
  background-color: #f3f4f6;
  padding: 2rem;
}

#printable-area {
  max-width: 1200px;
  margin: 0 auto;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

@media print {
  .print-container {
    background-color: white;
    padding: 0;
  }
  
  .print-controls {
    display: none !important;
  }
  
  #printable-area {
    max-width: 100%;
    box-shadow: none;
  }
  
  /* Improve print quality */
  body {
    print-color-adjust: exact;
    -webkit-print-color-adjust: exact;
  }
  
  @page {
    margin: 1cm;
    size: A4;
  }
}
</style>
