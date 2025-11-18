<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import axios from 'axios'

interface Activity {
  id: string
  type: string
  action: string
  item: string
  timestamp: string
  user?: {
    name: string
    email: string
  }
}

const router = useRouter()
const activities = ref<Activity[]>([])
const loading = ref(false)
const error = ref('')

// Filter states
const selectedAction = ref('all')
const startDate = ref('')
const endDate = ref('')
const searchTerm = ref('')

// Pagination
const currentPage = ref(1)
const itemsPerPage = 10

// Get current user from localStorage
const currentUser = JSON.parse(localStorage.getItem('user') || '{}')

const actionTypes = [
  { value: 'all', label: 'Semua Aktivitas' },
  { value: 'add', label: 'Barang Masuk (PO)' },
  { value: 'remove', label: 'Barang Keluar (SO)' },
  { value: 'edit', label: 'Edit Data' },
  { value: 'delete', label: 'Hapus Data' }
]

const getActionIcon = (type: string) => {
  switch (type) {
    case 'add':
      return 'M9 12.75l3 3m0 0l3-3m-3 3v-7.5M21 12a9 9 0 11-18 0 9 9 0 0118 0z'
    case 'remove':
      return 'M9 8.25H7.5a2.25 2.25 0 00-2.25 2.25v9a2.25 2.25 0 002.25 2.25h9a2.25 2.25 0 002.25-2.25v-9a2.25 2.25 0 00-2.25-2.25H15m0-3l-3-3m0 0l-3 3m3-3V15'
    case 'edit':
      return 'M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L10.582 16.07a4.5 4.5 0 01-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 011.13-1.897l8.932-8.931zm0 0L19.5 7.125M18 14v4.75A2.25 2.25 0 0115.75 21H5.25A2.25 2.25 0 013 18.75V8.25A2.25 2.25 0 015.25 6H10'
    case 'delete':
      return 'M14.74 9l-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 01-2.244 2.077H8.084a2.25 2.25 0 01-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 00-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 013.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 00-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 00-7.5 0'
    default:
      return 'M12 6v6h4.5m4.5 0a9 9 0 11-18 0 9 9 0 0118 0z'
  }
}

const getActionColor = (type: string) => {
  switch (type) {
    case 'add':
      return 'bg-purple-100 text-purple-600'
    case 'remove':
      return 'bg-blue-100 text-blue-600'
    case 'edit':
      return 'bg-yellow-100 text-yellow-600'
    case 'delete':
      return 'bg-red-100 text-red-600'
    default:
      return 'bg-gray-100 text-gray-600'
  }
}

const fetchActivities = async () => {
  loading.value = true
  error.value = ''
  
  try {
    const token = localStorage.getItem('token')
    const response = await axios.get('http://localhost:8000/api/staff/activities/my', {
      headers: {
        Authorization: `Bearer ${token}`
      }
    })
    
    activities.value = response.data
  } catch (err: any) {
    error.value = err.response?.data?.message || 'Gagal memuat data aktivitas'
    console.error('Error fetching activities:', err)
  } finally {
    loading.value = false
  }
}

const filteredActivities = () => {
  let filtered = [...activities.value]
  
  // Filter by action type
  if (selectedAction.value !== 'all') {
    filtered = filtered.filter(a => a.type === selectedAction.value)
  }
  
  // Filter by search term
  if (searchTerm.value) {
    const search = searchTerm.value.toLowerCase()
    filtered = filtered.filter(a => 
      a.action.toLowerCase().includes(search) ||
      a.item.toLowerCase().includes(search)
    )
  }
  
  // Filter by date range
  if (startDate.value) {
    filtered = filtered.filter(a => {
      const activityDate = new Date(a.timestamp)
      return activityDate >= new Date(startDate.value)
    })
  }
  
  if (endDate.value) {
    filtered = filtered.filter(a => {
      const activityDate = new Date(a.timestamp)
      return activityDate <= new Date(endDate.value + 'T23:59:59')
    })
  }
  
  return filtered
}

const paginatedActivities = () => {
  const filtered = filteredActivities()
  const start = (currentPage.value - 1) * itemsPerPage
  const end = start + itemsPerPage
  return filtered.slice(start, end)
}

