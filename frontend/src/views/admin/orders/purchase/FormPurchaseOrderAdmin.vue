<template>
  <div class="flex h-screen bg-gray-100">
    <!-- Sidebar Admin -->
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
            <p class="text-sm font-medium text-white">Admin</p>
            <p class="text-xs text-gray-400">Administrator</p>
          </div>
        </div>
      </div>
    </aside>

    <div class="fixed inset-0 bg-black bg-opacity-50 z-20 hidden" id="overlay" @click="toggleSidebar"></div>
    
    <div class="flex-1 flex flex-col transition-all duration-300 ease-in-out lg:ml-64" id="main-content">
      <!-- Header -->
      <Header @toggle-sidebar="toggleSidebar" />

      <!-- Success/Error Message -->
      <div v-if="message.show" :class="message.isError ? 'bg-red-500' : 'bg-green-500'" class="text-white px-6 py-3 text-center">
        {{ message.text }}
      </div>

      <main class="flex-1 p-6 overflow-y-auto">
        <div class="flex items-center justify-between mb-6">
          <h1 class="text-3xl font-bold text-gray-900">Buat Purchase Order</h1>
          <router-link
            to="/admin/purchase-orders"
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
                  :class="{ 'border-red-500': errors.supplier_id, 'text-gray-500': !form.supplier_id, 'text-gray-900': form.supplier_id }"
                >
                  <option value="" class="text-gray-500">Pilih Supplier</option>
                  <option v-for="supplier in suppliers" :key="supplier.id" :value="supplier.id" class="text-gray-900">
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
                />
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
                />
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
                  @change="onBarangSelected"
                  id="item_select"
                  class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                  :class="{ 'text-gray-500': !newItem.barang_id, 'text-gray-900': newItem.barang_id }"
                >
                  <option value="" class="text-gray-500">Pilih barang...</option>
                  <option v-for="barang in barangList" :key="barang.id" :value="barang.id" class="text-gray-900">
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
                />
              </div>
              <div class="md:col-span-3">
                <label for="item_price" class="block text-sm font-medium text-gray-700 mb-1">Harga Beli (Satuan)</label>
                <input
                  v-model.number="newItem.harga_satuan"
                  type="number"
                  id="item_price"
                  min="0"
                  class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                />
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
                  <tr v-if="items.length === 0">
                    <td colspan="5" class="px-6 py-4 text-center text-sm text-gray-500">
                      Belum ada barang ditambahkan
                    </td>
                  </tr>
                  <tr v-for="(item, index) in items" :key="index">
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ item.nama }}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 text-center">{{ item.qty }}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 text-right">{{ formatCurrency(item.harga_satuan) }}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900 text-right">{{ formatCurrency(item.qty * item.harga_satuan) }}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-center">
                      <button
                        @click="removeItem(index)"
                        type="button"
                        class="text-red-600 hover:text-red-800"
                      >
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
              @click="submitPO"
              :disabled="loading"
              type="button"
              class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-6 rounded-lg transition duration-150 disabled:bg-gray-400"
            >
              {{ loading ? 'Menyimpan...' : 'Simpan & Kirim PO' }}
            </button>
          </div>
        </div>

        <Footer />
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import AdminNavigation from '@/components/AdminNavigation.vue'
import Header from '@/components/Header.vue'
import Footer from '@/components/Footer.vue'
import purchaseOrderService from '@/services/purchaseOrder.service'
import supplierService from '@/services/supplier.service'
import barangService from '@/services/barang.service'

const router = useRouter()

// State
const loading = ref(false)
const suppliers = ref<any[]>([])
const barangList = ref<any[]>([])
const items = ref<any[]>([])

const form = ref({
  supplier_id: '',
  tgl_pesan: new Date().toISOString().split('T')[0],
  tgl_estimasi: '',
  catatan: ''
})

const newItem = ref({
  barang_id: '',
  nama: '',
  qty: 1,
  harga_satuan: 0
})

const errors = ref<any>({})

const message = ref({
  show: false,
  text: '',
  isError: false
})

