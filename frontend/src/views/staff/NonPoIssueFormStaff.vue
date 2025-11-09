<template>
  <div class="flex h-screen bg-gray-100">
    <!-- Sidebar Admin -->
    <aside class="fixed top-0 left-0 h-full w-64 bg-gray-900 text-gray-300 shadow-lg z-30 transform -translate-x-full lg:translate-x-0 transition-transform duration-300 ease-in-out print-hidden" id="sidebar">
      <div class="p-6 flex items-center space-x-3">
        <svg class="h-10 w-10 text-blue-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" d="M21 7.5l-9-5.25L3 7.5m18 0l-9 5.25m9-5.25v9l-9 5.25M3 7.5l9 5.25M3 7.5v9l9 5.25m0-9v9" />
        </svg>
        <span class="text-white text-2xl font-semibold">Inventori</span>
      </div>
      
      <StaffNavigation :current-path="$route.path" />
    </aside>

    <div class="fixed inset-0 bg-black bg-opacity-50 z-20 hidden print-hidden" id="overlay"></div>
    
    <div class="flex-1 flex flex-col transition-all duration-300 ease-in-out lg:ml-64" id="main-content">
      <header class="bg-white shadow-sm p-4 flex items-center justify-between z-10 print-hidden">
        <button id="hamburger-btn" class="text-gray-600 lg:hidden" @click="toggleSidebar">
          <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5" />
          </svg>
        </button>
        <div class="relative hidden sm:block"></div>
        <div class="flex items-center space-x-4">
          <!-- Profile placeholder -->
        </div>
      </header>

      <!-- Global Alert Message -->
      <div v-if="showAlert" 
        class="fixed top-20 right-6 py-3 px-6 rounded-lg shadow-lg z-50 text-white transition-all duration-300"
        :class="alertType === 'success' ? 'bg-green-600' : 'bg-red-600'">
        <span>{{ alertMessage }}</span>
      </div>

      <main class="flex-1 p-6 overflow-y-auto">
        <div class="flex items-center justify-between mb-6">
          <h1 class="text-3xl font-bold text-gray-900">Pengeluaran Barang (Non-SO)</h1>
          <router-link to="/staff/sales-order" class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150">
            <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5L8.25 12l7.5-7.5" />
            </svg>
            <span>Kembali</span>
          </router-link>
        </div>

        <div class="max-w-6xl mx-auto">
          <form @submit.prevent="submitIssue" class="space-y-6">
            <!-- Informasi Pengeluaran -->
            <div class="bg-white rounded-lg shadow-sm p-6">
              <h2 class="text-xl font-semibold mb-4 text-gray-900">Informasi Pengeluaran</h2>
              <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label for="recipient" class="block text-sm font-medium text-gray-700 mb-1">Penerima / Tujuan <span class="text-red-500">*</span></label>
                  <input 
                    v-model="formData.recipient" 
                    type="text" 
                    id="recipient" 
                    required 
                    class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500" 
                    placeholder="Contoh: Divisi Marketing"
                  >
                </div>
                <div>
                  <label for="issue_date" class="block text-sm font-medium text-gray-700 mb-1">Tanggal Dikeluarkan <span class="text-red-500">*</span></label>
                  <input 
                    v-model="formData.issue_date" 
                    type="date" 
                    id="issue_date" 
                    required 
                    class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                  >
                </div>
                <div class="md:col-span-2">
                  <label for="notes" class="block text-sm font-medium text-gray-700 mb-1">Catatan</label>
                  <textarea 
                    v-model="formData.notes" 
                    id="notes" 
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
                          @change="onBarangChangeInline(index)"
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
                :disabled="saving || formData.items.length === 0"
                class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-6 rounded-lg disabled:bg-gray-400 disabled:cursor-not-allowed"
              >
                {{ saving ? 'Menyimpan...' : 'Simpan' }}
              </button>
            </div>
          </form>
        </div>
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import StaffNavigation from '@/components/StaffNavigation.vue'
import axios from 'axios'

const router = useRouter()