const totalPages = () => {
  return Math.ceil(filteredActivities().length / itemsPerPage)
}

const formatDate = (timestamp: string) => {
  const date = new Date(timestamp)
  const now = new Date()
  const diff = now.getTime() - date.getTime()
  const diffDays = Math.floor(diff / (1000 * 60 * 60 * 24))
  
  if (diffDays === 0) {
    const diffHours = Math.floor(diff / (1000 * 60 * 60))
    if (diffHours === 0) {
      const diffMinutes = Math.floor(diff / (1000 * 60))
      return diffMinutes === 0 ? 'Baru saja' : `${diffMinutes} menit yang lalu`
    }
    return `${diffHours} jam yang lalu`
  } else if (diffDays === 1) {
    return 'Kemarin'
  } else if (diffDays < 7) {
    return `${diffDays} hari yang lalu`
  } else {
    return date.toLocaleDateString('id-ID', {
      day: 'numeric',
      month: 'long',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    })
  }
}

const resetFilters = () => {
  selectedAction.value = 'all'
  startDate.value = ''
  endDate.value = ''
  searchTerm.value = ''
  currentPage.value = 1
}

const goToPage = (page: number) => {
  if (page >= 1 && page <= totalPages()) {
    currentPage.value = page
  }
}

onMounted(() => {
  fetchActivities()
})
</script>

