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
      <Header @toggle-sidebar="toggleSidebar" />

      <main class="flex-1 p-6 overflow-y-auto">
        <div v-if="loading" class="flex justify-center items-center py-12">
          <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
        </div>

        <div v-else-if="purchaseOrder">
          <!-- Tombol Aksi (Kembali & Cetak) -->
          <div class="mb-6 flex flex-col md:flex-row justify-between md:items-center gap-4 print-hidden">
            <button @click="goBack" class="flex items-center space-x-2 text-sm font-medium text-gray-600 hover:text-gray-900 transition duration-150">
              <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7" />
              </svg>
              <span>Kembali ke Daftar PO</span>
            </button>
            <button @click="printDocument" class="w-full md:w-auto bg-green-600 hover:bg-green-700 text-white font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150">
              <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M6.72 13.829c-.24.03-.48.062-.72.096m.72-.096a42.415 42.415 0 0110.56 0m-10.56 0L6.34 18m10.94-4.171c.24.03.48.062.72.096m-.72-.096L17.66 18m0 0l.229 2.523a1.125 1.125 0 01-1.12 1.227H7.23a1.125 1.125 0 01-1.12-1.227L6.34 18m11.319 0H6.34m11.319 0l.044.506A1.125 1.125 0 0117.003 20H6.997a1.125 1.125 0 01-1.122-1.494l.044-.506M6.34 18v-4.172c0-.224.03-.447.086-.665A41.4 41.4 0 0112 3c1.83 0 3.597.133 5.28.362.057.218.086.44.086.665v4.172M6.34 18L4.26 7.5h15.48L17.66 18" />
              </svg>
              <span>Cetak Bukti</span>
            </button>
          </div>

          <!-- Area Cetak -->
          <div id="printable-area">
            <div class="bg-white rounded-lg shadow-md p-8 md:p-12" id="printable-area-content">
              <!-- Header Dokumen -->
              <div class="flex justify-between items-center border-b-2 border-gray-900 pb-4 mb-8">
                <div>
                  <h1 class="text-3xl font-bold text-gray-900">BUKTI PENERIMAAN BARANG</h1>
                  <p class="text-gray-600">No. Penerimaan: {{ generateReceiptNumber(purchaseOrder.id) }}</p>
                  <p class="text-gray-600">
                    Ref. PO: 
                    <router-link :to="`/admin/purchase-orders/detail/${purchaseOrder.id}`" class="text-blue-600 hover:underline">
                      {{ purchaseOrder.no_po }}
                    </router-link>
                  </p>
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
                  <h3 class="text-sm font-medium text-gray-500 uppercase mb-2">DITERIMA DARI (SUPPLIER):</h3>
                  <p class="text-lg font-semibold text-gray-900">{{ purchaseOrder.supplier?.nama || '-' }}</p>
                  <p class="text-gray-600">{{ purchaseOrder.supplier?.alamat || '-' }}</p>
                </div>
                <div>
                  <h3 class="text-sm font-medium text-gray-500 uppercase mb-2">DETAIL:</h3>
                  <p class="text-gray-700"><span class="font-medium">Tanggal Diterima:</span> {{ formatDate(new Date()) }}</p>
                  <p class="text-gray-700"><span class="font-medium">Dicatat Oleh:</span> {{ user?.name || 'Admin' }}</p>
                  <p class="text-gray-700"><span class="font-medium">No. Surat Jalan:</span> <input v-model="receiveData.no_surat_jalan" type="text" class="border-b border-gray-300 px-1 print-hidden" placeholder="Masukkan No. Surat Jalan"></p>
                </div>
              </div>

              <!-- Tabel Detail Barang -->
              <div class="overflow-x-auto mb-8">
                <table class="w-full min-w-max">
                  <thead class="border-b border-gray-300">
                    <tr>
                      <th class="px-4 py-3 text-left text-sm font-medium text-gray-600 uppercase">Nama Barang</th>
                      <th class="px-4 py-3 text-center text-sm font-medium text-gray-600 uppercase">Dipesan</th>
                      <th class="px-4 py-3 text-center text-sm font-medium text-gray-600 uppercase">Diterima</th>
                      <th class="px-4 py-3 text-right text-sm font-medium text-gray-600 uppercase">Harga Satuan</th>
                      <th class="px-4 py-3 text-right text-sm font-medium text-gray-600 uppercase">Subtotal</th>
                    </tr>
                  </thead>
                  <tbody class="divide-y divide-gray-200">
                    <tr v-for="(item, index) in receiveData.items" :key="index">
                      <td class="px-4 py-4 text-sm font-medium text-gray-900">{{ item.barang?.nama || '-' }}</td>
                      <td class="px-4 py-4 text-sm text-gray-800 text-center">{{ item.qty }}</td>
                      <td class="px-4 py-4 text-sm font-bold text-gray-900 text-center">
                        <!-- Non-editable display: show only the number without unit, no input box -->
                        <span class="text-center">{{ item.received_qty }}</span>
                      </td>
                      <td class="px-4 py-4 text-sm text-gray-800 text-right">{{ formatCurrency(item.harga_satuan) }}</td>
                      <td class="px-4 py-4 text-sm font-medium text-gray-900 text-right">{{ formatCurrency(item.subtotal || 0) }}</td>
                    </tr>
                  </tbody>
                  <!-- Total -->
                  <tfoot class="border-t-2 border-gray-300">
                    <tr>
                      <td colspan="4" class="px-4 py-3 text-right text-sm font-medium text-gray-600 uppercase">Subtotal</td>
                      <td class="px-4 py-3 text-right text-sm font-semibold text-gray-900">{{ formatCurrency(purchaseOrder.subtotal || 0) }}</td>
                    </tr>
                    <tr>
                      <td colspan="4" class="px-4 py-3 text-right text-sm font-medium text-gray-600 uppercase">PPN ({{ ppnPercent }}%)</td>
                      <td class="px-4 py-3 text-right text-sm font-semibold text-gray-900">{{ formatCurrency(purchaseOrder.ppn || 0) }}</td>
                    </tr>
                    <tr class="bg-gray-50">
                      <td colspan="4" class="px-4 py-3 text-right text-base font-bold text-gray-900 uppercase">Grand Total</td>
                      <td class="px-4 py-3 text-right text-base font-bold text-gray-900">{{ formatCurrency(purchaseOrder.total || 0) }}</td>
                    </tr>
                  </tfoot>
                </table>
              </div>

              <!-- Tanda Tangan -->
              <div class="grid grid-cols-3 gap-8 pt-12">
                <div class="text-center">
                  <p class="text-sm text-gray-700 mb-16">Diserahkan Oleh,</p>
                  <p class="text-sm font-medium text-gray-900">(...........................)</p>
                  <p class="text-sm text-gray-600">Kurir Supplier</p>
                </div>
                <div class="text-center">
                  <p class="text-sm text-gray-700 mb-16">Diterima Oleh,</p>
                  <p class="text-sm font-medium text-gray-900">({{ user?.name || 'Admin' }})</p>
                  <p class="text-sm text-gray-600">Staff Inventori</p>
                </div>
                <div class="text-center">
                  <p class="text-sm text-gray-700 mb-16">Diketahui Oleh,</p>
                  <p class="text-sm font-medium text-gray-900">(...........................)</p>
                  <p class="text-sm text-gray-600">Manajer / Admin</p>
                </div>
              </div>
            </div>
          </div> <!-- End #printable-area -->

          <!-- Tombol Simpan (Non-Print) -->
          <div class="mt-6 flex justify-end print-hidden">
            <button 
              @click="saveReceive" 
              :disabled="saving"
              class="bg-blue-600 hover:bg-blue-700 disabled:bg-gray-400 text-white font-medium py-2 px-6 rounded-lg transition duration-150"
            >
              <span v-if="saving">Menyimpan...</span>
              <span v-else>Simpan Penerimaan Barang</span>
            </button>
          </div>
        </div>

        <div v-else class="text-center py-12">
          <p class="text-gray-500">Purchase Order tidak ditemukan</p>
        </div>

        <Footer />
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import AdminNavigation from '@/components/AdminNavigation.vue'
import Header from '@/components/Header.vue'
import Footer from '@/components/Footer.vue'
import purchaseOrderService from '@/services/purchaseOrder.service'

