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
      <AdminNavigation :current-path="$route.path" />
      
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
          <div class="relative" v-click-outside="closeProfileMenu">
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
        <!-- Preserve original page content -->
        <div class="p-6">
          <!-- Header Halaman -->
          <div class="flex flex-col md:flex-row justify-between md:items-center mb-6 gap-4">
            <h1 class="text-3xl font-bold text-gray-900">Manajemen Barang</h1>
            <router-link
              to="/admin/barang/add"
              class="w-full md:w-auto bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150"
            >
              <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
              </svg>
              <span>Tambah Barang</span>
            </router-link>
          </div>

          <!-- Kontrol Filter dan Pencarian -->
          <div class="mb-6 bg-white p-4 rounded-lg shadow-sm">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
              <!-- Pencarian -->
              <div class="md:col-span-1">
                <label for="search-item" class="block text-sm font-medium text-gray-700 mb-1">Cari Barang</label>
                <div class="relative">
                  <input
                    v-model="filters.search"
                    type="text"
                    id="search-item"
                    class="w-full rounded-md border-gray-300 shadow-sm pl-10 p-2 focus:border-blue-500 focus:ring-blue-500"
                    placeholder="Nama atau Kode Barang..."
                    @input="handleSearch"
                  />
                  <svg class="h-5 w-5 text-gray-400 absolute left-3 top-2.5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M21 21l-5.197-5.197m0 0A7.5 7.5 0 105.196 5.196a7.5 7.5 0 0010.607 10.607z" />
                  </svg>
                </div>
              </div>

              <!-- Filter Kategori -->
              <div class="md:col-span-1">
                <label for="filter-kategori" class="block text-sm font-medium text-gray-700 mb-1">Kategori</label>
                <select
                  v-model="filters.kategori"
                  id="filter-kategori"
                  class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                  @change="fetchItems"
                >
                  <option value="">Semua Kategori</option>
                  <option value="atk">ATK</option>
                  <option value="elektronik">Elektronik</option>
                  <option value="dapur">Perlengkapan Dapur</option>
                  <option value="lainnya">Lainnya</option>
                </select>
              </div>

              <!-- Filter Stok -->
              <div class="md:col-span-1">
                <label for="filter-stok" class="block text-sm font-medium text-gray-700 mb-1">Status Stok</label>
                <select
                  v-model="filters.stok"
                  id="filter-stok"
                  class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                  @change="fetchItems"
                >
                  <option value="">Semua Stok</option>
                  <option value="tersedia">Stok Tersedia</option>
                  <option value="menipis">Stok Menipis</option>
                  <option value="habis">Stok Habis</option>
                </select>
              </div>
            </div>
          </div>

          <!-- Loading State -->
          <div v-if="loading" class="flex justify-center items-center py-12">
            <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
          </div>

          <!-- Tabel Data Barang -->
          <div v-else class="bg-white rounded-lg shadow-md overflow-hidden">
            <div class="overflow-x-auto">
              <table class="w-full min-w-max">
                <!-- Header Tabel -->
                <thead class="bg-gray-50 border-b border-gray-200">
                  <tr>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nama Barang</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Kategori</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Satuan</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Harga Beli</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Harga Jual</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Stok</th>
                    <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Aksi</th>
                  </tr>
                </thead>

                <!-- Body Tabel -->
                <tbody class="divide-y divide-gray-200">
                  <tr v-if="items.length === 0">
                    <td colspan="7" class="px-6 py-8 text-center text-gray-500">
                      Tidak ada data barang.
                    </td>
                  </tr>
                  <tr v-for="item in items" :key="item.id">
                    <td class="px-6 py-4 whitespace-nowrap">
                      <div class="text-sm font-medium text-gray-900">{{ item.nama }}</div>
                      <div class="text-sm text-gray-500">{{ item.kode }}</div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ item.kategori?.nama || '-' }}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ item.satuan }}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ formatCurrency(item.harga_beli) }}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ formatCurrency(item.harga_jual) }}</td>
                    <td class="px-6 py-4 whitespace-nowrap">
                      <span v-if="item.stok === 0" class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800">
                        Habis ({{ item.stok }})
                      </span>
                      <span v-else-if="item.stok <= item.stok_minimum" class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-yellow-100 text-yellow-800">
                        Menipis ({{ item.stok }})
                      </span>
                      <span v-else class="text-sm font-medium text-gray-900">{{ item.stok }}</span>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                      <router-link :to="`/admin/barang/edit/${item.id}`" class="text-blue-600 hover:text-blue-900">Edit</router-link>
                      <button @click="confirmDelete(item)" class="text-red-600 hover:text-red-900 ml-4">Hapus</button>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

          <!-- Modal Konfirmasi Hapus -->
          <div
            v-if="showDeleteModal"
            class="fixed inset-0 bg-gray-600 bg-opacity-75 flex items-center justify-center p-4 z-50 transition-opacity duration-300"
            @click.self="closeDeleteModal"
          >
            <div class="bg-white rounded-lg shadow-xl w-full max-w-md transform transition-all">
              <!-- Header Modal -->
              <div class="p-6 border-b border-gray-200">
                <h3 class="text-lg font-medium leading-6 text-gray-900">Hapus Barang</h3>
              </div>
              
              <!-- Body Modal -->
              <div class="p-6">
                <p class="text-sm text-gray-600">
                  Apakah Anda yakin ingin menghapus barang <strong>{{ itemToDelete?.name }}</strong>? 
                  Stok barang akan dihapus secara permanen. Tindakan ini tidak dapat dibatalkan.
                </p>
              </div>
              
              <!-- Footer Modal -->
              <div class="px-6 py-4 bg-gray-50 rounded-b-lg flex justify-end space-x-3">
                <button
                  @click="closeDeleteModal"
                  type="button"
                  class="bg-white hover:bg-gray-100 text-gray-700 font-medium py-2 px-4 rounded-lg border border-gray-300 transition duration-150"
                >
                  Batal
                </button>
                <button
                  @click="deleteItem"
                  type="button"
                  class="bg-red-600 hover:bg-red-700 text-white font-medium py-2 px-4 rounded-lg transition duration-150"
                >
                  Ya, Hapus
                </button>
              </div>
            </div>
          </div>

          <!-- Message Box -->
          <div
            v-if="message.show"
            :class="['fixed top-5 right-5 p-4 rounded-md shadow-lg text-white transition-all duration-300 z-50', message.isError ? 'bg-red-500' : 'bg-green-500']"
          >
            {{ message.text }}
          </div>
        </div>
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import AdminNavigation from '@/components/AdminNavigation.vue'
import barangService, { type Barang } from '@/services/barang.service'

