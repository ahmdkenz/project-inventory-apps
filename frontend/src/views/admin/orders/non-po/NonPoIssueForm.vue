<template>
  <div class="flex h-screen">
    <!-- Sidebar Admin -->
    <aside class="fixed top-0 left-0 h-full w-64 bg-gray-900 text-gray-300 shadow-lg z-30 transform -translate-x-full lg:translate-x-0 transition-transform duration-300 ease-in-out print-hidden" id="sidebar">
      <div class="p-6 flex items-center space-x-3 border-b border-gray-700">
        <svg class="h-10 w-10 text-blue-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M21 7.5l-9-5.25L3 7.5m18 0l-9 5.25m9-5.25v9l-9 5.25M3 7.5l9 5.25M3 7.5v9l9 5.25m0-9v9" /></svg>
        <span class="text-white text-2xl font-semibold">Inventori</span>
      </div>

      <AdminNavigation :current-path="$route.path" />
    </aside>

    <div class="fixed inset-0 bg-black bg-opacity-50 z-20 hidden print-hidden" id="overlay"></div>

    <div class="flex-1 flex flex-col transition-all duration-300 ease-in-out lg:ml-64" id="main-content">
      <Header @toggle-sidebar="toggleSidebar" />

      <div v-if="showAlert" class="fixed top-20 right-6 py-3 px-6 rounded-xl shadow-lg z-50 text-white" :class="alertType === 'success' ? 'bg-green-600' : 'bg-red-600'">
        {{ alertMessage }}
      </div>

      <main class="flex-1 p-4 md:p-8 overflow-y-auto">
        <div class="lg:grid lg:grid-cols-12 lg:gap-8">

          <!-- Left column: items -->
          <div class="lg:col-span-8 space-y-6">
            <div class="flex items-center justify-between mb-3 lg:hidden">
              <h1 class="text-2xl font-bold text-gray-900">Pengeluaran Non-PO</h1>
              <router-link to="/admin/sales-orders" class="bg-white hover:bg-slate-50 border border-slate-300 text-slate-700 font-medium py-2 px-3 rounded-lg text-sm">Kembali</router-link>
            </div>

            <div class="bg-white p-6 rounded-xl shadow-lg border border-slate-200">
              <h2 class="text-xl font-semibold text-gray-900 mb-4 flex items-center space-x-2">
                <svg class="h-6 w-6 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M20.25 7.5l-.625 10.632a2.25 2.25 0 01-2.247 2.118H6.622a2.25 2.25 0 01-2.247-2.118L3.75 7.5M10.5 11.25h3M12 15h.008" /></svg>
                <span>Detail Barang Keluar</span>
              </h2>

              <form @submit.prevent="addItem" class="grid grid-cols-1 md:grid-cols-12 gap-4 mb-6 items-end p-4 bg-slate-50 rounded-lg border border-slate-100">
                <div class="md:col-span-5">
                  <label for="item_select" class="block text-sm font-medium text-gray-700 mb-1">Pilih Barang</label>
                  <select v-model="newItem.barang_id" id="item_select" class="w-full rounded-lg border-gray-300 shadow-sm p-2.5 text-sm">
                    <option value="">Pilih barang...</option>
                    <option v-for="barang in barangList" :key="barang.id" :value="barang.id">{{ barang.kode }} - {{ barang.nama }}</option>
                  </select>
                </div>
                <div class="md:col-span-2">
                  <label for="item_qty" class="block text-sm font-medium text-gray-700 mb-1">Jumlah</label>
                  <input v-model.number="newItem.qty" type="number" id="item_qty" min="1" :max="selectedBarangStock" class="w-full rounded-lg border-gray-300 shadow-sm p-2.5 text-sm">
                </div>
                <div class="md:col-span-4">
                  <label for="item_notes" class="block text-sm font-medium text-gray-700 mb-1">Keterangan (Opsional)</label>
                  <input v-model="newItem.notes" type="text" id="item_notes" class="w-full rounded-lg border-gray-300 shadow-sm p-2.5 text-sm" placeholder="Alasan / keterangan...">
                </div>
                <div class="md:col-span-1">
                  <button type="submit" class="w-full bg-blue-600 hover:bg-blue-700 text-white font-medium py-2.5 px-3 rounded-lg flex items-center justify-center">
                    <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" /></svg>
                  </button>
                </div>
              </form>

              <div class="overflow-x-auto border rounded-lg">
                <table class="w-full min-w-max">
                  <thead class="bg-slate-50 border-b border-slate-200">
                    <tr>
                      <th class="px-6 py-3 text-left text-xs font-semibold text-slate-500 uppercase tracking-wider">Nama Barang</th>
                      <th class="px-6 py-3 text-center text-xs font-semibold text-slate-500 uppercase tracking-wider">Stok Tersedia</th>
                      <th class="px-6 py-3 text-center text-xs font-semibold text-slate-500 uppercase tracking-wider">Jumlah Keluar</th>
                      <th class="px-6 py-3 text-left text-xs font-semibold text-slate-500 uppercase tracking-wider">Keterangan</th>
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
                      <td class="px-6 py-4 whitespace-nowrap text-sm text-center text-gray-600">{{ item.stok }}</td>
                      <td class="px-6 py-4 whitespace-nowrap text-sm text-center text-gray-900 font-semibold">{{ item.qty }}</td>
                      <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ item.notes || '-' }}</td>
                      <td class="px-6 py-4 whitespace-nowrap text-center">
                        <button @click="removeItem(index)" type="button" class="text-red-500 hover:text-red-700">
                          <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M19.5 12h-15" /></svg>
                        </button>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>

          <!-- Right column: document info & actions -->
          <div class="lg:col-span-4 space-y-6">
            <div class="lg:sticky lg:top-8 space-y-6">
              <div class="bg-white p-6 rounded-xl shadow-lg border border-slate-200">
                <div class="flex items-center justify-between mb-5">
                  <h2 class="text-xl font-semibold text-gray-900 flex items-center space-x-2"><span>Informasi Dokumen</span></h2>
                </div>

                <div class="space-y-4">
                  <div>
                    <label for="type" class="block text-sm font-medium text-gray-700 mb-1">Jenis Transaksi</label>
                    <select id="type" class="w-full rounded-lg border-gray-300 shadow-sm p-3">
                      <option value="internal">Pemakaian Internal</option>
                      <option value="rusak">Barang Rusak / Dibuang</option>
                      <option value="penyesuaian">Penyesuaian Stok (Opname)</option>
                      <option value="lainnya">Lainnya</option>
                    </select>
                  </div>

                  <div>
                    <label for="recipient" class="block text-sm font-medium text-gray-700 mb-1">Tujuan / Penerima</label>
                    <input v-model="formData.recipient" id="recipient" type="text" class="w-full rounded-lg border-gray-300 shadow-sm p-3" placeholder="Cth: Divisi IT, Pembuangan..." />
                  </div>

                  <div>
                    <label for="issue_date" class="block text-sm font-medium text-gray-700 mb-1">Tanggal Pengeluaran</label>
                    <input v-model="formData.issue_date" id="issue_date" type="date" class="w-full rounded-lg border-gray-300 shadow-sm p-3" />
                  </div>

                  <div>
                    <label for="notes" class="block text-sm font-medium text-gray-700 mb-1">Catatan (Penting)</label>
                    <textarea v-model="formData.notes" id="notes" rows="3" class="w-full rounded-lg border-gray-300 shadow-sm p-3" placeholder="Jelaskan alasan pengeluaran ini secara rinci untuk keperluan audit..."></textarea>
                  </div>
                </div>
              </div>

              <div class="bg-white p-6 rounded-xl shadow-lg border border-slate-200">
                <h2 class="text-xl font-semibold text-gray-900 mb-4">Konfirmasi</h2>
                <p class="text-sm text-gray-500 mb-4">Pastikan data sudah benar. Stok barang akan langsung berkurang setelah disimpan.</p>
                <div class="flex flex-col gap-3">
                  <router-link to="/admin/sales-orders" class="w-full text-center bg-white hover:bg-slate-100 border border-slate-300 text-slate-700 font-medium py-3 px-4 rounded-lg">Batal</router-link>
                  <button type="button" @click="submitIssue" class="w-full text-center bg-blue-600 hover:bg-blue-700 text-white font-medium py-3 px-4 rounded-lg shadow-lg">Simpan Pengeluaran</button>
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
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import AdminNavigation from '@/components/AdminNavigation.vue'
import Header from '@/components/Header.vue'
import Footer from '@/components/Footer.vue'
import axios from 'axios'

