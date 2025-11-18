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
          <router-link to="/admin/barang" class="flex items-center space-x-2 text-sm font-medium text-gray-600 hover:text-gray-900 transition duration-150">
            <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7" />
            </svg>
            <span>Kembali ke Daftar Barang</span>
          </router-link>
        </div>

        <!-- Header Halaman -->
        <h1 class="text-3xl font-bold text-gray-900 mb-6">
          Tambah Barang Baru
          <!-- Judul bisa dinamis: "Edit Barang" jika dalam mode edit -->
        </h1>

        <!-- Formulir -->
        <div class="bg-white rounded-lg shadow-md">
          <form @submit.prevent="handleSubmit" id="item-form">
            <!-- Bagian Isi Form -->
            <div class="p-6">
              <!-- UPDATE: Layout disesuaikan untuk field harga baru -->
              <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <!-- Kode Barang (Auto-Generated) -->
                <div>
                  <label for="item-code" class="block text-sm font-medium leading-6 text-gray-900">Kode Barang</label>
                  <div class="mt-2 flex gap-2">
                    <input 
                      type="text" 
                      name="item-code" 
                      id="item-code" 
                      v-model="formData.code"
                      readonly
                      class="block w-full rounded-md border-0 p-3 text-gray-900 bg-gray-100 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 sm:text-sm sm:leading-6 cursor-not-allowed"
                      placeholder="Kode akan dibuat otomatis">
                    <button
                      type="button"
                      @click="generateCode"
                      class="px-3 py-2 bg-gray-600 hover:bg-gray-700 text-white rounded-md transition duration-150"
                      title="Generate ulang kode">
                      <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M16.023 9.348h4.992v-.001M2.985 19.644v-4.992m0 0h4.992m-4.993 0l3.181 3.183a8.25 8.25 0 0013.803-3.7M4.031 9.865a8.25 8.25 0 0113.803-3.7l3.181 3.182m0-4.991v4.99" />
                      </svg>
                    </button>
                  </div>
                  <p class="mt-1 text-xs text-gray-500">Kode dibuat otomatis: PRD-(Nama)-(Unik)</p>
                </div>

                <!-- Nama Barang -->
                <div>
                  <label for="item-name" class="block text-sm font-medium leading-6 text-gray-900">Nama Barang</label>
                  <div class="mt-2">
                    <input 
                      type="text" 
                      name="item-name" 
                      id="item-name" 
                      v-model="formData.name"
                      required
                      class="block w-full rounded-md border-0 p-3 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-blue-600 sm:text-sm sm:leading-6"
                      placeholder="Contoh: Kertas A4 80gr">
                  </div>
                </div>

                <!-- Kategori / Jenis -->
                <div>
                  <label for="item-category" class="block text-sm font-medium leading-6 text-gray-900">Kategori / Jenis</label>
                  <div class="mt-2">
                    <select 
                      id="item-category" 
                      name="item-category" 
                      v-model="formData.category"
                      required
                      class="block w-full rounded-md border-0 p-3 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 focus:ring-2 focus:ring-inset focus:ring-blue-600 sm:text-sm sm:leading-6">
                      <option value="" disabled selected>Pilih kategori</option>
                      <option 
                        v-for="kategori in kategoriList" 
                        :key="kategori.id" 
                        :value="kategori.id">
                        {{ kategori.nama }}
                      </option>
                    </select>
                  </div>
                </div>
                
                <!-- Satuan -->
                <div>
                  <label for="item-unit" class="block text-sm font-medium leading-6 text-gray-900">Satuan</label>
                  <div class="mt-2">
                    <input 
                      type="text" 
                      name="item-unit" 
                      id="item-unit" 
                      v-model="formData.unit"
                      required
                      class="block w-full rounded-md border-0 p-3 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-blue-600 sm:text-sm sm:leading-6"
                      placeholder="Contoh: Rim, Pcs, Unit, Box">
                  </div>
                </div>

                <!-- UPDATE: Harga Beli -->
                <div>
                  <label for="item-buy-price" class="block text-sm font-medium leading-6 text-gray-900">Harga Beli (Satuan)</label>
                  <div class="mt-2 relative rounded-md shadow-sm">
                    <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-4">
                      <span class="text-gray-500 sm:text-sm">Rp</span>
                    </div>
                    <input 
                      type="number" 
                      name="item-buy-price" 
                      id="item-buy-price" 
                      v-model="formData.buyPrice"
                      required 
                      min="0"
                      class="block w-full rounded-md border-0 p-3 pl-12 text-gray-900 ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-blue-600 sm:text-sm sm:leading-6"
                      placeholder="55000">
                  </div>
                </div>

                <!-- UPDATE: Harga Jual -->
                <div>
                  <label for="item-sell-price" class="block text-sm font-medium leading-6 text-gray-900">Harga Jual (Satuan)</label>
                  <div class="mt-2 relative rounded-md shadow-sm">
                    <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-4">
                      <span class="text-gray-500 sm:text-sm">Rp</span>
                    </div>
                    <input 
                      type="number" 
                      name="item-sell-price" 
                      id="item-sell-price" 
                      v-model="formData.sellPrice"
                      required 
                      min="0"
                      class="block w-full rounded-md border-0 p-3 pl-12 text-gray-900 ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-blue-600 sm:text-sm sm:leading-6"
                      placeholder="60000">
                  </div>
                </div>
              </div>

              <!-- UPDATE: Stok Awal dipindah ke baris baru (full width) -->
              <div class="mt-6">
                <label for="item-stock" class="block text-sm font-medium leading-6 text-gray-900">Stok Awal</label>
                <div class="mt-2">
                  <input 
                    type="number" 
                    name="item-stock" 
                    id="item-stock" 
                    v-model="formData.stock"
                    required 
                    min="0" 
                    value="0"
                    class="block w-full max-w-xs rounded-md border-0 p-3 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-blue-600 sm:text-sm sm:leading-6">
                  <p class="mt-1 text-sm text-gray-500">
                    Stok akan bertambah otomatis melalui 'Barang Masuk'.
                  </p>
                </div>
              </div>
            </div>
            
            <!-- Footer Form (Tombol Aksi) -->
            <div class="px-6 py-4 bg-gray-50 rounded-b-lg flex justify-end space-x-3">
              <router-link 
                to="/admin/barang" 
                class="bg-white hover:bg-gray-100 text-gray-700 font-medium py-2 px-4 rounded-lg border border-gray-300 transition duration-150">
                Batal
              </router-link>
              <button 
                type="submit" 
                :disabled="isSubmitting"
                class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg transition duration-150">
                {{ isSubmitting ? 'Menyimpan...' : 'Simpan Barang' }}
              </button>
            </div>
          </form>
        </div>

        <Footer />
      </main>
    </div>
  </div>

  <!-- Kotak Pesan Kustom (Pengganti alert()) -->
  <div 
    v-if="message.show"
    id="message-box" 
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
import barangService, { type Barang } from '@/services/barang.service'
import kategoriService, { type Kategori } from '@/services/kategori.service'

