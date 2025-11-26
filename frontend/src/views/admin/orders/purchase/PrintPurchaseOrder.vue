<template>
  <div class="print-container">
    <div v-if="loading" class="flex justify-center items-center py-12">
      <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
    </div>

    <div v-else-if="purchaseOrder" id="printable-area">
      <div class="bg-white p-8 md:p-12">
        <!-- Header Dokumen -->
        <div class="flex justify-between items-start border-b-2 border-gray-900 pb-4 mb-8">
          <div>
            <h1 class="text-3xl font-bold text-gray-900">BUKTI TRANSAKSI</h1>
            <h2 class="text-2xl font-semibold text-gray-700">PURCHASE ORDER</h2>
            <p class="text-gray-600 mt-2">No. PO: {{ purchaseOrder.no_po }}</p>
            <p v-if="purchaseOrder.no_surat_jalan" class="text-gray-600">
              No. Surat Jalan: {{ purchaseOrder.no_surat_jalan }}
            </p>
          </div>
          <div class="text-right">
            <h2 class="text-xl font-semibold text-gray-800">PT. NAMA PERUSAHAAN ANDA</h2>
            <p class="text-sm text-gray-600">Jl. Alamat Kantor No. 123</p>
            <p class="text-sm text-gray-600">Jakarta, Indonesia</p>
            <p class="text-sm text-gray-600">Telp: (021) 1234-5678</p>
          </div>
        </div>

        <!-- Info Transaksi -->
        <div class="grid grid-cols-2 gap-8 mb-8">
          <div>
            <h3 class="text-sm font-medium text-gray-500 uppercase mb-2">SUPPLIER:</h3>
            <p class="text-lg font-semibold text-gray-900">{{ purchaseOrder.supplier?.nama || '-' }}</p>
            <p class="text-gray-600">{{ purchaseOrder.supplier?.alamat || '-' }}</p>
            <p class="text-gray-600">Telp: {{ purchaseOrder.supplier?.telp || '-' }}</p>
            <p class="text-gray-600">Email: {{ purchaseOrder.supplier?.email || '-' }}</p>
          </div>
          <div>
            <h3 class="text-sm font-medium text-gray-500 uppercase mb-2">DETAIL TRANSAKSI:</h3>
            <p class="text-gray-700"><span class="font-medium">Tanggal Pesan:</span> {{ formatDate(purchaseOrder.tgl_pesan) }}</p>
            <p class="text-gray-700"><span class="font-medium">Tanggal Estimasi:</span> {{ formatDate(purchaseOrder.tgl_estimasi) }}</p>
            <p v-if="purchaseOrder.completed_at" class="text-gray-700">
              <span class="font-medium">Tanggal Diterima:</span> {{ formatDate(purchaseOrder.completed_at) }}
            </p>
            <p class="text-gray-700"><span class="font-medium">Status:</span> 
              <span :class="{
                'text-green-600 font-semibold': purchaseOrder.status === 'completed',
                'text-blue-600 font-semibold': purchaseOrder.status === 'approved',
                'text-yellow-600 font-semibold': purchaseOrder.status === 'pending'
              }">
                {{ getStatusLabel(purchaseOrder.status) }}
              </span>
            </p>
            <p class="text-gray-700"><span class="font-medium">Dibuat Oleh:</span> {{ purchaseOrder.creator?.name || '-' }}</p>
            <p v-if="purchaseOrder.approver" class="text-gray-700">
              <span class="font-medium">Disetujui Oleh:</span> {{ purchaseOrder.approver.name }}
            </p>
          </div>
        </div>

        <!-- Tabel Detail Barang -->
        <div class="overflow-x-auto mb-8">
          <table class="w-full border-collapse">
            <thead class="border-b-2 border-gray-300">
              <tr class="bg-gray-50">
                <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">No</th>
                <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Kode Barang</th>
                <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Nama Barang</th>
                <th class="px-4 py-3 text-center text-sm font-semibold text-gray-700">Qty Pesan</th>
                <th class="px-4 py-3 text-center text-sm font-semibold text-gray-700">Qty Terima</th>
                <th class="px-4 py-3 text-right text-sm font-semibold text-gray-700">Harga Satuan</th>
                <th class="px-4 py-3 text-right text-sm font-semibold text-gray-700">Subtotal</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-200">
              <tr v-for="(item, index) in purchaseOrder.items" :key="index">
                <td class="px-4 py-3 text-gray-700">{{ index + 1 }}</td>
                <td class="px-4 py-3 text-gray-700">{{ item.kode_barang }}</td>
                <td class="px-4 py-3 text-gray-900 font-medium">{{ item.nama_barang }}</td>
                <td class="px-4 py-3 text-center text-gray-700">{{ item.qty }}</td>
                <td class="px-4 py-3 text-center font-semibold" :class="{
                  'text-green-600': item.qty_received >= item.qty,
                  'text-yellow-600': item.qty_received > 0 && item.qty_received < item.qty,
                  'text-gray-400': !item.qty_received
                }">
                  {{ item.qty_received || '-' }}
                </td>
                <td class="px-4 py-3 text-right text-gray-700">{{ formatCurrency(item.harga_satuan) }}</td>
                <td class="px-4 py-3 text-right text-gray-900 font-medium">{{ formatCurrency(item.subtotal) }}</td>
              </tr>
            </tbody>
            <tfoot class="border-t-2 border-gray-300">
              <tr>
                <td colspan="6" class="px-4 py-3 text-right font-semibold text-gray-700">Subtotal:</td>
                <td class="px-4 py-3 text-right font-semibold text-gray-900">{{ formatCurrency(purchaseOrder.subtotal) }}</td>
              </tr>
              <tr>
                <td colspan="6" class="px-4 py-3 text-right font-semibold text-gray-700">PPN ({{ ppnPercentage }}%):</td>
                <td class="px-4 py-3 text-right font-semibold text-gray-900">{{ formatCurrency(purchaseOrder.ppn) }}</td>
              </tr>
              <tr class="bg-gray-50">
                <td colspan="6" class="px-4 py-4 text-right font-bold text-gray-900 text-lg">GRAND TOTAL:</td>
                <td class="px-4 py-4 text-right font-bold text-gray-900 text-lg">{{ formatCurrency(purchaseOrder.total) }}</td>
              </tr>
            </tfoot>
          </table>
        </div>

        <!-- Catatan -->
        <div v-if="purchaseOrder.catatan" class="mb-8 p-4 bg-gray-50 rounded-lg">
          <h3 class="text-sm font-medium text-gray-700 mb-2">CATATAN:</h3>
          <p class="text-gray-600">{{ purchaseOrder.catatan }}</p>
        </div>

        <!-- Tanda Tangan -->
        <div class="grid grid-cols-3 gap-8 mt-12">
          <div class="text-center">
            <p class="text-sm font-medium text-gray-700 mb-16">Dibuat Oleh,</p>
            <div class="border-t border-gray-400 pt-1">
              <p class="text-sm font-semibold text-gray-900">{{ purchaseOrder.creator?.name || '..............................' }}</p>
              <p class="text-xs text-gray-500">Staff</p>
            </div>
          </div>
          <div class="text-center">
            <p class="text-sm font-medium text-gray-700 mb-16">Disetujui Oleh,</p>
            <div class="border-t border-gray-400 pt-1">
              <p class="text-sm font-semibold text-gray-900">{{ purchaseOrder.approver?.name || '..............................' }}</p>
              <p class="text-xs text-gray-500">Admin</p>
            </div>
          </div>
          <div class="text-center">
            <p class="text-sm font-medium text-gray-700 mb-16">Diterima Oleh,</p>
            <div class="border-t border-gray-400 pt-1">
              <p class="text-sm font-semibold text-gray-900">..............................</p>
              <p class="text-xs text-gray-500">Penerima</p>
            </div>
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
        <button @click="printDocument" class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-3 px-6 rounded-lg shadow-lg transition duration-150">
          <svg class="h-5 w-5 inline mr-2" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M6.72 13.829c-.24.03-.48.062-.72.096m.72-.096a42.415 42.415 0 0110.56 0m-10.56 0L6.34 18m10.94-4.171c.24.03.48.062.72.096m-.72-.096L17.66 18m0 0l.229 2.523a1.125 1.125 0 01-1.12 1.227H7.23a1.125 1.125 0 01-1.12-1.227L6.34 18m11.319 0H6.34m11.319 0l.044.506A1.125 1.125 0 0117.003 20H6.997a1.125 1.125 0 01-1.122-1.494l.044-.506M6.34 18v-4.172c0-.224.03-.447.086-.665A41.4 41.4 0 0112 3c1.83 0 3.597.133 5.28.362.057.218.086.44.086.665v4.172M6.34 18L4.26 7.5h15.48L17.66 18" />
          </svg>
          Cetak
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
import axios from 'axios'

const route = useRoute()
const router = useRouter()

const loading = ref(true)
const purchaseOrder = ref<any>(null)

const ppnPercentage = computed(() => {
  if (!purchaseOrder.value || !purchaseOrder.value.subtotal || purchaseOrder.value.subtotal === 0) return 0
  return Math.round((purchaseOrder.value.ppn / purchaseOrder.value.subtotal) * 100)
})

const fetchPrintData = async () => {
  loading.value = true
  try {
    const id = route.params.id as string
    const token = localStorage.getItem('token')
    
    const response = await axios.get(
      `http://localhost:8000/api/admin/purchase-order/${id}/print`,
      {
        headers: {
          'Authorization': `Bearer ${token}`,
          'Accept': 'application/json'
        }
      }
    )
    
    if (response.data.success) {
      purchaseOrder.value = response.data.data
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

const getStatusLabel = (status: string) => {
  const labels: { [key: string]: string } = {
    'pending': 'Menunggu',
    'approved': 'Disetujui',
    'completed': 'Selesai',
    'rejected': 'Ditolak'
  }
  return labels[status] || status
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