const router = useRouter()
const route = useRoute()

const loading = ref(false)
const saving = ref(false)
const purchaseOrder = ref<any>(null)
const user = ref<any>(null)

const receiveData = ref({
  no_surat_jalan: '',
  items: [] as any[]
})

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
  router.push('/admin/purchase-orders')
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

const formatDate = (date: Date | string) => {
  if (!date) return '-'
  return new Date(date).toLocaleDateString('id-ID', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  })
}

// Generate No. Penerimaan dengan format IN-YYYYMMDD-{PO_ID}
const generateReceiptNumber = (poId: number, date: Date = new Date()) => {
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  return `IN-${year}${month}${day}-${poId}`
}

const validateReceivedQty = (item: any) => {
  if (item.received_qty > item.qty) {
    item.received_qty = item.qty
    alert(`Jumlah diterima tidak boleh lebih dari jumlah yang dipesan (${item.qty})`)
  }
  if (item.received_qty < 0) {
    item.received_qty = 0
  }
}

const saveReceive = async () => {
  // Validasi
  if (!receiveData.value.no_surat_jalan.trim()) {
    alert('Nomor Surat Jalan harus diisi')
    return
  }

  const hasInvalidQty = receiveData.value.items.some(item => {
    return item.received_qty === null || item.received_qty === undefined || item.received_qty < 0
  })

  if (hasInvalidQty) {
    alert('Semua jumlah barang yang diterima harus diisi dengan benar')
    return
  }

  saving.value = true
  try {
    const payload = {
      no_surat_jalan: receiveData.value.no_surat_jalan,
      items: receiveData.value.items.map(item => ({
        item_id: item.id,
        barang_id: item.barang_id,
        received_qty: item.received_qty
      }))
    }

    const response = await purchaseOrderService.receive(purchaseOrder.value.id, payload)
    
    if (response.success) {
      alert('Penerimaan barang berhasil disimpan!')
      router.push('/admin/purchase-orders')
    } else {
      alert(response.message || 'Gagal menyimpan penerimaan barang')
    }
  } catch (error: any) {
    console.error('Error saving receive:', error)
    alert(error.response?.data?.message || 'Terjadi kesalahan saat menyimpan data')
  } finally {
    saving.value = false
  }
}

