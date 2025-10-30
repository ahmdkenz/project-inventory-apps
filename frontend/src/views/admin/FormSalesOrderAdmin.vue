<template>
  <div class="flex h-screen">
    <!-- Sidebar -->
    <aside class="fixed top-0 left-0 h-full w-64 bg-gray-900 text-gray-300 shadow-lg z-30 transform -translate-x-full lg:translate-x-0 transition-transform duration-300 ease-in-out" id="sidebar">
      <!-- Logo/Header Sidebar -->
      <div class="p-6 flex items-center space-x-3">
        <svg class="h-10 w-10 text-blue-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" d="M21 7.5l-9-5.25L3 7.5m18 0l-9 5.25m9-5.25v9l-9 5.25M3 7.5l9 5.25M3 7.5v9l9 5.25m0-9v9" />
        </svg>
        <span class="text-white text-2xl font-semibold">Inventori</span>
      </div>
      
      <!-- Menu Navigasi Admin -->
      <AdminNavigation :current-path="$route.path" />
      
      <!-- User Info di Bawah Sidebar -->
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

    <!-- Latar belakang overlay untuk mobile -->
    <div class="fixed inset-0 bg-black bg-opacity-50 z-20 hidden" id="overlay"></div>
    
    <!-- Konten Utama -->
    <div class="flex-1 flex flex-col transition-all duration-300 ease-in-out lg:ml-64" id="main-content">
      <!-- Header/Navbar Atas -->
      <header class="bg-white shadow-sm p-4 flex items-center justify-between z-10">
        <!-- Tombol Hamburger (Mobile) -->
        <button id="hamburger-btn" class="text-gray-600 lg:hidden" @click="toggleSidebar">
          <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5" />
          </svg>
        </button>
        
        <!-- Search Bar -->
        <div class="relative hidden sm:block">
          <input type="text" class="border border-gray-300 rounded-full py-2 px-4 pl-10" placeholder="Cari...">
          <svg class="h-5 w-5 text-gray-400 absolute left-3 top-2.5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M21 21l-5.197-5.197m0 0A7.5 7.5 0 105.196 5.196a7.5 7.5 0 0010.607 10.607z" />
          </svg>
        </div>
        
        <!-- User Profile dan Notifikasi -->
        <div class="flex items-center space-x-4">
          <!-- Notifikasi -->
          <button class="text-gray-500 hover:text-gray-700 relative">
            <span class="absolute top-0 right-0 h-2 w-2 bg-red-500 rounded-full"></span>
            <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M14.857 17.082a23.848 23.848 0 005.454-1.31A8.967 8.967 0 0118 9.75v-.7V9A6 6 0 006 9v.75a8.967 8.967 0 01-2.312 6.022c1.733.64 3.56 1.085 5.455 1.31m5.714 0a24.255 24.255 0 01-5.714 0m5.714 0a3 3 0 11-5.714 0" />
            </svg>
          </button>
          
          <!-- Profile Dropdown -->
          <div class="relative" ref="profileRef">
            <button @click="toggleProfileMenu" class="flex items-center space-x-2">
              <img class="h-9 w-9 rounded-full" src="https://placehold.co/100x100/EBF8FF/3182CE?text=A" alt="Avatar Pengguna">
              <span class="hidden md:block text-sm font-medium text-gray-700">{{ user?.name || 'Admin' }}</span>
            </button>
            <div v-show="showProfileMenu" class="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg py-1 z-20">
              <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Profil Saya</a>
              <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Pengaturan</a>
              <hr class="my-1">
              <a href="#" @click.prevent="handleLogout" class="block px-4 py-2 text-sm text-red-600 hover:bg-gray-100">Logout</a>
            </div>
          </div>
        </div>
      </header>

      <!-- Konten Halaman -->
      <main class="flex-1 p-6 overflow-y-auto">
        <div class="flex items-center justify-between mb-6">
          <h1 class="text-3xl font-bold text-gray-900">Buat Sales Order Baru</h1>
          <router-link
            to="/admin/sales-orders"
            class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150"
          >
            <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5L8.25 12l7.5-7.5" />
            </svg>
            <span>Kembali ke Daftar</span>
          </router-link>
        </div>
        
        <div class="max-w-7xl mx-auto space-y-6">
          <!-- Informasi SO -->
          <div class="bg-white p-6 rounded-lg shadow-sm">
            <h2 class="text-xl font-semibold text-gray-900 mb-4">Informasi Dokumen</h2>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
              <div>
                <label for="receiver" class="block text-sm font-medium text-gray-700 mb-1">Penerima / Tujuan</label>
                <input
                  v-model="form.customer_name"
                  type="text"
                  id="receiver"
                  required
                  placeholder="Cth: Divisi IT"
                  class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                />
              </div>
              <div>
                <label for="so_date" class="block text-sm font-medium text-gray-700 mb-1">Tanggal SO</label>
                <input
                  v-model="form.tgl_order"
                  type="date"
                  id="so_date"
                  required
                  class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                />
              </div>
              <div>
                <label for="so_number" class="block text-sm font-medium text-gray-700 mb-1">Nomor SO (Otomatis)</label>
                <input
                  type="text"
                  id="so_number"
                  value="SO-2024-XXXX"
                  readonly
                  class="w-full rounded-md border-gray-300 shadow-sm p-2 bg-gray-100 cursor-not-allowed"
                />
              </div>
              <div class="md:col-span-3">
                <label for="notes" class="block text-sm font-medium text-gray-700 mb-1">Catatan (Opsional)</label>
                <textarea
                  v-model="form.catatan"
                  id="notes"
                  rows="2"
                  class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
                  placeholder="Keperluan..."
                ></textarea>
              </div>
            </div>
          </div>

          <!-- Detail Barang -->
          <div class="bg-white p-6 rounded-lg shadow-sm">
            <h2 class="text-xl font-semibold text-gray-900 mb-4">Detail Barang</h2>
            <!-- Form Tambah Item -->
            <form @submit.prevent="addItem" class="grid grid-cols-1 md:grid-cols-12 gap-4 mb-4 items-end">
              <div class="md:col-span-8">
                <label for="item_select" class="block text-sm font-medium text-gray-700 mb-1">Pilih Barang</label>
                <select v-model="newItem.barang_id" id="item_select" class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500">
                  <option value="">Pilih barang...</option>
                  <option
                    v-for="barang in barangList"
                    :key="barang.id"
                    :value="barang.id"
                  >
                    {{ barang.kode }} - {{ barang.nama }} (Stok: {{ barang.stok }})
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
              <div class="md:col-span-2">
                <button
                  type="submit"
                  class="w-full bg-blue-500 hover:bg-blue-600 text-white font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150"
                >
                  <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
                  </svg>
                  <span>Tambah</span>
                </button>
              </div>
            </form>
            
            <!-- Tabel Item Ditambahkan -->
            <div class="overflow-x-auto border rounded-lg">
              <table class="w-full min-w-max">
                <thead class="bg-gray-50">
                  <tr>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nama Barang</th>
                    <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">Stok Tersedia</th>
                    <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">Jumlah Diminta</th>
                    <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">Aksi</th>
                  </tr>
                </thead>
                <tbody class="divide-y divide-gray-200">
                  <tr v-if="form.items.length === 0">
                    <td colspan="4" class="px-6 py-4 text-center text-sm text-gray-500">
                      Belum ada barang ditambahkan
                    </td>
                  </tr>
                  <tr v-for="(item, index) in form.items" :key="index">
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ item.name }}</td>
                    <td
                      class="px-6 py-4 whitespace-nowrap text-sm text-center"
                      :class="item.stok < item.qty ? 'text-red-600 font-medium' : 'text-gray-500'"
                    >
                      {{ item.stok }}
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 font-medium text-center">{{ item.qty }}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-center">
                      <button @click="removeItem(index)" type="button" class="text-red-600 hover:text-red-800">
                        <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                          <path stroke-linecap="round" stroke-linejoin="round" d="M14.74 9l-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 01-2.244 2.077H8.084a2.25 2.25 0 01-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 00-3.478-.397m-12.578 0c-.275.046-.55.097-.824.15l-1.172 0m11.356 0c-.049-.02-.097-.04-.145-.059M4.772 5.79L4.772 5.79m0 0L3.105 5.79A2.25 2.25 0 00.864 7.93l1.524 11.022a2.25 2.25 0 002.244 2.077h8.734a2.25 2.25 0 002.244-2.077L19.895 7.93a2.25 2.25 0 00-2.244-2.14h-3.352m-6.352 0c.049-.02.097-.04.145-.059m6.352 0a48.108 48.108 0 01-3.478-.397m12.578 0c.275.046.55.097.824.15l1.172 0m-11.356 0c.049-.02.097-.04.145-.059" />
                        </svg>
                      </button>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

          <!-- Tombol Aksi Bawah -->
          <div class="flex justify-end">
            <button
              @click="submitSO"
              type="button"
              :disabled="loading"
              class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-6 rounded-lg transition duration-150 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {{ loading ? 'Menyimpan...' : 'Simpan dan Ajukan' }}
            </button>
          </div>
        </div>
      </main>
    </div>

    <!-- Message Box -->
    <div
      v-if="message.show"
      :class="['fixed top-5 right-5 p-4 rounded-md shadow-lg text-white transition-all duration-300 z-50', message.isError ? 'bg-red-500' : 'bg-green-500']"
    >
      {{ message.text }}
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onBeforeUnmount } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import AdminNavigation from '@/components/AdminNavigation.vue'
import salesOrderService from '@/services/salesOrder.service'
import barangService from '@/services/barang.service'

