<template>
  <div class="bg-gray-100">
    <!-- Global Alert Message -->
    <div v-if="showAlert" 
      class="fixed top-20 right-6 py-3 px-6 rounded-xl shadow-lg z-50 text-white transition-all duration-300"
      :class="alertType === 'success' ? 'bg-green-600' : 'bg-red-600'">
      <span>{{ alertMessage }}</span>
    </div>

    <div class="lg:grid lg:grid-cols-12 lg:gap-8">
      <!-- KOLOM KIRI (AREA KERJA) -->
      <div class="lg:col-span-8 space-y-6">
        
        <!-- Header & Tombol Kembali (Mobile) -->
        <div class="flex items-center justify-between mb-4 lg:hidden">
          <h1 class="text-2xl font-bold text-gray-900">Penerimaan Non-PO</h1>
          <router-link to="/staff/non-po" class="bg-white hover:bg-slate-50 border border-slate-300 text-slate-700 font-medium py-2 px-3 rounded-lg text-sm">
            <span>Kembali</span>
          </router-link>
        </div>
        
        <!-- Card Detail Barang -->
        <div class="bg-white p-6 rounded-xl shadow-lg border border-slate-200">
          <h2 class="text-xl font-semibold text-gray-900 mb-6 flex items-center space-x-2">
            <svg class="h-6 w-6 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M20.25 7.5l-.625 10.632a2.25 2.25 0 01-2.247 2.118H6.622a2.25 2.25 0 01-2.247-2.118L3.75 7.5M10.5 11.25h3M12 15h.008" /></svg>
            <span>Detail Barang Masuk</span>
          </h2>
          
          <!-- Form Tambah Item -->
          <form @submit.prevent="addItem" class="grid grid-cols-1 md:grid-cols-12 gap-4 mb-6 items-end p-4 bg-slate-50 rounded-lg border border-slate-100">
            <div class="md:col-span-5">
              <label for="item_select" class="block text-sm font-medium text-gray-700 mb-1">Pilih Barang</label>
              <select v-model="newItem.barang_id" id="item_select" class="w-full rounded-lg border-gray-300 shadow-sm p-2.5 focus:border-blue-500 focus:ring-2 focus:ring-blue-500 transition-all duration-150 text-sm">
                <option value="">Pilih barang...</option>
                <option v-for="barang in barangList" :key="barang.id" :value="barang.id">
                  {{ barang.kode }} - {{ barang.nama }}
                </option>
              </select>
            </div>
            <div class="md:col-span-3">
              <label for="item_qty" class="block text-sm font-medium text-gray-700 mb-1">Jumlah</label>
              <input v-model.number="newItem.qty" type="number" id="item_qty" min="1" class="w-full rounded-lg border-gray-300 shadow-sm p-2.5 focus:border-blue-500 focus:ring-2 focus:ring-blue-500 text-sm">
            </div>
            <div class="md:col-span-3">
              <label for="item_price" class="block text-sm font-medium text-gray-700 mb-1">Estimasi Harga (Opsional)</label>
              <div class="relative">
                <span class="absolute inset-y-0 left-0 pl-3 flex items-center text-gray-500 text-sm">Rp</span>
                <input v-model.number="newItem.price" type="number" id="item_price" min="0" placeholder="0" class="w-full rounded-lg border-gray-300 shadow-sm p-2.5 pl-8 focus:border-blue-500 focus:ring-2 focus:ring-blue-500 text-sm">
              </div>
            </div>
            <div class="md:col-span-1">
              <button type="submit" class="w-full bg-blue-600 hover:bg-blue-700 text-white font-medium py-2.5 px-3 rounded-lg flex items-center justify-center transition-all duration-300 hover:shadow-md">
                <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" /></svg>
              </button>
            </div>
          </form>
          
          <!-- Tabel Item Ditambahkan -->
          <div class="overflow-x-auto border rounded-lg">
            <table class="w-full min-w-max">
              <thead class="bg-slate-50 border-b border-slate-200">
                <tr>
                  <th class="px-6 py-3 text-left text-xs font-semibold text-slate-500 uppercase tracking-wider">Nama Barang</th>
                  <th class="px-6 py-3 text-center text-xs font-semibold text-slate-500 uppercase tracking-wider">Jumlah</th>
                  <th class="px-6 py-3 text-right text-xs font-semibold text-slate-500 uppercase tracking-wider">Est. Harga</th>
                  <th class="px-6 py-3 text-right text-xs font-semibold text-slate-500 uppercase tracking-wider">Subtotal</th>
                  <th class="px-6 py-3 text-center text-xs font-semibold text-slate-500 uppercase tracking-wider">Aksi</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-slate-200">
                <tr v-if="formData.items.length === 0">
                  <td colspan="5" class="px-6 py-10 text-center text-sm text-gray-500">
                    <svg class="h-12 w-12 text-gray-300 mx-auto mb-2" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M3 16.5v2.25A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75V16.5m-13.5-9L12 3m0 0l4.5 4.5M12 3v13.5" /></svg>
                    <p class="font-medium">Belum ada barang ditambahkan</p>
                    <p class="text-xs text-gray-400">Silakan pilih barang dan klik tombol tambah.</p>
                  </td>
                </tr>
                <tr v-for="(item, index) in formData.items" :key="index" class="hover:bg-slate-50 transition-colors duration-150">
                  <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ item.name }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600 text-center">{{ item.qty }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600 text-right">{{ formatCurrency(item.price) }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 font-semibold text-right">{{ formatCurrency(item.qty * item.price) }}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-center">
                    <button @click="removeItem(index)" type="button" class="text-red-500 hover:text-red-700 transition-colors">
                      <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M19.5 12h-15" /></svg>
                    </button>
                  </td>
                </tr>
              </tbody>
              <!-- Footer Total (Optional for Non-PO) -->
              <tfoot v-if="formData.items.length > 0" class="bg-slate-50 border-t border-slate-200">
                <tr>
                  <td colspan="3" class="px-6 py-3 text-right text-sm font-semibold text-gray-700 uppercase">Total Estimasi Nilai</td>
                  <td class="px-6 py-3 text-right text-base font-bold text-gray-900">{{ formatCurrency(totalValue) }}</td>
                  <td></td>
                </tr>
              </tfoot>
            </table>
          </div>
        </div>
      </div>
      
      <!-- KOLOM KANAN (INFO & AKSI) -->
      <div class="lg:col-span-4 space-y-6">
        <div class="lg:sticky lg:top-8 space-y-6">
          
          <!-- Card Info Dokumen -->
          <div class="bg-white p-6 rounded-xl shadow-lg border border-slate-200">
            <div class="flex items-center justify-between mb-5">
              <h2 class="text-xl font-semibold text-gray-900 flex items-center space-x-2">
                <svg class="h-6 w-6 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M11.25 11.25l.041-.02a.75.75 0 011.063.852l-.708 2.836a.75.75 0 001.063.853l.041-.021M21 12a9 9 0 11-18 0 9 9 0 0118 0zm-9-3.75h.008v.008H12V8.25z" /></svg>
                <span>Informasi Dokumen</span>
              </h2>
              <router-link to="/staff/non-po" class="hidden lg:block bg-white hover:bg-slate-50 border border-slate-300 text-slate-700 font-medium py-2 px-3 rounded-lg text-sm transition-colors duration-150">
                <span>Kembali</span>
              </router-link>
            </div>
            
            <div class="space-y-4">
              <div>
                <label for="type" class="block text-sm font-medium text-gray-700 mb-1">Jenis Transaksi</label>
                <select id="type" class="w-full rounded-lg border-gray-300 shadow-sm p-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-500 transition-all duration-150">
                  <option value="penyesuaian">Penyesuaian Stok (Opname)</option>
                  <option value="retur">Retur Internal / Batal Kirim</option>
                  <option value="hibah">Hibah / Donasi Masuk</option>
                  <option value="lainnya">Lainnya</option>
                </select>
              </div>
              <div>
                <label for="source" class="block text-sm font-medium text-gray-700 mb-1">Sumber Barang</label>
                <input v-model="formData.source" type="text" id="source" required placeholder="Cth: Retur Divisi IT, Hibah..." class="w-full rounded-lg border-gray-300 shadow-sm p-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-500 transition-all duration-150">
              </div>
              <div>
                <label for="receive_date" class="block text-sm font-medium text-gray-700 mb-1">Tanggal Diterima</label>
                <input v-model="formData.receive_date" type="date" id="receive_date" required class="w-full rounded-lg border-gray-300 shadow-sm p-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-500 transition-all duration-150">
              </div>
              <div>
                <label for="notes" class="block text-sm font-medium text-gray-700 mb-1">Catatan (Penting)</label>
                <textarea v-model="formData.notes" id="notes" rows="3" required class="w-full rounded-lg border-gray-300 shadow-sm p-3 focus:border-blue-500 focus:ring-2 focus:ring-blue-500 transition-all duration-150" placeholder="Jelaskan alasan penerimaan ini secara rinci untuk keperluan audit..."></textarea>
              </div>
            </div>
          </div>
          
          <!-- Card Aksi (CTA) -->
          <div class="bg-white p-6 rounded-xl shadow-lg border border-slate-200">
            <h2 class="text-xl font-semibold text-gray-900 mb-4 flex items-center space-x-2">
              <svg class="h-6 w-6 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
              <span>Konfirmasi</span>
            </h2>
            <p class="text-sm text-gray-500 mb-4">Pastikan data sudah benar. Stok barang akan langsung bertambah setelah disimpan.</p>
            <div class="flex flex-col gap-3">
              <router-link to="/staff/non-po" class="w-full text-center bg-white hover:bg-slate-100 border border-slate-300 text-slate-700 font-medium py-3 px-4 rounded-lg transition-all duration-300 transform hover:scale-105">
                Batal
              </router-link>
              <button type="button" @click="submitReceipt" :disabled="saving" class="w-full text-center bg-blue-600 hover:bg-blue-700 text-white font-medium py-3 px-4 rounded-lg shadow-lg shadow-blue-500/30 hover:shadow-xl hover:shadow-blue-500/50 transition-all duration-300 transform hover:-translate-y-0.5">
                {{ saving ? 'Menyimpan...' : 'Simpan Penerimaan' }}
              </button>
            </div>
          </div>
          
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
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
