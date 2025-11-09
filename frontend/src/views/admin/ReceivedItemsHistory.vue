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
        <!-- Header Halaman -->
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6">
          <h1 class="text-3xl font-bold text-gray-900">Riwayat Barang Masuk</h1>
        </div>

        <!-- Filter dan Pencarian -->
        <div class="mb-6 bg-white p-4 rounded-lg shadow-sm">
          <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
            <input
              type="text"
              v-model="filters.search"
              placeholder="Cari No. Dokumen / No. Ref..."
              class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
            />
            <select
              v-model="filters.type"
              class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
            >
              <option value="">Semua Tipe</option>
              <option value="po">Dari PO</option>
              <option value="non-po">Non-PO</option>
            </select>
            <input
              type="date"
              v-model="filters.start_date"
              class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500 text-gray-500"
            />
            <input
              type="date"
              v-model="filters.end_date"
              class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500 text-gray-500"
            />
          </div>
        </div>

        <!-- Loading State -->
        <div v-if="loading" class="bg-white rounded-lg shadow-sm p-12 text-center">
          <div class="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
          <p class="mt-4 text-gray-600">Memuat data...</p>
        </div>

        <!-- Empty State -->
        <div v-else-if="!loading && receivedItems.length === 0" class="bg-white rounded-lg shadow-sm p-12 text-center">
          <svg
            class="mx-auto h-12 w-12 text-gray-400"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
            />
          </svg>
          <h3 class="mt-2 text-sm font-medium text-gray-900">Tidak ada data</h3>
          <p class="mt-1 text-sm text-gray-500">
            Tidak ada riwayat barang masuk yang sesuai dengan filter.
          </p>
        </div>

        <!-- Tabel Riwayat -->
        <div v-else class="bg-white rounded-lg shadow-sm overflow-hidden">
          <div class="overflow-x-auto">
            <table class="w-full min-w-max">
              <thead class="bg-gray-50 border-b border-gray-200">
                <tr>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    No. Dokumen
                  </th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Tanggal
                  </th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Tipe
                  </th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    No. Referensi
                  </th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Sumber
                  </th>
                  <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Total Nilai
                  </th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Oleh
                  </th>
                  <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Aksi
                  </th>
                </tr>
              </thead>
              <tbody class="divide-y divide-gray-200">
                <tr v-for="item in receivedItems" :key="item.id">
                  <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-blue-600 hover:text-blue-800">
                    <router-link 
                      v-if="item.tipe === 'po'"
                      :to="`/admin/received-items/${item.original_id}`"
                    >
                      {{ generateReceiptNumber(item) }}
                    </router-link>
                    <router-link 
                      v-else
                      :to="`/admin/non-po/receipt/${item.original_id}/print`"
                    >
                      {{ item.no_dokumen }}
                    </router-link>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {{ formatDate(item.tanggal) }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <span
                      class="px-3 py-1 inline-flex text-xs font-medium rounded-full"
                      :class="
                        item.tipe === 'po'
                          ? 'bg-blue-100 text-blue-800'
                          : 'bg-purple-100 text-purple-800'
                      "
                    >
                      {{ item.tipe === 'po' ? 'Dari PO' : 'Non-PO' }}
                    </span>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {{ item.no_referensi || '-' }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                    {{ item.sumber }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 text-right">
                    {{ formatCurrency(item.total_nilai) }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {{ item.dicatat_oleh }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium space-x-2">
                    <router-link
                      v-if="item.tipe === 'po'"
                      :to="`/admin/purchase-orders/${item.original_id}/print-receipt`"
                      class="text-green-600 hover:text-green-800"
                    >
                      Cetak Bukti
                    </router-link>
                    <router-link
                      v-else
                      :to="`/admin/non-po/receipt/${item.original_id}/print`"
                      class="text-green-600 hover:text-green-800"
                    >
                      Cetak Bukti
                    </router-link>
                    <router-link
                      v-if="item.tipe === 'po'"
                      :to="`/admin/purchase-orders/detail/${item.original_id}`"
                      class="text-indigo-600 hover:text-indigo-900"
                    >
                      Lihat Detail
                    </router-link>
                    <router-link
                      v-else
                      :to="`/admin/non-po/receipt/${item.original_id}/detail`"
                      class="text-indigo-600 hover:text-indigo-900"
                    >
                      Lihat Detail
                    </router-link>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Pagination -->
        <div v-if="!loading && receivedItems.length > 0" class="mt-6 flex items-center justify-between">
          <button
            @click="prevPage"
            :disabled="meta.current_page === 1"
            class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 font-medium py-2 px-4 rounded-lg text-sm transition duration-150 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            Sebelumnya
          </button>
          <span class="text-sm text-gray-600">
            Halaman <span class="font-medium">{{ meta.current_page }}</span> dari
            <span class="font-medium">{{ meta.last_page }}</span>
          </span>
          <button
            @click="nextPage"
            :disabled="meta.current_page === meta.last_page"
            class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 font-medium py-2 px-4 rounded-lg text-sm transition duration-150 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            Berikutnya
          </button>
        </div>
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, watch, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import AdminNavigation from '@/components/AdminNavigation.vue'
import receivedItemsService, { type ReceivedItem } from '@/services/receivedItems.service'

const router = useRouter()

const receivedItems = ref<ReceivedItem[]>([])
const loading = ref(false)
const filters = ref({
  search: '',
  type: '',
  start_date: '',
  end_date: ''
})

const meta = ref({
  current_page: 1,
  last_page: 1,
  per_page: 10,
  total: 0
})

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
    month: 'short',
    year: 'numeric'
  })
}

const formatCurrency = (amount: number) => {
  return new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    minimumFractionDigits: 0
  }).format(amount)
}

// Generate No. Penerimaan dengan format IN-YYYYMMDD-{PO_ID}
const generateReceiptNumber = (item: ReceivedItem) => {
  const date = new Date(item.tanggal)
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  return `IN-${year}${month}${day}-${item.original_id}`
}

const fetchReceivedItems = async () => {
  loading.value = true
  try {
    const response = await receivedItemsService.getAll({
      search: filters.value.search || undefined,
      type: filters.value.type || undefined,
      start_date: filters.value.start_date || undefined,
      end_date: filters.value.end_date || undefined,
      page: meta.value.current_page
    })
    receivedItems.value = response.data
    meta.value = response.meta
  } catch (error) {
    console.error('Error fetching received items:', error)
    alert('Gagal memuat data riwayat barang masuk')
  } finally {
    loading.value = false
  }
}

const prevPage = () => {
  if (meta.value.current_page > 1) {
    meta.value.current_page--
    fetchReceivedItems()
  }
}

const nextPage = () => {
  if (meta.value.current_page < meta.value.last_page) {
    meta.value.current_page++
    fetchReceivedItems()
  }
}

// Watch filters untuk auto-search
watch(filters, () => {
  meta.value.current_page = 1
  fetchReceivedItems()
}, { deep: true })

onMounted(() => {
  loadUserData()
  fetchReceivedItems()
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