// Router & auth
const router = useRouter()
const authStore = useAuthStore()

// Header/Profile state
const showProfileMenu = ref(false)
const user = ref<any>(null)

const toggleProfileMenu = () => {
  showProfileMenu.value = !showProfileMenu.value
}

const closeProfileMenu = () => {
  showProfileMenu.value = false
}

const toggleSidebar = () => {
  const sidebar = document.getElementById('sidebar')
  const overlay = document.getElementById('overlay')
  if (sidebar && overlay) {
    sidebar.classList.toggle('-translate-x-full')
    overlay.classList.toggle('hidden')
  }
}

const handleLogout = async () => {
  try {
    await authStore.logout()
    await router.push('/login')
  } catch (error) {
    console.error('Error during logout:', error)
    localStorage.removeItem('token')
    localStorage.removeItem('user')
    await router.push('/login')
  }
}

// State (original)
const items = ref<Barang[]>([])
const loading = ref(false)
const showDeleteModal = ref(false)
const itemToDelete = ref<any>(null)

const filters = ref({
  search: '',
  kategori: '',
  stok: ''
})

const message = ref({
  show: false,
  text: '',
  isError: false
})

// Methods (original)
const fetchItems = async () => {
  loading.value = true
  try {
    const response = await barangService.getAll()
    
    if (response.success && Array.isArray(response.data)) {
      items.value = response.data
    } else {
      showMessage('Gagal memuat data barang', true)
    }
  } catch (error: any) {
    console.error('Error fetching items:', error)
    showMessage(error.response?.data?.message || 'Gagal memuat data barang', true)
  } finally {
    loading.value = false
  }
}

let searchTimeout: any = null
const handleSearch = () => {
  clearTimeout(searchTimeout)
  searchTimeout = setTimeout(() => {
    fetchItems()
  }, 500)
}

const confirmDelete = (item: any) => {
  itemToDelete.value = item
  showDeleteModal.value = true
}

const closeDeleteModal = () => {
  showDeleteModal.value = false
  itemToDelete.value = null
}

const deleteItem = async () => {
  try {
    if (!itemToDelete.value?.id) return
    
    await barangService.delete(itemToDelete.value.id)
    
    // Refresh data after delete
    await fetchItems()
    
    showMessage('Barang berhasil dihapus.', false)
    closeDeleteModal()
  } catch (error: any) {
    console.error('Error deleting item:', error)
    showMessage(error.response?.data?.message || 'Gagal menghapus barang', true)
  }
}

const formatCurrency = (value: number) => {
  return new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    minimumFractionDigits: 0
  }).format(value)
}

const showMessage = (text: string, isError: boolean = false) => {
  message.value = { show: true, text, isError }
  setTimeout(() => {
    message.value.show = false
  }, 3000)
}

// Lifecycle
onMounted(() => {
  const userData = localStorage.getItem('user')
  if (userData) {
    user.value = JSON.parse(userData)
  }
  fetchItems()
})
</script>
