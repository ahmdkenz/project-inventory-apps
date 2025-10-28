<template>
  <div class="flex h-screen">
    <!-- Sidebar -->
    <aside class="fixed top-0 left-0 h-full w-64 bg-gray-900 text-gray-300 shadow-lg z-30 transform -translate-x-full lg:translate-x-0 transition-transform duration-300 ease-in-out print-hidden" id="sidebar">
      <div class="p-6 flex items-center space-x-3">
        <svg class="h-10 w-10 text-blue-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" d="M21 7.5l-9-5.25L3 7.5m18 0l-9 5.25m9-5.25v9l-9 5.25M3 7.5l9 5.25M3 7.5v9l9 5.25m0-9v9" />
        </svg>
        <span class="text-white text-2xl font-semibold">Inventori</span>
      </div>
      <StaffNavigation :current-path="$route.path" />
      <div class="absolute bottom-0 left-0 w-full p-4 border-t border-gray-700">
        <div class="flex items-center space-x-3">
          <img class="h-10 w-10 rounded-full" src="https://placehold.co/100x100/EBF8FF/3182CE?text=S" alt="Avatar">
          <div>
            <p class="text-sm font-medium text-white">{{ user?.name || 'Staff' }}</p>
            <p class="text-xs text-gray-400">Staff Gudang</p>
          </div>
        </div>
      </div>
    </aside>

    <div class="fixed inset-0 bg-black bg-opacity-50 z-20 hidden" id="overlay" @click="toggleSidebar"></div>
    
    <div class="flex-1 flex-col transition-all duration-300 ease-in-out lg:ml-64" id="main-content">
      <header class="bg-white shadow-sm p-4 flex items-center justify-between z-10 print-hidden">
        <button class="text-gray-600 lg:hidden" @click="toggleSidebar">
          <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5" />
          </svg>
        </button>
        <div class="relative hidden sm:block">
          <input type="text" class="border border-gray-300 rounded-full py-2 px-4 pl-10" placeholder="Cari...">
          <svg class="h-5 w-5 text-gray-400 absolute left-3 top-2.5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M21 21l-5.197-5.197m0 0A7.5 7.5 0 105.196 5.196a7.5 7.5 0 0010.607 10.607z" />
          </svg>
        </div>
        <div class="flex items-center space-x-4">
          <button class="text-gray-500 hover:text-gray-700 relative">
            <span class="absolute top-0 right-0 h-2 w-2 bg-red-500 rounded-full"></span>
            <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M14.857 17.082a23.848 23.848 0 005.454-1.31A8.967 8.967 0 0118 9.75v-.7V9A6 6 0 006 9v.75a8.967 8.967 0 01-2.312 6.022c1.733.64 3.56 1.085 5.455 1.31m5.714 0a24.255 24.255 0 01-5.714 0m5.714 0a3 3 0 11-5.714 0" />
            </svg>
          </button>
          <div class="relative">
            <button @click="showProfileMenu = !showProfileMenu" class="flex items-center space-x-2">
              <img class="h-9 w-9 rounded-full" src="https://placehold.co/100x100/EBF8FF/3182CE?text=S" alt="Avatar Pengguna">
              <span class="hidden md:block text-sm font-medium text-gray-700">{{ user?.name || 'Staff' }}</span>
            </button>
            <div v-if="showProfileMenu" @click.outside="showProfileMenu = false" class="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg py-1 z-20">
              <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Profil Saya</a>
              <a @click.prevent="handleLogout" href="#" class="block px-4 py-2 text-sm text-red-600 hover:bg-gray-100">Logout</a>
            </div>
          </div>
        </div>
      </header>

      <main class="flex-1 p-6 overflow-y-auto">
        <div v-if="loading" class="flex justify-center items-center py-12">
          <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
        </div>

        <div v-else-if="purchaseOrder">
          <!-- Action Buttons -->
          <div class="flex items-center justify-between mb-6 print-hidden">
            <h1 class="text-3xl font-bold text-gray-900">Detail Purchase Order</h1>
            <div class="flex space-x-3">
              <button @click="goBack" class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150">
                <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5L8.25 12l7.5-7.5" />
                </svg>
                <span>Kembali</span>
              </button>
              <button @click="printDocument" class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150">
                <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M6.72 13.829c-.24.03-.48.062-.72.096m.72-.096a42.415 42.415 0 0110.56 0m-10.56 0L6.34 18m10.94-4.171c.24.03.48.062.72.096m-.72-.096L17.66 18m0 0l.229 2.523a1.125 1.125 0 01-1.12 1.227H7.23a1.125 1.125 0 01-1.12-1.227L6.34 18m11.318 0H6.34m11.319 0l.044.506A1.125 1.125 0 0117.003 20H6.997a1.125 1.125 0 01-1.122-1.494l.044-.506M6.34 18v-4.172c0-.224.03-.447.086-.665A41.4 41.4 0 0112 3c1.83 0 3.597.133 5.28.362.057.218.086.44.086.665v4.172M6.34 18L4.26 7.5h15.48L17.66 18" />
                </svg>
                <span>Cetak PO</span>
              </button>
            </div>
          </div>

          <!-- Printable Area -->
          <div class="max-w-4xl mx-auto bg-white p-8 rounded-lg shadow-lg border border-gray-200" id="printable-area">
            <!-- Header Dokumen -->
            <div class="flex justify-between items-start pb-6 border-b-2 border-gray-900">
              <div>
                <h2 class="text-3xl font-bold text-gray-900">PURCHASE ORDER</h2>
                <p class="text-lg font-semibold text-blue-600">{{ purchaseOrder.no_po }}</p>
                <span :class="getStatusBadgeClass(purchaseOrder.status)" class="inline-block px-3 py-1 text-xs font-semibold rounded-full mt-2">
                  {{ getStatusLabel(purchaseOrder.status) }}
                </span>
              </div>
              <div class="text-right">
                <img src="https://placehold.co/150x50/000000/FFFFFF?text=LOGO+PERUSAHAAN" alt="Logo Perusahaan" class="h-12 mb-2 ml-auto">
                <p class="text-sm font-semibold text-gray-800">Nama Perusahaan Anda</p>
                <p class="text-sm text-gray-600">Jl. Jend. Sudirman No. 1, Jakarta</p>
                <p class="text-sm text-gray-600">Telepon: (021) 123456</p>
              </div>
            </div>

            <!-- Info PO dan Supplier -->
            <div class="grid grid-cols-2 gap-8 my-6">
              <div>
                <p class="text-sm font-semibold text-gray-500 uppercase mb-2">DITUJUKAN KEPADA:</p>
                <p class="text-lg font-bold text-gray-900">{{ purchaseOrder.supplier?.nama || '-' }}</p>
                <p class="text-sm text-gray-600">{{ purchaseOrder.supplier?.alamat || '-' }}</p>
                <p class="text-sm text-gray-600">{{ purchaseOrder.supplier?.telepon || '-' }}</p>
                <p v-if="purchaseOrder.supplier?.contact_person" class="text-sm text-gray-600">UP: {{ purchaseOrder.supplier.contact_person }}</p>
              </div>
              <div class="text-right">
                <div class="mb-2">
                  <span class="text-sm font-semibold text-gray-500 uppercase">Tanggal PO: </span>
                  <span class="text-sm font-medium text-gray-800">{{ formatDate(purchaseOrder.tgl_pesan) }}</span>
                </div>
                <div>
                  <span class="text-sm font-semibold text-gray-500 uppercase">Estimasi Tiba: </span>
                  <span class="text-sm font-medium text-gray-800">{{ formatDate(purchaseOrder.tgl_estimasi) }}</span>
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
                  <tr v-for="(item, index) in purchaseOrder.items" :key="item.id">
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{{ index + 1 }}.</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ item.barang?.nama || '-' }}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600 text-center">{{ item.qty }}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600 text-right">{{ formatCurrency(item.harga_satuan) }}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900 text-right">{{ formatCurrency(item.subtotal || 0) }}</td>
                  </tr>
                </tbody>
                <!-- Footer Kalkulasi -->
                <tfoot class="bg-gray-100 border-t-2 border-gray-300">
                  <tr>
                    <td colspan="4" class="px-6 py-3 text-right text-sm font-medium text-gray-800">Subtotal</td>
                    <td class="px-6 py-3 text-right text-sm font-bold text-gray-900">{{ formatCurrency(purchaseOrder.subtotal || 0) }}</td>
                  </tr>
                  <tr>
                    <td colspan="4" class="px-6 py-3 text-right text-sm font-medium text-gray-800">PPN ({{ ppnPercent }}%)</td>
                    <td class="px-6 py-3 text-right text-sm font-bold text-gray-900">{{ formatCurrency(purchaseOrder.ppn || 0) }}</td>
                  </tr>
                  <tr class="text-base">
                    <td colspan="4" class="px-6 py-4 text-right font-bold text-gray-900 uppercase">Total</td>
                    <td class="px-6 py-4 text-right font-bold text-gray-900">{{ formatCurrency(purchaseOrder.total || 0) }}</td>
                  </tr>
                </tfoot>
              </table>
            </div>

            <!-- Catatan dan Tanda Tangan -->
            <div class="grid grid-cols-2 gap-8 pt-6 border-t border-gray-200">
              <div>
                <p class="text-sm font-semibold text-gray-500 uppercase mb-2">Catatan:</p>
                <p class="text-sm text-gray-600">{{ purchaseOrder.catatan || 'Mohon sertakan No. PO pada surat jalan Anda.' }}</p>
              </div>
              <div class="grid grid-cols-2 gap-4 text-center">
                <div>
                  <p class="text-sm text-gray-700 mb-16">Dibuat oleh,</p>
                  <p class="text-sm font-medium text-gray-900 border-t border-gray-400 pt-1">{{ purchaseOrder.creator?.name || 'Staff' }}</p>
                  <p class="text-xs text-gray-500">Staff Pembelian</p>
                </div>
                <div>
                  <p class="text-sm text-gray-700 mb-16">Disetujui oleh,</p>
                  <p class="text-sm font-medium text-gray-900 border-t border-gray-400 pt-1">(Manajer)</p>
                  <p class="text-xs text-gray-500">Manajer Operasional</p>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div v-else class="text-center py-12">
          <p class="text-gray-500">Purchase Order tidak ditemukan</p>
        </div>
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import StaffNavigation from '@/components/StaffNavigation.vue'
import purchaseOrderService from '@/services/purchaseOrder.service'