const router = useRouter()
const route = useRoute()

// User state
const user = ref({
  name: 'Admin',
  email: 'admin@example.com',
  role: 'Administrator'
})

// UI state
const isSubmitting = ref(false)
const isEdit = ref(false)

// Kategori list
const kategoriList = ref<Kategori[]>([])

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
  category: '',
  unit: '',
  buyPrice: 0,
  sellPrice: 0,
  stock: 0
})

// Load user data and kategori
onMounted(async () => {
  const storedUser = localStorage.getItem('user')
  if (storedUser) {
    const userData = JSON.parse(storedUser)
    user.value = userData
  }

  // Load kategori
  await loadKategori()

  // If route has id param -> edit mode
  const idParam = route.params.id
  if (idParam) {
    const id = Number(idParam)
    if (!isNaN(id)) {
      isEdit.value = true
      // Fetch barang data
      try {
        const resp = await barangService.getById(id)
        if (resp.success && resp.data) {
          const data = resp.data as Barang
          formData.code = data.kode || ''
          formData.name = data.nama || ''
          formData.category = String(data.kategori_id || data.kategori?.id || '')
          formData.unit = data.satuan || ''
          formData.buyPrice = Number(data.harga_beli || 0)
          formData.sellPrice = Number(data.harga_jual || 0)
          formData.stock = Number(data.stok || 0)
        } else {
          showMessage('Gagal memuat data barang untuk diedit.', true)
          router.push('/admin/barang')
        }
      } catch (error) {
        console.error('Error loading barang for edit:', error)
        showMessage('Terjadi kesalahan saat memuat data barang.', true)
        router.push('/admin/barang')
      }
    }
  }
})