// Router & auth
const router = useRouter()
const authStore = useAuthStore()

// Header/Profile state
const showProfileMenu = ref(false)
const user = ref<any>(null)
const profileRef = ref<HTMLElement | null>(null)

const toggleProfileMenu = () => {
  showProfileMenu.value = !showProfileMenu.value
}

const closeProfileMenu = () => {
  showProfileMenu.value = false
}

const toggleSidebar = () => {
  const sidebar = document.getElementById('sidebar')
  const overlay = document.getElementById('overlay')
  if (sidebar && overlay) {
    sidebar.classList.toggle('-translate-x-full')
    overlay.classList.toggle('hidden')
  }
}

// Handle click outside profile menu
const handleClickOutside = (event: MouseEvent) => {
  const target = event.target as Node
  if (showProfileMenu.value && profileRef.value && !profileRef.value.contains(target)) {
    closeProfileMenu()
  }
}

const handleLogout = async () => {
  try {
    await authStore.logout()
    await router.push('/login')
  } catch (error) {
    console.error('Error during logout:', error)
    localStorage.removeItem('token')
    localStorage.removeItem('user')
    await router.push('/login')
  }
}

// State
const loading = ref(false)
const barangList = ref<any[]>([])

const form = ref({
  customer_name: '',
  tgl_order: new Date().toISOString().split('T')[0],
  tgl_kirim: new Date().toISOString().split('T')[0],
  catatan: '',
  items: [] as Array<{
    barang_id: number
    name: string
    qty: number
    stok: number
    harga_satuan: number
  }>
})

