<!-- Buat file terpisah untuk menu navigasi admin -->
<script setup lang="ts">
import { ref } from 'vue'

interface SubMenuItem {
  path: string
  name: string
}

interface MenuGroup {
  name: string
  icon: string
  items: SubMenuItem[]
}

interface SingleMenuItem {
  path: string
  name: string
  icon: string
}

const props = defineProps<{
  currentPath: string
}>()

// State untuk dropdown
const openDropdown = ref<string | null>(null)

const toggleDropdown = (menuName: string) => {
  if (openDropdown.value === menuName) {
    openDropdown.value = null
  } else {
    openDropdown.value = menuName
  }
}

// Menu single (tidak punya submenu)
const singleMenuItems: SingleMenuItem[] = [
  {
    path: '/admin/dashboard',
    name: 'Dashboard',
    icon: 'M3.75 3v11.25A2.25 2.25 0 006 16.5h12M3.75 3h16.5M3.75 3v16.5M19.5 3v11.25A2.25 2.25 0 0117.25 16.5H6M6 16.5h12M18 20.25h-12A2.25 2.25 0 013.75 18v-2.25m16.5 4.5v-2.25a2.25 2.25 0 00-2.25-2.25H6a2.25 2.25 0 00-2.25 2.25v2.25m16.5 0h-16.5'
  }
]

// Menu group dengan dropdown
const menuGroups: MenuGroup[] = [
  {
    name: 'Master Data',
    icon: 'M20.25 6.375c0 2.278-3.694 4.125-8.25 4.125S3.75 8.653 3.75 6.375m16.5 0c0-2.278-3.694-4.125-8.25-4.125S3.75 4.097 3.75 6.375m16.5 0v11.25c0 2.278-3.694 4.125-8.25 4.125s-8.25-1.847-8.25-4.125V6.375m16.5 0v3.75m-16.5-3.75v3.75m16.5 0v3.75C20.25 16.153 16.556 18 12 18s-8.25-1.847-8.25-4.125v-3.75m16.5 0c0 2.278-3.694 4.125-8.25 4.125s-8.25-1.847-8.25-4.125',
    items: [
      { path: '/admin/barang', name: 'Data Barang' },
      { path: '/admin/kategori', name: 'Kategori' },
      { path: '/admin/supplier', name: 'Supplier' }
    ]
  },
  {
    name: 'Transaksi',
    icon: 'M2.25 18.75a60.07 60.07 0 0115.797 2.101c.727.198 1.453-.342 1.453-1.096V18.75M3.75 4.5v.75A.75.75 0 013 6h-.75m0 0v-.375c0-.621.504-1.125 1.125-1.125H20.25M2.25 6v9m18-10.5v.75c0 .414.336.75.75.75h.75m-1.5-1.5h.375c.621 0 1.125.504 1.125 1.125v9.75c0 .621-.504 1.125-1.125 1.125h-.375m1.5-1.5H21a.75.75 0 00-.75.75v.75m0 0H3.75m0 0h-.375a1.125 1.125 0 01-1.125-1.125V15m1.5 1.5v-.75A.75.75 0 003 15h-.75M15 10.5a3 3 0 11-6 0 3 3 0 016 0zm3 0h.008v.008H18V10.5zm-12 0h.008v.008H6V10.5z',
    items: [
      { path: '/admin/purchase-orders', name: 'Purchase Order' },
      { path: '/admin/sales-orders', name: 'Sales Order' },
      { path: '/admin/received-items', name: 'Riwayat Barang Masuk' },
      { path: '/admin/outgoing-items', name: 'Riwayat Barang Keluar' }
    ]
  }
]

