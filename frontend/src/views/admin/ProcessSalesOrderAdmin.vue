<template>
  <div class="flex h-screen">
    <!-- Sidebar -->
    <aside class="fixed top-0 left-0 h-full w-64 bg-gray-900 text-gray-300 shadow-lg z-30 transform -translate-x-full lg:translate-x-0 transition-transform duration-300 ease-in-out" id="sidebar">
      <!-- Logo/Header Sidebar -->
      <div class="p-6 flex items-center space-x-3">
        <svg class="h-10 w-10 text-blue-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" d="M21 7.5l-9-5.25L3 7.5m18 0l-9 5.25m9-5.25v9l-9 5.25M3 7.5l9 5.25M3 7.5v9l9 5.25m0-9v9" />
        </svg>
        <span class="text-white text-2xl font-semibold">Inventori</span>
      </div>
      
      <!-- Menu Navigasi Admin -->
      <AdminNavigation :current-path="$route.path"></AdminNavigation>
      
      <!-- User Info di Bawah Sidebar -->
      <div class="absolute bottom-0 left-0 w-full p-4 border-t border-gray-700">
        <div class="flex items-center space-x-3">
          <img class="h-10 w-10 rounded-full" src="https://placehold.co/100x100/EBF8FF/3182CE?text=A" alt="Avatar Pengguna">
          <div>
            <p class="text-sm font-medium text-white">{{ user?.name || 'Admin' }}</p>
            <p class="text-xs text-gray-400">Administrator</p>
          </div>
        </div>
      </div>
    </aside>

    <!-- Latar belakang overlay untuk mobile -->
    <div class="fixed inset-0 bg-black bg-opacity-50 z-20 hidden" id="overlay"></div>
    
    <!-- Konten Utama -->
    <div class="flex-1 flex flex-col transition-all duration-300 ease-in-out lg:ml-64" id="main-content">
      <!-- Header/Navbar Atas -->
      <header class="bg-white shadow-sm p-4 flex items-center justify-between z-10">
        <!-- Tombol Hamburger (Mobile) -->
        <button id="hamburger-btn" class="text-gray-600 lg:hidden" @click="toggleSidebar">
          <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5" />
          </svg>
        </button>
        
        <!-- Search Bar -->
        <div class="relative hidden sm:block">
          <input type="text" class="border border-gray-300 rounded-full py-2 px-4 pl-10" placeholder="Cari...">
          <svg class="h-5 w-5 text-gray-400 absolute left-3 top-2.5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M21 21l-5.197-5.197m0 0A7.5 7.5 0 105.196 5.196a7.5 7.5 0 0010.607 10.607z" />
          </svg>
        </div>
        
        <!-- User Profile dan Notifikasi -->
        <div class="flex items-center space-x-4">
          <!-- Notifikasi -->
          <button class="text-gray-500 hover:text-gray-700 relative">
            <span class="absolute top-0 right-0 h-2 w-2 bg-red-500 rounded-full"></span>
            <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M14.857 17.082a23.848 23.848 0 005.454-1.31A8.967 8.967 0 0118 9.75v-.7V9A6 6 0 006 9v.75a8.967 8.967 0 01-2.312 6.022c1.733.64 3.56 1.085 5.455 1.31m5.714 0a24.255 24.255 0 01-5.714 0m5.714 0a3 3 0 11-5.714 0" />
            </svg>
          </button>
          
          <!-- Profile Dropdown -->
          <div class="relative" ref="profileRef">
            <button @click="toggleProfileMenu" class="flex items-center space-x-2">
              <img class="h-9 w-9 rounded-full" src="https://placehold.co/100x100/EBF8FF/3182CE?text=A" alt="Avatar Pengguna">
              <span class="hidden md:block text-sm font-medium text-gray-700">{{ user?.name || 'Admin' }}</span>
            </button>
            <div v-show="showProfileMenu" class="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg py-1 z-20">
              <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Profil Saya</a>
              <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Pengaturan</a>
              <hr class="my-1">
              <a href="#" @click.prevent="handleLogout" class="block px-4 py-2 text-sm text-red-600 hover:bg-gray-100">Logout</a>
            </div>
          </div>
        </div>
      </header>

      <!-- Konten Halaman -->
      <main class="flex-1 p-6 overflow-y-auto">
        <!-- Loading State -->
        <div v-if="loading" class="flex justify-center items-center py-12">
          <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
        </div>

        <div v-else>
          <!-- Tombol Aksi Atas -->
          <div class="flex items-center justify-between mb-6">
            <h1 class="text-3xl font-bold text-gray-900">Proses Pengeluaran Barang</h1>
            <div class="flex space-x-3">
              <router-link
                to="/admin/sales-orders"
                class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150"
              >
                <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5L8.25 12l7.5-7.5" />
                </svg>
                <span>Kembali</span>
              </router-link>
            </div>
          </div>

          <!-- Info SO -->
          <div class="bg-white rounded-lg shadow-sm p-6 mb-6">
            <div class="grid grid-cols-2 gap-6">
              <div>
                <h3 class="text-sm font-medium text-gray-500 uppercase mb-2">REFERENSI SALES ORDER:</h3>
                <p class="text-xl font-bold text-blue-600">{{ salesOrder.no_so }}</p>
                <p class="text-sm text-gray-600 mt-1">Tanggal: {{ formatDate(salesOrder.tgl_order) }}</p>
              </div>
              <div>
                <h3 class="text-sm font-medium text-gray-500 uppercase mb-2">PENERIMA:</h3>
                <p class="text-lg font-semibold text-gray-900">{{ salesOrder.customer_name }}</p>
                <p class="text-sm text-gray-600">{{ salesOrder.customer_address || '-' }}</p>
              </div>
            </div>
          </div>

          <!-- Form Pengeluaran Barang -->
          <div class="bg-white rounded-lg shadow-sm p-6">
            <h2 class="text-xl font-semibold text-gray-900 mb-4">Detail Barang</h2>
            
            <!-- Tabel Items -->
            <div class="overflow-x-auto mb-6">
              <table class="w-full min-w-max">
                <thead class="border-b border-gray-300">
                  <tr>
                    <th class="px-4 py-3 text-left text-sm font-medium text-gray-600 uppercase">Kode</th>
                    <th class="px-4 py-3 text-left text-sm font-medium text-gray-600 uppercase">Nama Barang</th>
                    <th class="px-4 py-3 text-center text-sm font-medium text-gray-600 uppercase">Jumlah Diminta</th>
                    <th class="px-4 py-3 text-center text-sm font-medium text-gray-600 uppercase">Jumlah Dikeluarkan</th>
                    <th class="px-4 py-3 text-left text-sm font-medium text-gray-600 uppercase">Keterangan</th>
                  </tr>
                </thead>
                <tbody class="divide-y divide-gray-200">
                  <tr v-for="(item, index) in processItems" :key="item.id">
                    <td class="px-4 py-4 text-sm text-gray-800">{{ item.barang?.kode || '-' }}</td>
                    <td class="px-4 py-4 text-sm font-medium text-gray-900">{{ item.barang?.nama }}</td>
                    <td class="px-4 py-4 text-sm text-gray-800 text-center">{{ item.qty }}</td>
                    <td class="px-4 py-4 text-center">
                      <input
                        type="number"
                        v-model.number="item.qty_issued"
                        :max="item.qty"
                        min="0"
                        class="w-24 rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500 text-center"
                        @input="validateQty(index)"
                      />
                    </td>
                    <td class="px-4 py-4">
                      <input
                        type="text"
                        v-model="item.catatan"
                        placeholder="Catatan (opsional)"
                        class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500 text-sm"
                      />
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>

            <!-- Catatan Umum -->
            <div class="mb-6">
              <label class="block text-sm font-medium text-gray-700 mb-2">Catatan Pengeluaran</label>
              <textarea
                v-model="catatan"
                rows="3"
                class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                placeholder="Catatan umum untuk pengeluaran barang ini..."
              ></textarea>
            </div>

            <!-- Tombol Aksi -->
            <div class="flex justify-end space-x-3">
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

