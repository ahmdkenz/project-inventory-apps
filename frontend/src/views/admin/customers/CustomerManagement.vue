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
    </aside>

    <!-- Latar belakang overlay untuk mobile -->
    <div class="fixed inset-0 bg-black bg-opacity-50 z-20 hidden" id="overlay" @click="toggleSidebar"></div>
    
    <!-- Konten Utama -->
    <div class="flex-1 flex flex-col lg:ml-64">
      <!-- Header -->
      <!-- Header -->
      <Header @toggle-sidebar="toggleSidebar" />

      <!-- Success/Error Message -->
      <div v-if="message.show" :class="message.isError ? 'bg-red-500' : 'bg-green-500'" class="text-white px-6 py-3 text-center">
        {{ message.text }}
      </div>

      <!-- Main Content -->
      <main class="flex-1 p-6 overflow-y-auto">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6">
          <h1 class="text-3xl font-bold text-gray-900">Manajemen Customer</h1>
          <router-link 
            to="/admin/customers/create" 
            class="mt-4 md:mt-0 bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150"
          >
            <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
            </svg>
            <span>Tambah Customer Baru</span>
          </router-link>
        </div>
        
        <!-- Filter dan Pencarian -->
        <div class="mb-6 bg-white p-4 rounded-lg shadow-sm">
          <input 
            v-model="searchQuery" 
            @input="handleSearch"
            type="text" 
            placeholder="Cari nama customer, email, atau telepon..." 
            class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
          >
        </div>

        <!-- Loading State -->
        <div v-if="loading" class="text-center py-12">
          <div class="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
          <p class="mt-4 text-gray-600">Memuat data customer...</p>
        </div>

        <!-- Tabel Data Customer -->
        <div v-else class="bg-white rounded-lg shadow-sm overflow-hidden">
          <div class="overflow-x-auto">
            <table class="w-full min-w-max">
              <thead class="bg-gray-50 border-b border-gray-200">
                <tr>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nama Customer</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Email</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Telepon</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Alamat</th>
                  <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Aksi</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-gray-200">
                <tr v-if="customers.length === 0">
                  <td colspan="5" class="px-6 py-8 text-center text-gray-500">
                    Belum ada data customer
                  </td>
                </tr>
                <tr v-for="customer in customers" :key="customer.id">
                  <td class="px-6 py-4 whitespace-nowrap">
                    <div class="text-sm font-medium text-gray-900">{{ customer.company_name }}</div>
                    <div v-if="customer.contact_name" class="text-sm text-gray-500">Kontak: {{ customer.contact_name }}</div>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ customer.email }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ customer.phone }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 max-w-xs truncate">
                    {{ customer.address || '-' }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium space-x-2">
                    <router-link 
                      :to="`/admin/customers/${customer.id}/edit`" 
                      class="text-indigo-600 hover:text-indigo-900"
                    >
                      Edit
                    </router-link>
                    <button 
                      @click="confirmDelete(customer)" 
                      class="text-red-600 hover:text-red-900"
                    >
                      Hapus
                    </button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Pagination -->
        <div v-if="!loading && customers.length > 0" class="mt-6 flex items-center justify-between">
          <button 
            @click="changePage(meta.current_page - 1)" 
            :disabled="meta.current_page === 1"
            class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 font-medium py-2 px-4 rounded-lg text-sm transition duration-150 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            Sebelumnya
          </button>
          <span class="text-sm text-gray-600">
            Halaman <span class="font-medium">{{ meta.current_page }}</span> dari <span class="font-medium">{{ meta.last_page }}</span>
          </span>
          <button 
            @click="changePage(meta.current_page + 1)" 
            :disabled="meta.current_page === meta.last_page"
            class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 font-medium py-2 px-4 rounded-lg text-sm transition duration-150 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            Berikutnya
          </button>
        </div>

        <!-- Footer -->
        <Footer />
      </main>
    </div>

    <!-- Modal Konfirmasi Hapus -->
    <div v-if="showDeleteModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50">
      <div class="bg-white rounded-lg shadow-xl p-6 w-full max-w-md mx-4">
        <div class="flex items-start">
          <div class="flex-shrink-0 p-3 bg-red-100 rounded-full">
            <svg class="h-6 w-6 text-red-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z" />
            </svg>
          </div>
          <div class="ml-4">
            <h3 class="text-lg font-medium text-gray-900">Hapus Customer</h3>
            <p class="text-sm text-gray-500 mt-1">
              Apakah Anda yakin ingin menghapus customer <strong>{{ customerToDelete?.company_name }}</strong>? Data customer yang sudah dihapus tidak dapat dikembalikan.
            </p>
          </div>
        </div>
        <div class="mt-6 flex justify-end space-x-3">
          <button 
            @click="showDeleteModal = false" 
            class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 font-medium py-2 px-4 rounded-lg transition duration-150"
          >
            Batal
          </button>
          <button 
            @click="deleteCustomer" 
            class="bg-red-600 hover:bg-red-700 text-white font-medium py-2 px-4 rounded-lg transition duration-150"
          >
            Ya, Hapus
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import AdminNavigation from '@/components/AdminNavigation.vue'
import Header from '@/components/Header.vue'
import Footer from '@/components/Footer.vue'
import customerService, { type Customer } from '@/services/customer.service'

const router = useRouter()
const customers = ref<Customer[]>([])
const loading = ref(false)
const searchQuery = ref('')
const showDeleteModal = ref(false)
const customerToDelete = ref<Customer | null>(null)

const message = ref({
  show: false,
  text: '',
  isError: false
})

const meta = ref({
  current_page: 1,
  last_page: 1,
  per_page: 10,
  total: 0
})

let searchTimeout: number | null = null

const toggleSidebar = () => {
  const sidebar = document.getElementById('sidebar')
  const overlay = document.getElementById('overlay')
  if (sidebar && overlay) {
    sidebar.classList.toggle('-translate-x-full')
    overlay.classList.toggle('hidden')
  }
}

const showMessage = (text: string, isError: boolean = false) => {
  message.value = { show: true, text, isError }
  setTimeout(() => {
    message.value.show = false
  }, 3000)
}

const fetchCustomers = async (page: number = 1) => {
  loading.value = true
  try {
    const response = await customerService.getAll(searchQuery.value, page, meta.value.per_page)
    customers.value = response.data
    meta.value = {
      current_page: response.current_page,
      last_page: response.last_page,
      per_page: response.per_page,
      total: response.total
    }
  } catch (error) {
    console.error('Error fetching customers:', error)
    showMessage('Gagal memuat data customer', true)
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  if (searchTimeout) {
    clearTimeout(searchTimeout)
  }
  searchTimeout = window.setTimeout(() => {
    meta.value.current_page = 1
    fetchCustomers(1)
  }, 500)
}

const changePage = (page: number) => {
  if (page >= 1 && page <= meta.value.last_page) {
    meta.value.current_page = page
    fetchCustomers(page)
  }
}

const confirmDelete = (customer: Customer) => {
  customerToDelete.value = customer
  showDeleteModal.value = true
}

const deleteCustomer = async () => {
  if (!customerToDelete.value) return
  
  try {
    await customerService.delete(customerToDelete.value.id)
    showMessage('Customer berhasil dihapus')
    showDeleteModal.value = false
    customerToDelete.value = null
    fetchCustomers(meta.value.current_page)
  } catch (error) {
    console.error('Error deleting customer:', error)
    showMessage('Gagal menghapus customer', true)
  }
}

onMounted(() => {
  fetchCustomers()
})
</script>