// Menu single lainnya
const otherMenuItems: SingleMenuItem[] = [
  {
    path: '/admin/laporan',
    name: 'Laporan',
    icon: 'M19.5 14.25v-2.625a3.375 3.375 0 00-3.375-3.375h-1.5A1.125 1.125 0 0113.5 7.125v-1.5a3.375 3.375 0 00-3.375-3.375H8.25m0 12.75h7.5m-7.5 3H12M10.5 2.25H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 00-9-9z'
  },
  {
    path: '/admin/users',
    name: 'Pengguna',
    icon: 'M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z'
  },
  {
    path: '/admin/audit-log',
    name: 'Riwayat Aktivitas',
    icon: 'M12 6v6h4.5m4.5 0a9 9 0 11-18 0 9 9 0 0118 0z'
  },
  {
    path: '/admin/pengaturan',
    name: 'Pengaturan',
    icon: 'M10.5 6h9.75M10.5 6a1.5 1.5 0 11-3 0m3 0a1.5 1.5 0 10-3 0M3.75 6H7.5m3 12h9.75m-9.75 0a1.5 1.5 0 01-3 0m3 0a1.5 1.5 0 00-3 0M3.75 18H7.5m3-6h9.75m-9.75 0a1.5 1.5 0 01-3 0m3 0a1.5 1.5 0 00-3 0M3.75 12H7.5'
  }
]

// Check if current path is in submenu
const isSubmenuActive = (items: SubMenuItem[]) => {
  return items.some(item => props.currentPath === item.path || props.currentPath.startsWith(item.path + '/'))
}

// Check if dropdown should be open by default
const shouldBeOpen = (group: MenuGroup) => {
  return isSubmenuActive(group.items)
}
</script>

<template>
  <nav class="mt-6 flex-1 px-4 space-y-1">
    <!-- Single Menu Items (Dashboard) -->
    <router-link
      v-for="item in singleMenuItems"
      :key="item.path"
      :to="item.path"
      class="flex items-center space-x-3 px-4 py-3 rounded-lg transition duration-150"
      :class="{
        'bg-blue-600 text-white font-medium': currentPath === item.path,
        'text-gray-300 hover:bg-gray-800': currentPath !== item.path
      }"
    >
      <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" :d="item.icon" />
      </svg>
      <span>{{ item.name }}</span>
    </router-link>

    <!-- Menu Groups dengan Dropdown -->
    <div v-for="group in menuGroups" :key="group.name" class="space-y-1">
      <!-- Parent Menu -->
      <button
        @click="toggleDropdown(group.name)"
        class="w-full flex items-center justify-between px-4 py-3 rounded-lg transition duration-150"
        :class="{
          'bg-blue-600 text-white font-medium': isSubmenuActive(group.items) || openDropdown === group.name,
          'text-gray-300 hover:bg-gray-800': !isSubmenuActive(group.items) && openDropdown !== group.name
        }"
      >
        <div class="flex items-center space-x-3">
          <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" :d="group.icon" />
          </svg>
          <span>{{ group.name }}</span>
        </div>
        <svg
          class="h-5 w-5 transition-transform duration-200"
          :class="{ 'rotate-180': openDropdown === group.name || shouldBeOpen(group) }"
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
          stroke-width="2"
          stroke="currentColor"
        >
          <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 8.25l-7.5 7.5-7.5-7.5" />
        </svg>
      </button>

      <!-- Submenu Items -->
      <div
        v-show="openDropdown === group.name || shouldBeOpen(group)"
        class="ml-6 space-y-1"
      >
        <router-link
          v-for="subItem in group.items"
          :key="subItem.path"
          :to="subItem.path"
          class="flex items-center space-x-3 px-4 py-2 rounded-lg transition duration-150 text-sm"
          :class="{
            'bg-blue-500 text-white font-medium': currentPath === subItem.path || currentPath.startsWith(subItem.path + '/'),
            'text-gray-400 hover:bg-gray-800 hover:text-gray-200': currentPath !== subItem.path && !currentPath.startsWith(subItem.path + '/')
          }"
        >
          <svg class="h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 4.5l7.5 7.5-7.5 7.5" />
          </svg>
          <span>{{ subItem.name }}</span>
        </router-link>
      </div>
    </div>

    <!-- Other Single Menu Items -->
    <router-link
      v-for="item in otherMenuItems"
      :key="item.path"
      :to="item.path"
      class="flex items-center space-x-3 px-4 py-3 rounded-lg transition duration-150"
      :class="{
        'bg-blue-600 text-white font-medium': currentPath === item.path,
        'text-gray-300 hover:bg-gray-800': currentPath !== item.path
      }"
    >
      <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" :d="item.icon" />
      </svg>
      <span>{{ item.name }}</span>
    </router-link>
  </nav>
</template>