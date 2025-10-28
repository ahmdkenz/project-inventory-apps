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
      
      <StaffNavigation :current-path="$route.path" />
      
      <div class="absolute bottom-0 left-0 w-full p-4 border-t border-gray-700">
        <div class="flex items-center space-x-3">
          <img class="h-10 w-10 rounded-full" src="https://placehold.co/100x100/FEF2F2/DC2626?text=S" alt="Avatar Pengguna">
          <div>
            <p class="text-sm font-medium text-white">{{ user.name }}</p>
            <p class="text-xs text-gray-400">Staff Gudang</p>
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
        <div class="relative hidden sm:block"></div>
        <div class="flex items-center space-x-4">
          <button class="text-gray-500 hover:text-gray-700 relative">
            <span class="absolute top-0 right-0 h-2 w-2 bg-red-500 rounded-full"></span>
            <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M14.857 17.082a23.848 23.848 0 005.454-1.31A8.967 8.967 0 0118 9.75v-.7V9A6 6 0 006 9v.75a8.967 8.967 0 01-2.312 6.022c1.733.64 3.56 1.085 5.455 1.31m5.714 0a24.255 24.255 0 01-5.714 0m5.714 0a3 3 0 11-5.714 0" />
            </svg>
          </button>
          <div class="flex items-center space-x-2 cursor-pointer">
            <img class="h-9 w-9 rounded-full" src="https://placehold.co/100x100/EBF8FF/3182CE?text=S" alt="Avatar Pengguna">
            <span class="hidden md:block text-sm font-medium text-gray-700">{{ user.name }}</span>
          </div>
        </div>
      </header>

      <!-- Success/Error Message -->
      <div v-if="message.show" :class="message.isError ? 'bg-red-500' : 'bg-green-500'" class="text-white px-6 py-3 text-center">
        {{ message.text }}
      </div>

      <main class="flex-1 p-6 overflow-y-auto">
        <div class="flex items-center justify-between mb-6">
          <h1 class="text-3xl font-bold text-gray-900">{{ isEditMode ? 'Edit' : 'Buat' }} Purchase Order</h1>
          <router-link 
            to="/staff/purchase-order" 
            class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150"
          >
            <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5L8.25 12l7.5-7.5" />
            </svg>
            <span>Kembali</span>
          </router-link>
        </div>
        
        <div class="max-w-6xl mx-auto">
          <!-- Informasi Transaksi -->
          <div class="bg-white p-6 rounded-lg shadow-sm mb-6">
            <h2 class="text-xl font-semibold text-gray-900 mb-4">Informasi Transaksi</h2>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
              <div>
                <label for="supplier" class="block text-sm font-medium text-gray-700 mb-1">Supplier <span class="text-red-500">*</span></label>
                <select 
                  v-model="form.supplier_id" 
                  id="supplier" 
                  class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                  :class="{ 'border-red-500': errors.supplier_id }"
                >
                  <option value="">Pilih Supplier</option>
                  <option v-for="supplier in supplierList" :key="supplier.id" :value="supplier.id">
                    {{ supplier.nama }}
                  </option>
                </select>
                <span v-if="errors.supplier_id" class="text-red-500 text-xs">{{ errors.supplier_id }}</span>
              </div>
              <div>
                <label for="tgl_pesan" class="block text-sm font-medium text-gray-700 mb-1">Tanggal Pesan <span class="text-red-500">*</span></label>
                <input 
                  v-model="form.tgl_pesan" 
                  type="date" 
                  id="tgl_pesan" 
                  class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                  :class="{ 'border-red-500': errors.tgl_pesan }"
                >
                <span v-if="errors.tgl_pesan" class="text-red-500 text-xs">{{ errors.tgl_pesan }}</span>
              </div>
              <div>
                <label for="tgl_estimasi" class="block text-sm font-medium text-gray-700 mb-1">Estimasi Tgl. Tiba <span class="text-red-500">*</span></label>
                <input 
                  v-model="form.tgl_estimasi" 
                  type="date" 
                  id="tgl_estimasi" 
                  class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                  :class="{ 'border-red-500': errors.tgl_estimasi }"
                >
                <span v-if="errors.tgl_estimasi" class="text-red-500 text-xs">{{ errors.tgl_estimasi }}</span>
              </div>
              <div class="md:col-span-3">
                <label for="catatan_po" class="block text-sm font-medium text-gray-700 mb-1">Catatan (Opsional)</label>
                <textarea 
                  v-model="form.catatan" 
                  id="catatan_po" 
                  rows="2" 
                  class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500" 
                  placeholder="Catatan untuk supplier..."
                ></textarea>
              </div>
            </div>
          </div>

          <!-- Detail Barang -->
          <div class="bg-white p-6 rounded-lg shadow-sm mb-6">
            <h2 class="text-xl font-semibold text-gray-900 mb-4">Detail Barang</h2>
            <!-- Form Tambah Item -->
            <div class="grid grid-cols-1 md:grid-cols-12 gap-4 mb-4 items-end">
              <div class="md:col-span-5">
                <label for="item_select" class="block text-sm font-medium text-gray-700 mb-1">Pilih Barang</label>
                <select 
                  v-model="newItem.barang_id" 
                  @change="onBarangSelect"
                  id="item_select" 
                  class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                >
                  <option value="">Pilih barang...</option>
                  <option v-for="barang in barangList" :key="barang.id" :value="barang.id">
                    {{ barang.kode }} - {{ barang.nama }}
                  </option>
                </select>
              </div>
              <div class="md:col-span-2">
                <label for="item_qty" class="block text-sm font-medium text-gray-700 mb-1">Jumlah</label>
                <input 
                  v-model.number="newItem.qty" 
                  type="number" 
                  id="item_qty" 
                  min="1" 
                  class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                >
              </div>
              <div class="md:col-span-3">
                <label for="item_price" class="block text-sm font-medium text-gray-700 mb-1">Harga Beli (Satuan)</label>
                <input 
                  v-model.number="newItem.harga_satuan" 
                  type="number" 
                  id="item_price" 
                  min="0" 
                  class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                >
              </div>
              <div class="md:col-span-2">
                <button 
                  @click="addItem" 
                  type="button"
                  class="w-full bg-blue-500 hover:bg-blue-600 text-white font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150"
                >
                  <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
                  </svg>
                  <span>Tambah</span>
                </button>
              </div>
            </div>
            
            <!-- Tabel Item Ditambahkan -->
            <div class="overflow-x-auto border rounded-lg">
              <table class="w-full min-w-max">
                <thead class="bg-gray-50">
                  <tr>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nama Barang</th>
                    <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">Jumlah</th>
                    <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Harga Satuan</th>
                    <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Subtotal</th>
                    <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">Aksi</th>
                  </tr>
                </thead>
                <tbody class="divide-y divide-gray-200">
                  <tr v-if="form.items.length === 0">
                    <td colspan="5" class="px-6 py-4 text-center text-sm text-gray-500">
                      Belum ada barang ditambahkan
                    </td>
                  </tr>
                  <tr v-for="(item, index) in form.items" :key="index">
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ item.barang?.nama }}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 text-center">{{ item.qty }}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 text-right">{{ formatCurrency(item.harga_satuan) }}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900 text-right">{{ formatCurrency(item.qty * item.harga_satuan) }}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-center">
                      <button @click="removeItem(index)" type="button" class="text-red-600 hover:text-red-800">
                        <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                          <path stroke-linecap="round" stroke-linejoin="round" d="M14.74 9l-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 01-2.244 2.077H8.084a2.25 2.25 0 01-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 00-3.478-.397m-12 0c-.275.046-.55.097-.824.15" />
                        </svg>
                      </button>
                    </td>
                  </tr>
                </tbody>
                <!-- Footer Kalkulasi -->
                <tfoot class="bg-gray-50 border-t-2 border-gray-300">
                  <tr>
                    <td colspan="3" class="px-6 py-3 text-right text-base font-bold text-gray-900">Total</td>
                    <td class="px-6 py-3 text-right text-base font-bold text-gray-900">{{ formatCurrency(total) }}</td>
                    <td></td>
                  </tr>
                </tfoot>
              </table>
            </div>
            <span v-if="errors.items" class="text-red-500 text-xs mt-2 block">{{ errors.items }}</span>
          </div>

          <!-- Tombol Aksi Bawah -->
          <div class="flex justify-end space-x-4">
            <button 
              @click="submitForm" 
              :disabled="loading"
              type="button" 
              class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-6 rounded-lg transition duration-150 disabled:bg-gray-400"
            >
              {{ loading ? 'Menyimpan...' : (isEditMode ? 'Update PO' : 'Simpan & Kirim PO') }}
            </button>
          </div>
        </div>
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import StaffNavigation from '@/components/StaffNavigation.vue'
import purchaseOrderService from '@/services/purchaseOrder.service'
import staffBarangService from '@/services/staff/barang.service'
import supplierService from '@/services/supplier.service'
import type { PurchaseOrder, PurchaseOrderItem } from '@/services/purchaseOrder.service'
import type { Barang } from '@/services/barang.service'
import type { Supplier } from '@/services/supplier.service'

