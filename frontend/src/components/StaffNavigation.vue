<!-- Menu navigasi staff -->
<script setup lang="ts">
interface MenuItem {
  path: string
  name: string
  icon: string
}

const staffMenuItems: MenuItem[] = [
  {
    path: '/staff/dashboard',
    name: 'Dashboard',
    icon: 'M3.75 3v11.25A2.25 2.25 0 006 16.5h12M3.75 3h16.5M3.75 3v16.5M19.5 3v11.25A2.25 2.25 0 0117.25 16.5H6M6 16.5h12M18 20.25h-12A2.25 2.25 0 013.75 18v-2.25m16.5 4.5v-2.25a2.25 2.25 0 00-2.25-2.25H6a2.25 2.25 0 00-2.25 2.25v2.25m16.5 0h-16.5'
  },
  {
    path: '/staff/barang',
    name: 'Data Barang',
    icon: 'M20.25 7.5l-.625 10.632a2.25 2.25 0 01-2.247 2.118H6.622a2.25 2.25 0 01-2.247-2.118L3.75 7.5M10.5 11.25h3M12 15h.008'
  },
  {
    path: '/staff/purchase-order',
    name: 'Purchase Order (PO)',
    icon: 'M9 12.75l3 3m0 0l3-3m-3 3v-7.5M21 12a9 9 0 11-18 0 9 9 0 0118 0z'
  },
  {
    path: '/staff/sales-order',
    name: 'Sales Order (SO)',
    icon: 'M9 8.25H7.5a2.25 2.25 0 00-2.25 2.25v9a2.25 2.25 0 002.25 2.25h9a2.25 2.25 0 002.25-2.25v-9a2.25 2.25 0 00-2.25-2.25H15m0-3l-3-3m0 0l-3 3m3-3V15'
  },
  {
    path: '/staff/received-items',
    name: 'Riwayat Barang Masuk',
    icon: 'M9 3.75H6.912a2.25 2.25 0 00-2.15 1.588L2.35 13.177a2.25 2.25 0 00-.1.661V18a2.25 2.25 0 002.25 2.25h15A2.25 2.25 0 0021.75 18v-4.162c0-.224-.034-.447-.1-.661L19.24 5.338a2.25 2.25 0 00-2.15-1.588H15M2.25 13.5h3.86a2.25 2.25 0 012.012 1.244l.256.512a2.25 2.25 0 002.013 1.244h3.218a2.25 2.25 0 002.013-1.244l.256-.512a2.25 2.25 0 012.013-1.244h3.859m-19.5.338V18a2.25 2.25 0 002.25 2.25h15A2.25 2.25 0 0021.75 18v-4.162c0-.224-.034-.447-.1-.661L19.24 5.338a2.25 2.25 0 00-2.15-1.588H15M12 9v3.75m0 0l-3-3m3 3l3-3'
  },
  {
    path: '/staff/outgoing-items',
    name: 'Riwayat Barang Keluar',
    icon: 'M9 3.75H6.912a2.25 2.25 0 00-2.15 1.588L2.35 13.177a2.25 2.25 0 00-.1.661V18a2.25 2.25 0 002.25 2.25h15A2.25 2.25 0 0021.75 18v-4.162c0-.224-.034-.447-.1-.661L19.24 5.338a2.25 2.25 0 00-2.15-1.588H15M2.25 13.5h3.86a2.25 2.25 0 012.012 1.244l.256.512a2.25 2.25 0 002.013 1.244h3.218a2.25 2.25 0 002.013-1.244l.256-.512a2.25 2.25 0 012.013-1.244h3.859M12 3v8.25m0 0l-3-3m3 3l3-3'
  },
  {
    path: '/staff/laporan',
    name: 'Laporan',
    icon: 'M19.5 14.25v-2.625a3.375 3.375 0 00-3.375-3.375h-1.5A1.125 1.125 0 0113.5 7.125v-1.5a3.375 3.375 0 00-3.375-3.375H8.25m0 12.75h7.5m-7.5 3H12M10.5 2.25H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 00-9-9z'
  },
  {
    path: '/staff/aktivitas',
    name: 'Riwayat Saya',
    icon: 'M12 6v6h4.5m4.5 0a9 9 0 11-18 0 9 9 0 0118 0z'
  }
]

defineProps<{
  currentPath: string
}>()
</script>

<template>
  <nav class="mt-6 flex-1 px-4 space-y-1">
    <router-link
      v-for="item in staffMenuItems"
      :key="item.path"
      :to="item.path"
      class="flex items-center space-x-3 px-4 py-3 rounded-lg transition duration-150"
      :class="{
        'bg-blue-600 text-white font-medium': currentPath === item.path,
        'text-gray-300 hover:bg-gray-800': currentPath !== item.path
      }"
    >
      <svg
        class="h-6 w-6"
        xmlns="http://www.w3.org/2000/svg"
        fill="none"
        viewBox="0 0 24 24"
        stroke-width="1.5"
        stroke="currentColor"
      >
        <path stroke-linecap="round" stroke-linejoin="round" :d="item.icon" />
      </svg>
      <span>{{ item.name }}</span>
    </router-link>
  </nav>
</template>