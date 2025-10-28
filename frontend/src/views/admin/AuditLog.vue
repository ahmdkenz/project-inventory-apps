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
        <div class="flex-1"></div>
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
              <svg class="h-4 w-4 text-gray-500 hidden md:block" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 8.25l-7.5 7.5-7.5-7.5" />
              </svg>
            </button>
            <div v-if="showProfileMenu" class="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg py-1 z-20 border border-gray-200">
              <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Profil Saya</a>
              <a @click.prevent="handleLogout" href="#" class="block px-4 py-2 text-sm text-red-600 hover:bg-gray-100">Logout</a>
            </div>
          </div>
        </div>
      </header>

      <main class="flex-1 p-6 overflow-y-auto">
        <h1 class="text-3xl font-bold text-gray-900 mb-6">Riwayat Aktivitas Sistem</h1>
        
        <!-- Filter -->
        <div class="mb-6 bg-white p-6 rounded-lg shadow-sm border border-gray-200">
          <h3 class="text-lg font-medium text-gray-900 mb-4">Filter Log</h3>
          <div class="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-5 gap-4">
            <div class="md:col-span-1">
              <label for="filter-user" class="block text-sm font-medium text-gray-700 mb-1">Pengguna</label>
              <input 
                v-model="filters.username" 
                type="text" 
                id="filter-user" 
                placeholder="Cari username..." 
                class="w-full rounded-md border-gray-300 shadow-sm p-2 text-sm focus:border-blue-500 focus:ring-blue-500">
            </div>
            <div class="md:col-span-1">
              <label for="filter-action" class="block text-sm font-medium text-gray-700 mb-1">Jenis Aksi</label>
              <select 
                v-model="filters.action" 
                id="filter-action" 
                class="w-full rounded-md border-gray-300 shadow-sm p-2 text-sm focus:border-blue-500 focus:ring-blue-500">
                <option value="">Semua Aksi</option>
                <option value="login">Login</option>
                <option value="logout">Logout</option>
                <option value="create">Tambah Data</option>
                <option value="update">Edit Data</option>
                <option value="delete">Hapus Data</option>
                <option value="approve">Approve</option>
                <option value="reject">Reject</option>
              </select>
            </div>
            <div>
              <label for="filter-date-start" class="block text-sm font-medium text-gray-700 mb-1">Tanggal Mulai</label>
              <input 
                v-model="filters.date_start" 
                type="date" 
                id="filter-date-start" 
                class="w-full rounded-md border-gray-300 shadow-sm p-2 text-sm focus:border-blue-500 focus:ring-blue-500">
            </div>
            <div>
              <label for="filter-date-end" class="block text-sm font-medium text-gray-700 mb-1">Tanggal Selesai</label>
              <input 
                v-model="filters.date_end" 
                type="date" 
                id="filter-date-end" 
                class="w-full rounded-md border-gray-300 shadow-sm p-2 text-sm focus:border-blue-500 focus:ring-blue-500">
            </div>
            <div class="flex items-end">
              <button 
                @click="applyFilters" 
                class="w-full bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg transition duration-150">
                Terapkan
              </button>
            </div>
          </div>
        </div>

        <!-- Daftar Log Aktivitas -->
        <div class="bg-white rounded-lg shadow-sm border border-gray-200">
          <div v-if="loading" class="flex justify-center items-center py-12">
            <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
          </div>

          <ul v-else class="divide-y divide-gray-200">
            <li v-if="logs.length === 0" class="p-8 text-center text-gray-500">
              <svg class="mx-auto h-12 w-12 text-gray-400 mb-3" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 6v6h4.5m4.5 0a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
              <p class="text-sm font-medium">Tidak ada data log aktivitas.</p>
            </li>

            <li v-for="log in logs" :key="log.id" class="p-4 sm:p-6 flex items-start space-x-4 hover:bg-gray-50 transition duration-150">
              <div class="flex-shrink-0 p-3 rounded-full" :class="getActionBgClass(log.action)">
                <svg class="h-6 w-6" :class="getActionTextClass(log.action)" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" :d="getActionIcon(log.action)" />
                </svg>
              </div>
              <div class="flex-1 min-w-0">
                <p class="text-sm text-gray-800">
                  <span class="font-medium text-gray-900">{{ log.username }}</span> {{ log.description }}
                </p>
                <p class="text-sm text-gray-500 mt-1">{{ formatDate(log.created_at) }}</p>
              </div>
            </li>
          </ul>
        </div>

        <!-- Pagination -->
        <div v-if="pagination.total > 0" class="mt-6 flex items-center justify-between">
          <button 
            @click="changePage(pagination.current_page - 1)"
            :disabled="pagination.current_page === 1"
            :class="[
              'bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 font-medium py-2 px-4 rounded-lg text-sm transition duration-150',
              pagination.current_page === 1 ? 'opacity-50 cursor-not-allowed' : ''
            ]">
            Sebelumnya
          </button>
          <span class="text-sm text-gray-600">
            Halaman <span class="font-medium">{{ pagination.current_page }}</span> dari <span class="font-medium">{{ pagination.last_page }}</span>
          </span>
          <button 
            @click="changePage(pagination.current_page + 1)"
            :disabled="pagination.current_page === pagination.last_page"
            :class="[
              'bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 font-medium py-2 px-4 rounded-lg text-sm transition duration-150',
              pagination.current_page === pagination.last_page ? 'opacity-50 cursor-not-allowed' : ''
            ]">
            Berikutnya
          </button>
        </div>

      </main>
    </div>
  </div>

  <!-- Message Toast -->
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
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import AdminNavigation from '@/components/AdminNavigation.vue'
import auditLogService, { type AuditLog, type AuditLogFilters } from '@/services/auditLog.service'

