<template>
  <div class="lg:grid lg:grid-cols-12 lg:gap-8">
    <div class="lg:col-span-8 space-y-6">

      <!-- Mobile header/back -->
      <div class="flex items-center justify-between mb-4 lg:hidden">
        <h1 class="text-2xl font-bold text-gray-900">{{ isEditMode ? 'Edit' : 'Buat' }} Sales Order</h1>
        <router-link to="/staff/sales-order" class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 font-medium py-2 px-3 rounded-lg text-sm">
          <span>Kembali</span>
        </router-link>
      </div>

      <!-- Card Detail Barang -->
      <div class="bg-white p-6 rounded-xl shadow-lg border border-slate-200">
        <h2 class="text-xl font-semibold text-gray-900 mb-6 flex items-center space-x-2">
          <svg class="h-6 w-6 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M20.25 7.5l-.625 10.632a2.25 2.25 0 01-2.247 2.118H6.622a2.25 2.25 0 01-2.247-2.118L3.75 7.5M10.5 11.25h3M12 15h.008" /></svg>
          <span>Detail Barang Diminta</span>
        </h2>

        <!-- Table Items -->
        <div class="overflow-x-auto border rounded-lg">
          <table class="w-full min-w-max">
            <thead class="bg-slate-50">
              <tr>
                <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">Nama Barang</th>
                <th class="px-6 py-3 text-center text-xs font-medium text-slate-500 uppercase tracking-wider">Stok Tersedia</th>
                <th class="px-6 py-3 text-center text-xs font-medium text-slate-500 uppercase tracking-wider">Jumlah</th>
                <th class="px-6 py-3 text-right text-xs font-medium text-slate-500 uppercase tracking-wider">Harga</th>
                <th class="px-6 py-3 text-right text-xs font-medium text-slate-500 uppercase tracking-wider">Subtotal</th>
                <th class="px-6 py-3 text-center text-xs font-medium text-slate-500 uppercase tracking-wider">Aksi</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-slate-200">
              <template v-for="(item, index) in formData.items" :key="index">
                <tr class="hover:bg-slate-50 transition-colors duration-150">
                  <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                    <select v-model="item.barang_id" @change="onBarangChange(index)" class="w-full rounded-md border-gray-300 shadow-sm p-2">
                      <option value="">Pilih Barang</option>
                      <option v-for="barang in availableBarang" :key="barang.id" :value="barang.id">{{ barang.nama }} - Stok: {{ barang.stok }}</option>
                    </select>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-center" :class="item.stok < item.qty ? 'text-red-600 font-semibold' : 'text-gray-600'">{{ item.stok ?? '-' }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 font-semibold text-center">
                    <input v-model.number="item.qty" @input="calculateItemSubtotal(index)" type="number" min="1" class="w-20 rounded-md border-gray-300 p-2 text-center">
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600 text-right">
                    <input v-model.number="item.harga_satuan" @input="calculateItemSubtotal(index)" type="number" min="0" class="w-32 rounded-md border-gray-300 p-2 text-right">
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 font-semibold text-right">{{ formatCurrency(item.subtotal || 0) }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-center">
                    <button @click="removeItem(index)" type="button" class="text-red-500 hover:text-red-700">
                      <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M19.5 12h-15" /></svg>
                    </button>
                  </td>
                </tr>
              </template>

              <template v-if="formData.items.length === 0">
                <tr>
                  <td colspan="6" class="px-6 py-10 text-center text-sm text-gray-500">
                    <svg class="h-12 w-12 text-gray-300 mx-auto" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M2.25 3h1.386c.51 0 .955.343 1.087.835l.383 1.437M7.5 14.25a3 3 0 00-3 3h15.75m-12.75-3h11.218c1.121-2.3 2.1-4.684 2.924-7.138a60.114 60.114 0 00-16.536-1.84M7.5 14.25L5.106 5.272M6 20.25a.75.75 0 11-1.5 0 .75.75 0 011.5 0zm12.75 0a.75.75 0 11-1.5 0 .75.75 0 011.5 0z" /></svg>
                    <p class="mt-2 font-medium">Belum ada barang diminta</p>
                    <p class="text-xs text-gray-400">Silakan pilih barang dan tambahkan ke daftar.</p>
                  </td>
                </tr>
              </template>
            </tbody>

            <tfoot class="bg-slate-50 border-t border-slate-200" v-if="formData.items.length > 0">
              <tr>
                <td colspan="4" class="px-6 py-3 text-right text-sm font-semibold text-gray-700 uppercase">Total Estimasi</td>
                <td class="px-6 py-3 text-right text-sm font-bold text-gray-900">{{ formatCurrency(formData.total) }}</td>
                <td></td>
              </tr>
            </tfoot>
          </table>
        </div>

        <div class="mt-4">
          <button @click="addItem" type="button" class="w-full md:w-auto bg-blue-600 hover:bg-blue-700 text-white font-medium py-3 px-4 rounded-lg inline-flex items-center space-x-2">
            <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M12 4v16m8-8H4" /></svg>
            <span>Tambah</span>
          </button>
        </div>
      </div>
    </div>

    <!-- Right column -->
    <div class="lg:col-span-4 space-y-6">
      <div class="lg:sticky lg:top-8 space-y-6">

        <!-- Card Info Dokumen -->
        <div class="bg-white p-6 rounded-xl shadow-lg border border-slate-200">
          <div class="flex items-center justify-between mb-5">
            <h2 class="text-xl font-semibold text-gray-900 flex items-center space-x-2">
              <svg class="h-6 w-6 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M11.25 11.25l.041-.02a.75.75 0 011.063.852l-.708 2.836a.75.75 0 001.063.853l.041-.021M21 12a9 9 0 11-18 0 9 9 0 0118 0zm-9-3.75h.008v.008H12V8.25z" /></svg>
              <span>Informasi Dokumen</span>
            </h2>
            <router-link to="/staff/sales-order" class="hidden lg:block bg-white hover:bg-slate-50 border border-slate-300 text-slate-700 font-medium py-2 px-3 rounded-lg text-sm transition-colors duration-150">Kembali</router-link>
          </div>

          <div class="space-y-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Pilih Customer</label>
              <select v-model="formData.customer_id" @change="onCustomerChange" class="w-full rounded-lg border-gray-300 shadow-sm p-3">
                <option value="">-- Pilih Customer --</option>
                <option v-for="c in customers" :key="c.id" :value="c.id">{{ c.company_name }}</option>
              </select>
            </div>

            <div v-show="formData.customer_id" class="space-y-4 p-4 bg-slate-50 rounded-lg border border-slate-100">
              <div>
                <label class="block text-xs font-semibold text-gray-500 uppercase mb-1">No. Telepon</label>
                <input type="text" :value="formData.customer_phone" readonly class="w-full bg-transparent border-0 p-0 text-sm text-gray-900 font-medium focus:ring-0 cursor-default">
              </div>
              <div>
                <label class="block text-xs font-semibold text-gray-500 uppercase mb-1">Alamat</label>
                <textarea readonly class="w-full bg-transparent border-0 p-0 text-sm text-gray-900 font-medium focus:ring-0 cursor-default resize-none" rows="2">{{ formData.customer_address }}</textarea>
              </div>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Tanggal Order</label>
              <input type="date" v-model="formData.tgl_order" class="w-full rounded-lg border-gray-300 shadow-sm p-3">
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Tanggal Kirim Estimasi</label>
              <input type="date" v-model="formData.tgl_kirim" class="w-full rounded-lg border-gray-300 shadow-sm p-3">
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Nomor SO (Otomatis)</label>
              <input type="text" value="SO-2024-XXXX" readonly class="w-full rounded-lg border-gray-300 shadow-sm p-3 bg-slate-100 cursor-not-allowed">
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Catatan (Opsional)</label>
              <textarea v-model="formData.catatan" rows="2" class="w-full rounded-lg border-gray-300 shadow-sm p-3" placeholder="Instruksi khusus pengiriman..."></textarea>
            </div>
          </div>
        </div>

        <!-- Card Aksi -->
        <div class="bg-white p-6 rounded-xl shadow-lg border border-slate-200">
          <h2 class="text-xl font-semibold text-gray-900 mb-4 flex items-center space-x-2">
            <svg class="h-6 w-6 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M4.5 12.75l6 6 9-13.5" /></svg>
            <span>Aksi</span>
          </h2>
          <div class="flex flex-col gap-3">
            <button type="button" @click="handleSubmit" class="w-full text-center bg-white hover:bg-slate-100 border border-slate-300 text-slate-700 font-medium py-3 px-4 rounded-lg">Simpan sebagai Draft</button>
            <button type="button" @click="handleSubmit" class="w-full text-center bg-blue-600 hover:bg-blue-700 text-white font-medium py-3 px-4 rounded-lg shadow-lg">Simpan dan Ajukan</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import salesOrderService from '@/services/salesOrder.service'