// Computed
const total = computed(() => {
  return items.value.reduce((total, item) => total + (item.qty * item.harga_satuan), 0)
})

// Methods
const toggleSidebar = () => {
  const sidebar = document.getElementById('sidebar')
  const overlay = document.getElementById('overlay')
  if (sidebar && overlay) {
    sidebar.classList.toggle('-translate-x-full')
    overlay.classList.toggle('hidden')
  }
}

const formatCurrency = (value: number) => {
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

const fetchSuppliers = async () => {
  try {
    const response = await supplierService.getAll()
    if (response.success && Array.isArray(response.data)) {
      suppliers.value = response.data
    }
  } catch (error) {
    console.error('Error fetching suppliers:', error)
  }
}

const fetchBarang = async () => {
  try {
    const response = await barangService.getAll()
    if (response.success && Array.isArray(response.data)) {
      barangList.value = response.data
    }
  } catch (error) {
    console.error('Error fetching barang:', error)
  }
}

const onBarangSelected = () => {
  const selectedBarang = barangList.value.find(b => b.id === newItem.value.barang_id)
  if (selectedBarang) {
    newItem.value.nama = selectedBarang.nama
    // Set harga default jika ada
    if (selectedBarang.harga_beli) {
      newItem.value.harga_satuan = selectedBarang.harga_beli
    }
  }
}

const addItem = () => {
  if (!newItem.value.barang_id || newItem.value.qty <= 0) {
    showMessage('Silakan pilih barang dan isi jumlah (minimal 1).', true)
    return
  }

  if (newItem.value.harga_satuan <= 0) {
    showMessage('Harga satuan harus lebih dari 0.', true)
    return
  }

  // Cek jika barang sudah ada
  const existingItem = items.value.find(item => item.barang_id === newItem.value.barang_id)
  if (existingItem) {
    existingItem.qty += newItem.value.qty
    existingItem.harga_satuan = newItem.value.harga_satuan
  } else {
    items.value.push({ ...newItem.value })
  }

  // Reset form
  newItem.value = {
    barang_id: '',
    nama: '',
    qty: 1,
    harga_satuan: 0
  }
}

const removeItem = (index: number) => {
  items.value.splice(index, 1)
}

const validateForm = () => {
  errors.value = {}

  if (!form.value.supplier_id) {
    errors.value.supplier_id = 'Supplier harus dipilih'
  }

  if (!form.value.tgl_pesan) {
    errors.value.tgl_pesan = 'Tanggal pesan harus diisi'
  }

  if (!form.value.tgl_estimasi) {
    errors.value.tgl_estimasi = 'Estimasi tanggal tiba harus diisi'
  }

  if (items.value.length === 0) {
    errors.value.items = 'Minimal harus ada 1 barang'
  }

  return Object.keys(errors.value).length === 0
}

const submitPO = async () => {
  if (!validateForm()) {
    showMessage('Mohon lengkapi semua field yang wajib diisi', true)
    return
  }

  loading.value = true
  try {
    const payload = {
      supplier_id: parseInt(form.value.supplier_id),
      tgl_pesan: form.value.tgl_pesan,
      tgl_estimasi: form.value.tgl_estimasi,
      catatan: form.value.catatan || '',
      status: 'pending' as const,
      subtotal: total.value,
      ppn: 0,
      total: total.value,
      items: items.value.map(item => ({
        barang_id: item.barang_id,
        qty: item.qty,
        harga_satuan: item.harga_satuan,
        subtotal: item.qty * item.harga_satuan
      }))
    }

    const response = await purchaseOrderService.create(payload as any)
    if (response.success) {
      showMessage('Purchase Order berhasil dibuat dan diajukan!', false)
      setTimeout(() => {
        router.push('/admin/purchase-orders')
      }, 1500)
    }
  } catch (error: any) {
    console.error('Error creating PO:', error)
    showMessage(error.response?.data?.message || 'Gagal membuat Purchase Order', true)
  } finally {
    loading.value = false
  }
}

// Lifecycle
onMounted(() => {
  fetchSuppliers()
  fetchBarang()
})
</script>
