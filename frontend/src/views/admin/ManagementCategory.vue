<template>
  <div class="flex h-screen bg-gray-100">
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
            <p class="text-sm font-medium text-white">{{ user.name }}</p>
            <p class="text-xs text-gray-400">Administrator</p>
          </div>
        </div>
      </div>
    </aside>

    <!-- Latar belakang overlay untuk mobile -->
    <div class="fixed inset-0 bg-black bg-opacity-50 z-20 hidden" id="overlay" @click="toggleSidebar"></div>
    
    <!-- Konten Utama -->
    <div class="flex-1 flex flex-col transition-all duration-300 ease-in-out lg:ml-64" id="main-content">
      <!-- Header/Navbar Atas -->
      <!-- Header -->
      <Header @toggle-sidebar="toggleSidebar" />

      <!-- Konten Halaman Utama -->
      <main class="flex-1 p-6 overflow-y-auto">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6">
          <h1 class="text-3xl font-bold text-gray-900">Manajemen Kategori Barang</h1>
          <router-link
            to="/admin/kategori/add"
            class="mt-4 md:mt-0 bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150">
            <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
            </svg>
            <span>Tambah Kategori</span>
          </router-link>
        </div>
        
        <!-- Filter dan Pencarian -->
        <div class="mb-6 bg-white p-4 rounded-lg shadow-sm">
          <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <input 
              v-model="searchQuery"
              @input="handleSearch"
              type="text" 
              placeholder="Cari Nama Kategori..." 
              class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500 md:col-span-2">
            <button 
              @click="fetchKategori"
              class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg transition duration-150">
              Cari
            </button>
          </div>
        </div>

        <!-- Tabel Data Kategori -->
        <div class="bg-white rounded-lg shadow-sm overflow-hidden">
          <div v-if="loading" class="flex justify-center items-center py-12">
            <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
          </div>
          
          <div v-else class="overflow-x-auto">
            <table class="w-full min-w-max">
              <thead class="bg-gray-50 border-b border-gray-200">
                <tr>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nama Kategori</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Kode</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Deskripsi</th>
                  <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Aksi</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-gray-200">
                <tr v-if="kategoriList.length === 0">
                  <td colspan="4" class="px-6 py-8 text-center text-gray-500">
                    Tidak ada data kategori.
                  </td>
                </tr>
                <tr v-for="kategori in filteredKategori" :key="kategori.id">
                  <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ kategori.nama }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ kategori.kode }}</td>
                  <td class="px-6 py-4 text-sm text-gray-500">{{ kategori.deskripsi || '-' }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium space-x-2">
                    <router-link 
                      :to="`/admin/kategori/edit/${kategori.id}`" 
                      class="text-indigo-600 hover:text-indigo-900">
                      Edit
                    </router-link>
                    <button 
                      @click="confirmDelete(kategori)" 
                      class="text-red-600 hover:text-red-900">
                      Hapus
                    </button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Modal Konfirmasi Hapus -->
        <div v-if="showDeleteModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50">
          <div @click.self="closeDeleteModal" class="bg-white rounded-lg shadow-xl p-6 w-full max-w-md">
            <div class="flex items-start">
              <div class="mr-4 flex-shrink-0 bg-red-100 rounded-full p-2">
                <svg class="h-6 w-6 text-red-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z" />
                </svg>
              </div>
              <div class="flex-1">
                <h3 class="text-lg font-medium text-gray-900">Hapus Kategori</h3>
                <p class="mt-2 text-sm text-gray-600">
                  Apakah Anda yakin ingin menghapus kategori "{{ categoryToDelete?.nama }}"? Menghapus kategori mungkin akan mempengaruhi data barang yang terkait.
                </p>
              </div>
            </div>
            <div class="mt-6 flex justify-end space-x-3">
              <button 
                @click="closeDeleteModal" 
                class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 font-medium py-2 px-4 rounded-lg transition duration-150">
                Batal
              </button>
              <button 
                @click="deleteCategory" 
                class="bg-red-600 hover:bg-red-700 text-white font-medium py-2 px-4 rounded-lg transition duration-150">
                Ya, Hapus
              </button>
            </div>
          </div>
        </div>

        <!-- Footer -->
        <Footer />
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
import AdminNavigation from '@/components/AdminNavigation.vue'
import Header from '@/components/Header.vue'
import Footer from '@/components/Footer.vue'
import kategoriService, { type Kategori } from '@/services/kategori.service'

const router = useRouter()

// User state
const user = ref({
  name: 'Admin',
  email: 'admin@example.com',
  role: 'Administrator'
})

// UI state
const loading = ref(false)
const showDeleteModal = ref(false)
const categoryToDelete = ref<Kategori | null>(null)
const searchQuery = ref('')

// Kategori list
const kategoriList = ref<Kategori[]>([])

// Message state
const message = reactive({
  show: false,
  text: '',
  isError: false
})

// Filtered kategori based on search
const filteredKategori = computed(() => {
  if (!searchQuery.value) return kategoriList.value
  
  const query = searchQuery.value.toLowerCase()
  return kategoriList.value.filter(k => 
    k.nama.toLowerCase().includes(query) ||
    k.kode?.toLowerCase().includes(query) ||
    k.deskripsi?.toLowerCase().includes(query)
  )
})

// Load user data and fetch kategori
onMounted(async () => {
  const storedUser = localStorage.getItem('user')
  if (storedUser) {
    const userData = JSON.parse(storedUser)
    user.value = userData
  }
  
  await fetchKategori()
})

// Fetch kategori from API
const fetchKategori = async () => {
  loading.value = true
  try {
    const response = await kategoriService.getAll()
    if (response.success && Array.isArray(response.data)) {
      kategoriList.value = response.data
    }
  } catch (error: any) {
    console.error('Error loading kategori:', error)
    showMessage(error.response?.data?.message || 'Gagal memuat data kategori', true)
  } finally {
    loading.value = false
  }
}

// Handle search
let searchTimeout: any = null
const handleSearch = () => {
  clearTimeout(searchTimeout)
  searchTimeout = setTimeout(() => {
    // Filtering is done by computed property
  }, 300)
}

// Confirm delete
const confirmDelete = (kategori: Kategori) => {
  categoryToDelete.value = kategori
  showDeleteModal.value = true
}

// Close delete modal
const closeDeleteModal = () => {
  showDeleteModal.value = false
  categoryToDelete.value = null
}

// Delete category
const deleteCategory = async () => {
  if (!categoryToDelete.value?.id) return
  
  try {
    await kategoriService.delete(categoryToDelete.value.id)
    showMessage('Kategori berhasil dihapus.', false)
    closeDeleteModal()
    await fetchKategori()
  } catch (error: any) {
    console.error('Error deleting category:', error)
    showMessage(error.response?.data?.message || 'Gagal menghapus kategori', true)
  }
}

// Toggle sidebar for mobile
const toggleSidebar = () => {
  const sidebar = document.getElementById('sidebar')
  const overlay = document.getElementById('overlay')
  
  if (sidebar && overlay) {
    sidebar.classList.toggle('-translate-x-full')
    overlay.classList.toggle('hidden')
  }
}

// Show message
const showMessage = (text: string, isError: boolean = false) => {
  message.text = text
  message.isError = isError
  message.show = true
  
  setTimeout(() => {
    message.show = false
  }, 3000)
}
</script>

<style scoped>
/* Additional custom styles if needed */
</style>
