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

      <!-- Konten Utama (Form) -->
      <main class="flex-1 p-6 overflow-y-auto">
        <div class="flex items-center justify-between mb-6">
          <h1 class="text-3xl font-bold text-gray-900">Penerimaan Barang (Non-PO)</h1>
          <router-link to="/admin/purchase-orders" class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150">
            <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5L8.25 12l7.5-7.5" />
            </svg>
            <span>Kembali ke Daftar PO</span>
          </router-link>
        </div>
        
        <div class="max-w-7xl mx-auto space-y-6">
          <!-- Informasi Penerimaan -->
          <div class="bg-white p-6 rounded-lg shadow-sm">
            <h2 class="text-xl font-semibold text-gray-900 mb-4">Informasi Dokumen</h2>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
              <div>
                <label for="source" class="block text-sm font-medium text-gray-700 mb-1">Sumber Barang</label>
                <input v-model="formData.source" type="text" id="source" required placeholder="Cth: Retur Divisi IT, Hibah, etc." class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500 border">
              </div>
              <div>
                <label for="receive_date" class="block text-sm font-medium text-gray-700 mb-1">Tanggal Diterima</label>
                <input v-model="formData.receive_date" type="date" id="receive_date" required class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500 border">
              </div>
              <div class="md:col-span-3">
                <label for="notes" class="block text-sm font-medium text-gray-700 mb-1">Catatan (Penting)</label>
                <textarea v-model="formData.notes" id="notes" rows="2" required class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500 border" placeholder="Tuliskan alasan penerimaan non-PO ini..."></textarea>
              </div>
            </div>
          </div>

          <!-- Detail Barang -->
          <div class="bg-white p-6 rounded-lg shadow-sm">
            <h2 class="text-xl font-semibold text-gray-900 mb-4">Detail Barang yang Diterima</h2>
            
            <!-- Form Tambah Item -->
            <form @submit.prevent="addItem" class="grid grid-cols-1 md:grid-cols-12 gap-4 mb-4 items-end">
              <div class="md:col-span-5">
                <label for="item_select" class="block text-sm font-medium text-gray-700 mb-1">Pilih Barang</label>
                <select v-model="newItem.barang_id" id="item_select" class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500 border">
                  <option value="">Pilih barang...</option>
                  <option v-for="barang in barangList" :key="barang.id" :value="barang.id">
                    {{ barang.kode }} - {{ barang.nama }}
                  </option>
                </select>
              </div>
              <div class="md:col-span-3">
                <label for="item_qty" class="block text-sm font-medium text-gray-700 mb-1">Jumlah Diterima</label>
                <input v-model.number="newItem.qty" type="number" id="item_qty" min="1" class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500 border">
              </div>
              <div class="md:col-span-3">
                <label for="item_price" class="block text-sm font-medium text-gray-700 mb-1">Harga Satuan (Opsional)</label>
                <input v-model.number="newItem.price" type="number" id="item_price" min="0" placeholder="0" class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500 border">
              </div>
              <div class="md:col-span-1">
                <label class="block text-sm font-medium text-transparent mb-1">Aksi</label>
                <button type="submit" class="w-full bg-blue-500 hover:bg-blue-600 text-white font-medium py-2 px-4 rounded-lg flex items-center justify-center transition duration-150">
                  <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
                  </svg>
                </button>
              </div>
            </form>
            
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
                  <tr v-if="formData.items.length === 0">
                    <td colspan="5" class="px-6 py-4 text-center text-sm text-gray-500">
                      Belum ada barang ditambahkan
                    </td>
                  </tr>
                  <tr v-for="(item, index) in formData.items" :key="index">
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ item.name }}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 text-center">{{ item.qty }}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 text-right">{{ formatCurrency(item.price) }}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 font-medium text-right">{{ formatCurrency(item.qty * item.price) }}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-center">
                      <button @click="removeItem(index)" type="button" class="text-red-600 hover:text-red-800">
                        <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                          <path stroke-linecap="round" stroke-linejoin="round" d="M14.74 9l-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 01-2.244 2.077H8.084a2.25 2.25 0 01-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 00-3.478-.397m-12 0c.34-.058.682-.114 1.022-.165m0 0a48.11 48.11 0 013.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 00-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 00-7.5 0" />
                        </svg>
                      </button>
                    </td>
                  </tr>
                </tbody>
                <tfoot v-if="formData.items.length > 0" class="bg-gray-50 font-medium">
                  <tr>
                    <td colspan="3" class="px-6 py-3 text-right text-sm text-gray-700 uppercase">Total Nilai Barang (Jika Diisi)</td>
                    <td class="px-6 py-3 text-right text-base font-semibold text-gray-900">{{ formatCurrency(totalValue) }}</td>
                    <td></td>
                  </tr>
                </tfoot>
              </table>
            </div>
          </div>

          <div class="flex justify-end">
            <button type="button" @click="submitReceipt" :disabled="saving" class="bg-green-600 hover:bg-green-700 text-white font-medium py-2 px-6 rounded-lg transition duration-150 disabled:opacity-50 disabled:cursor-not-allowed">
              {{ saving ? 'Menyimpan...' : 'Simpan Penerimaan Barang' }}
            </button>
          </div>
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