import type { SalesOrderItem } from '@/services/salesOrder.service'
import staffBarangService from '@/services/staff/barang.service'
import staffCustomerService from '@/services/staff/customer.service'

const router = useRouter()
const route = useRoute()
const submitting = ref(false)
const availableBarang = ref<any[]>([])
const customers = ref<any[]>([])

const isEditMode = computed(() => !!route.params.id)

interface FormData {
  customer_id: number | null
  customer_name: string
  customer_phone: string
  customer_address: string
  tgl_order: string
  tgl_kirim: string
  catatan: string
  items: SalesOrderItem[]
  subtotal: number
  ppn: number
  total: number
}

const formData = ref<FormData>({
  customer_id: null,
  customer_name: '',
  customer_phone: '',
  customer_address: '',
  tgl_order: new Date().toISOString().split('T')[0] ?? '',
  tgl_kirim: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString().split('T')[0] ?? '',
  catatan: '',
  items: [],
  subtotal: 0,
  ppn: 0,
  total: 0
})

const message = ref({
  show: false,
  text: '',
  isError: false
})

const fetchCustomers = async () => {
  try {
    const response = await staffCustomerService.getAll('', 1, 1000)
    if (response.data && Array.isArray(response.data)) {
      customers.value = response.data
    }
  } catch (error) {
    console.error('Error fetching customers:', error)
    showMessage('Gagal memuat data customer', true)
  }
}

