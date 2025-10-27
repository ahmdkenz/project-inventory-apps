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
      <header class="bg-white shadow-sm p-4 flex items-center justify-between z-10">
        <button id="hamburger-btn" @click="toggleSidebar" class="text-gray-600 lg:hidden">
          <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5" />
          </svg>
        </button>
        <div class="relative hidden sm:block">
          <input 
            v-model="searchQuery" 
            @input="handleSearch"
            type="text" 
            class="border border-gray-300 rounded-full py-2 px-4 pl-10" 
            placeholder="Cari pengguna...">
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

      <!-- Konten Halaman Utama -->
      <main class="flex-1 p-6 overflow-y-auto">
        <!-- Header Halaman -->
        <div class="flex justify-between items-center mb-6">
          <h1 class="text-3xl font-bold text-gray-900">Manajemen Pengguna</h1>
          <router-link 
            to="/admin/users/add"
            class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg flex items-center space-x-2 transition duration-150">
            <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
            </svg>
            <span>Tambah Pengguna</span>
          </router-link>
        </div>

        <!-- Tabel Data Pengguna -->
        <div class="bg-white rounded-lg shadow-md overflow-hidden">
          <div v-if="loading" class="flex justify-center items-center py-12">
            <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
          </div>
          
          <!-- Kontainer untuk responsif mobile -->
          <div v-else class="overflow-x-auto">
            <table class="w-full min-w-max">
              <!-- Header Tabel -->
              <thead class="bg-gray-50 border-b border-gray-200">
                <tr>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nama</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Username</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Peran</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tgl. Bergabung</th>
                  <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Aksi</th>
                </tr>
              </thead>
              <!-- Body Tabel -->
              <tbody class="divide-y divide-gray-200">
                <tr v-if="filteredUsers.length === 0">
                  <td colspan="6" class="px-6 py-8 text-center text-gray-500">
                    Tidak ada data pengguna.
                  </td>
                </tr>
                <tr v-for="userData in filteredUsers" :key="userData.id">
                  <td class="px-6 py-4 whitespace-nowrap">
                    <div class="flex items-center">
                      <img 
                        class="h-10 w-10 rounded-full" 
                        :src="`https://placehold.co/100x100/EBF8FF/3182CE?text=${userData.name.charAt(0).toUpperCase()}`" 
                        alt="">
                      <div class="ml-4">
                        <div class="text-sm font-medium text-gray-900">{{ userData.name }}</div>
                        <div class="text-sm text-gray-500">{{ userData.email }}</div>
                      </div>
                    </div>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ userData.username }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                    <span :class="[
                      'px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full',
                      userData.role === 'admin' ? 'bg-purple-100 text-purple-800' : 'bg-blue-100 text-blue-800'
                    ]">
                      {{ userData.role === 'admin' ? 'Admin' : 'Staff' }}
                    </span>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <span :class="[
                      'px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full',
                      userData.status === 'active' ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'
                    ]">
                      {{ userData.status === 'active' ? 'Aktif' : 'Nonaktif' }}
                    </span>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {{ formatDate(userData.created_at) }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                    <router-link 
                      :to="`/admin/users/edit/${userData.id}`"
                      class="text-blue-600 hover:text-blue-900">
                      Edit
                    </router-link>
                    <button 
                      @click="confirmDelete(userData)"
                      class="text-red-600 hover:text-red-900 ml-4">
                      Hapus
                    </button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </main>
    </div>
  </div>

  <!-- Modal Konfirmasi Hapus -->
  <div v-if="showDeleteModal" class="fixed inset-0 bg-gray-600 bg-opacity-75 flex items-center justify-center p-4 z-50 transition-opacity duration-300">
    <div class="bg-white rounded-lg shadow-xl w-full max-w-md transform transition-all">
      <!-- Header Modal -->
      <div class="p-6 border-b border-gray-200">
        <h3 class="text-lg font-medium leading-6 text-gray-900">Hapus Pengguna</h3>
      </div>
      <!-- Body Modal -->
      <div class="p-6">
        <p class="text-sm text-gray-600">
          Apakah Anda yakin ingin menghapus pengguna <strong>{{ userToDelete?.name }}</strong>? Tindakan ini tidak dapat dibatalkan.
        </p>
      </div>
      <!-- Footer Modal -->
      <div class="px-6 py-4 bg-gray-50 rounded-b-lg flex justify-end space-x-3">
        <button 
          @click="closeDeleteModal"
          type="button" 
          class="bg-white hover:bg-gray-100 text-gray-700 font-medium py-2 px-4 rounded-lg border border-gray-300 transition duration-150">
          Batal
        </button>
        <button 
          @click="deleteUser"
          type="button" 
          class="bg-red-600 hover:bg-red-700 text-white font-medium py-2 px-4 rounded-lg transition duration-150">
          Ya, Hapus
        </button>
      </div>
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
import userService, { type User } from '@/services/user.service'

const router = useRouter()

// User state
const user = ref({
  name: 'Admin',
  email: 'admin@example.com',
  role: 'Administrator'
})

// UI state
const showProfileMenu = ref(false)
const loading = ref(false)
const showDeleteModal = ref(false)
const userToDelete = ref<User | null>(null)
const searchQuery = ref('')

// Users list
const usersList = ref<User[]>([])

// Message state
const message = reactive({
  show: false,
  text: '',
  isError: false
})

// Filtered users based on search
const filteredUsers = computed(() => {
  if (!searchQuery.value) return usersList.value
  
  const query = searchQuery.value.toLowerCase()
  return usersList.value.filter(u => 
    u.name.toLowerCase().includes(query) ||
    u.username.toLowerCase().includes(query) ||
    u.email.toLowerCase().includes(query) ||
    u.role.toLowerCase().includes(query)
  )
})

// Load user data and fetch users
onMounted(async () => {
  const storedUser = localStorage.getItem('user')
  if (storedUser) {
    const userData = JSON.parse(storedUser)
    user.value = userData
  }
  
  await fetchUsers()
})

// Fetch users from API
const fetchUsers = async () => {
  loading.value = true
  try {
    const response = await userService.getAll()
    if (response.success && Array.isArray(response.data)) {
      usersList.value = response.data
    }
  } catch (error: any) {
    console.error('Error loading users:', error)
    showMessage(error.response?.data?.message || 'Gagal memuat data pengguna', true)
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
const confirmDelete = (userData: User) => {
  userToDelete.value = userData
  showDeleteModal.value = true
}

// Close delete modal
const closeDeleteModal = () => {
  showDeleteModal.value = false
  userToDelete.value = null
}

// Delete user
const deleteUser = async () => {
  if (!userToDelete.value?.id) return
  
  try {
    await userService.delete(userToDelete.value.id)
    showMessage('Pengguna berhasil dihapus.', false)
    closeDeleteModal()
    await fetchUsers()
  } catch (error: any) {
    console.error('Error deleting user:', error)
    showMessage(error.response?.data?.message || 'Gagal menghapus pengguna', true)
  }
}

// Format date
const formatDate = (dateString: string | undefined) => {
  if (!dateString) return '-'
  const date = new Date(dateString)
  return date.toLocaleDateString('id-ID', { 
    day: '2-digit', 
    month: 'short', 
    year: 'numeric' 
  })
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

// Handle logout
const handleLogout = () => {
  localStorage.removeItem('token')
  localStorage.removeItem('user')
  router.push('/login')
}
</script>

<style scoped>
/* Additional custom styles if needed */
</style>
