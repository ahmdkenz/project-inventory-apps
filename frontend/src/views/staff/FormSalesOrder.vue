<template>
  <div>
    <div v-if="message.show" :class="message.isError ? 'bg-red-500' : 'bg-green-500'" class="text-white px-6 py-3 text-center mb-6 rounded-lg">
      {{ message.text }}
    </div>

    <div class="flex items-center justify-between mb-6">
          <h1 class="text-3xl font-bold text-gray-900">{{ isEditMode ? 'Edit' : 'Buat' }} Sales Order</h1>
          <router-link 
            to="/staff/sales-order" 
            class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150"
          >
            <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5L8.25 12l7.5-7.5" />
            </svg>
            <span>Kembali</span>
          </router-link>
        </div>

        <div class="max-w-6xl mx-auto">
          <form @submit.prevent="handleSubmit" class="space-y-6">
            <!-- Informasi Customer -->
            <div class="bg-white rounded-lg shadow-sm p-6">
              <h2 class="text-xl font-semibold mb-4 text-gray-900">Informasi Customer</h2>
              <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Pilih Customer <span class="text-red-500">*</span></label>
                  <select 
                    v-model="formData.customer_id"
                    @change="onCustomerChange"
                    required
                    class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                    :class="{ 'text-gray-500': !formData.customer_id, 'text-gray-900': formData.customer_id }"
                  >
                    <option :value="null" class="text-gray-500">-- Pilih Customer --</option>
                    <option 
                      v-for="customer in customers" 
                      :key="customer.id" 
                      :value="customer.id"
                      class="text-gray-900"
                    >
                      {{ customer.company_name }}
                    </option>
                  </select>
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">No. Telepon <span class="text-red-500">*</span></label>
                  <input 
                    v-model="formData.customer_phone" 
                    type="text" 
                    required
                    readonly
                    class="w-full rounded-md border-gray-300 shadow-sm p-2 bg-gray-50 focus:border-blue-500 focus:ring-blue-500"
                    placeholder="Otomatis terisi"
                  >
                </div>
                <div class="md:col-span-2">
                  <label class="block text-sm font-medium text-gray-700 mb-1">Alamat <span class="text-red-500">*</span></label>
                  <textarea 
                    v-model="formData.customer_address" 
                    required
                    readonly
                    rows="3"
                    class="w-full rounded-md border-gray-300 shadow-sm p-2 bg-gray-50 focus:border-blue-500 focus:ring-blue-500"
                    placeholder="Otomatis terisi"
                  ></textarea>
                </div>
              </div>
            </div>

            <!-- Informasi Order -->
            <div class="bg-white rounded-lg shadow-sm p-6">
              <h2 class="text-xl font-semibold mb-4 text-gray-900">Informasi Order</h2>
              <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Tanggal Order <span class="text-red-500">*</span></label>
                  <input 
                    v-model="formData.tgl_order" 
                    type="date" 
                    required
                    class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                  >
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Tanggal Kirim Estimasi <span class="text-red-500">*</span></label>
                  <input 
                    v-model="formData.tgl_kirim" 
                    type="date" 
                    required
                    class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                  >
                </div>
                <div class="md:col-span-2">
                  <label class="block text-sm font-medium text-gray-700 mb-1">Catatan</label>
                  <textarea 
                    v-model="formData.catatan" 
                    rows="2"
                    class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                    placeholder="Catatan tambahan (opsional)"
                  ></textarea>
                </div>
              </div>
            </div>

            <!-- Detail Barang -->
            <div class="bg-white rounded-lg shadow-sm p-6">
              <h2 class="text-xl font-semibold mb-4 text-gray-900">Detail Barang</h2>
              
              <!-- Tabel Barang -->
              <div class="overflow-x-auto">
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
                  <tr v-for="(item, index) in formData.items" :key="index">
                    <td class="px-4 py-3">
                      <select 
                        v-model="item.barang_id" 
                        @change="onBarangChange(index)"
                        required
                        class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                      >
                        <option value="">Pilih Barang</option>
                        <option v-for="barang in availableBarang" :key="barang.id" :value="barang.id">
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
                    <td class="px-4 py-3 text-right">{{ formatCurrency(formData.subtotal) }}</td>
                    <td></td>
                  </tr>
                  <tr>
                    <td colspan="3" class="px-4 py-3 text-right">PPN (0%)</td>
                    <td class="px-4 py-3 text-right">{{ formatCurrency(formData.ppn) }}</td>
                    <td></td>
                  </tr>
                  <tr class="text-lg">
                    <td colspan="3" class="px-4 py-3 text-right">Total</td>
                    <td class="px-4 py-3 text-right text-blue-600">{{ formatCurrency(formData.total) }}</td>
                    <td></td>
                  </tr>
                </tfoot>
              </table>
              </div>

              <button 
                type="button"
                @click="addItem"
                class="mt-4 inline-flex items-center px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
              >
                <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                </svg>
                Tambah Barang
              </button>
            </div>

            <!-- Action Buttons -->
          <div class="flex justify-end space-x-4">
            <router-link 
              to="/staff/sales-order" 
              class="bg-white hover:bg-gray-100 text-gray-700 font-medium py-2 px-6 rounded-lg border border-gray-300"
            >
              Batal
            </router-link>
            <button 
              type="submit" 
              :disabled="submitting || formData.items.length === 0"
              class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-6 rounded-lg disabled:bg-gray-400 disabled:cursor-not-allowed"
            >
              {{ submitting ? 'Menyimpan...' : (isEditMode ? 'Update' : 'Simpan') }}
            </button>
          </div>
        </form>
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