const fetchBarang = async () => {
  try {
    const response = await staffBarangService.getAll({ per_page: 1000 })
    if (response.success && Array.isArray(response.data)) {
      availableBarang.value = response.data
    } else if (response.success && response.data && typeof response.data === 'object' && !Array.isArray(response.data) && 'data' in response.data) {
      availableBarang.value = Array.isArray((response.data as Record<string, any>).data) ? (response.data as Record<string, any>).data : []
    }
  } catch (error) {
    console.error('Error fetching barang:', error)
    showMessage('Gagal memuat data barang', true)
  }
}

const fetchSalesOrder = async () => {
  if (!route.params.id) return
  
  try {
    const response = await salesOrderService.getById(Number(route.params.id))
    if (response.success && !Array.isArray(response.data)) {
      const so = response.data
      
      // Populate form data
      formData.value.customer_name = so.customer_name
      formData.value.customer_phone = so.customer_phone || ''
      formData.value.customer_address = so.customer_address || ''
      
      // Try to find matching customer by name
      const matchingCustomer = customers.value.find(
        c => c.company_name === so.customer_name
      )
      if (matchingCustomer) {
        formData.value.customer_id = matchingCustomer.id
      }
      
      formData.value.tgl_order = so.tgl_order
      formData.value.tgl_kirim = so.tgl_kirim
      formData.value.catatan = so.catatan || ''
      formData.value.items = so.items?.map(item => ({
        barang_id: item.barang_id,
        qty: item.qty,
        harga_satuan: item.harga_satuan,
        subtotal: item.subtotal
      })) || []
      
      calculateTotal()
    }
  } catch (error: any) {
    showMessage('Gagal memuat data sales order', true)
    router.push('/staff/sales-order')
  }
}