const newItem = ref({
  barang_id: '',
  qty: 1
})

const message = ref({
  show: false,
  text: '',
  isError: false
})

// Methods
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
  if (!newItem.value.barang_id || newItem.value.qty <= 0) {
    showMessage('Silakan pilih barang dan isi jumlah (minimal 1)', true)
    return
  }
  
  const selectedBarang = barangList.value.find(b => b.id === parseInt(newItem.value.barang_id as any))
  if (!selectedBarang) {
    showMessage('Barang tidak valid', true)
    return
  }
  
  if (selectedBarang.stok === 0) {
    showMessage('Stok barang ini 0, tidak bisa diminta', true)
    return
  }
  
  // Cek jika barang sudah ada, update qty
  const existingItem = form.value.items.find(item => item.barang_id === selectedBarang.id)
  if (existingItem) {
    existingItem.qty += newItem.value.qty
  } else {
    form.value.items.push({
      barang_id: selectedBarang.id,
      name: selectedBarang.nama,
      qty: newItem.value.qty,
      stok: selectedBarang.stok,
      harga_satuan: selectedBarang.harga_jual || 0
    })
  }
  
  resetNewItem()
}

const removeItem = (index: number) => {
  form.value.items.splice(index, 1)
}

const resetNewItem = () => {
  newItem.value = { barang_id: '', qty: 1 }
}

const submitSO = async () => {
  if (form.value.items.length === 0) {
    showMessage('Anda harus menambahkan minimal 1 barang', true)
    return
  }
  
  // Cek jika ada permintaan melebihi stok
  const overStock = form.value.items.find(item => item.qty > item.stok)
  if (overStock) {
    showMessage(`Permintaan ${overStock.name} (${overStock.qty}) melebihi stok (${overStock.stok})`, true)
    return
  }
  
  if (!form.value.customer_name.trim()) {
    showMessage('Penerima/Tujuan harus diisi', true)
    return
  }
  
  loading.value = true
  try {
    const payload = {
      customer_name: form.value.customer_name,
      tgl_order: form.value.tgl_order,
      tgl_kirim: form.value.tgl_kirim,
      catatan: form.value.catatan,
      items: form.value.items.map(item => ({
        barang_id: item.barang_id,
        qty: item.qty,
        harga_satuan: item.harga_satuan
      })),
      status: 'pending' as const
    }
    
    const response = await (salesOrderService.create as any)(payload)
    if (response.success) {
      showMessage('Sales Order berhasil dibuat dan diajukan untuk persetujuan!', false)
      setTimeout(() => {
        router.push('/admin/sales-orders')
      }, 1500)
    }
  } catch (error: any) {
    console.error('Error creating sales order:', error)
    showMessage(error.response?.data?.message || 'Gagal membuat sales order', true)
  } finally {
    loading.value = false
  }
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
  
  // Add click outside listener
  document.addEventListener('click', handleClickOutside)
  
  fetchBarang()
})

onBeforeUnmount(() => {
  // Remove click outside listener
  document.removeEventListener('click', handleClickOutside)
})
</script>
