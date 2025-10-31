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
      <header class="bg-white shadow-sm p-4 flex items-center justify-between">
        <!-- Tombol Hamburger (Mobile) -->
        <button class="text-gray-600 lg:hidden" @click="toggleSidebar">
          <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5" />
          </svg>
        </button>
        <h2 class="text-xl font-semibold text-gray-800">{{ isEditMode ? 'Edit' : 'Tambah' }} Customer</h2>
        <div class="flex items-center space-x-4">
          <div class="flex items-center space-x-3">
            <span class="text-sm text-gray-600">Admin</span>
            <div class="h-10 w-10 rounded-full bg-blue-600 flex items-center justify-center text-white font-semibold">
              A
            </div>
          </div>
        </div>
      </header>

      <!-- Success Message -->
      <div 
        v-if="showSuccess"
        class="bg-green-600 text-white py-3 px-6 text-center"
      >
        <span>Data customer berhasil disimpan!</span>
      </div>

      <!-- Main Content -->
      <main class="flex-1 p-6 overflow-y-auto">
        <div class="flex items-center justify-between mb-6">
          <h1 class="text-3xl font-bold text-gray-900">{{ isEditMode ? 'Edit' : 'Formulir' }} Customer</h1>
          <router-link 
            to="/admin/customers" 
            class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150"
          >
            <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5L8.25 12l7.5-7.5" />
            </svg>
            <span>Kembali</span>
          </router-link>
        </div>
        
        <form @submit.prevent="submitForm" class="max-w-4xl mx-auto bg-white p-8 rounded-lg shadow-sm">
          <h2 class="text-xl font-semibold text-gray-900 mb-6">Informasi Customer</h2>
          
          <!-- Error Messages -->
          <div v-if="errors.general" class="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg">
            <p class="text-sm text-red-600">{{ errors.general }}</p>
          </div>

          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label for="company_name" class="block text-sm font-medium text-gray-700 mb-1">
                Nama Perusahaan / Customer <span class="text-red-500">*</span>
              </label>
              <input 
                type="text" 
                id="company_name" 
                v-model="formData.company_name"
                placeholder="Cth: PT. Jaya Abadi" 
                required 
                class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                :class="{ 'border-red-500': errors.company_name }"
              >
              <p v-if="errors.company_name" class="mt-1 text-sm text-red-600">{{ errors.company_name }}</p>
            </div>
            
            <div>
              <label for="contact_name" class="block text-sm font-medium text-gray-700 mb-1">Nama Kontak (PIC)</label>
              <input 
                type="text" 
                id="contact_name" 
                v-model="formData.contact_name"
                placeholder="Cth: Budi Santoso" 
                class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
              >
            </div>
            
            <div>
              <label for="email" class="block text-sm font-medium text-gray-700 mb-1">
                Email <span class="text-red-500">*</span>
              </label>
              <input 
                type="email" 
                id="email" 
                v-model="formData.email"
                placeholder="Cth: budi@jayaabadi.com" 
                required 
                class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                :class="{ 'border-red-500': errors.email }"
              >
              <p v-if="errors.email" class="mt-1 text-sm text-red-600">{{ errors.email }}</p>
            </div>
            
            <div>
              <label for="phone" class="block text-sm font-medium text-gray-700 mb-1">
                Nomor Telepon <span class="text-red-500">*</span>
              </label>
              <input 
                type="tel" 
                id="phone" 
                v-model="formData.phone"
                placeholder="Cth: 081234567890" 
                required 
                class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                :class="{ 'border-red-500': errors.phone }"
              >
              <p v-if="errors.phone" class="mt-1 text-sm text-red-600">{{ errors.phone }}</p>
            </div>
            
            <div class="md:col-span-2">
              <label for="address" class="block text-sm font-medium text-gray-700 mb-1">Alamat Lengkap</label>
              <textarea 
                id="address" 
                v-model="formData.address"
                rows="3" 
                class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500" 
                placeholder="Jl. Mangga Dua Raya No. 12..."
              ></textarea>
            </div>
            
            <div>
              <label for="city" class="block text-sm font-medium text-gray-700 mb-1">Kota</label>
              <input 
                type="text" 
                id="city" 
                v-model="formData.city"
                placeholder="Cth: Jakarta Utara" 
                class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
              >
            </div>
            
            <div>
              <label for="zipcode" class="block text-sm font-medium text-gray-700 mb-1">Kode Pos</label>
              <input 
                type="text" 
                id="zipcode" 
                v-model="formData.zipcode"
                placeholder="Cth: 14430" 
                class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
              >
            </div>
          </div>

          <!-- Tombol Aksi Bawah -->
          <div class="mt-8 pt-6 border-t border-gray-200 flex justify-end space-x-3">
            <router-link 
              to="/admin/customers" 
              class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 font-medium py-2 px-4 rounded-lg transition duration-150"
            >
              Batal
            </router-link>
            <button 
              type="submit" 
              :disabled="isSubmitting"
              class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg transition duration-150 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {{ isSubmitting ? 'Menyimpan...' : 'Simpan Customer' }}
            </button>
          </div>
        </form>
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import AdminNavigation from '@/components/AdminNavigation.vue'
import customerService, { type CustomerFormData } from '@/services/customer.service'

const router = useRouter()
const route = useRoute()

const isEditMode = computed(() => !!route.params.id)
const customerId = computed(() => route.params.id ? Number(route.params.id) : null)

const formData = ref<CustomerFormData>({
  company_name: '',
  contact_name: '',
  email: '',
  phone: '',
  address: '',
  city: '',
  zipcode: ''
})

const errors = ref<Record<string, string>>({})
const isSubmitting = ref(false)
const showSuccess = ref(false)

const toggleSidebar = () => {
  const sidebar = document.getElementById('sidebar')
  const overlay = document.getElementById('overlay')
  if (sidebar && overlay) {
    sidebar.classList.toggle('-translate-x-full')
    overlay.classList.toggle('hidden')
  }
}

const loadCustomer = async () => {
  if (!customerId.value) return
  
  try {
    const customer = await customerService.getById(customerId.value)
    formData.value = {
      company_name: customer.company_name,
      contact_name: customer.contact_name || '',
      email: customer.email,
      phone: customer.phone,
      address: customer.address || '',
      city: customer.city || '',
      zipcode: customer.zipcode || ''
    }
  } catch (error) {
    console.error('Error loading customer:', error)
    alert('Gagal memuat data customer')
    router.push('/admin/customers')
  }
}

const submitForm = async () => {
  errors.value = {}
  isSubmitting.value = true
  
  try {
    if (isEditMode.value && customerId.value) {
      await customerService.update(customerId.value, formData.value)
    } else {
      await customerService.create(formData.value)
    }
    
    showSuccess.value = true
    
    setTimeout(() => {
      router.push('/admin/customers')
    }, 1500)
  } catch (error: any) {
    console.error('Error submitting form:', error)
    
    if (error.response?.data?.errors) {
      // Validation errors from backend
      const backendErrors = error.response.data.errors
      Object.keys(backendErrors).forEach(key => {
        errors.value[key] = Array.isArray(backendErrors[key]) 
          ? backendErrors[key][0] 
          : backendErrors[key]
      })
    } else {
      errors.value.general = error.response?.data?.message || 'Terjadi kesalahan saat menyimpan data'
    }
  } finally {
    isSubmitting.value = false
  }
}

onMounted(() => {
  if (isEditMode.value) {
    loadCustomer()
  }
})
</script>
