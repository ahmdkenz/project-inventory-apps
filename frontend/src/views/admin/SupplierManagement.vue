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
      
      <AdminNavigation :current-path="$route.path" />
      
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
              <img class="h-9 w-9 rounded-full" src="https://placehold.co/100x100/EBF8FF/3182CE?text=A" alt="Avatar Pengguna">
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
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6">
          <h1 class="text-3xl font-bold text-gray-900">Manajemen Supplier</h1>
          <router-link
            to="/admin/supplier/add"
            class="mt-4 md:mt-0 bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150">
            <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
            </svg>
            <span>Tambah Supplier</span>
          </router-link>
        </div>
        
        <!-- Filter dan Pencarian -->
        <div class="mb-6 bg-white p-4 rounded-lg shadow-sm">
          <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <input 
              v-model="searchQuery"
              @input="handleSearch"
              type="text" 
              placeholder="Cari Nama Supplier / Kontak..." 
              class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500">
            <input 
              v-model="searchAddress"
              @input="handleSearch"
              type="text" 
              placeholder="Cari Alamat..." 
              class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500">
            <button 
              @click="fetchSuppliers"
              class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg transition duration-150">
              Cari
            </button>
          </div>
        </div>

        <!-- Tabel Data Supplier -->
        <div class="bg-white rounded-lg shadow-sm overflow-hidden">
          <div v-if="loading" class="flex justify-center items-center py-12">
            <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
          </div>
          
          <div v-else class="overflow-x-auto">
            <table class="w-full min-w-max">
              <thead class="bg-gray-50 border-b border-gray-200">
                <tr>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nama Supplier</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Kontak Person</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">No. Telepon</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Email</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Alamat</th>
                  <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Aksi</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-gray-200">
                <tr v-if="filteredSuppliers.length === 0">
                  <td colspan="6" class="px-6 py-8 text-center text-gray-500">
                    Tidak ada data supplier.
                  </td>
                </tr>
                <tr v-for="supplier in filteredSuppliers" :key="supplier.id">
                  <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ supplier.nama }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ supplier.kontak_person }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ supplier.telepon }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ supplier.email }}</td>
                  <td class="px-6 py-4 text-sm text-gray-500">{{ supplier.alamat || '-' }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium space-x-2">
                    <router-link 
                      :to="`/admin/supplier/edit/${supplier.id}`" 
                      class="text-indigo-600 hover:text-indigo-900">
                      Edit
                    </router-link>
                    <button 
                      @click="confirmDelete(supplier)" 
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
                <h3 class="text-lg font-medium text-gray-900">Hapus Supplier</h3>
                <p class="mt-2 text-sm text-gray-600">
                  Apakah Anda yakin ingin menghapus supplier "{{ supplierToDelete?.nama }}"? Tindakan ini tidak dapat dibatalkan.
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
                @click="deleteSupplier" 
                class="bg-red-600 hover:bg-red-700 text-white font-medium py-2 px-4 rounded-lg transition duration-150">
                Ya, Hapus
              </button>
            </div>
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
import AdminNavigation from '@/components/AdminNavigation.vue'
import supplierService, { type Supplier } from '@/services/supplier.service'

const router = useRouter()

const user = ref({
  name: 'Admin',
  email: 'admin@example.com',
  role: 'Administrator'
})

const showProfileMenu = ref(false)
const loading = ref(false)
const showDeleteModal = ref(false)
const supplierToDelete = ref<Supplier | null>(null)
const searchQuery = ref('')
const searchAddress = ref('')

const supplierList = ref<Supplier[]>([])

const message = reactive({
  show: false,
  text: '',
  isError: false
})

const filteredSuppliers = computed(() => {
  if (!searchQuery.value && !searchAddress.value) return supplierList.value
  
  const query = searchQuery.value.toLowerCase()
  const address = searchAddress.value.toLowerCase()
  
  return supplierList.value.filter(s => 
    (s.nama.toLowerCase().includes(query) ||
    s.kontak_person.toLowerCase().includes(query) ||
    s.telepon.toLowerCase().includes(query) ||
    s.email.toLowerCase().includes(query)) &&
    (s.alamat?.toLowerCase().includes(address) || !address)
  )
})

onMounted(async () => {
  const storedUser = localStorage.getItem('user')
  if (storedUser) {
    const userData = JSON.parse(storedUser)
    user.value = userData
  }
  
  await fetchSuppliers()
})

const fetchSuppliers = async () => {
  loading.value = true
  try {
    const response = await supplierService.getAll()
    if (response.success && Array.isArray(response.data)) {
      supplierList.value = response.data
    }
  } catch (error: any) {
    console.error('Error loading suppliers:', error)
    showMessage(error.response?.data?.message || 'Gagal memuat data supplier', true)
  } finally {
    loading.value = false
  }
}

let searchTimeout: any = null
const handleSearch = () => {
  clearTimeout(searchTimeout)
  searchTimeout = setTimeout(() => {
    // Filtering is done by computed property
  }, 300)
}

const confirmDelete = (supplier: Supplier) => {
  supplierToDelete.value = supplier
  showDeleteModal.value = true
}

const closeDeleteModal = () => {
  showDeleteModal.value = false
  supplierToDelete.value = null
}

const deleteSupplier = async () => {
  if (!supplierToDelete.value?.id) return
  
  try {
    await supplierService.delete(supplierToDelete.value.id)
    showMessage('Supplier berhasil dihapus.', false)
    closeDeleteModal()
    await fetchSuppliers()
  } catch (error: any) {
    console.error('Error deleting supplier:', error)
    showMessage(error.response?.data?.message || 'Gagal menghapus supplier', true)
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
