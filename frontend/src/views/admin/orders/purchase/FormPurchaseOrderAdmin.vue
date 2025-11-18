<template>
  <div class="flex h-screen bg-slate-100">
    <!-- Sidebar Admin -->
    <aside class="fixed top-0 left-0 h-full w-64 bg-gray-900 text-gray-300 shadow-lg z-30 transform -translate-x-full lg:translate-x-0 transition-transform duration-300 ease-in-out" id="sidebar">
      <div class="p-6 flex items-center space-x-3 border-b border-gray-700">
        <svg class="h-10 w-10 text-blue-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M21 7.5l-9-5.25L3 7.5m18 0l-9 5.25m9-5.25v9l-9 5.25M3 7.5l9 5.25M3 7.5v9l9 5.25m0-9v9" /></svg>
        <span class="text-white text-2xl font-semibold">Inventori</span>
      </div>

      <AdminNavigation :current-path="$route.path" />
    </aside>

    <div class="fixed inset-0 bg-black bg-opacity-50 z-20 hidden" id="overlay" @click="toggleSidebar"></div>

    <div class="flex-1 flex flex-col transition-all duration-300 ease-in-out lg:ml-64" id="main-content">
      <Header @toggle-sidebar="toggleSidebar" />

      <main class="flex-1 p-4 md:p-8 overflow-y-auto">
        <div class="lg:grid lg:grid-cols-12 lg:gap-8">
          <!-- Left column: work area -->
          <div class="lg:col-span-8 space-y-6">
            <div class="flex items-center justify-between mb-4 lg:hidden">
              <h1 class="text-2xl font-bold text-gray-900">Buat PO Baru</h1>
              <router-link to="/admin/purchase-orders" class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 font-medium py-2 px-3 rounded-lg text-sm">Kembali</router-link>
            </div>

            <div class="bg-white p-6 rounded-xl shadow-lg border border-slate-200">
              <h2 class="text-xl font-semibold text-gray-900 mb-6 flex items-center space-x-2">
                <svg class="h-6 w-6 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M20.25 7.5l-.625 10.632a2.25 2.25 0 01-2.247 2.118H6.622a2.25 2.25 0 01-2.247-2.118L3.75 7.5M10.5 11.25h3M12 15h.008" /></svg>
                <span>Detail Barang</span>
              </h2>

              <form @submit.prevent="addItem" class="grid grid-cols-1 md:grid-cols-12 gap-4 mb-4 items-end">
                <div class="md:col-span-5">
                  <label for="item_select" class="block text-sm font-medium text-gray-700 mb-1">Pilih Barang</label>
                  <select v-model="newItem.barang_id" @change="onBarangSelected" id="item_select" class="w-full rounded-lg border-gray-300 shadow-sm p-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-500 transition-all duration-150">
                    <option value="">Pilih barang...</option>
                    <option v-for="barang in barangList" :key="barang.id" :value="barang.id" :data-nama="barang.nama" :data-price="barang.harga_beli || 0">{{ barang.kode }} - {{ barang.nama }}</option>
                  </select>
                </div>

                <div class="md:col-span-2">
                  <label for="item_qty" class="block text-sm font-medium text-gray-700 mb-1">Jumlah</label>
                  <input v-model.number="newItem.qty" type="number" id="item_qty" min="1" class="w-full rounded-lg border-gray-300 shadow-sm p-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-500 transition-all duration-150" />
                </div>

                <div class="md:col-span-3">
                  <label for="item_price" class="block text-sm font-medium text-gray-700 mb-1">Harga Satuan (Rp)</label>
                  <input v-model.number="newItem.harga_satuan" type="number" id="item_price" min="0" class="w-full rounded-lg border-gray-300 shadow-sm p-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-500 transition-all duration-150" />
                </div>

                <div class="md:col-span-2">
                  <button type="submit" class="w-full bg-blue-600 hover:bg-blue-700 text-white font-medium py-3 px-4 rounded-lg flex items-center justify-center space-x-2 transition-all duration-300 transform hover:-translate-y-0.5 hover:shadow-lg">
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
                      <th class="px-6 py-3 text-center text-xs font-medium text-slate-500 uppercase tracking-wider">Jumlah</th>
                      <th class="px-6 py-3 text-right text-xs font-medium text-slate-500 uppercase tracking-wider">Harga Satuan</th>
                      <th class="px-6 py-3 text-right text-xs font-medium text-slate-500 uppercase tracking-wider">Subtotal</th>
                      <th class="px-6 py-3 text-center text-xs font-medium text-slate-500 uppercase tracking-wider">Aksi</th>
                    </tr>
                  </thead>
                  <tbody class="divide-y divide-slate-200">
                    <tr v-if="items.length === 0">
                      <td colspan="5" class="px-6 py-10 text-center text-sm text-gray-500">
                        <svg class="h-12 w-12 text-gray-300 mx-auto" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M2.25 3h1.386c.51 0 .955.343 1.087.835l.383 1.437M7.5 14.25a3 3 0 00-3 3h15.75m-12.75-3h11.218c1.121-2.3 2.1-4.684 2.924-7.138a60.114 60.114 0 00-16.536-1.84M7.5 14.25L5.106 5.272M6 20.25a.75.75 0 11-1.5 0 .75.75 0 011.5 0zm12.75 0a.75.75 0 11-1.5 0 .75.75 0 011.5 0z" /></svg>
                        <p class="mt-2 font-medium">Keranjang PO masih kosong</p>
                        <p class="text-xs text-gray-400">Silakan pilih barang dan tambahkan ke daftar.</p>
                      </td>
                    </tr>
                    <tr v-for="(item, index) in items" :key="index" class="hover:bg-slate-50 transition-colors duration-150">
                      <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ item.nama }}</td>
                      <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600 text-center">{{ item.qty }}</td>
                      <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600 text-right">{{ formatCurrency(item.harga_satuan) }}</td>
                      <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 font-semibold text-right">{{ formatCurrency(item.qty * item.harga_satuan) }}</td>
                      <td class="px-6 py-4 whitespace-nowrap text-center">
                        <button @click="removeItem(index)" type="button" class="text-red-500 hover:text-red-700">
                          <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M19.5 12h-15" /></svg>
                        </button>
                      </td>
                    </tr>
                  </tbody>
                  <tfoot class="bg-slate-50">
                    <tr>
                      <td colspan="3" class="px-6 py-3 text-right text-base font-bold text-gray-900">Subtotal</td>
                      <td class="px-6 py-3 text-right text-base font-bold text-gray-900">{{ formatCurrency(subtotal) }}</td>
                      <td></td>
                    </tr>
                  </tfoot>
                </table>
              </div>
              <span v-if="errors.items" class="text-red-500 text-xs mt-2 block">{{ errors.items }}</span>
            </div>
          </div>

          <!-- Right column: document info & totals -->
          <div class="lg:col-span-4 space-y-6">
            <div class="lg:sticky lg:top-8 space-y-6">
              <div class="bg-white p-6 rounded-xl shadow-lg border border-slate-200">
                <div class="flex items-center justify-between mb-5">
                  <h2 class="text-xl font-semibold text-gray-900 flex items-center space-x-2">
                    <svg class="h-6 w-6 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M19.5 14.25v-2.625a3.375 3.375 0 00-3.375-3.375h-1.5A1.125 1.125 0 0113.5 7.125v-1.5a3.375 3.375 0 00-3.375-3.375H8.25m.75 12l3 3m0 0l3-3m-3 3v-6m-1.5-9H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 00-9-9z" /></svg>
                    <span>Informasi Dokumen</span>
                  </h2>
                  <router-link to="/admin/purchase-orders" class="hidden lg:block bg-white hover:bg-slate-50 border border-slate-300 text-slate-700 font-medium py-2 px-3 rounded-lg text-sm">Kembali</router-link>
                </div>

                <div class="space-y-4">
                  <div>
                    <label for="supplier" class="block text-sm font-medium text-gray-700 mb-1">Supplier</label>
                    <select v-model="form.supplier_id" id="supplier" required class="w-full rounded-lg border-gray-300 shadow-sm p-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-500 transition-all duration-150">
                      <option value="">Pilih Supplier...</option>
                      <option v-for="s in suppliers" :key="s.id" :value="s.id">{{ s.nama }}</option>
                    </select>
                  </div>
                  <div>
                    <label for="po_date" class="block text-sm font-medium text-gray-700 mb-1">Tanggal PO</label>
                    <input v-model="form.tgl_pesan" type="date" id="po_date" required class="w-full rounded-lg border-gray-300 shadow-sm p-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-500 transition-all duration-150" />
                  </div>
                  <div>
                    <label for="tgl_estimasi" class="block text-sm font-medium text-gray-700 mb-1">Estimasi Tgl. Tiba</label>
                    <input v-model="form.tgl_estimasi" type="date" id="tgl_estimasi" required class="w-full rounded-lg border-gray-300 shadow-sm p-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-500 transition-all duration-150" />
                    <span v-if="errors.tgl_estimasi" class="text-red-500 text-xs">{{ errors.tgl_estimasi }}</span>
                  </div>
                  <div>
                    <label for="po_number" class="block text-sm font-medium text-gray-700 mb-1">Nomor PO (Otomatis)</label>
                    <input type="text" id="po_number" :value="'PO-' + new Date().getFullYear() + '-XXXX'" readonly class="w-full rounded-lg border-gray-300 shadow-sm p-3 bg-slate-100 cursor-not-allowed" />
                  </div>
                  <div>
                    <label for="notes" class="block text-sm font-medium text-gray-700 mb-1">Catatan (Opsional)</label>
                    <textarea v-model="form.catatan" id="notes" rows="2" class="w-full rounded-lg border-gray-300 shadow-sm p-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-500 transition-all duration-150" placeholder="Termin pembayaran, dll..."></textarea>
                  </div>
                </div>
              </div>

              <div class="bg-white p-6 rounded-xl shadow-lg border border-slate-200">
                <h2 class="text-xl font-semibold text-gray-900 mb-4 flex items-center space-x-2">
                  <svg class="h-6 w-6 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M15.75 15.75l-2.489-2.489m0 0a3.375 3.375 0 10-4.773-4.773 3.375 3.375 0 004.774 4.774zM21 12a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
                  <span>Total Kalkulasi</span>
                </h2>
                <dl class="space-y-3">
                  <div class="flex justify-between items-center">
                    <dt class="text-sm text-gray-600">Subtotal</dt>
                    <dd class="text-base font-medium text-gray-900">{{ formatCurrency(subtotal) }}</dd>
                  </div>
                  <div class="flex justify-between items-center">
                    <dt class="text-sm text-gray-600">PPh (2%)</dt>
                    <dd class="text-base font-medium text-gray-900">{{ formatCurrency(pph) }}</dd>
                  </div>
                  <div class="flex justify-between items-center pt-3 border-t border-slate-200">
                    <dt class="text-lg font-bold text-gray-900">Total</dt>
                    <dd class="text-xl font-bold text-gray-900">{{ formatCurrency(total) }}</dd>
                  </div>
                </dl>
              </div>

              <div class="bg-white p-6 rounded-xl shadow-lg border border-slate-200">
                <h2 class="text-xl font-semibold text-gray-900 mb-4 flex items-center space-x-2">
                  <svg class="h-6 w-6 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M4.5 12.75l6 6 9-13.5" /></svg>
                  <span>Aksi</span>
                </h2>
                <div class="flex flex-col gap-3">
                  <button type="button" @click="submitPO('draft')" class="w-full text-center bg-white hover:bg-slate-100 border border-slate-300 text-slate-700 font-medium py-3 px-4 rounded-lg transition-all duration-300 transform hover:scale-105">Simpan sebagai Draft</button>
                  <button type="button" @click="submitPO('submit')" class="w-full text-center bg-blue-600 hover:bg-blue-700 text-white font-medium py-3 px-4 rounded-lg shadow-lg shadow-blue-500/30 hover:shadow-xl hover:shadow-blue-500/50 transition-all duration-300 transform hover:-translate-y-0.5">Simpan dan Ajukan</button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </main>

      <Footer />
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
const subtotal = computed(() => {
  return items.value.reduce((total, item) => total + (item.qty * item.harga_satuan), 0)
})

// PPh 2% calculation
const pph = computed(() => {
  // round to nearest integer
  return Math.round(subtotal.value * 0.02)
})

// Grand total = subtotal + pph (ppn currently 0)
const total = computed(() => {
  return subtotal.value + pph.value
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
      subtotal: subtotal.value,
      ppn: 0,
      pph: pph.value,
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