const formData = ref({
  source: '',
  receive_date: new Date().toISOString().split('T')[0],
  notes: '',
  items: [] as any[]
})

const newItem = ref({
  barang_id: '',
  qty: 1,
  price: 0,
  name: ''
})

const barangList = ref<any[]>([])
const saving = ref(false)
const showAlert = ref(false)
const alertMessage = ref('')
const alertType = ref<'success' | 'danger'>('success')

const totalValue = computed(() => {
  return formData.value.items.reduce((total, item) => total + (item.qty * item.price), 0)
})

const formatCurrency = (value: number) => {
  return new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    minimumFractionDigits: 0
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
  if (!newItem.value.barang_id || newItem.value.qty <= 0) {
    showAlertMessage('Silakan pilih barang dan isi jumlah (minimal 1).', 'danger')
    return
  }

  const selectedBarang = barangList.value.find(b => b.id === parseInt(newItem.value.barang_id as any))
  if (!selectedBarang) {
    showAlertMessage('Barang tidak valid.', 'danger')
    return
  }

  const existingItem = formData.value.items.find(item => item.barang_id === newItem.value.barang_id)
  if (existingItem) {
    existingItem.qty += newItem.value.qty
    if (newItem.value.price > 0) existingItem.price = newItem.value.price
  } else {
    formData.value.items.push({
      barang_id: newItem.value.barang_id,
      name: `${selectedBarang.kode} - ${selectedBarang.nama}`,
      qty: newItem.value.qty,
      price: newItem.value.price || 0
    })
  }

  resetNewItem()
}

const removeItem = (index: number) => {
  formData.value.items.splice(index, 1)
}

const resetNewItem = () => {
  newItem.value = {
    barang_id: '',
    qty: 1,
    price: 0,
    name: ''
  }
}

const submitReceipt = async () => {
  if (!formData.value.source || !formData.value.notes) {
    showAlertMessage('Sumber Barang dan Catatan wajib diisi.', 'danger')
    return
  }

  if (formData.value.items.length === 0) {
    showAlertMessage('Anda harus menambahkan minimal 1 barang.', 'danger')
    return
  }

  saving.value = true
  try {
    const token = localStorage.getItem('token')
    const response = await axios.post('http://localhost:8000/api/staff/non-po/receipt', formData.value, {
      headers: {
        'Authorization': `Bearer ${token}`,
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      }
    })

    if (response.data.success) {
      showAlertMessage('Penerimaan Non-PO berhasil disimpan!', 'success')
      
      setTimeout(() => {
        router.push(`/staff/non-po/receipt/${response.data.data.id}/print`)
      }, 1500)
    } else {
      showAlertMessage(response.data.message || 'Gagal menyimpan data', 'danger')
    }
  } catch (error: any) {
    console.error('Error saving receipt:', error)
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
