<template>
  <div>
    <!-- Header Halaman -->
    <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6">
          <h1 class="text-3xl font-bold text-gray-900">Riwayat Barang Keluar</h1>
        </div>

        <!-- Filter dan Pencarian -->
        <div class="mb-6 bg-white p-4 rounded-lg shadow-sm">
          <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
            <input
              type="text"
              v-model="filters.search"
              placeholder="Cari No. Dokumen / No. Ref..."
              class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
            />
            <select
              v-model="filters.type"
              class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
            >
              <option value="">Semua Tipe</option>
              <option value="so">Dari SO</option>
              <option value="non-so">Non-SO</option>
            </select>
            <input
              type="date"
              v-model="filters.start_date"
              class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500 text-gray-500"
            />
            <input
              type="date"
              v-model="filters.end_date"
              class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500 text-gray-500"
            />
          </div>
        </div>

        <!-- Loading State -->
        <div v-if="loading" class="bg-white rounded-lg shadow-sm p-12 text-center">
          <div class="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
          <p class="mt-4 text-gray-600">Memuat data...</p>
        </div>

        <!-- Empty State -->
        <div v-else-if="!loading && outgoingItems.length === 0" class="bg-white rounded-lg shadow-sm p-12 text-center">
          <svg
            class="mx-auto h-12 w-12 text-gray-400"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
            />
          </svg>
          <h3 class="mt-2 text-sm font-medium text-gray-900">Tidak ada data</h3>
          <p class="mt-1 text-sm text-gray-500">
            Tidak ada riwayat barang keluar yang sesuai dengan filter.
          </p>
        </div>

        <!-- Tabel Riwayat -->
        <div v-else class="bg-white rounded-lg shadow-sm overflow-hidden">
          <div class="overflow-x-auto">
            <table class="w-full min-w-max">
              <thead class="bg-gray-50 border-b border-gray-200">
                <tr>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    No. Dokumen
                  </th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Tanggal
                  </th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Tipe
                  </th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    No. Referensi
                  </th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Penerima
                  </th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Oleh
                  </th>
                  <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Aksi
                  </th>
                </tr>
              </thead>
              <tbody class="divide-y divide-gray-200">
                <tr v-for="item in outgoingItems" :key="item.id">
                  <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-blue-600 hover:text-blue-800">
                    <router-link 
                      v-if="item.tipe === 'so'"
                      :to="`/staff/outgoing-items/${item.original_id}`"
                    >
                      {{ item.no_dokumen }}
                    </router-link>
                    <router-link 
                      v-else
                      :to="`/staff/non-po/issue/${item.original_id}/print`"
                    >
                      {{ item.no_dokumen }}
                    </router-link>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {{ formatDate(item.tanggal) }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <span
                      class="px-3 py-1 inline-flex text-xs font-medium rounded-full"
                      :class="
                        item.tipe === 'so'
                          ? 'bg-blue-100 text-blue-800'
                          : 'bg-purple-100 text-purple-800'
                      "
                    >
                      {{ item.tipe === 'so' ? 'Dari SO' : 'Non-SO' }}
                    </span>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {{ item.tipe === 'non-so' ? item.no_dokumen.replace('OUT-NON-', 'SO-NON-') : (item.no_referensi || '-') }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                    {{ item.penerima }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {{ item.dicatat_oleh }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                    <div class="flex items-center justify-end space-x-2">
                      <!-- Tombol Detail -->
                      <router-link
                        v-if="item.tipe === 'so'"
                        :to="`/staff/sales-order/detail/${item.original_id}`"
                        class="inline-flex items-center px-3 py-1.5 bg-blue-50 text-blue-600 hover:bg-blue-100 rounded-lg transition"
                      >
                        <svg class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                        </svg>
                        Detail
                      </router-link>
                      <router-link
                        v-else
                        :to="`/staff/non-po/issue/${item.original_id}/detail`"
                        class="inline-flex items-center px-3 py-1.5 bg-blue-50 text-blue-600 hover:bg-blue-100 rounded-lg transition"
                      >
                        <svg class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                        </svg>
                        Detail
                      </router-link>
                      
                      <!-- Tombol Cetak -->
                      <router-link
                        v-if="item.tipe === 'so'"
                        :to="`/staff/sales-orders/${item.original_id}/print-issue`"
                        class="inline-flex items-center px-3 py-1.5 bg-green-600 text-white hover:bg-green-700 rounded-lg transition"
                      >
                        <svg class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z" />
                        </svg>
                        Cetak
                      </router-link>
                      <router-link
                        v-else
                        :to="`/staff/non-po/issue/${item.original_id}/print`"
                        class="inline-flex items-center px-3 py-1.5 bg-green-600 text-white hover:bg-green-700 rounded-lg transition"
                      >
                        <svg class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z" />
                        </svg>
                        Cetak
                      </router-link>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Pagination -->
        <div v-if="!loading && outgoingItems.length > 0" class="mt-6 flex items-center justify-between">
          <button
            @click="prevPage"
            :disabled="meta.current_page === 1"
            class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 font-medium py-2 px-4 rounded-lg text-sm transition duration-150 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            Sebelumnya
          </button>
          <span class="text-sm text-gray-600">
            Halaman <span class="font-medium">{{ meta.current_page }}</span> dari
            <span class="font-medium">{{ meta.last_page }}</span>
          </span>
          <button
            @click="nextPage"
            :disabled="meta.current_page === meta.last_page"
            class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 font-medium py-2 px-4 rounded-lg text-sm transition duration-150 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            Berikutnya
          </button>
        </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import outgoingItemsService, { type OutgoingItem } from '@/services/outgoingItems.service'

const router = useRouter()

const outgoingItems = ref<OutgoingItem[]>([])
const loading = ref(false)
const filters = ref({
  search: '',
  type: '',
  start_date: '',
  end_date: ''
})

const meta = ref({
  current_page: 1,
  last_page: 1,
  per_page: 10,
  total: 0
})

const formatDate = (dateString: string) => {
  const date = new Date(dateString)
  return date.toLocaleDateString('id-ID', {
    day: 'numeric',
    month: 'short',
    year: 'numeric'
  })
}

const fetchOutgoingItems = async () => {
  loading.value = true
  try {
    const response = await outgoingItemsService.getAll({
      search: filters.value.search || undefined,
      type: filters.value.type || undefined,
      start_date: filters.value.start_date || undefined,
      end_date: filters.value.end_date || undefined,
      page: meta.value.current_page
    }, 'staff')
    outgoingItems.value = response.data
    meta.value = response.meta
  } catch (error) {
    console.error('Error fetching outgoing items:', error)
    alert('Gagal memuat data riwayat barang keluar')
  } finally {
    loading.value = false
  }
}

const prevPage = () => {
  if (meta.value.current_page > 1) {
    meta.value.current_page--
    fetchOutgoingItems()
  }
}

const nextPage = () => {
  if (meta.value.current_page < meta.value.last_page) {
    meta.value.current_page++
    fetchOutgoingItems()
  }
}

// Watch filters untuk auto-search
watch(filters, () => {
  meta.value.current_page = 1
  fetchOutgoingItems()
}, { deep: true })

onMounted(() => {
  fetchOutgoingItems()
})
</script>
