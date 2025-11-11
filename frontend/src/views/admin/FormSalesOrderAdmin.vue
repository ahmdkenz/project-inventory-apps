<template>
  <div class="flex h-screen">
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
            <p class="text-sm font-medium text-white">{{ user?.name || 'Admin' }}</p>
            <p class="text-xs text-gray-400">Administrator</p>
          </div>
        </div>
      </div>
    </aside>

    <!-- Latar belakang overlay untuk mobile -->
    <div class="fixed inset-0 bg-black bg-opacity-50 z-20 hidden" id="overlay"></div>
    
    <!-- Konten Utama -->
    <div class="flex-1 flex flex-col transition-all duration-300 ease-in-out lg:ml-64" id="main-content">
      <!-- Header -->
      <Header @toggle-sidebar="toggleSidebar" />

      <div v-if="message.show" :class="message.isError ? 'bg-red-500' : 'bg-green-500'" class="text-white px-6 py-3 text-center">
        {{ message.text }}
      </div>

      <!-- Konten Halaman -->
      <main class="flex-1 p-6 overflow-y-auto">
        <div class="mb-6">
          <div class="flex items-center space-x-2 mb-2">
            <router-link to="/admin/sales-orders" class="text-blue-600 hover:text-blue-800">
              <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
              </svg>
            </router-link>
            <h1 class="text-3xl font-bold text-gray-900">Buat Sales Order</h1>
          </div>
        </div>
        
        <form @submit.prevent="handleSubmit" class="space-y-6">
          <!-- Informasi Customer -->
          <div class="bg-white rounded-lg shadow-md p-6">
            <h2 class="text-xl font-semibold mb-4 text-gray-800">Informasi Customer</h2>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">
                  Customer <span class="text-red-500">*</span>
                </label>
                <select
                  v-model="form.customer_id"
                  @change="onCustomerSelected"
                  required
                  class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                  :class="{ 'border-red-500': errors.customer_id }"
                >
                  <option value="">Pilih Customer</option>
                  <option v-for="customer in customers" :key="customer.id" :value="customer.id">
                    {{ customer.company_name }}
                  </option>
                </select>
                <p v-if="errors.customer_id" class="text-red-500 text-xs mt-1">{{ errors.customer_id }}</p>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">No. Telepon <span class="text-red-500">*</span></label>
                <input 
                  v-model="form.customer_phone" 
                  type="text" 
                  required
                  class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                  placeholder="Masukkan nomor telepon"
                >
              </div>
              <div class="md:col-span-2">
                <label class="block text-sm font-medium text-gray-700 mb-1">Alamat <span class="text-red-500">*</span></label>
                <textarea 
                  v-model="form.customer_address" 
                  required
                  rows="3"
                  class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                  placeholder="Masukkan alamat lengkap customer"
                ></textarea>
              </div>
            </div>
          </div>

          <!-- Informasi Order -->
          <div class="bg-white rounded-lg shadow-md p-6">
            <h2 class="text-xl font-semibold mb-4 text-gray-800">Informasi Order</h2>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Tanggal Order <span class="text-red-500">*</span></label>
                <input
                  v-model="form.tgl_order"
                  type="date"
                  required
                  class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Tanggal Kirim Estimasi <span class="text-red-500">*</span></label>
                <input
                  v-model="form.tgl_kirim"
                  type="date"
                  required
                  class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                />
              </div>
              <div class="md:col-span-2">
                <label class="block text-sm font-medium text-gray-700 mb-1">Catatan</label>
                <textarea
                  v-model="form.catatan"
                  rows="2"
                  class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                  placeholder="Catatan tambahan (opsional)"
                ></textarea>
              </div>
            </div>
          </div>

          <!-- Detail Barang -->
          <div class="bg-white rounded-lg shadow-md p-6">
            <div class="flex justify-between items-center mb-4">
              <h2 class="text-xl font-semibold text-gray-800">Detail Barang</h2>
              <button 
                type="button" 
                @click="addItem" 
                class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg flex items-center space-x-2"
              >
                <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.5v15m7.5-7.5h-15" />
                </svg>
                <span>Tambah Barang</span>
              </button>
            </div>

            <div v-if="form.items.length === 0" class="text-center py-8 text-gray-500">
              Belum ada barang ditambahkan
            </div>

            <div v-else class="overflow-x-auto">
              <table class="w-full text-sm">
                <thead class="bg-gray-50 border-b">
                  <tr>
                    <th class="px-4 py-3 text-left font-medium text-gray-700">Barang</th>
                    <th class="px-4 py-3 text-center font-medium text-gray-700">Qty</th>
                    <th class="px-4 py-3 text-right font-medium text-gray-700">Harga Satuan</th>
                    <th class="px-4 py-3 text-right font-medium text-gray-700">Subtotal</th>
                    <th class="px-4 py-3 text-center font-medium text-gray-700">Aksi</th>
                  </tr>
                </thead>
                <tbody class="divide-y">
                  <tr v-for="(item, index) in form.items" :key="index">
                    <td class="px-4 py-3">
                      <select 
                        v-model="item.barang_id" 
                        @change="onBarangChange(index)"
                        required
                        class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                      >
                        <option value="">Pilih Barang</option>
                        <option v-for="barang in barangList" :key="barang.id" :value="barang.id">
                          {{ barang.nama }} - Stok: {{ barang.stok }}
                        </option>
                      </select>
                    </td>
                    <td class="px-4 py-3">
                      <input 
                        v-model.number="item.qty" 
                        @input="calculateItemSubtotal(index)"
                        type="number" 
                        min="1"
                        required
                        class="w-24 rounded-md border-gray-300 shadow-sm p-2 text-center focus:border-blue-500 focus:ring-blue-500"
                      >
                    </td>
                    <td class="px-4 py-3 text-right">
                      <input 
                        v-model.number="item.harga_satuan" 
                        @input="calculateItemSubtotal(index)"
                        type="number" 
                        min="0"
                        required
                        class="w-32 rounded-md border-gray-300 shadow-sm p-2 text-right focus:border-blue-500 focus:ring-blue-500"
                      >
                    </td>
                    <td class="px-4 py-3 text-right font-medium">
                      {{ formatCurrency(item.subtotal || 0) }}
                    </td>
                    <td class="px-4 py-3 text-center">
                      <button 
                        type="button" 
                        @click="removeItem(index)"
                        class="text-red-600 hover:text-red-800"
                      >
                        <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                        </svg>
                      </button>
                    </td>
                  </tr>
                </tbody>
                <tfoot class="bg-gray-50 font-semibold">
                  <tr>
                    <td colspan="3" class="px-4 py-3 text-right">Subtotal</td>
                    <td class="px-4 py-3 text-right">{{ formatCurrency(form.subtotal || 0) }}</td>
                    <td></td>
                  </tr>
                  <tr>
                    <td colspan="3" class="px-4 py-3 text-right">PPN (0%)</td>
                    <td class="px-4 py-3 text-right">{{ formatCurrency(form.ppn || 0) }}</td>
                    <td></td>
                  </tr>
                  <tr class="text-lg">
                    <td colspan="3" class="px-4 py-3 text-right">Total</td>
                    <td class="px-4 py-3 text-right text-blue-600">{{ formatCurrency(form.total || 0) }}</td>
                    <td></td>
                  </tr>
                </tfoot>
              </table>
            </div>
          </div>

          <!-- Action Buttons -->
          <div class="flex justify-end space-x-4">
            <router-link 
              to="/admin/sales-orders" 
              class="bg-white hover:bg-gray-100 text-gray-700 font-medium py-2 px-6 rounded-lg border border-gray-300"
            >
              Batal
            </router-link>
            <button 
              type="submit" 
              :disabled="loading || form.items.length === 0"
              class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-6 rounded-lg disabled:bg-gray-400 disabled:cursor-not-allowed"
            >
              {{ loading ? 'Menyimpan...' : 'Simpan' }}
            </button>
          </div>
        </form>

        <Footer />
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onBeforeUnmount, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import AdminNavigation from '@/components/AdminNavigation.vue'
import Header from '@/components/Header.vue'
import Footer from '@/components/Footer.vue'
import salesOrderService from '@/services/salesOrder.service'
import barangService from '@/services/barang.service'
import customerService, { type Customer } from '@/services/customer.service'

