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
      <!-- Header -->
      <Header @toggle-sidebar="toggleSidebar" />

      <!-- Konten Halaman Utama -->
      <main class="flex-1 p-6 overflow-y-auto">
        <!-- Tombol Kembali -->
        <div class="mb-6">
          <router-link to="/admin/kategori" class="flex items-center space-x-2 text-sm font-medium text-gray-600 hover:text-gray-900 transition duration-150">
            <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7" />
            </svg>
            <span>Kembali ke Daftar Kategori</span>
          </router-link>
        </div>

        <h1 class="text-3xl font-bold text-gray-900 mb-6">
          {{ isEdit ? 'Edit Kategori' : 'Tambah Kategori Baru' }}
        </h1>

        <!-- Formulir -->
        <div class="bg-white rounded-lg shadow-md max-w-2xl">
          <form @submit.prevent="handleSubmit" id="category-form">
            <div class="p-6">
              <div class="space-y-6">
                <!-- Kode Kategori (Auto-Generated, Readonly) -->
                <div>
                  <label for="category-code" class="block text-sm font-medium leading-6 text-gray-900">Kode Kategori</label>
                  <div class="mt-2 flex gap-2">
                    <input 
                      type="text" 
                      id="category-code" 
                      v-model="formData.code"
                      readonly
                      class="block w-full rounded-md border-0 p-3 text-gray-900 bg-gray-100 shadow-sm ring-1 ring-inset ring-gray-300 sm:text-sm sm:leading-6 cursor-not-allowed">
                    <button
                      v-if="!isEdit"
                      type="button"
                      @click="generateCode"
                      class="px-3 py-2 bg-gray-600 hover:bg-gray-700 text-white rounded-md transition duration-150"
                      title="Generate ulang kode">
                      <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M16.023 9.348h4.992v-.001M2.985 19.644v-4.992m0 0h4.992m-4.993 0l3.181 3.183a8.25 8.25 0 0013.803-3.7M4.031 9.865a8.25 8.25 0 0113.803-3.7l3.181 3.182m0-4.991v4.99" />
                      </svg>
                    </button>
                  </div>
                  <p class="mt-1 text-xs text-gray-500">Kode dibuat otomatis: CAT-(Nama)-(Unik)</p>
                </div>

                <!-- Nama Kategori -->
                <div>
                  <label for="category-name" class="block text-sm font-medium leading-6 text-gray-900">Nama Kategori</label>
                  <div class="mt-2">
                    <input 
                      type="text" 
                      id="category-name" 
                      v-model="formData.name"
                      required
                      class="block w-full rounded-md border-0 p-3 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-blue-600"
                      placeholder="Contoh: Elektronik">
                  </div>
                </div>
                
                <!-- Deskripsi -->
                <div>
                  <label for="description" class="block text-sm font-medium leading-6 text-gray-900">Deskripsi (Opsional)</label>
                  <div class="mt-2">
                    <textarea 
                      id="description" 
                      v-model="formData.description"
                      rows="4"
                      class="block w-full rounded-md border-0 p-3 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-blue-600"
                      placeholder="Masukkan deskripsi singkat kategori..."></textarea>
                  </div>
                </div>
              </div>
            </div>
            
            <!-- Footer Form -->
            <div class="px-6 py-4 bg-gray-50 rounded-b-lg flex justify-end space-x-3">
              <router-link 
                to="/admin/kategori" 
                class="bg-white hover:bg-gray-100 text-gray-700 font-medium py-2 px-4 rounded-lg border border-gray-300 transition duration-150">
                Batal
              </router-link>
              <button 
                type="submit" 
                :disabled="isSubmitting"
                class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg transition duration-150 disabled:opacity-50 disabled:cursor-not-allowed">
                {{ isSubmitting ? 'Menyimpan...' : 'Simpan Kategori' }}
              </button>
            </div>
          </form>
        </div>

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
import { ref, reactive, onMounted, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import AdminNavigation from '@/components/AdminNavigation.vue'
import Header from '@/components/Header.vue'
import Footer from '@/components/Footer.vue'
import kategoriService, { type Kategori } from '@/services/kategori.service'

const router = useRouter()
const route = useRoute()

// Check if edit mode
const isEdit = ref(false)
const kategoriId = ref<number | null>(null)

// User state
const user = ref({
  name: 'Admin',
  email: 'admin@example.com',
  role: 'Administrator'
})

// UI state
const isSubmitting = ref(false)

// Message state
const message = reactive({
  show: false,
  text: '',
  isError: false
})

// Form data
const formData = reactive({
  code: '',
  name: '',
  description: ''
})

// Load user data and check edit mode
onMounted(async () => {
  const storedUser = localStorage.getItem('user')
  if (storedUser) {
    const userData = JSON.parse(storedUser)
    user.value = userData
  }
  
  // Check if edit mode
  if (route.params.id) {
    isEdit.value = true
    kategoriId.value = parseInt(route.params.id as string)
    await loadKategori()
  }
})

// Load kategori for edit
const loadKategori = async () => {
  if (!kategoriId.value) return
  
  try {
    const response = await kategoriService.getById(kategoriId.value)
    if (response.success && !Array.isArray(response.data)) {
      const kategori = response.data
      formData.code = kategori.kode || ''
      formData.name = kategori.nama
      formData.description = kategori.deskripsi || ''
    }
  } catch (error: any) {
    console.error('Error loading kategori:', error)
    showMessage(error.response?.data?.message || 'Gagal memuat data kategori', true)
  }
}

// Generate kode kategori otomatis dengan pola CAT-(Nama Kategori)-(Kode Unik)
const generateCode = () => {
  if (formData.name && formData.name.trim() !== '') {
    const namePrefix = formData.name
      .trim()
      .split(' ')[0]
      .toUpperCase()
      .replace(/[^A-Z0-9]/g, '')
      .substring(0, 5)
    
    const uniqueCode = Date.now().toString().slice(-4)
    formData.code = `CAT-${namePrefix}-${uniqueCode}`
  } else {
    formData.code = ''
  }
}

// Watch perubahan pada nama kategori untuk auto-generate kode (hanya saat tambah)
watch(() => formData.name, (newValue, oldValue) => {
  if (!isEdit.value && newValue !== oldValue) {
    generateCode()
  }
})

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

// Handle form submit
const handleSubmit = async () => {
  // Validasi nama kategori
  if (!formData.name || formData.name.trim() === '') {
    showMessage('Nama kategori harus diisi.', true)
    return
  }

  isSubmitting.value = true

  try {
    const kategoriData: Partial<Kategori> = {
      nama: formData.name,
      kode: formData.code,
      deskripsi: formData.description || undefined
    }

    if (isEdit.value && kategoriId.value) {
      // Update kategori
      const response = await kategoriService.update(kategoriId.value, kategoriData as Kategori)
      if (response.success) {
        showMessage('Kategori berhasil diperbarui.', false)
      } else {
        showMessage(response.message || 'Gagal memperbarui kategori.', true)
      }
    } else {
      // Create new kategori
      const response = await kategoriService.create(kategoriData as Kategori)
      if (response.success) {
        showMessage('Kategori berhasil ditambahkan.', false)
      } else {
        showMessage(response.message || 'Gagal menambahkan kategori.', true)
      }
    }
    
    // Redirect after successful save
    setTimeout(() => {
      router.push('/admin/kategori')
    }, 1500)
  } catch (error: any) {
    console.error('Error saving data:', error)
    
    // Handle validation errors
    if (error.response?.data?.errors) {
      const errors = error.response.data.errors
      const firstError = Object.values(errors)[0]
      showMessage(Array.isArray(firstError) ? firstError[0] : 'Gagal menyimpan data kategori.', true)
    } else {
      showMessage(error.response?.data?.message || 'Gagal menyimpan data kategori. Silakan coba lagi.', true)
    }
  } finally {
    isSubmitting.value = false
  }
}
</script>

<style scoped>
/* Additional custom styles if needed */
</style>