const router = useRouter()
const route = useRoute()

const isEditMode = computed(() => route.params.id !== undefined)

const user = ref({
  name: 'Staff',
  role: 'staff'
})

const loading = ref(false)
const barangList = ref<Barang[]>([])
const supplierList = ref<Supplier[]>([])

const form = reactive<PurchaseOrder>({
  supplier_id: 0,
  tgl_pesan: '',
  tgl_estimasi: '',
  catatan: '',
  status: 'pending',
  items: []
})

const newItem = reactive<PurchaseOrderItem>({
  barang_id: 0,
  qty: 1,
  harga_satuan: 0
})

const errors = reactive<any>({})

const message = reactive({
  show: false,
  text: '',
  isError: false
})

const subtotal = computed(() => {
  return form.items.reduce((acc, item) => acc + (item.qty * item.harga_satuan), 0)
})

const total = computed(() => {
  return subtotal.value
})

onMounted(async () => {
  const storedUser = localStorage.getItem('user')
  if (storedUser) {
    const userData = JSON.parse(storedUser)
    user.value = userData
  }
  
  // Set default date to today
  const today = new Date().toISOString().split('T')[0]
  if (today) {
    form.tgl_pesan = today
  }
  
  await fetchBarang()
  await fetchSupplier()
  
  if (isEditMode.value) {
    await loadPurchaseOrder()
  }
})