// Router & auth
const router = useRouter()
const authStore = useAuthStore()

// Header/Profile state
const user = ref<any>(null)

const toggleSidebar = () => {
  const sidebar = document.getElementById('sidebar')
  const overlay = document.getElementById('overlay')
  if (sidebar && overlay) {
    sidebar.classList.toggle('-translate-x-full')
    overlay.classList.toggle('hidden')
  }
}

// State
const loading = ref(false)
const barangList = ref<any[]>([])
const customers = ref<Customer[]>([])
const selectedCustomer = ref<Customer | null>(null)

const form = ref({
  customer_id: '',
  customer_name: '',
  customer_phone: '',
  customer_address: '',
  tgl_order: new Date().toISOString().split('T')[0],
  tgl_kirim: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString().split('T')[0],
  catatan: '',
  items: [] as Array<{
    barang_id: number
    qty: number
    harga_satuan: number
    subtotal: number
  }>,
  subtotal: 0,
  ppn: 0,
  total: 0
})

const errors = ref<Record<string, string>>({})

const message = ref({
  show: false,
  text: '',
  isError: false
})

// Methods
const fetchCustomers = async () => {
  try {
    const response = await customerService.getAll('', 1, 1000)
    customers.value = response.data
  } catch (error: any) {
    console.error('Error fetching customers:', error)
    showMessage('Gagal memuat data customer', true)
  }
}

