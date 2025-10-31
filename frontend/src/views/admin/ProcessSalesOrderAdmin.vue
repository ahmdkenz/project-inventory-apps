<template>
  <div class="flex h-screen bg-gray-100">
    <AdminNavigation :current-path="$route.path" />
    
    <div class="flex-1 flex flex-col lg:ml-64">
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
        <!-- Loading State -->
        <div v-if="loading" class="flex justify-center items-center py-12">
          <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
        </div>

        <div v-else>
          <!-- Tombol Aksi Atas -->
          <div class="flex items-center justify-between mb-6 print-hidden">
            <h1 class="text-3xl font-bold text-gray-900">Proses Pengeluaran Barang</h1>
            <div class="flex space-x-3">
              <button @click="goBack" class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150">
                <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5L8.25 12l7.5-7.5" />
                </svg>
                <span>Kembali</span>
              </button>
              <button @click="printDocument" class="bg-green-600 hover:bg-green-700 text-white font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150">
                <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M6.72 13.829c-.24.03-.48.062-.72.096m.72-.096a42.415 42.415 0 0110.56 0m-10.56 0L6.34 18m10.94-4.171c.24.03.48.062.72.096m-.72-.096L17.66 18m0 0l.229 2.523a1.125 1.125 0 01-1.12 1.227H7.23a1.125 1.125 0 01-1.12-1.227L6.34 18m11.319 0H6.34m11.319 0l.044.506A1.125 1.125 0 0117.003 20H6.997a1.125 1.125 0 01-1.122-1.494l.044-.506M6.34 18v-4.172c0-.224.03-.447.086-.665A41.4 41.4 0 0112 3c1.83 0 3.597.133 5.28.362.057.218.086.44.086.665v4.172M6.34 18L4.26 7.5h15.48L17.66 18" />
                </svg>
                <span>Cetak Bukti</span>
              </button>
            </div>
          </div>

          <!-- Area Cetak -->
          <div id="printable-area" class="max-w-6xl">
            <div class="bg-white rounded-lg shadow-sm p-8 md:p-12" id="printable-area-content">
              <!-- Header Dokumen -->
              <div class="flex justify-between items-center border-b-2 border-gray-900 pb-4 mb-8">
                <div>
                  <h1 class="text-3xl font-bold text-gray-900">BUKTI BARANG KELUAR</h1>
                  <p class="text-gray-600">No. Transaksi: {{ generateDocNumber() }}</p>
                </div>
                <div class="text-right">
                  <h2 class="text-xl font-semibold text-gray-800">Nama Perusahaan Anda</h2>
                  <p class="text-sm text-gray-600">Jl. Alamat Kantor No. 123</p>
                  <p class="text-sm text-gray-600">Jakarta, Indonesia</p>
                </div>
              </div>

              <!-- Info Transaksi -->
              <div class="grid grid-cols-2 gap-8 mb-8">
                <div>
                  <h3 class="text-sm font-medium text-gray-500 uppercase mb-2">DITERIMA OLEH:</h3>
                  <p class="text-lg font-semibold text-gray-900">{{ salesOrder.customer_name }}</p>
                  <p class="text-gray-600">{{ salesOrder.customer_address || '-' }}</p>
                </div>
                <div>
                  <h3 class="text-sm font-medium text-gray-500 uppercase mb-2">DETAIL:</h3>
                  <p class="text-gray-700"><span class="font-medium">Tanggal Transaksi:</span> {{ formatDate(new Date().toISOString()) }}</p>
                  <p class="text-gray-700"><span class="font-medium">Referensi SO:</span> {{ salesOrder.no_so }}</p>
                  <p class="text-gray-700"><span class="font-medium">Dicatat Oleh:</span> {{ user?.name || 'Admin' }}</p>
                  <p v-if="catatan" class="text-gray-700"><span class="font-medium">Keterangan:</span> {{ catatan }}</p>
                </div>
              </div>

              <!-- Tabel Detail Barang (Tanpa Harga) -->
              <div class="overflow-x-auto mb-8">
                <table class="w-full min-w-max">
                  <thead class="border-b border-gray-300">
                    <tr>
                      <th class="px-4 py-3 text-left text-sm font-medium text-gray-600 uppercase">Kode</th>
                      <th class="px-4 py-3 text-left text-sm font-medium text-gray-600 uppercase">Nama Barang</th>
                      <th class="px-4 py-3 text-center text-sm font-medium text-gray-600 uppercase">Jumlah</th>
                      <th class="px-4 py-3 text-left text-sm font-medium text-gray-600 uppercase">Keterangan Item</th>
                    </tr>
                  </thead>
                  <tbody class="divide-y divide-gray-200">
                    <tr v-for="(item, index) in processItems" :key="item.id">
                      <td class="px-4 py-4 text-sm text-gray-800">{{ item.barang?.kode || '-' }}</td>
                      <td class="px-4 py-4 text-sm font-medium text-gray-900">{{ item.barang?.nama }}</td>
                      <td class="px-4 py-4 text-sm text-gray-800 text-center">
                        <input
                          type="number"
                          v-model.number="item.qty_issued"
                          :max="item.qty"
                          min="0"
                          class="w-20 rounded-md border-gray-300 shadow-sm p-1 focus:border-blue-500 focus:ring-blue-500 text-center text-sm print-hide-input"
                          @input="validateQty(index)"
                        />
                        <span class="print-show-value hidden">{{ item.qty_issued }}</span>
                      </td>
                      <td class="px-4 py-4 text-sm text-gray-800">
                        <input
                          type="text"
                          v-model="item.catatan"
                          placeholder="-"
                          class="w-full rounded-md border-gray-300 shadow-sm p-1 focus:border-blue-500 focus:ring-blue-500 text-sm print-hide-input"
                        />
                        <span class="print-show-value hidden">{{ item.catatan || '-' }}</span>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>

              <!-- Catatan Umum (Non-Printable) -->
              <div class="mb-8 print-hidden">
                <label class="block text-sm font-medium text-gray-700 mb-2">Catatan Pengeluaran</label>
                <textarea
                  v-model="catatan"
                  rows="3"
                  class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                  placeholder="Catatan umum untuk pengeluaran barang ini..."
                ></textarea>
              </div>

              <!-- Tanda Tangan Disesuaikan -->
              <div class="grid grid-cols-3 gap-8 pt-12">
                <div class="text-center">
                  <p class="text-sm text-gray-700 mb-16">Diserahkan Oleh,</p>
                  <p class="text-sm font-medium text-gray-900">({{ user?.name || 'Staff Gudang' }})</p>
                  <p class="text-sm text-gray-600">Staff Inventori</p>
                </div>
                <div class="text-center">
                  <p class="text-sm text-gray-700 mb-16">Diterima Oleh,</p>
                  <p class="text-sm font-medium text-gray-900">(...........................)</p>
                  <p class="text-sm text-gray-600">Penerima ({{ salesOrder.customer_name }})</p>
                </div>
                <div class="text-center">
                  <p class="text-sm text-gray-700 mb-16">Diketahui Oleh,</p>
                  <p class="text-sm font-medium text-gray-900">(...........................)</p>
                  <p class="text-sm text-gray-600">Manajer / Admin</p>
                </div>
              </div>

              <!-- Tombol Aksi (Non-Printable) -->
              <div class="flex justify-end space-x-3 mt-8 print-hidden">
                <router-link
                  to="/admin/sales-orders"
                  class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 font-medium py-2 px-6 rounded-lg transition duration-150"
                >
                  Batal
                </router-link>
                <button
                  @click="submitProcess"
                  :disabled="!isValid"
                  class="bg-green-600 hover:bg-green-700 text-white font-medium py-2 px-6 rounded-lg transition duration-150 disabled:bg-gray-400 disabled:cursor-not-allowed"
                >
                  Proses & Keluarkan Barang
                </button>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed, onUnmounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import AdminNavigation from '@/components/AdminNavigation.vue'