const router = useRouter()

const formData = ref({
  recipient: '',
  issue_date: new Date().toISOString().split('T')[0],
  notes: '',
  items: [] as any[]
})

const newItem = ref({
  barang_id: '',
  qty: 1
})

const barangList = ref<any[]>([])
const saving = ref(false)
const showAlert = ref(false)
const alertMessage = ref('')
const alertType = ref<'success' | 'danger'>('success')

const selectedBarangStock = computed(() => {
  if (!newItem.value.barang_id) return 999999
  const barang = barangList.value.find(b => b.id === parseInt(newItem.value.barang_id as any))
  return barang ? barang.stok : 999999
})

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
    const response = await axios.get('http://localhost:8000/api/admin/barang', {
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

  if (selectedBarang.stok < newItem.value.qty) {
    showAlertMessage(`Stok ${selectedBarang.nama} tidak mencukupi. Stok tersedia: ${selectedBarang.stok}`, 'danger')
    return
  }

  const existingItem = formData.value.items.find(item => item.barang_id === newItem.value.barang_id)
  if (existingItem) {
    existingItem.qty += newItem.value.qty
  } else {
    formData.value.items.push({
      barang_id: newItem.value.barang_id,
      name: selectedBarang.nama,
      kode: selectedBarang.kode,
      stok: selectedBarang.stok,
      qty: newItem.value.qty
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
    qty: 1
  }
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

  saving.value = true
  try {
    const token = localStorage.getItem('token')
    const response = await axios.post('http://localhost:8000/api/admin/non-po/issue', formData.value, {
      headers: {
        'Authorization': `Bearer ${token}`,
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      }
    })

    if (response.data.success) {
      showAlertMessage('Pengeluaran Non-PO berhasil disimpan!', 'success')
      
      setTimeout(() => {
        router.push(`/admin/non-po/issue/${response.data.data.id}/print`)
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