const router = useRouter()

const user = ref({
  name: 'Admin',
  email: 'admin@example.com',
  role: 'Administrator'
})

const showProfileMenu = ref(false)
const loading = ref(false)
const logs = ref<AuditLog[]>([])

const filters = reactive<AuditLogFilters>({
  username: '',
  action: '',
  date_start: '',
  date_end: '',
  per_page: 15,
  page: 1
})

const pagination = reactive({
  current_page: 1,
  last_page: 1,
  per_page: 15,
  total: 0
})

const message = reactive({
  show: false,
  text: '',
  isError: false
})

onMounted(async () => {
  const storedUser = localStorage.getItem('user')
  if (storedUser) {
    const userData = JSON.parse(storedUser)
    user.value = userData
  }
  
  await fetchLogs()
})

const fetchLogs = async () => {
  loading.value = true
  try {
    const response = await auditLogService.getAll(filters)
    if (response.success) {
      logs.value = response.data
      Object.assign(pagination, response.pagination)
    }
  } catch (error: any) {
    console.error('Error loading logs:', error)
    showMessage(error.response?.data?.message || 'Gagal memuat data log aktivitas', true)
  } finally {
    loading.value = false
  }
}

const applyFilters = async () => {
  filters.page = 1
  await fetchLogs()
}

const changePage = async (page: number) => {
  if (page < 1 || page > pagination.last_page) return
  filters.page = page
  await fetchLogs()
}

const toggleSidebar = () => {
  const sidebar = document.getElementById('sidebar')
  const overlay = document.getElementById('overlay')
  
  if (sidebar && overlay) {
    sidebar.classList.toggle('-translate-x-full')
    overlay.classList.toggle('hidden')
  }
}

const getActionBgClass = (action: string) => {
  const classes: any = {
    'login': 'bg-green-100',
    'logout': 'bg-gray-100',
    'create': 'bg-blue-100',
    'update': 'bg-yellow-100',
    'delete': 'bg-red-100',
    'approve': 'bg-green-100',
    'reject': 'bg-red-100'
  }
  return classes[action] || 'bg-gray-100'
}

const getActionTextClass = (action: string) => {
  const classes: any = {
    'login': 'text-green-600',
    'logout': 'text-gray-600',
    'create': 'text-blue-600',
    'update': 'text-yellow-600',
    'delete': 'text-red-600',
    'approve': 'text-green-600',
    'reject': 'text-red-600'
  }
  return classes[action] || 'text-gray-600'
}

const getActionIcon = (action: string) => {
  const icons: any = {
    'login': 'M15.75 9V5.25A2.25 2.25 0 0013.5 3h-6a2.25 2.25 0 00-2.25 2.25v13.5A2.25 2.25 0 007.5 21h6a2.25 2.25 0 002.25-2.25V15m3 0l3-3m0 0l-3-3m3 3H9',
    'logout': 'M15.75 9V5.25A2.25 2.25 0 0013.5 3h-6a2.25 2.25 0 00-2.25 2.25v13.5A2.25 2.25 0 007.5 21h6a2.25 2.25 0 002.25-2.25V15M12 9l-3 3m0 0l3 3m-3-3h12.75',
    'create': 'M12 4.5v15m7.5-7.5h-15',
    'update': 'M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L10.582 16.07a4.5 4.5 0 01-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 011.13-1.897l8.932-8.931zm0 0L19.5 7.125M18 14v4.75A2.25 2.25 0 0115.75 21H5.25A2.25 2.25 0 013 18.75V8.25A2.25 2.25 0 015.25 6H10',
    'delete': 'M14.74 9l-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 01-2.244 2.077H8.084a2.25 2.25 0 01-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 00-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 013.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 00-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 00-7.5 0',
    'approve': 'M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z',
    'reject': 'M9.75 9.75l4.5 4.5m0-4.5l-4.5 4.5M21 12a9 9 0 11-18 0 9 9 0 0118 0z'
  }
  return icons[action] || 'M12 6v6h4.5m4.5 0a9 9 0 11-18 0 9 9 0 0118 0z'
}

const formatDate = (dateString: string) => {
  if (!dateString) return '-'
  const date = new Date(dateString)
  return date.toLocaleString('id-ID', { 
    day: 'numeric', 
    month: 'short', 
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  }) + ' WIB'
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
/* Smooth transitions */
* {
  transition-property: background-color, border-color, color, fill, stroke;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
  transition-duration: 150ms;
}
</style>
