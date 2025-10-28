<template>
  <div class="flex h-screen bg-gray-100">
    <!-- Sidebar -->
    <aside class="fixed top-0 left-0 h-full w-64 bg-gray-900 text-gray-300 shadow-lg z-30 transform -translate-x-full lg:translate-x-0 transition-transform duration-300 ease-in-out" id="sidebar">
      <div class="p-6 flex items-center space-x-3">
        <svg class="h-10 w-10 text-blue-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" d="M21 7.5l-9-5.25L3 7.5m18 0l-9 5.25m9-5.25v9l-9 5.25M3 7.5l9 5.25M3 7.5v9l9 5.25m0-9v9" />
        </svg>
        <span class="text-white text-2xl font-semibold">Inventori</span>
      </div>
      
      <StaffNavigation :current-path="$route.path" />
      
      <div class="absolute bottom-0 left-0 w-full p-4 border-t border-gray-700">
        <div class="flex items-center space-x-3">
          <img class="h-10 w-10 rounded-full" src="https://placehold.co/100x100/FEF2F2/DC2626?text=S" alt="Avatar Pengguna">
          <div>
            <p class="text-sm font-medium text-white">{{ user.name }}</p>
            <p class="text-xs text-gray-400">Staff Gudang</p>
          </div>
        </div>
      </div>
    </aside>

    <div class="fixed inset-0 bg-black bg-opacity-50 z-20 hidden" id="overlay" @click="toggleSidebar"></div>
    
    <div class="flex-1 flex flex-col transition-all duration-300 ease-in-out lg:ml-64" id="main-content">
      <header class="bg-white shadow-sm p-4 flex items-center justify-between z-10">
        <button id="hamburger-btn" @click="toggleSidebar" class="text-gray-600 lg:hidden">
          <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5" />
          </svg>
        </button>
        <div class="relative hidden sm:block"></div>
        <div class="flex items-center space-x-4">
          <button class="text-gray-500 hover:text-gray-700 relative">
            <span class="absolute top-0 right-0 h-2 w-2 bg-red-500 rounded-full"></span>
            <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M14.857 17.082a23.848 23.848 0 005.454-1.31A8.967 8.967 0 0118 9.75v-.7V9A6 6 0 006 9v.75a8.967 8.967 0 01-2.312 6.022c1.733.64 3.56 1.085 5.455 1.31m5.714 0a24.255 24.255 0 01-5.714 0m5.714 0a3 3 0 11-5.714 0" />
            </svg>
          </button>
          <div class="relative">
            <button @click="showProfileMenu = !showProfileMenu" class="flex items-center space-x-2">
              <img class="h-9 w-9 rounded-full" src="https://placehold.co/100x100/FEF2F2/DC2626?text=S" alt="Avatar Pengguna">
              <span class="hidden md:block text-sm font-medium text-gray-700">{{ user.name }}</span>
            </button>
            <div v-if="showProfileMenu" class="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg py-1 z-20">
              <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Profil Saya</a>
              <a @click.prevent="handleLogout" href="#" class="block px-4 py-2 text-sm text-red-600 hover:bg-gray-100">Logout</a>
            </div>
          </div>
        </div>
      </header>

      <main class="flex-1 p-6 overflow-y-auto">
        <h1 class="text-3xl font-bold text-gray-900 mb-6">Data Barang</h1>
        
        <!-- Filter dan Pencarian -->
        <div class="mb-6 bg-white p-4 rounded-lg shadow-sm">
          <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
            <div class="flex-1 grid grid-cols-1 sm:grid-cols-3 gap-4">
              <!-- Pencarian -->
              <div>
                <label for="search" class="sr-only">Cari...</label>
                <input 
                  type="text" 
                  id="search" 
                  v-model="searchQuery"
                  @input="handleSearch"
                  placeholder="Cari barang (nama/kode)..." 
                  class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500">
              </div>
              
              <!-- Filter Kategori -->
              <div>
                <label for="filter-kategori" class="sr-only">Filter Kategori</label>
                <select 
                  id="filter-kategori" 
                  v-model="filterKategori"
                  @change="handleSearch"
                  class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500">
                  <option value="">Semua Kategori</option>
                  <option v-for="kategori in kategoriList" :key="kategori.id" :value="kategori.id">
                    {{ kategori.nama }}
                  </option>
                </select>
              </div>

              <!-- Filter Stok -->
              <div>
                <label for="filter-stok" class="sr-only">Filter Stok</label>
                <select 
                  id="filter-stok" 
                  v-model="filterStok"
                  @change="handleSearch"
                  class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500">
                  <option value="">Semua Stok</option>
                  <option value="tersedia">Tersedia</option>
                  <option value="menipis">Menipis</option>
                  <option value="habis">Habis</option>
                </select>
              </div>
            </div>
          </div>
        </div>

        <!-- Tabel Data Barang (Read Only) -->
        <div class="bg-white rounded-lg shadow-sm overflow-hidden">
          <div v-if="loading" class="flex justify-center items-center py-12">
            <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
          </div>
          
          <div v-else class="overflow-x-auto">
            <table class="w-full min-w-max">
              <thead class="bg-gray-50 border-b border-gray-200">
                <tr>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nama Barang</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Kode</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Kategori</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Harga Beli</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Harga Jual</th>
                  <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">Stok</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-gray-200">
                <tr v-if="filteredBarang.length === 0">
                  <td colspan="6" class="px-6 py-8 text-center text-gray-500">
                    Tidak ada data barang.
                  </td>
                </tr>
                <tr v-for="barang in filteredBarang" :key="barang.id">
                  <td class="px-6 py-4 whitespace-nowrap">
                    <div class="text-sm font-medium text-gray-900">{{ barang.nama }}</div>
                    <div class="text-sm text-gray-500">{{ barang.satuan }}</div>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ barang.kode }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ barang.kategori?.nama || '-' }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ formatCurrency(barang.harga_beli) }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ formatCurrency(barang.harga_jual) }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-center">
                    <span :class="getStockClass(barang.stok, barang.stok_minimum || 0)">
                      {{ barang.stok }}
                    </span>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </main>
    </div>
  </div>

  <!-- Kotak Pesan -->
  <div 
    v-if="message.show"
    :class="[
      'fixed top-5 right-5 p-4 rounded-md shadow-lg text-white transition-all duration-300 z-50',
      message.isError ? 'bg-red-500' : 'bg-green-500'
    ]">
    {{ message.text }}
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import StaffNavigation from '@/components/StaffNavigation.vue'
import staffBarangService from '@/services/staff/barang.service'
import staffKategoriService from '@/services/staff/kategori.service'
import type { Barang } from '@/services/barang.service'
import type { Kategori } from '@/services/kategori.service'