import salesOrderService, { type SalesOrder } from '@/services/salesOrder.service'

const router = useRouter()
const route = useRoute()

const loading = ref(false)
const salesOrder = ref<SalesOrder>({
  no_so: '',
  customer_name: '',
  tgl_order: '',
  tgl_kirim: '',
  status: 'pending',
  items: []
})

const processItems = ref<any[]>([])
const catatan = ref('')

// User data
const user = ref<{ name: string; role: string } | null>(null)

// Load user data
const loadUserData = () => {
  const userData = localStorage.getItem('user')
  if (userData) {
    user.value = JSON.parse(userData)
  }
}

// Sidebar toggle
const toggleSidebar = () => {
  const sidebar = document.getElementById('sidebar')
  const overlay = document.getElementById('overlay')
  if (sidebar && overlay) {
    sidebar.classList.toggle('-translate-x-full')
    overlay.classList.toggle('hidden')
  }
}

const formatDate = (dateString: string) => {
  const date = new Date(dateString)
  return date.toLocaleDateString('id-ID', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  })
}

const generateDocNumber = () => {
  const date = new Date()
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  const random = String(Math.floor(Math.random() * 1000)).padStart(3, '0')
  return `OUT-${year}${month}${day}-${random}`
}

const goBack = () => {
  router.push('/admin/sales-orders')
}