const onCustomerSelected = () => {
  const customer = customers.value.find(c => c.id === parseInt(form.value.customer_id as any))
  if (customer) {
    selectedCustomer.value = customer
    form.value.customer_name = customer.company_name
    form.value.customer_phone = customer.phone || ''
    form.value.customer_address = customer.address || ''
  }
}

const onBarangChange = (index: number) => {
  const item = form.value.items[index]
  if (!item) return
  
  const barang = barangList.value.find(b => b.id === item.barang_id)
  
  if (barang) {
    // Set harga_satuan to harga_jual (selling price)
    item.harga_satuan = barang.harga_jual || 0
    calculateItemSubtotal(index)
  }
}

const calculateItemSubtotal = (index: number) => {
  const item = form.value.items[index]
  if (!item) return
  item.subtotal = item.qty * item.harga_satuan
  calculateTotal()
}

const calculateTotal = () => {
  form.value.subtotal = form.value.items.reduce((sum, item) => sum + (item.subtotal || 0), 0)
  form.value.ppn = 0 // No PPN
  form.value.total = form.value.subtotal + form.value.ppn
}

const fetchBarang = async () => {
  try {
    const response = await barangService.getAll()
    if (response.success && Array.isArray(response.data)) {
      barangList.value = response.data
    }
  } catch (error: any) {
    console.error('Error fetching barang:', error)
    showMessage('Gagal memuat data barang', true)
  }
}

const addItem = () => {
  form.value.items.push({
    barang_id: 0,
    qty: 1,
    harga_satuan: 0,
    subtotal: 0
  })
}

const removeItem = (index: number) => {
  form.value.items.splice(index, 1)
  calculateTotal()
}

const handleSubmit = async () => {
  errors.value = {}
  
  if (!form.value.customer_id) {
    errors.value.customer_id = 'Customer harus dipilih'
    showMessage('Customer harus dipilih', true)
    return
  }
  
  if (form.value.items.length === 0) {
    showMessage('Minimal harus ada 1 barang', true)
    return
  }

  // Validate stock for each item
  for (const item of form.value.items) {
    const barang = barangList.value.find(b => b.id === item.barang_id)
    if (barang && item.qty > barang.stok) {
      showMessage(`Stok ${barang.nama} tidak mencukupi. Stok tersedia: ${barang.stok}`, true)
      return
    }
  }
  
  loading.value = true
  try {
    const payload = {
      customer_name: form.value.customer_name,
      customer_phone: form.value.customer_phone,
      customer_address: form.value.customer_address,
      tgl_order: form.value.tgl_order,
      tgl_kirim: form.value.tgl_kirim,
      catatan: form.value.catatan,
      items: form.value.items,
      subtotal: form.value.subtotal,
      ppn: form.value.ppn,
      total: form.value.total,
      status: 'pending' as 'pending' | 'approved' | 'rejected' | 'completed'
    }
    
    const response = await (salesOrderService.create as any)(payload)
    if (response.success) {
      showMessage('Sales Order berhasil dibuat', false)
      setTimeout(() => {
        router.push('/admin/sales-orders')
      }, 1500)
    }
  } catch (error: any) {
    console.error('Error creating sales order:', error)
    const errorMsg = error.response?.data?.message || 'Gagal menyimpan sales order'
    showMessage(errorMsg, true)
  } finally {
    loading.value = false
  }
}

const formatCurrency = (value: number) => {
  if (!value) return 'Rp 0'
  return new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    minimumFractionDigits: 0
  }).format(value)
}

const showMessage = (text: string, isError: boolean = false) => {
  message.value = { show: true, text, isError }
  setTimeout(() => {
    message.value.show = false
  }, 3000)
}

// Lifecycle
onMounted(() => {
  const userData = localStorage.getItem('user')
  if (userData) {
    user.value = JSON.parse(userData)
  }
  
  // Add click outside listener
  document.addEventListener('click', handleClickOutside)
  
  fetchCustomers()
  fetchBarang()
})

onBeforeUnmount(() => {
  // Remove click outside listener
  document.removeEventListener('click', handleClickOutside)
})
</script>