<template>
  <div>
    <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6">
          <div>
            <h1 class="text-3xl font-bold text-gray-900">Riwayat Saya</h1>
            <p class="text-sm text-gray-600 mt-1">Daftar aktivitas yang telah saya lakukan</p>
          </div>
          <button
            @click="fetchActivities"
            :disabled="loading"
            class="mt-4 md:mt-0 bg-blue-600 hover:bg-blue-700 disabled:bg-blue-400 text-white font-medium py-2 px-4 rounded-lg flex items-center space-x-2 transition duration-150"
          >
            <svg class="h-5 w-5" :class="{ 'animate-spin': loading }" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M16.023 9.348h4.992v-.001M2.985 19.644v-4.992m0 0h4.992m-4.993 0l3.181 3.183a8.25 8.25 0 0013.803-3.7M4.031 9.865a8.25 8.25 0 0113.803-3.7l3.181 3.182m0-4.991v4.99" />
            </svg>
            <span>{{ loading ? 'Memuat...' : 'Refresh' }}</span>
          </button>
        </div>
        <!-- Filter Section -->
        <div class="mb-6 bg-white p-4 rounded-lg shadow-sm">
          <h2 class="text-lg font-semibold text-gray-800 mb-4">Filter Aktivitas</h2>
          <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
            <!-- Action Type Filter -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Jenis Aktivitas</label>
              <select
                v-model="selectedAction"
                class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
              >
                <option v-for="action in actionTypes" :key="action.value" :value="action.value">
                  {{ action.label }}
                </option>
              </select>
            </div>

            <!-- Search Term -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Cari</label>
              <input
                v-model="searchTerm"
                type="text"
                placeholder="Cari aktivitas..."
                class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
              />
            </div>

            <!-- Start Date -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Tanggal Mulai</label>
              <input
                v-model="startDate"
                type="date"
                class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500 text-gray-500"
              />
            </div>

            <!-- End Date -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Tanggal Akhir</label>
              <input
                v-model="endDate"
                type="date"
                class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500 text-gray-500"
              />
            </div>
          </div>

          <div class="mt-4 flex justify-between items-center">
            <p class="text-sm text-gray-600">
              Menampilkan {{ filteredActivities().length }} dari {{ activities.length }} aktivitas
            </p>
            <button
              @click="resetFilters"
              class="px-4 py-2 text-sm text-gray-700 bg-gray-100 rounded-lg hover:bg-gray-200 transition duration-150"
            >
              Reset Filter
            </button>
          </div>
        </div>

        <!-- Activities List -->
        <div class="bg-white rounded-lg shadow-sm overflow-hidden">
          <!-- Loading State -->
          <div v-if="loading" class="text-center py-12">
            <div class="inline-block h-8 w-8 animate-spin rounded-full border-4 border-solid border-blue-600 border-r-transparent"></div>
            <p class="mt-4 text-gray-600">Memuat data aktivitas...</p>
          </div>

          <!-- Error State -->
          <div v-else-if="error" class="text-center py-12">
            <svg class="mx-auto h-12 w-12 text-red-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <p class="mt-4 text-red-600">{{ error }}</p>
            <button
              @click="fetchActivities"
              class="mt-4 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700"
            >
              Coba Lagi
            </button>
          </div>

          <!-- Empty State -->
          <div v-else-if="paginatedActivities().length === 0" class="text-center py-12">
            <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
            </svg>
            <p class="mt-4 text-gray-600">Belum ada aktivitas yang tercatat</p>
          </div>

          <!-- Activities Timeline -->
          <div v-else class="p-6 space-y-4">
            <div
              v-for="activity in paginatedActivities()"
              :key="activity.id"
              class="flex items-start space-x-4 p-4 border border-gray-200 rounded-lg hover:bg-gray-50 transition duration-150"
            >
              <!-- Icon -->
              <div class="flex-shrink-0">
                <div :class="['h-12 w-12 rounded-full flex items-center justify-center', getActionColor(activity.type)]">
                  <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" :d="getActionIcon(activity.type)" />
                  </svg>
                </div>
              </div>

              <!-- Content -->
              <div class="flex-1 min-w-0">
                <div class="flex items-start justify-between">
                  <div>
                    <p class="text-sm font-medium text-gray-900">
                      {{ currentUser.name || 'Anda' }}
                      <span class="text-gray-600 font-normal">{{ activity.action }}</span>
                    </p>
                    <p class="text-sm text-gray-600 mt-1">
                      <span class="font-medium">{{ activity.item }}</span>
                    </p>
                    <p class="text-xs text-gray-500 mt-2">{{ formatDate(activity.timestamp) }}</p>
                  </div>
                  
                  <!-- Action Badge -->
                  <span
                    :class="[
                      'px-3 py-1 text-xs font-medium rounded-full',
                      activity.type === 'add' ? 'bg-purple-100 text-purple-700' :
                      activity.type === 'remove' ? 'bg-blue-100 text-blue-700' :
                      activity.type === 'edit' ? 'bg-yellow-100 text-yellow-700' :
                      activity.type === 'delete' ? 'bg-red-100 text-red-700' :
                      'bg-gray-100 text-gray-700'
                    ]"
                  >
                    {{ activity.type === 'add' ? 'Barang Masuk' :
                       activity.type === 'remove' ? 'Barang Keluar' :
                       activity.type === 'edit' ? 'Edit' :
                       activity.type === 'delete' ? 'Hapus' : activity.type }}
                  </span>
                </div>
              </div>
            </div>
          </div>

          <!-- Pagination -->
          <div v-if="!loading && !error && totalPages() > 1" class="mt-6 flex items-center justify-between border-t border-gray-200 pt-4">
            <div class="flex items-center space-x-2">
              <button
                @click="goToPage(currentPage - 1)"
                :disabled="currentPage === 1"
                :class="[
                  'px-3 py-2 rounded-lg text-sm font-medium transition duration-150',
                  currentPage === 1
                    ? 'bg-gray-100 text-gray-400 cursor-not-allowed'
                    : 'bg-blue-600 text-white hover:bg-blue-700'
                ]"
              >
                Previous
              </button>
              
              <div class="flex items-center space-x-1">
                <button
                  v-for="page in totalPages()"
                  :key="page"
                  @click="goToPage(page)"
                  :class="[
                    'px-4 py-2 rounded-lg text-sm font-medium transition duration-150',
                    currentPage === page
                      ? 'bg-blue-600 text-white'
                      : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                  ]"
                >
                  {{ page }}
                </button>
              </div>
              
              <button
                @click="goToPage(currentPage + 1)"
                :disabled="currentPage === totalPages()"
                :class="[
                  'px-3 py-2 rounded-lg text-sm font-medium transition duration-150',
                  currentPage === totalPages()
                    ? 'bg-gray-100 text-gray-400 cursor-not-allowed'
                    : 'bg-blue-600 text-white hover:bg-blue-700'
                ]"
              >
                Next
              </button>
            </div>

            <p class="text-sm text-gray-600">
              Halaman {{ currentPage }} dari {{ totalPages() }}
            </p>
          </div>
        </div>
  </div>
</template>
