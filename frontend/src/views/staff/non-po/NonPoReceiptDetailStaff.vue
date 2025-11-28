<template>
  <div class="bg-gray-100">
    <div v-if="loading" class="flex justify-center items-center py-12">
          <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
        </div>

        <div v-else-if="receiptData">
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
                :to="`/staff/non-po/receipt/${receiptData.id}/print`"
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
                    <h2 class="text-3xl font-bold text-gray-900">PENERIMAAN BARANG (NON-PO)</h2>
                    <p class="text-lg font-semibold text-blue-600">{{ receiptData.no_dokumen }}</p>
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
                    <p class="text-lg font-bold text-gray-900">{{ receiptData.source }}</p>
                    <p v-if="receiptData.notes" class="text-sm text-gray-600">{{ receiptData.notes }}</p>
                  </div>
                  <div class="text-right">
                    <div class="mb-2">
                      <span class="text-sm font-semibold text-gray-500 uppercase">Tanggal Diterima: </span>
                      <span class="text-sm font-medium text-gray-800">{{ formatDate(receiptData.receive_date) }}</span>
                    </div>
                    <div>
                      <span class="text-sm font-semibold text-gray-500 uppercase">Dicatat Oleh: </span>
                      <span class="text-sm font-medium text-gray-800">{{ receiptData.creator?.name || '-' }}</span>
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
                      <tr v-for="(item, index) in receiptData.items" :key="index">
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{{ index + 1 }}.</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ item.nama_barang || '-' }}</td>
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
                          <p class="text-sm text-gray-600">{{ receiptData.notes || '-' }}</p>
                        </td>
                        <td class="px-6 py-4 text-right text-base text-gray-900 uppercase font-semibold">Total Nilai</td>
                        <td class="px-6 py-4 text-right text-base text-gray-900 font-semibold">{{ formatCurrency(receiptData.total_value || 0) }}</td>
                      </tr>
                    </tfoot>
                  </table>
                </div>

                <!-- Tanda Tangan -->
                <div class="grid grid-cols-3 gap-8 pt-6 border-t border-gray-200">
                  <div class="text-center">
                    <p class="text-sm text-gray-700 mb-16">Diterima oleh,</p>
                    <p class="text-sm font-medium text-gray-900 border-t border-gray-400 pt-1">({{ receiptData.creator?.name || 'Staff' }})</p>
                    <p class="text-xs text-gray-500">Staff / Admin</p>
                  </div>
                  <div class="text-center">
                    <p class="text-sm text-gray-700 mb-16">Disetujui oleh,</p>
                    <p class="text-sm font-medium text-gray-900 border-t border-gray-400 pt-1">({{ receiptData.approver?.name || 'Admin' }})</p>
                    <p class="text-xs text-gray-500">Manajer / Owner</p>
                  </div>
                  <div class="text-center">
                    <p class="text-sm text-gray-700 mb-16">Sumber,</p>
                    <p class="text-sm font-medium text-gray-400 border-t border-dashed border-gray-300 pt-1"></p>
                    <p class="text-xs text-gray-700">{{ receiptData.source || '-' }}</p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Kolom Kanan: Info -->
            <div class="lg:col-span-4 space-y-6 print-hidden">
              
              <!-- Info Penerimaan -->
              <div class="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
                <h3 class="text-lg font-semibold text-gray-900 mb-4">Informasi Penerimaan</h3>
                <div class="space-y-3">
                  <div>
                    <dt class="text-sm font-medium text-gray-500">No. Dokumen</dt>
                    <dd class="text-base text-gray-900 font-medium">{{ receiptData.no_dokumen }}</dd>
                  </div>
                  <div>
                    <dt class="text-sm font-medium text-gray-500">Tanggal</dt>
                    <dd class="text-base text-gray-900 font-medium">{{ formatDate(receiptData.receive_date) }}</dd>
                  </div>
                  <div>
                    <dt class="text-sm font-medium text-gray-500">Dicatat Oleh</dt>
                    <dd class="text-base text-gray-900 font-medium">{{ receiptData.creator?.name || '-' }}</dd>
                  </div>
                </div>
              </div>

              <!-- Informasi Sumber -->
              <div class="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
                <h3 class="text-lg font-semibold text-gray-900 mb-4">Info Sumber</h3>
                <dl>
                  <dt class="text-sm font-medium text-gray-500">Sumber Barang</dt>
                  <dd class="text-base text-gray-900 font-medium mb-2">{{ receiptData.source }}</dd>
                  <dt v-if="receiptData.notes" class="text-sm font-medium text-gray-500">Catatan</dt>
                  <dd v-if="receiptData.notes" class="text-base text-gray-900 font-medium">{{ receiptData.notes }}</dd>
                </dl>
              </div>
              
            </div>
          </div>
        </div>

        <div v-else class="text-center py-8">
          <p class="text-gray-600">Data tidak ditemukan</p>
        </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import api from '@/services/api'

const router = useRouter()
const route = useRoute()

interface ReceiptItem {
  barang_id: number
  nama_barang: string
  kode_barang: string
  qty: number
  price?: number
  subtotal?: number
}

interface ReceiptData {
  id: number
  no_dokumen: string
  source: string
  receive_date: string
  notes: string | null
  total_value?: number
  creator: {
    name: string
  } | null
  items: ReceiptItem[]
}

const loading = ref(false)
const receiptData = ref<ReceiptData | null>(null)

const goBack = () => {
  router.push('/staff/incoming-items')
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

const fetchReceiptData = async () => {
  loading.value = true
  try {
    const id = route.params.id as string
    const response = await api.get(`/staff/non-po/receipt/${id}/print`)
    
    if (response.data && response.data.success && response.data.data) {
      const data = response.data.data
      
      // Ensure items is an array
      if (!data.items) {
        data.items = []
      } else if (typeof data.items === 'object' && !Array.isArray(data.items)) {
        data.items = Object.values(data.items)
      }
      
      receiptData.value = data
    }
  } catch (error: any) {
    console.error('Error fetching receipt data:', error)
    alert('Gagal memuat data penerimaan barang')
    router.push('/staff/incoming-items')
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchReceiptData()
})
</script>

<style scoped>
@media print {
  .print-hidden {
    display: none !important;
  }
}
</style>