interface FormItem {
  barang_id: number | string
  qty: number
  harga_satuan: number
  subtotal: number
}

const formData = ref({
  recipient: '',
  issue_date: new Date().toISOString().split('T')[0],
  notes: '',
  items: [] as FormItem[],
  subtotal: 0,
  ppn: 0,
  total: 0
})

const barangList = ref<any[]>([])
const saving = ref(false)
const showAlert = ref(false)
const alertMessage = ref('')
const alertType = ref<'success' | 'danger'>('success')

const onBarangChangeInline = (index: number) => {
  const item = formData.value.items[index]
  if (!item) return
  
  const barang = barangList.value.find(b => b.id === item.barang_id)
  
  if (barang) {
    // Set harga_satuan to harga_beli (purchase price)
    item.harga_satuan = barang.harga_beli || 0
    calculateItemSubtotal(index)
  }
}

const calculateItemSubtotal = (index: number) => {
  const item = formData.value.items[index]
  if (!item) return
  item.subtotal = (item.qty || 0) * (item.harga_satuan || 0)
  calculateTotal()
}

const calculateTotal = () => {
  formData.value.subtotal = formData.value.items.reduce((sum, item) => sum + (item.subtotal || 0), 0)
  formData.value.ppn = 0 // No PPN (same as Sales Order)
  formData.value.total = formData.value.subtotal + formData.value.ppn
}

const formatCurrency = (value: number) => {
  return new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    minimumFractionDigits: 0,
    maximumFractionDigits: 0
  }).format(value || 0)
}

const toggleSidebar = () => {
  const sidebar = document.getElementById('sidebar')
  const overlay = document.getElementById('overlay')
  if (sidebar && overlay) {
    sidebar.classList.toggle('-translate-x-full')
    overlay.classList.toggle('hidden')
  }
}

const fetchBarangList = async () => {
  try {
    const token = localStorage.getItem('token')
    const response = await axios.get('http://localhost:8000/api/staff/barang', {
      headers: {
        'Authorization': `Bearer ${token}`,
        'Accept': 'application/json'
      }
    })
    
    if (response.data.success) {
      barangList.value = response.data.data
    }
  } catch (error) {
    console.error('Error fetching barang:', error)
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

const submitIssue = async () => {
  if (!formData.value.recipient) {
    showAlertMessage('Penerima/Tujuan wajib diisi.', 'danger')
    return
  }

  if (formData.value.items.length === 0) {
    showAlertMessage('Anda harus menambahkan minimal 1 barang.', 'danger')
    return
  }

  // Validate stock for each item
  for (const item of formData.value.items) {
    const barang = barangList.value.find(b => b.id === item.barang_id)
    if (barang && item.qty > barang.stok) {
      showAlertMessage(`Stok ${barang.nama} tidak mencukupi. Stok tersedia: ${barang.stok}`, 'danger')
      return
    }
  }

  saving.value = true
  try {
    const token = localStorage.getItem('token')
    const response = await axios.post('http://localhost:8000/api/staff/non-po/issue', formData.value, {
      headers: {
        'Authorization': `Bearer ${token}`,
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      }
    })

    if (response.data.success) {
      showAlertMessage('Pengeluaran Non-SO berhasil disimpan!', 'success')
      
      setTimeout(() => {
        router.push('/staff/sales-order')
      }, 1500)
    } else {
      showAlertMessage(response.data.message || 'Gagal menyimpan data', 'danger')
    }
  } catch (error: any) {
    console.error('Error saving issue:', error)
    showAlertMessage(error.response?.data?.message || 'Terjadi kesalahan saat menyimpan data', 'danger')
  } finally {
    saving.value = false
  }
}

const showAlertMessage = (message: string, type: 'success' | 'danger') => {
  alertMessage.value = message
  alertType.value = type
  showAlert.value = true
  
  setTimeout(() => {
    showAlert.value = false
  }, 3000)
}

onMounted(() => {
  fetchBarangList()
})
</script>

<style scoped>
@media print {
  .print-hidden {
    display: none !important;
  }
}
</style>