const fetchPurchaseOrder = async () => {
  loading.value = true
  try {
    const id = route.params.id as string
    const response = await purchaseOrderService.adminGetById(parseInt(id))
    
    if (response.success && !Array.isArray(response.data)) {
      purchaseOrder.value = response.data
      
      // Initialize receive data dengan qty dari PO
      receiveData.value.items = purchaseOrder.value.items.map((item: any) => ({
        ...item,
        received_qty: item.qty // Default: semua barang diterima
      }))
    }
  } catch (error: any) {
    console.error('Error fetching purchase order:', error)
    alert('Gagal memuat data PO')
    router.push('/admin/purchase-orders')
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  const userData = localStorage.getItem('user')
  if (userData) {
    user.value = JSON.parse(userData)
  }
  fetchPurchaseOrder()
})
</script>

<style scoped>
@media print {
  /* Sembunyikan semua elemen kecuali area cetak */
  body > * {
    display: none;
  }
  
  .print-hidden {
    display: none !important;
  }
  
  #main-content {
    margin-left: 0 !important;
  }
  
  #printable-area {
    display: block !important;
    margin: 0;
    padding: 0;
    width: 100%;
    font-size: 12pt;
    color: #000;
  }
  
  /* Pastikan tidak ada bayangan atau border saat cetak */
  #printable-area-content {
    box-shadow: none !important;
    border: none !important;
  }
  
  /* Hindari tabel terpotong */
  tr, td, th {
    page-break-inside: avoid;
  }
  
  thead {
    display: table-header-group;
  }
  
  tfoot {
    display: table-footer-group;
  }
}
</style>
