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
        <!-- Tombol Kembali -->
        <div class="mb-6">
          <router-link to="/admin/supplier" class="flex items-center space-x-2 text-sm font-medium text-gray-600 hover:text-gray-900 transition duration-150">
            <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7" />
            </svg>
            <span>Kembali ke Daftar Supplier</span>
          </router-link>
        </div>

        <h1 class="text-3xl font-bold text-gray-900 mb-6">
          {{ isEdit ? 'Edit Supplier' : 'Tambah Supplier Baru' }}
        </h1>

        <!-- Formulir -->
        <div class="bg-white rounded-lg shadow-md max-w-3xl">
          <form @submit.prevent="handleSubmit" id="supplier-form">
            <div class="p-6">
              <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <!-- Nama Supplier -->
                <div>
                  <label for="supplier-name" class="block text-sm font-medium leading-6 text-gray-900">Nama Supplier</label>
                  <div class="mt-2">
                    <input 
                      type="text" 
                      id="supplier-name" 
                      v-model="formData.nama"
                      required
                      class="block w-full rounded-md border-0 p-3 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-blue-600"
                      placeholder="Contoh: PT. Supplier Jaya">
                  </div>
                </div>

                <!-- Kontak Person -->
                <div>
                  <label for="contact-person" class="block text-sm font-medium leading-6 text-gray-900">Kontak Person</label>
                  <div class="mt-2">
                    <input 
                      type="text" 
                      id="contact-person" 
                      v-model="formData.kontak_person"
                      required
                      class="block w-full rounded-md border-0 p-3 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-blue-600"
                      placeholder="Contoh: Bpk. Anton">
                  </div>
                </div>
                
                <!-- No. Telepon -->
                <div>
                  <label for="phone" class="block text-sm font-medium leading-6 text-gray-900">No. Telepon</label>
                  <div class="mt-2">
                    <input 
                      type="tel" 
                      id="phone" 
                      v-model="formData.telepon"
                      required
                      class="block w-full rounded-md border-0 p-3 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-blue-600"
                      placeholder="Contoh: 08123456789">
                  </div>
                </div>
                
                <!-- Email -->
                <div>
                  <label for="email" class="block text-sm font-medium leading-6 text-gray-900">Email</label>
                  <div class="mt-2">
                    <input 
                      type="email" 
                      id="email" 
                      v-model="formData.email"
                      required
                      class="block w-full rounded-md border-0 p-3 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-blue-600"
                      placeholder="Contoh: info@supplierjaya.com">
                  </div>
                </div>
                
                <!-- Alamat -->
                <div class="md:col-span-2">
                  <label for="address" class="block text-sm font-medium leading-6 text-gray-900">Alamat</label>
                  <div class="mt-2">
                    <textarea 
                      id="address" 
                      v-model="formData.alamat"
                      rows="4"
                      class="block w-full rounded-md border-0 p-3 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-blue-600"
                      placeholder="Masukkan alamat lengkap supplier..."></textarea>
                  </div>
                </div>
              </div>
            </div>
            
            <!-- Footer Form -->
            <div class="px-6 py-4 bg-gray-50 rounded-b-lg flex justify-end space-x-3">
              <router-link 
                to="/admin/supplier" 
                class="bg-white hover:bg-gray-100 text-gray-700 font-medium py-2 px-4 rounded-lg border border-gray-300 transition duration-150">
                Batal
              </router-link>
              <button 
                type="submit" 
                :disabled="isSubmitting"
                class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg transition duration-150 disabled:opacity-50 disabled:cursor-not-allowed">
                {{ isSubmitting ? 'Menyimpan...' : 'Simpan Supplier' }}
              </button>
            </div>
          </form>
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
import { ref, reactive, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import AdminNavigation from '@/components/AdminNavigation.vue'
import Header from '@/components/Header.vue'
import Footer from '@/components/Footer.vue'
import supplierService, { type Supplier } from '@/services/supplier.service'

const router = useRouter()
const route = useRoute()

const isEdit = ref(false)
const supplierId = ref<number | null>(null)

const user = ref({
  name: 'Admin',
  email: 'admin@example.com',
  role: 'Administrator'
})

const isSubmitting = ref(false)

const message = reactive({
  show: false,
  text: '',
  isError: false
})

const formData = reactive({
  nama: '',
  kontak_person: '',
  telepon: '',
  email: '',
  alamat: ''
})

onMounted(async () => {
  const storedUser = localStorage.getItem('user')
  if (storedUser) {
    const userData = JSON.parse(storedUser)
    user.value = userData
  }
  
  if (route.params.id) {
    isEdit.value = true
    supplierId.value = parseInt(route.params.id as string)
    await loadSupplier()
  }
})

const loadSupplier = async () => {
  if (!supplierId.value) return
  
  try {
    const response = await supplierService.getById(supplierId.value, 'admin')
    if (response.success && !Array.isArray(response.data)) {
      const supplier = response.data
      formData.nama = supplier.nama
      formData.kontak_person = supplier.kontak_person
      formData.telepon = supplier.telepon
      formData.email = supplier.email
      formData.alamat = supplier.alamat || ''
    }
  } catch (error: any) {
    console.error('Error loading supplier:', error)
    showMessage(error.response?.data?.message || 'Gagal memuat data supplier', true)
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

const handleSubmit = async () => {
  if (!formData.nama || formData.nama.trim() === '') {
    showMessage('Nama supplier harus diisi.', true)
    return
  }

  if (!formData.kontak_person || formData.kontak_person.trim() === '') {
    showMessage('Kontak person harus diisi.', true)
    return
  }

  if (!formData.telepon || formData.telepon.trim() === '') {
    showMessage('No. telepon harus diisi.', true)
    return
  }

  if (!formData.email || formData.email.trim() === '') {
    showMessage('Email harus diisi.', true)
    return
  }

  isSubmitting.value = true

  try {
    const supplierData: Supplier = {
      nama: formData.nama,
      kontak_person: formData.kontak_person,
      telepon: formData.telepon,
      email: formData.email,
      alamat: formData.alamat || undefined
    }

    if (isEdit.value && supplierId.value) {
      const response = await supplierService.update(supplierId.value, supplierData)
      if (response.success) {
        showMessage('Data supplier berhasil diperbarui.', false)
      } else {
        showMessage(response.message || 'Gagal memperbarui data supplier.', true)
      }
    } else {
      const response = await supplierService.create(supplierData)
      if (response.success) {
        showMessage('Supplier berhasil ditambahkan.', false)
      } else {
        showMessage(response.message || 'Gagal menambahkan supplier.', true)
      }
    }
    
    setTimeout(() => {
      router.push('/admin/supplier')
    }, 1500)
  } catch (error: any) {
    console.error('Error saving data:', error)
    
    if (error.response?.data?.errors) {
      const errors = error.response.data.errors
      const firstError = Object.values(errors)[0]
      showMessage(Array.isArray(firstError) ? firstError[0] : 'Gagal menyimpan data supplier.', true)
    } else {
      showMessage(error.response?.data?.message || 'Gagal menyimpan data supplier. Silakan coba lagi.', true)
    }
  } finally {
    isSubmitting.value = false
  }
}
</script>

<style scoped>
/* Additional custom styles if needed */
</style>