const printDocument = () => {
  window.print()
}

const validateQty = (index: number) => {
  const item = processItems.value[index]
  if (item.qty_issued > item.qty) {
    item.qty_issued = item.qty
  }
  if (item.qty_issued < 0) {
    item.qty_issued = 0
  }
}

const isValid = computed(() => {
  return processItems.value.every(item => item.qty_issued > 0)
})

const fetchSalesOrder = async () => {
  loading.value = true
  try {
    const id = parseInt(route.params.id as string)
    const response = await salesOrderService.adminGetById(id)
    
    if (response.success && !Array.isArray(response.data)) {
      salesOrder.value = response.data
      
      // Check if status is approved
      if (salesOrder.value.status !== 'approved') {
        alert('Sales Order ini tidak dapat diproses')
        router.push('/admin/sales-orders')
        return
      }
      
      // Initialize process items with qty_issued
      processItems.value = salesOrder.value.items.map(item => ({
        ...item,
        qty_issued: item.qty, // Default to full quantity
        catatan: ''
      }))
    }
  } catch (error) {
    console.error('Error fetching sales order:', error)
    alert('Gagal memuat data sales order')
  } finally {
    loading.value = false
  }
}

const submitProcess = async () => {
  if (!isValid.value) {
    alert('Pastikan semua jumlah dikeluarkan terisi dengan benar')
    return
  }

  if (!confirm('Apakah Anda yakin ingin memproses pengeluaran barang ini?')) {
    return
  }

  loading.value = true
  try {
    const id = parseInt(route.params.id as string)
    const data = {
      items: processItems.value.map(item => ({
        item_id: item.id!,
        barang_id: item.barang_id,
        qty_issued: item.qty_issued
      })),
      catatan: catatan.value
    }

    const response = await salesOrderService.process(id, data)
    
    if (response.success) {
      alert('Pengeluaran barang berhasil diproses!')
      router.push('/admin/sales-orders')
    } else {
      alert(response.message || 'Gagal memproses pengeluaran barang')
    }
  } catch (error: any) {
    console.error('Error processing sales order:', error)
    alert(error.response?.data?.message || 'Gagal memproses pengeluaran barang')
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadUserData()
  fetchSalesOrder()
})
</script>

<style scoped>
/* CSS untuk Print */
@media print {
  /* Sembunyikan semua elemen kecuali area cetak */
  body > * {
    display: none;
  }
  
  #non-printable-area,
  .print-hidden {
    display: none !important;
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

  /* Hide inputs and show values when printing */
  .print-hide-input {
    display: none !important;
  }

  .print-show-value {
    display: inline !important;
  }
}
</style>
