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
        <div v-if="loading" class="flex justify-center items-center py-12">
          <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
        </div>

        <div v-else-if="salesOrder">
          <!-- Action Buttons -->
          <div class="mb-6 flex flex-col md:flex-row justify-between md:items-center gap-4 print-hidden">
            <button @click="goBack" class="flex items-center space-x-2 text-sm font-medium text-gray-600 hover:text-gray-900 transition duration-150">
              <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
              </svg>
              <span>Kembali ke Riwayat</span>
            </button>
            <button @click="printDocument" class="w-full md:w-auto bg-green-600 hover:bg-green-700 text-white font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150">
              <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M6.72 13.829c-.24.03-.48.062-.72.096m.72-.096a42.415 42.415 0 0110.56 0m-10.56 0L6.34 18m10.94-4.171c.24.03.48.062.72.096m-.72-.096L17.66 18m0 0l.229 2.523a1.125 1.125 0 01-1.12 1.227H7.23a1.125 1.125 0 01-1.12-1.227L6.34 18m11.319 0H6.34m11.319 0l.044.506A1.125 1.125 0 0117.003 20H6.997a1.125 1.125 0 01-1.122-1.494l.044-.506M6.34 18v-4.172c0-.224.03-.447.086-.665A41.4 41.4 0 0112 3c1.83 0 3.597.133 5.28.362.057.218.086.44.086.665v4.172M6.34 18L4.26 7.5h15.48L17.66 18" />
              </svg>
              <span>Cetak Bukti</span>
            </button>
          </div>

          <!-- Printable Area -->
          <div id="printable-area">
            <div class="bg-white rounded-lg shadow-md p-8 md:p-12" id="printable-area-content">
              <!-- Header Document -->
              <div class="flex justify-between items-center border-b-2 border-gray-900 pb-4 mb-8">
                <div>
                  <h1 class="text-3xl font-bold text-gray-900">BUKTI BARANG KELUAR</h1>
                  <p class="text-gray-600">No. Transaksi: {{ salesOrder.no_so }}</p>
                </div>
                <div class="text-right">
                  <h2 class="text-xl font-semibold text-gray-800">PT. Inventori Sukses</h2>
                  <p class="text-sm text-gray-600">Jl. Alamat Kantor No. 123</p>
                  <p class="text-sm text-gray-600">Jakarta, Indonesia</p>
                </div>
              </div>

              <!-- Transaction Info -->
              <div class="grid grid-cols-2 gap-8 mb-8">
                <div>
                  <h3 class="text-sm font-medium text-gray-500 uppercase mb-2">DITERIMA OLEH:</h3>
                  <p class="text-lg font-semibold text-gray-900">{{ salesOrder.customer_name || '-' }}</p>
                  <p class="text-gray-600">{{ salesOrder.customer_address || '-' }}</p>
                  <p class="text-gray-600">Telp: {{ salesOrder.customer_phone || '-' }}</p>
                </div>
                <div>
                  <h3 class="text-sm font-medium text-gray-500 uppercase mb-2">DETAIL:</h3>
                  <p class="text-gray-700"><span class="font-medium">Tanggal Transaksi:</span> {{ formatDate(salesOrder.tgl_order) }}</p>
                  <p class="text-gray-700"><span class="font-medium">Dicatat Oleh:</span> {{ salesOrder.creator?.name || '-' }}</p>
                  <p v-if="salesOrder.catatan" class="text-gray-700"><span class="font-medium">Keterangan:</span> {{ salesOrder.catatan }}</p>
                </div>
              </div>

              <!-- Items Table -->
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
                    <tr v-for="(item, index) in salesOrder.items" :key="item.id">
                      <td class="px-4 py-4 text-sm text-gray-800">{{ item.barang?.kode || '-' }}</td>
                      <td class="px-4 py-4 text-sm font-medium text-gray-900">{{ item.barang?.nama || '-' }}</td>
                      <td class="px-4 py-4 text-sm text-gray-800 text-center">{{ item.qty }} {{ item.barang?.satuan || 'pcs' }}</td>
                      <td class="px-4 py-4 text-sm text-gray-800">-</td>
                    </tr>
                  </tbody>
                </table>
              </div>

              <!-- Signatures -->
              <div class="grid grid-cols-3 gap-8 pt-12">
                <div class="text-center">
                  <p class="text-sm text-gray-700 mb-16">Diserahkan Oleh,</p>
                  <p class="text-sm font-medium text-gray-900">({{ salesOrder.creator?.name || 'Staff Gudang' }})</p>
                  <p class="text-sm text-gray-600">Staff Inventori</p>
                </div>
                <div class="text-center">
                  <p class="text-sm text-gray-700 mb-16">Diterima Oleh,</p>
                  <p class="text-sm font-medium text-gray-900">(...........................)</p>
                  <p class="text-sm text-gray-600">Penerima ({{ salesOrder.customer_name }})</p>
                </div>
                <div class="text-center">
                  <p class="text-sm text-gray-700 mb-16">Diketahui Oleh,</p>
                  <p class="text-sm font-medium text-gray-900">({{ salesOrder.approver?.name || '.........................' }})</p>
                  <p class="text-sm text-gray-600">Manajer / Admin</p>
                </div>
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
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import AdminNavigation from '@/components/AdminNavigation.vue'
import salesOrderService from '@/services/salesOrder.service'

const router = useRouter()
const route = useRoute()

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
  router.push('/admin/sales-orders')
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

const getStatusLabel = (status: string) => {
  const labels: Record<string, string> = {
    pending: 'Pending',
    approved: 'Disetujui',
    rejected: 'Ditolak'
  }
  return labels[status] || status
}

const getStatusBadgeClass = (status: string) => {
  const classes: Record<string, string> = {
    pending: 'bg-yellow-100 text-yellow-800',
    approved: 'bg-green-100 text-green-800',
    rejected: 'bg-red-100 text-red-800'
  }
  return classes[status] || 'bg-gray-100 text-gray-800'
}

const fetchSalesOrder = async () => {
  loading.value = true
  try {
    const id = route.params.id as string
    const response = await salesOrderService.adminGetById(parseInt(id))
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
  
  #printable-area-content {
    box-shadow: none !important;
    border: none !important;
  }
  
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