const router = useRouter()

const user = ref({
  name: 'Staff',
  email: 'staff@example.com',
  role: 'Staff'
})

const showProfileMenu = ref(false)
const loading = ref(false)
const searchQuery = ref('')
const filterKategori = ref('')
const filterStok = ref('')

const barangList = ref<Barang[]>([])
const kategoriList = ref<Kategori[]>([])

const message = reactive({
  show: false,
  text: '',
  isError: false
})

const filteredBarang = computed(() => {
  let result = barangList.value

  // Filter by search query
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    result = result.filter(b => 
      b.nama.toLowerCase().includes(query) ||
      b.kode?.toLowerCase().includes(query)
    )
  }

  // Filter by kategori
  if (filterKategori.value) {
    result = result.filter(b => b.kategori_id === parseInt(filterKategori.value))
  }

  // Filter by stok status
  if (filterStok.value) {
    if (filterStok.value === 'tersedia') {
      result = result.filter(b => b.stok > (b.stok_minimum || 0))
    } else if (filterStok.value === 'menipis') {
      result = result.filter(b => b.stok > 0 && b.stok <= (b.stok_minimum || 0))
    } else if (filterStok.value === 'habis') {
      result = result.filter(b => b.stok === 0)
    }
  }

  return result
})

onMounted(async () => {
  const storedUser = localStorage.getItem('user')
  if (storedUser) {
    const userData = JSON.parse(storedUser)
    user.value = userData
  }
  
  await fetchBarang()
  await fetchKategori()
})

const fetchBarang = async () => {
  loading.value = true
  try {
    const response = await staffBarangService.getAll()
    if (response.success && Array.isArray(response.data)) {
      barangList.value = response.data
    }
  } catch (error: any) {
    console.error('Error loading barang:', error)
    showMessage(error.response?.data?.message || 'Gagal memuat data barang', true)
  } finally {
    loading.value = false
  }
}

const fetchKategori = async () => {
  try {
    const response = await staffKategoriService.getAll()
    if (response.success && Array.isArray(response.data)) {
      kategoriList.value = response.data
    }
  } catch (error: any) {
    console.error('Error loading kategori:', error)
  }
}

let searchTimeout: any = null
const handleSearch = () => {
  clearTimeout(searchTimeout)
  searchTimeout = setTimeout(() => {
    // Filtering is done by computed property
  }, 300)
}

const formatCurrency = (value: number) => {
  return new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    minimumFractionDigits: 0
  }).format(value)
}

const getStockClass = (stok: number, stokMinimum: number) => {
  if (stok === 0) {
    return 'px-3 py-1 inline-flex text-sm font-medium rounded-full bg-red-100 text-red-800'
  } else if (stok <= stokMinimum) {
    return 'px-3 py-1 inline-flex text-sm font-medium rounded-full bg-yellow-100 text-yellow-800'
  } else {
    return 'px-3 py-1 inline-flex text-sm font-medium rounded-full bg-green-100 text-green-800'
  }
}

const toggleSidebar = () => {
  const sidebar = document.getElementById('sidebar')
  const overlay = document.getElementById('overlay')
  
  if (sidebar && overlay) {
    sidebar.classList.toggle('-translate-x-full')
    overlay.classList.toggle('hidden')
  }
}

const showMessage = (text: string, isError: boolean = false) => {
  message.text = text
  message.isError = isError
  message.show = true
  
  setTimeout(() => {
    message.show = false
  }, 3000)
}

const handleLogout = () => {
  localStorage.removeItem('token')
  localStorage.removeItem('user')
  router.push('/login')
}
</script>

<style scoped>
/* Additional custom styles if needed */
</style>