const addItem = () => {
  formData.value.items.push({
    barang_id: 0,
    qty: 1,
    harga_satuan: 0,
    subtotal: 0
  })
}

const removeItem = (index: number) => {
  formData.value.items.splice(index, 1)
  calculateTotal()
}

const onCustomerChange = () => {
  if (!formData.value.customer_id) {
    formData.value.customer_name = ''
    formData.value.customer_phone = ''
    formData.value.customer_address = ''
    return
  }

  const customer = customers.value.find(c => c.id === formData.value.customer_id)
  if (customer) {
    formData.value.customer_name = customer.company_name || ''
    formData.value.customer_phone = customer.phone || ''
    formData.value.customer_address = customer.address || ''
  }
}

const onBarangChange = (index: number) => {
  const item = formData.value.items[index]
  if (!item) return
  
  const barang = availableBarang.value.find(b => b.id === item.barang_id)
  
  if (barang) {
    // Set harga_satuan to harga_jual (selling price)
    item.harga_satuan = barang.harga_jual || 0
    calculateItemSubtotal(index)
  }
}

const calculateItemSubtotal = (index: number) => {
  const item = formData.value.items[index]
  if (!item) return
  item.subtotal = item.qty * item.harga_satuan
  calculateTotal()
}

const calculateTotal = () => {
  formData.value.subtotal = formData.value.items.reduce((sum, item) => sum + (item.subtotal || 0), 0)
  formData.value.ppn = 0 // No PPN
  formData.value.total = formData.value.subtotal + formData.value.ppn
}

const handleSubmit = async () => {
  if (formData.value.items.length === 0) {
    showMessage('Minimal harus ada 1 barang', true)
    return
  }

  // Validate stock for each item
  for (const item of formData.value.items) {
    const barang = availableBarang.value.find(b => b.id === item.barang_id)
    if (barang && item.qty > barang.stok) {
      showMessage(`Stok ${barang.nama} tidak mencukupi. Stok tersedia: ${barang.stok}`, true)
      return
    }
  }

  submitting.value = true

  try {
    const payload = {
      customer_name: formData.value.customer_name,
      customer_phone: formData.value.customer_phone,
      customer_address: formData.value.customer_address,
      tgl_order: formData.value.tgl_order,
      tgl_kirim: formData.value.tgl_kirim,
      catatan: formData.value.catatan,
      items: formData.value.items,
      subtotal: formData.value.subtotal,
      ppn: formData.value.ppn,
      total: formData.value.total,
      status: 'pending' as 'pending' | 'approved' | 'rejected' | 'completed'
    }

    let response
    if (isEditMode.value) {
      response = await salesOrderService.update(Number(route.params.id), payload)
    } else {
      response = await salesOrderService.create(payload)
    }

    if (response.success) {
      showMessage(
        isEditMode.value ? 'Sales Order berhasil diupdate' : 'Sales Order berhasil dibuat',
        false
      )
      setTimeout(() => {
        router.push('/staff/sales-order')
      }, 1500)
    }
  } catch (error: any) {
    console.error('Error saving sales order:', error)
    const errorMsg = error.response?.data?.message || 'Gagal menyimpan sales order'
    showMessage(errorMsg, true)
  } finally {
    submitting.value = false
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

onMounted(async () => {
  await fetchCustomers()
  await fetchBarang()
  
  if (isEditMode.value) {
    await fetchSalesOrder()
  }
})
</script>