// Load kategori from API
const loadKategori = async () => {
  try {
    const response = await kategoriService.getAll()
    if (response.success && Array.isArray(response.data)) {
      kategoriList.value = response.data
    }
  } catch (error) {
    console.error('Error loading kategori:', error)
    showMessage('Gagal memuat data kategori', true)
  }
}

// Generate kode barang otomatis dengan pola PRD-(Nama Barang)-(Kode Unik)
const generateCode = () => {
  if (formData.name && formData.name.trim() !== '') {
    // Ambil kata pertama atau 3 karakter pertama dari nama barang
    const namePrefix = ((formData.name || '')
      .trim()
      .split(' ')[0] || '') // Ambil kata pertama
      .toUpperCase()
      .replace(/[^A-Z0-9]/g, '') // Hapus karakter khusus
      .substring(0, 5) // Maksimal 5 karakter
    
    // Generate kode unik 4 digit dari timestamp
    const uniqueCode = Date.now().toString().slice(-4)
    
    // Format: PRD-NAMABARANG-1234
    formData.code = `PRD-${namePrefix}-${uniqueCode}`
  } else {
    formData.code = ''
  }
}

// Watch perubahan pada nama barang untuk auto-generate kode
watch(() => formData.name, (newValue, oldValue) => {
  // Hanya generate ulang jika nama barang berubah signifikan
  if (newValue !== oldValue) {
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
  // Validasi harga
  if (parseFloat(formData.sellPrice.toString()) < parseFloat(formData.buyPrice.toString())) {
    showMessage('Harga Jual tidak boleh lebih rendah dari Harga Beli.', true)
    return
  }

  // Validasi kategori
  if (!formData.category) {
    showMessage('Silakan pilih kategori barang.', true)
    return
  }

  isSubmitting.value = true

  try {
    // Prepare data for API
    const barangData: Barang = {
      nama: formData.name,
      kode: formData.code,
      kategori_id: parseInt(formData.category),
      satuan: formData.unit,
      harga_beli: parseFloat(formData.buyPrice.toString()),
      harga_jual: parseFloat(formData.sellPrice.toString()),
      stok: parseInt(formData.stock.toString()),
      stok_minimum: 0,
      status: true
    }

    let response
    if (isEdit.value) {
      const id = Number(route.params.id)
      response = await barangService.update(id, barangData)
    } else {
      response = await barangService.create(barangData)
    }

    if (response.success) {
      showMessage(isEdit.value ? 'Data barang berhasil diubah.' : 'Data barang berhasil disimpan.', false)

      // Redirect after successful save
      setTimeout(() => {
        router.push('/admin/barang')
      }, 1500)
    } else {
      showMessage(response.message || (isEdit.value ? 'Gagal mengubah data barang.' : 'Gagal menyimpan data barang.'), true)
    }
  } catch (error: any) {
    console.error('Error saving data:', error)

    // Handle validation errors
    if (error.response?.data?.errors) {
      const errors = error.response.data.errors
      const firstError = Object.values(errors)[0]
      showMessage(Array.isArray(firstError) ? firstError[0] : (isEdit.value ? 'Gagal mengubah data barang.' : 'Gagal menyimpan data barang.'), true)
    } else {
      showMessage(error.response?.data?.message || (isEdit.value ? 'Gagal mengubah data barang. Silakan coba lagi.' : 'Gagal menyimpan data barang. Silakan coba lagi.'), true)
    }
  } finally {
    isSubmitting.value = false
  }
}
</script>

<style scoped>
/* Additional custom styles if needed */
</style>