const fetchBarang = async () => {
  try {
    const response = await staffBarangService.getAll()
    if (response.success && Array.isArray(response.data)) {
      barangList.value = response.data
    }
  } catch (error: any) {
    console.error('Error loading barang:', error)
  }
}

const fetchSupplier = async () => {
  try {
    const response = await supplierService.getAll()
    if (response.success && Array.isArray(response.data)) {
      supplierList.value = response.data
    }
  } catch (error: any) {
    console.error('Error loading supplier:', error)
  }
}

const loadPurchaseOrder = async () => {
  const id = parseInt(route.params.id as string)
  loading.value = true
  try {
    const response = await purchaseOrderService.getById(id)
    if (response.success && !Array.isArray(response.data)) {
      const po = response.data
      form.supplier_id = po.supplier_id
      form.tgl_pesan = po.tgl_pesan
      form.tgl_estimasi = po.tgl_estimasi
      form.catatan = po.catatan || ''
      form.items = po.items
    }
  } catch (error: any) {
    console.error('Error loading purchase order:', error)
    showMessage(error.response?.data?.message || 'Gagal memuat data purchase order', true)
    router.push('/staff/purchase-order')
  } finally {
    loading.value = false
  }
}

const onBarangSelect = () => {
  const selectedBarang = barangList.value.find(b => b.id === newItem.barang_id)
  if (selectedBarang) {
    newItem.harga_satuan = selectedBarang.harga_beli || 0
  }
}

const addItem = () => {
  // Validate
  if (!newItem.barang_id || newItem.qty <= 0 || newItem.harga_satuan < 0) {
    showMessage('Pilih barang, jumlah, dan harga dengan benar', true)
    return
  }

  const selectedBarang = barangList.value.find(b => b.id === newItem.barang_id)
  if (!selectedBarang) {
    showMessage('Barang tidak valid', true)
    return
  }

  // Check if item already exists
  const existingItem = form.items.find(item => item.barang_id === newItem.barang_id)
  if (existingItem) {
    existingItem.qty += newItem.qty
    existingItem.harga_satuan = newItem.harga_satuan
  } else {
    form.items.push({
      barang_id: newItem.barang_id,
      qty: newItem.qty,
      harga_satuan: newItem.harga_satuan,
      barang: {
        id: selectedBarang.id!,
        nama: selectedBarang.nama,
        kode: selectedBarang.kode
      }
    })
  }

  // Reset form
  newItem.barang_id = 0
  newItem.qty = 1
  newItem.harga_satuan = 0
}

const removeItem = (index: number) => {
  form.items.splice(index, 1)
}

const validateForm = () => {
  const newErrors: any = {}
  
  if (!form.supplier_id) {
    newErrors.supplier_id = 'Supplier harus dipilih'
  }
  
  if (!form.tgl_pesan) {
    newErrors.tgl_pesan = 'Tanggal pesan harus diisi'
  }
  
  if (!form.tgl_estimasi) {
    newErrors.tgl_estimasi = 'Estimasi tanggal tiba harus diisi'
  }
  
  if (form.items.length === 0) {
    newErrors.items = 'Minimal harus ada 1 barang'
  }
  
  Object.keys(errors).forEach(key => delete errors[key])
  Object.assign(errors, newErrors)
  
  return Object.keys(newErrors).length === 0
}

const submitForm = async () => {
  if (!validateForm()) {
    showMessage('Mohon lengkapi semua field yang wajib diisi', true)
    return
  }

  loading.value = true
  try {
    // Prepare data
    const data: PurchaseOrder = {
      ...form,
      subtotal: subtotal.value,
      ppn: 0,
      total: total.value
    }

    let response
    if (isEditMode.value) {
      const id = parseInt(route.params.id as string)
      response = await purchaseOrderService.update(id, data)
    } else {
      response = await purchaseOrderService.create(data)
    }

    if (response.success) {
      showMessage(response.message, false)
      setTimeout(() => {
        router.push('/staff/purchase-order')
      }, 1500)
    }
  } catch (error: any) {
    console.error('Error saving purchase order:', error)
    showMessage(error.response?.data?.message || 'Gagal menyimpan purchase order', true)
  } finally {
    loading.value = false
  }
}

const formatCurrency = (value: number) => {
  return new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    minimumFractionDigits: 0
  }).format(value)
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
/* Additional custom styles if needed */
</style>
