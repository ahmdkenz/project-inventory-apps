<template>
  <div>
    <!-- Success/Error Message -->
    <div v-if="message.show" :class="message.isError ? 'bg-red-500' : 'bg-green-500'" class="text-white px-6 py-3 text-center mb-6 rounded-lg">
      {{ message.text }}
    </div>

    <div class="lg:grid lg:grid-cols-12 lg:gap-8">
      <!-- Left column: Work area -->
      <div class="lg:col-span-8 space-y-6">
        <div class="flex items-center justify-between mb-4 lg:hidden">
          <h1 class="text-2xl font-bold text-gray-900">{{ isEditMode ? 'Edit' : 'Buat' }} Purchase Order</h1>
          <router-link to="/staff/purchase-order" class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 font-medium py-2 px-3 rounded-lg text-sm">
            <span>Kembali</span>
          </router-link>
        </div>

        <!-- Card Detail Barang -->
        <div class="bg-white p-6 rounded-xl shadow-lg border border-slate-200">
          <h2 class="text-xl font-semibold text-gray-900 mb-6 flex items-center space-x-2">
            <span>Detail Barang</span>
          </h2>

          <!-- Form Tambah Item -->
          <form @submit.prevent="addItem" class="grid grid-cols-1 md:grid-cols-12 gap-4 mb-4 items-end">
            <div class="md:col-span-5">
              <label for="item_select" class="block text-sm font-medium text-gray-700 mb-1">Pilih Barang</label>
              <select v-model="newItem.barang_id" @change="onBarangSelect" id="item_select" class="w-full rounded-lg border-gray-300 shadow-sm p-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-500 transition-all duration-150">
                <option value="">Pilih barang...</option>
                <option v-for="barang in barangList" :key="barang.id" :value="barang.id" :data-nama="barang.nama" :data-price="barang.harga_beli">{{ barang.kode }} - {{ barang.nama }}</option>
              </select>
            </div>
            <div class="md:col-span-2">
              <label for="item_qty" class="block text-sm font-medium text-gray-700 mb-1">Jumlah</label>
              <input v-model.number="newItem.qty" type="number" id="item_qty" min="1" class="w-full rounded-lg border-gray-300 shadow-sm p-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-500 transition-all duration-150">
            </div>
            <div class="md:col-span-3">
              <label for="item_price" class="block text-sm font-medium text-gray-700 mb-1">Harga Satuan (Rp)</label>
              <input v-model.number="newItem.harga_satuan" type="number" id="item_price" min="0" class="w-full rounded-lg border-gray-300 shadow-sm p-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-500 transition-all duration-150">
            </div>
            <div class="md:col-span-2">
              <button type="submit" class="w-full bg-blue-600 hover:bg-blue-700 text-white font-medium py-3 px-4 rounded-lg flex items-center justify-center space-x-2 transition-all duration-300 transform hover:-translate-y-0.5 hover:shadow-lg">
                <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" /></svg>
                <span>Tambah</span>
              </button>
            </div>
          </form>

          <!-- Tabel Item Ditambahkan -->
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
                <tr v-for="(item, index) in form.items" :key="index" class="hover:bg-slate-50 transition-colors duration-150">
                  <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ item.barang?.nama }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600 text-center">{{ item.qty }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600 text-right">{{ formatCurrency(item.harga_satuan) }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 font-semibold text-right">{{ formatCurrency(item.qty * item.harga_satuan) }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-center">
                    <button @click="removeItem(index)" type="button" class="text-red-500 hover:text-red-700">
                      <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M19.5 12h-15" /></svg>
                    </button>
                  </td>
                </tr>
                <tr v-if="form.items.length === 0">
                  <td colspan="5" class="px-6 py-10 text-center text-sm text-gray-500">
                    Keranjang PO masih kosong
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <!-- Right column: Info & actions -->
      <div class="lg:col-span-4 space-y-6">
        <div class="lg:sticky lg:top-8 space-y-6">
          <!-- Card Info Dokumen -->
          <div class="bg-white p-6 rounded-xl shadow-lg border border-slate-200">
            <div class="flex items-center justify-between mb-5">
              <h2 class="text-xl font-semibold text-gray-900">Informasi Dokumen</h2>
              <router-link to="/staff/purchase-order" class="hidden lg:block bg-white hover:bg-slate-50 border border-slate-300 text-slate-700 font-medium py-2 px-3 rounded-lg text-sm">Kembali</router-link>
            </div>
            <div class="space-y-4">
              <div>
                <label for="supplier" class="block text-sm font-medium text-gray-700 mb-1">Supplier</label>
                <select id="supplier" v-model="form.supplier_id" required class="w-full rounded-lg border-gray-300 shadow-sm p-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-500 transition-all duration-150">
                  <option value="">Pilih Supplier...</option>
                  <option v-for="s in supplierList" :key="s.id" :value="s.id">{{ s.nama }}</option>
                </select>
              </div>
              <div>
                <label for="po_date" class="block text-sm font-medium text-gray-700 mb-1">Tanggal PO</label>
                <input type="date" id="po_date" v-model="form.tgl_pesan" required class="w-full rounded-lg border-gray-300 shadow-sm p-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-500 transition-all duration-150">
              </div>
              <div>
                <label for="tgl_estimasi" class="block text-sm font-medium text-gray-700 mb-1">Estimasi Tgl. Tiba</label>
                <input type="date" id="tgl_estimasi" v-model="form.tgl_estimasi" required class="w-full rounded-lg border-gray-300 shadow-sm p-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-500 transition-all duration-150">
              </div>
              <div>
                <label for="notes" class="block text-sm font-medium text-gray-700 mb-1">Catatan (Opsional)</label>
                <textarea id="notes" v-model="form.catatan" rows="2" class="w-full rounded-lg border-gray-300 shadow-sm p-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-500 transition-all duration-150" placeholder="Termin pembayaran, dll..."></textarea>
              </div>
            </div>
          </div>

          <!-- Card Kalkulasi Total (menampilkan PPN 2%) -->
          <div class="bg-white p-6 rounded-xl shadow-lg border border-slate-200">
            <h2 class="text-xl font-semibold text-gray-900 mb-4">Total Kalkulasi</h2>
            <dl class="space-y-3">
              <div class="flex justify-between items-center">
                <dt class="text-sm text-gray-600">Subtotal</dt>
                <dd class="text-base font-medium text-gray-900">{{ formatCurrency(subtotal) }}</dd>
              </div>
              <div class="flex justify-between items-center">
                <dt class="text-sm text-gray-600">PPN (2%)</dt>
                <dd class="text-base font-medium text-gray-900">{{ formatCurrency(ppn) }}</dd>
              </div>
              <div class="flex justify-between items-center pt-3 border-t border-slate-200">
                <dt class="text-lg font-bold text-gray-900">Total</dt>
                <dd class="text-xl font-bold text-gray-900">{{ formatCurrency(total) }}</dd>
              </div>
            </dl>
          </div>

          <!-- Card Aksi (CTA) -->
          <div class="bg-white p-6 rounded-xl shadow-lg border border-slate-200">
            <h2 class="text-xl font-semibold text-gray-900 mb-4">Aksi</h2>
            <div class="flex flex-col gap-3">
              <button type="button" @click="saveDraft" class="w-full text-center bg-white hover:bg-slate-100 border border-slate-300 text-slate-700 font-medium py-3 px-4 rounded-lg">Simpan sebagai Draft</button>
              <button type="button" @click="submitForm" :disabled="loading" class="w-full text-center bg-blue-600 hover:bg-blue-700 text-white font-medium py-3 px-4 rounded-lg shadow-lg">Simpan dan Ajukan</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import purchaseOrderService from '@/services/purchaseOrder.service'
import staffBarangService from '@/services/staff/barang.service'
import staffSupplierService from '@/services/staff/supplier.service'
import type { PurchaseOrder, PurchaseOrderItem } from '@/services/purchaseOrder.service'
import type { Barang } from '@/services/barang.service'
import type { Supplier } from '@/services/supplier.service'

const router = useRouter()
const route = useRoute()

const user = ref<any>(null)

const isEditMode = computed(() => route.params.id !== undefined)

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

// PPN 2% (ditambahkan pada total)
const ppn = computed(() => {
  return Math.round(subtotal.value * 0.02)
})

// Total setelah menambahkan PPN 2%
const total = computed(() => {
  return subtotal.value + ppn.value
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
    const response = await staffBarangService.getAll({ per_page: 1000 })
    if (response.success && Array.isArray(response.data)) {
      barangList.value = response.data
    }
  } catch (error: any) {
    console.error('Error loading barang:', error)
  }
}

const fetchSupplier = async () => {
  try {
    const response = await staffSupplierService.getAll()
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

const submitForm = async (status: 'submit' | 'draft' = 'submit') => {
  if (!validateForm()) {
    showMessage('Mohon lengkapi semua field yang wajib diisi', true)
    return
  }

  loading.value = true
    try {
    // Prepare data
    const data: any = {
      ...form,
      subtotal: subtotal.value,
      ppn: ppn.value,
      total: total.value,
      status: status === 'draft' ? 'draft' : form.status || 'pending'
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

const saveDraft = async () => {
  await submitForm('draft')
}

const formatCurrency = (value: number) => {
  return new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    minimumFractionDigits: 0
  }).format(value)
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
