<template>
  <div class="flex h-screen">
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
            <p class="text-sm font-medium text-white">{{ user?.name || 'Admin' }}</p>
            <p class="text-xs text-gray-400">Administrator</p>
          </div>
        </div>
      </div>
    </aside>

    <div class="fixed inset-0 bg-black bg-opacity-50 z-20 hidden" id="overlay"></div>

    <div class="flex-1 flex flex-col transition-all duration-300 ease-in-out lg:ml-64" id="main-content">
      <Header @toggle-sidebar="toggleSidebar" />

      <div v-if="message.show" :class="message.isError ? 'bg-red-500' : 'bg-green-500'" class="text-white px-6 py-3 text-center">
        {{ message.text }}
      </div>

      <main class="flex-1 p-6 md:p-8 overflow-y-auto">
        <div class="lg:grid lg:grid-cols-12 lg:gap-8">

          <!-- Left column: Items -->
          <div class="lg:col-span-8 space-y-6">
            <div class="flex items-center justify-between mb-3 lg:hidden">
              <h1 class="text-2xl font-bold text-gray-900">Buat SO Baru</h1>
              <router-link to="/admin/sales-orders" class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 font-medium py-2 px-3 rounded-lg text-sm">Kembali</router-link>
            </div>

            <div class="bg-white p-6 rounded-xl shadow-lg border border-slate-200">
              <h2 class="text-xl font-semibold text-gray-900 mb-4 flex items-center space-x-2">
                <svg class="h-6 w-6 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M20.25 7.5l-.625 10.632a2.25 2.25 0 01-2.247 2.118H6.622a2.25 2.25 0 01-2.247-2.118L3.75 7.5M10.5 11.25h3M12 15h.008" /></svg>
                <span>Detail Barang Diminta</span>
              </h2>

              <!-- Add Item (kept simple — uses existing addItem method) -->
              <form @submit.prevent="addItem" class="grid grid-cols-1 md:grid-cols-12 gap-4 mb-4 items-end">
                <div class="md:col-span-8">
                  <!-- placeholder select — user will choose per-row after adding -->
                  <label class="block text-sm font-medium text-gray-700 mb-1">Pilih Barang</label>
                  <select disabled class="w-full rounded-lg border-gray-300 shadow-sm p-3 bg-slate-100 cursor-not-allowed">
                    <option>Tambahkan item lalu pilih barang pada barisnya</option>
                  </select>
                </div>
                <div class="md:col-span-2">
                  <label class="block text-sm font-medium text-gray-700 mb-1">Jumlah</label>
                  <input type="number" min="1" class="w-full rounded-lg border-gray-300 shadow-sm p-3" disabled />
                </div>
                <div class="md:col-span-2">
                  <button type="submit" class="w-full bg-blue-600 hover:bg-blue-700 text-white font-medium py-3 px-4 rounded-lg flex items-center justify-center space-x-2 transition-all duration-300">
                    <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" /></svg>
                    <span>Tambah</span>
                  </button>
                </div>
              </form>

              <div class="overflow-x-auto border rounded-lg">
                <table class="w-full min-w-max">
                  <thead class="bg-slate-50">
                    <tr>
                      <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">Nama Barang</th>
                      <th class="px-6 py-3 text-center text-xs font-medium text-slate-500 uppercase tracking-wider">Stok</th>
                      <th class="px-6 py-3 text-center text-xs font-medium text-slate-500 uppercase tracking-wider">Jumlah</th>
                      <th class="px-6 py-3 text-right text-xs font-medium text-slate-500 uppercase tracking-wider">Harga</th>
                      <th class="px-6 py-3 text-right text-xs font-medium text-slate-500 uppercase tracking-wider">Subtotal</th>
                      <th class="px-6 py-3 text-center text-xs font-medium text-slate-500 uppercase tracking-wider">Aksi</th>
                    </tr>
                  </thead>
                  <tbody class="divide-y divide-slate-200">
                    <tr v-for="(item, index) in form.items" :key="index" class="hover:bg-slate-50 transition-colors duration-150">
                      <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                        <select v-model="item.barang_id" @change="onBarangChange(index)" class="w-full rounded-md border-gray-300 p-2">
                          <option value="">Pilih Barang</option>
                          <option v-for="barang in barangList" :key="barang.id" :value="barang.id">{{ barang.nama }}</option>
                        </select>
                      </td>
                      <td class="px-6 py-4 whitespace-nowrap text-sm text-center">{{ barangList.find(b => b.id === item.barang_id)?.stok ?? '-' }}</td>
                      <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 font-semibold text-center">
                        <input v-model.number="item.qty" @input="calculateItemSubtotal(index)" type="number" min="1" class="w-20 text-center rounded-md border-gray-300 p-2" />
                      </td>
                      <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600 text-right">
                        <input v-model.number="item.harga_satuan" @input="calculateItemSubtotal(index)" type="number" min="0" class="w-32 rounded-md border-gray-300 p-2 text-right" />
                      </td>
                      <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 font-semibold text-right">{{ formatCurrency(item.subtotal || 0) }}</td>
                      <td class="px-6 py-4 whitespace-nowrap text-center">
                        <button @click="removeItem(index)" type="button" class="text-red-500 hover:text-red-700">
                          <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19.5 12h-15" /></svg>
                        </button>
                      </td>
                    </tr>
                    <tr v-if="form.items.length === 0">
                      <td colspan="6" class="px-6 py-10 text-center text-sm text-gray-500">
                        <svg class="h-12 w-12 text-gray-300 mx-auto" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M2.25 3h1.386c.51 0 .955.343 1.087.835l.383 1.437M7.5 14.25a3 3 0 00-3 3h15.75m-12.75-3h11.218c1.121-2.3 2.1-4.684 2.924-7.138a60.114 60.114 0 00-16.536-1.84M7.5 14.25L5.106 5.272M6 20.25a.75.75 0 11-1.5 0 .75.75 0 011.5 0zm12.75 0a.75.75 0 11-1.5 0 .75.75 0 011.5 0z" /></svg>
                        <p class="mt-2 font-medium">Belum ada barang ditambahkan</p>
                        <p class="text-xs text-gray-400">Silakan tambahkan barang untuk memulai SO.</p>
                      </td>
                    </tr>
                  </tbody>
                  <tfoot class="bg-slate-50 border-t border-slate-200" v-show="form.items.length > 0">
                    <tr>
                      <td colspan="4" class="px-6 py-3 text-right text-sm font-semibold text-gray-700 uppercase">Total Estimasi</td>
                      <td class="px-6 py-3 text-right text-sm font-bold text-gray-900">{{ formatCurrency(form.total || 0) }}</td>
                      <td></td>
                    </tr>
                  </tfoot>
                </table>
              </div>
            </div>
          </div>

          <!-- Right column: Info & Actions -->
          <div class="lg:col-span-4 space-y-6">
            <div class="lg:sticky lg:top-8 space-y-6">
              <div class="bg-white p-6 rounded-xl shadow-lg border border-slate-200">
                <div class="flex items-center justify-between mb-5">
                  <h2 class="text-xl font-semibold text-gray-900 flex items-center space-x-2"><span>Informasi Dokumen</span></h2>
                  <router-link to="/admin/sales-orders" class="hidden lg:block bg-white hover:bg-slate-50 border border-slate-300 text-slate-700 font-medium py-2 px-3 rounded-lg text-sm">Kembali</router-link>
                </div>

                <div class="space-y-4">
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Pilih Customer</label>
                    <select v-model="form.customer_id" @change="onCustomerSelected" class="w-full rounded-lg border-gray-300 shadow-sm p-3">
                      <option value="">-- Pilih Customer --</option>
                      <option v-for="c in customers" :key="c.id" :value="c.id">{{ c.company_name }}</option>
                    </select>
                  </div>

                  <div v-if="selectedCustomer" class="space-y-4 p-4 bg-slate-50 rounded-lg border border-slate-100">
                    <div>
                      <label class="block text-xs font-semibold text-gray-500 uppercase mb-1">No. Telepon</label>
                      <input type="text" :value="selectedCustomer?.phone" readonly class="w-full bg-transparent border-0 p-0 text-sm text-gray-900 font-medium focus:ring-0 cursor-default">
                    </div>
                    <div>
                      <label class="block text-xs font-semibold text-gray-500 uppercase mb-1">Alamat</label>
                      <textarea readonly class="w-full bg-transparent border-0 p-0 text-sm text-gray-900 font-medium focus:ring-0 cursor-default resize-none" rows="2" :value="selectedCustomer?.address"></textarea>
                    </div>
                  </div>

                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Tanggal Order</label>
                    <input v-model="form.tgl_order" type="date" class="w-full rounded-lg border-gray-300 shadow-sm p-3" />
                  </div>

                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Tanggal Kirim Estimasi</label>
                    <input v-model="form.tgl_kirim" type="date" class="w-full rounded-lg border-gray-300 shadow-sm p-3" />
                  </div>

                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Catatan (Opsional)</label>
                    <textarea v-model="form.catatan" rows="2" class="w-full rounded-lg border-gray-300 shadow-sm p-3" placeholder="Instruksi khusus pengiriman..."></textarea>
                  </div>
                </div>
              </div>

              <div class="bg-white p-6 rounded-xl shadow-lg border border-slate-200">
                <h2 class="text-xl font-semibold text-gray-900 mb-4">Aksi</h2>
                <div class="flex flex-col gap-3">
                  <button type="button" @click="handleSubmit" class="w-full text-center bg-white hover:bg-slate-100 border border-slate-300 text-slate-700 font-medium py-3 px-4 rounded-lg">Simpan sebagai Draft</button>
                  <button type="button" @click="handleSubmit" class="w-full text-center bg-blue-600 hover:bg-blue-700 text-white font-medium py-3 px-4 rounded-lg shadow-lg">Simpan dan Ajukan</button>
                </div>
              </div>
            </div>
          </div>

        </div>
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
  
  fetchCustomers()
  fetchBarang()
})
</script>
