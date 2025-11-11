<template>
  <header class="bg-white shadow-sm p-4 flex items-center justify-between z-10 print-hidden">
    <!-- Tombol Hamburger (Mobile) -->
    <button class="text-gray-600 lg:hidden" @click="toggleSidebar">
      <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5" />
      </svg>
    </button>

    <!-- Title (Desktop) -->
    <div class="hidden lg:flex items-center space-x-3">
      <svg class="h-8 w-8 text-blue-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" d="M21 7.5l-9-5.25L3 7.5m18 0l-9 5.25m9-5.25v9l-9 5.25M3 7.5l9 5.25M3 7.5v9l9 5.25m0-9v9" />
      </svg>
      <div>
        <h1 class="text-lg font-bold text-gray-900">INVENTORY DUTA OTO RAYA</h1>
        <p class="text-xs text-gray-500">Inventory Management System</p>
      </div>
    </div>

    <!-- Mobile Title -->
    <div class="flex lg:hidden items-center space-x-2">
      <svg class="h-6 w-6 text-blue-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" d="M21 7.5l-9-5.25L3 7.5m18 0l-9 5.25m9-5.25v9l-9 5.25M3 7.5l9 5.25M3 7.5v9l9 5.25m0-9v9" />
      </svg>
      <span class="text-sm font-bold text-gray-900">DUTA OTO RAYA</span>
    </div>

    <!-- Right Side: Notification & Profile -->
    <div class="flex items-center space-x-4">
      <!-- Notification Bell -->
      <button class="text-gray-500 hover:text-gray-700 relative">
        <span class="absolute top-0 right-0 h-2 w-2 bg-red-500 rounded-full"></span>
        <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" d="M14.857 17.082a23.848 23.848 0 005.454-1.31A8.967 8.967 0 0118 9.75v-.7V9A6 6 0 006 9v.75a8.967 8.967 0 01-2.312 6.022c1.733.64 3.56 1.085 5.455 1.31m5.714 0a24.255 24.255 0 01-5.714 0m5.714 0a3 3 0 11-5.714 0" />
        </svg>
      </button>

      <!-- Profile Dropdown -->
      <div class="relative" ref="profileRef">
        <button @click="toggleProfileMenu" class="flex items-center space-x-2">
          <img class="h-9 w-9 rounded-full" src="https://placehold.co/100x100/EBF8FF/3182CE?text=U" alt="Avatar Pengguna">
          <span class="hidden md:block text-sm font-medium text-gray-700">{{ user?.name || 'User' }}</span>
          <svg class="h-4 w-4 text-gray-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M19 9l-7 7-7-7" />
          </svg>
        </button>
        
        <div v-show="showProfileMenu" class="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg py-1 z-20 border border-gray-200">
          <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Profil Saya</a>
          <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Pengaturan</a>
          <hr class="my-1">
          <a href="#" @click.prevent="handleLogout" class="block px-4 py-2 text-sm text-red-600 hover:bg-gray-100">Logout</a>
        </div>
      </div>
    </div>
  </header>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const user = ref<{ name: string; role: string } | null>(null)
const showProfileMenu = ref(false)
const profileRef = ref<HTMLElement | null>(null)

// Emit event untuk toggle sidebar (parent akan handle)
const emit = defineEmits(['toggle-sidebar'])

const toggleSidebar = () => {
  emit('toggle-sidebar')
  // Fallback untuk halaman yang belum migrasi
  const sidebar = document.getElementById('sidebar')
  const overlay = document.getElementById('overlay')
  if (sidebar && overlay) {
    sidebar.classList.toggle('-translate-x-full')
    overlay.classList.toggle('hidden')
  }
}

const toggleProfileMenu = () => {
  showProfileMenu.value = !showProfileMenu.value
}

const handleLogout = () => {
  localStorage.removeItem('token')
  localStorage.removeItem('user')
  router.push('/login')
}

const handleClickOutside = (event: MouseEvent) => {
  if (profileRef.value && !profileRef.value.contains(event.target as Node)) {
    showProfileMenu.value = false
  }
}

const loadUserData = () => {
  const userData = localStorage.getItem('user')
  if (userData) {
    user.value = JSON.parse(userData)
  }
}

onMounted(() => {
  loadUserData()
  document.addEventListener('click', handleClickOutside)
})

onUnmounted(() => {
  document.removeEventListener('click', handleClickOutside)
})
</script>

<style scoped>
@media print {
  .print-hidden {
    display: none !important;
  }
}
</style>