const router = useRouter()
const route = useRoute()

const loading = ref(false)
const purchaseOrder = ref<any>(null)
const showProfileMenu = ref(false)
const user = ref<any>(null)

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

const handleLogout = () => {
  localStorage.removeItem('token')
  localStorage.removeItem('user')
  router.push('/login')
}

const goBack = () => {
  router.push('/staff/purchase-orders')
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

const formatDate = (dateString: string) => {
  if (!dateString) return '-'
  const date = new Date(dateString)
  return date.toLocaleDateString('id-ID', { day: 'numeric', month: 'long', year: 'numeric' })
}

const getStatusBadgeClass = (status: string) => {
  const classes: any = {
    'pending': 'bg-yellow-100 text-yellow-800',
    'approved': 'bg-green-100 text-green-800',
    'rejected': 'bg-red-100 text-red-800',
    'completed': 'bg-blue-100 text-blue-800'
  }
  return classes[status] || 'bg-gray-100 text-gray-800'
}

const getStatusLabel = (status: string) => {
  const labels: any = {
    'pending': 'Menunggu Persetujuan',
    'approved': 'Disetujui',
    'rejected': 'Ditolak',
    'completed': 'Selesai'
  }
  return labels[status] || status
}

const fetchPurchaseOrder = async () => {
  const id = parseInt(route.params.id as string)
  if (!id) {
    router.push('/staff/purchase-orders')
    return
  }

  loading.value = true
  try {
    const response = await purchaseOrderService.getById(id)
    if (response.success && !Array.isArray(response.data)) {
      purchaseOrder.value = response.data
    } else {
      router.push('/staff/purchase-orders')
    }
  } catch (error: any) {
    console.error('Error fetching purchase order:', error)
    router.push('/staff/purchase-orders')
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
  body > * {
    display: none;
  }
  
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