// Profile menu state
const showProfileMenu = ref(false)
const profileRef = ref<HTMLElement | null>(null)

// Sidebar toggle
const toggleSidebar = () => {
  const sidebar = document.getElementById('sidebar')
  const overlay = document.getElementById('overlay')
  if (sidebar && overlay) {
    sidebar.classList.toggle('-translate-x-full')
    overlay.classList.toggle('hidden')
  }
}

// Profile menu toggle
const toggleProfileMenu = () => {
  showProfileMenu.value = !showProfileMenu.value
}

// Handle logout
const handleLogout = () => {
  localStorage.removeItem('token')
  localStorage.removeItem('user')
  router.push('/login')
}

// Close profile menu when clicking outside
const handleClickOutside = (event: MouseEvent) => {
  if (profileRef.value && !profileRef.value.contains(event.target as Node)) {
    showProfileMenu.value = false
  }
}

// Load user data
const loadUserData = () => {
  const userData = localStorage.getItem('user')
  if (userData) {
    user.value = JSON.parse(userData)
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
  document.addEventListener('click', handleClickOutside)
  
  // Setup overlay click handler
  const overlay = document.getElementById('overlay')
  if (overlay) {
    overlay.addEventListener('click', toggleSidebar)
  }
})

onUnmounted(() => {
  document.removeEventListener('click', handleClickOutside)
})
</script>
