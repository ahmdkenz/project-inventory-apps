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
      <!-- Header -->
      <Header @toggle-sidebar="toggleSidebar" />

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
        <div class="mb-6 bg-white p-4 rounded-lg shadow-sm border border-gray-200">
          <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <input 
              v-model="searchQuery"
              @input="handleSearch"
              type="text" 
              placeholder="Cari Nama Supplier / Kontak..." 
              class="w-full rounded-md border-gray-300 shadow-sm p-2.5 focus:border-blue-500 focus:ring-blue-500 text-sm">
            <input 
              v-model="searchAddress"
              @input="handleSearch"
              type="text" 
              placeholder="Cari Alamat..." 
              class="w-full rounded-md border-gray-300 shadow-sm p-2.5 focus:border-blue-500 focus:ring-blue-500 text-sm">
            <button 
              @click="fetchSuppliers"
              class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2.5 px-4 rounded-lg transition duration-150 flex items-center justify-center">
              <svg class="h-5 w-5 mr-2" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M21 21l-5.197-5.197m0 0A7.5 7.5 0 105.196 5.196a7.5 7.5 0 0010.607 10.607z" />
              </svg>
              <span>Cari</span>
            </button>
          </div>
        </div>

        <!-- Tabel Data Supplier -->
        <div class="bg-white rounded-lg shadow-sm overflow-hidden border border-gray-200">
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
              <tbody class="divide-y divide-gray-200 bg-white">
                <tr v-if="filteredSuppliers.length === 0">
                  <td colspan="6" class="px-6 py-8 text-center text-gray-500">
                    <svg class="mx-auto h-12 w-12 text-gray-400 mb-3" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" d="M20.25 7.5l-.625 10.632a2.25 2.25 0 01-2.247 2.118H6.622a2.25 2.25 0 01-2.247-2.118L3.75 7.5M10 11.25h4M3.375 7.5h17.25c.621 0 1.125-.504 1.125-1.125v-1.5c0-.621-.504-1.125-1.125-1.125H3.375c-.621 0-1.125.504-1.125 1.125v1.5c0 .621.504 1.125 1.125 1.125z" />
                    </svg>
                    <p class="text-sm font-medium">Tidak ada data supplier.</p>
                  </td>
                </tr>
                <tr v-for="supplier in filteredSuppliers" :key="supplier.id">
                  <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ supplier.nama }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ supplier.kontak_person }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ supplier.telepon }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ supplier.email }}</td>
                  <td class="px-6 py-4 text-sm text-gray-500">{{ supplier.alamat || '-' }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                    <div class="flex items-center justify-end space-x-2">
                      <router-link 
                        :to="`/admin/supplier/edit/${supplier.id}`" 
                        class="text-indigo-600 hover:text-indigo-900 transition duration-150">
                        Edit
                      </router-link>
                      <button 
                        @click="confirmDelete(supplier)" 
                        class="text-red-600 hover:text-red-900 transition duration-150">
                        Hapus
                      </button>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Modal Konfirmasi Hapus -->
        <div v-if="showDeleteModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50" @click.self="closeDeleteModal">
          <div class="bg-white rounded-lg shadow-xl p-6 w-full max-w-md">
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
                :disabled="deletingSupplier"
                :class="[
                  'bg-red-600 hover:bg-red-700 text-white font-medium py-2 px-4 rounded-lg transition duration-150',
                  deletingSupplier ? 'opacity-50 cursor-not-allowed' : ''
                ]">
                <span v-if="deletingSupplier">Menghapus...</span>
                <span v-else>Ya, Hapus</span>
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
import supplierService, { type Supplier } from '@/services/supplier.service'

const router = useRouter()

const user = ref({
  name: 'Admin',
  email: 'admin@example.com',
  role: 'Administrator'
})

const loading = ref(false)
const deletingSupplier = ref(false)
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
    const response = await supplierService.getAll('admin')
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
  
  deletingSupplier.value = true
  try {
    await supplierService.delete(supplierToDelete.value.id)
    showMessage('Supplier berhasil dihapus.', false)
    closeDeleteModal()
    await fetchSuppliers()
  } catch (error: any) {
    console.error('Error deleting supplier:', error)
    showMessage(error.response?.data?.message || 'Gagal menghapus supplier', true)
  } finally {
    deletingSupplier.value = false
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
</script>

<style scoped>
/* Smooth transitions */
* {
  transition-property: background-color, border-color, color, fill, stroke;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
  transition-duration: 150ms;
}

/* Table hover effect */
tbody tr:hover {
  background-color: #f9fafb;
}

/* Custom scrollbar for table */
.overflow-x-auto::-webkit-scrollbar {
  height: 8px;
}

.overflow-x-auto::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 4px;
}

.overflow-x-auto::-webkit-scrollbar-thumb {
  background: #cbd5e0;
  border-radius: 4px;
}

.overflow-x-auto::-webkit-scrollbar-thumb:hover {
  background: #a0aec0;
}

/* Ensure consistent button sizing */
button, a {
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

/* Modal animation */
@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

.fixed.inset-0.z-50 {
  animation: fadeIn 0.2s ease-out;
}
</style>
