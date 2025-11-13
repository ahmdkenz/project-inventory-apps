<template>
  <div class="flex h-screen">
    <!-- Sidebar Admin -->
    <aside class="fixed top-0 left-0 h-full w-64 bg-gray-900 text-gray-300 shadow-lg z-30 transform -translate-x-full lg:translate-x-0 transition-transform duration-300 ease-in-out print-hidden" id="sidebar">
      <div class="p-6 flex items-center space-x-3">
        <svg class="h-10 w-10 text-blue-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" d="M21 7.5l-9-5.25L3 7.5m18 0l-9 5.25m9-5.25v9l-9 5.25M3 7.5l9 5.25M3 7.5v9l9 5.25m0-9v9" />
        </svg>
        <span class="text-white text-2xl font-semibold">Inventori</span>
      </div>
      
      <AdminNavigation :current-path="$route.path" />
    </aside>

    <div class="fixed inset-0 bg-black bg-opacity-50 z-20 hidden print-hidden" id="overlay"></div>
    
    <div class="flex-1 flex flex-col transition-all duration-300 ease-in-out lg:ml-64" id="main-content">
      <!-- Header -->
      <Header @toggle-sidebar="toggleSidebar" />

      <!-- Main Content -->
      <main class="flex-1 p-6 overflow-y-auto">
        <div v-if="loading" class="flex justify-center items-center py-12">
          <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
        </div>

        <div v-else-if="salesOrder">
          <!-- Tombol Aksi Atas -->
          <div class="flex items-center justify-between mb-6 print-hidden">
            <h1 class="text-3xl font-bold text-gray-900">Detail Sales Order</h1>
            <div class="flex space-x-3">
              <button @click="goBack" class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150">
                <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5L8.25 12l7.5-7.5" />
                </svg>
                <span>Kembali</span>
              </button>
              <button @click="printDocument" class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg flex items-center justify-center space-x-2 transition duration-150">
                <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M6.72 13.829c-.24.03-.48.062-.72.096m.72-.096a42.415 42.415 0 0110.56 0m-10.56 0L6.34 18m10.94-4.171c.24.03.48.062.72.096m-.72-.096L17.66 18m0 0l.229 2.523a1.125 1.125 0 01-1.12 1.227H7.23a1.125 1.125 0 01-1.12-1.227L6.34 18m11.319 0H6.34m11.319 0l.044.506A1.125 1.125 0 0117.003 20H6.997a1.125 1.125 0 01-1.122-1.494l.044-.506M6.34 18v-4.172c0-.224.03-.447.086-.665A41.4 41.4 0 0112 3c1.83 0 3.597.133 5.28.362.057.218.086.44.086.665v4.172M6.34 18L4.26 7.5h15.48L17.66 18" />
                </svg>
                <span>Cetak SO</span>
              </button>
            </div>
          </div>
          
          <!-- Layout 2 Kolom -->
          <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">

            <!-- Kolom Kiri: Dokumen SO (Area Cetak) -->
            <div class="lg:col-span-8" id="printable-area-container">
              <div class="bg-white p-8 rounded-lg shadow-lg border border-gray-200" id="printable-area-content">
                <!-- Header Dokumen -->
                <div class="flex justify-between items-start pb-6 border-b-2 border-gray-900">
                  <div>
                    <h2 class="text-3xl font-bold text-gray-900">SALES ORDER</h2>
                    <p class="text-lg font-semibold text-blue-600">{{ salesOrder.no_so }}</p>
                  </div>
                  <div class="text-right">
                    <img src="https://placehold.co/150x50/000000/FFFFFF?text=LOGO+PERUSAHAAN" alt="Logo Perusahaan" class="h-12 mb-2 ml-auto">
                    <p class="text-sm font-semibold text-gray-800">Nama Perusahaan Anda</p>
                    <p class="text-sm text-gray-600">Jl. Jend. Sudirman No. 1, Jakarta</p>
                    <p class="text-sm text-gray-600">Telepon: (021) 123456</p>
                  </div>
                </div>

                <!-- Info Penerima dan Tanggal -->
                <div class="grid grid-cols-2 gap-8 my-6">
                  <div>
                    <p class="text-sm font-semibold text-gray-500 uppercase mb-2">PENERIMA / TUJUAN:</p>
                    <p class="text-lg font-bold text-gray-900">{{ salesOrder.customer_name }}</p>
                    <p v-if="salesOrder.customer_address" class="text-sm text-gray-600">{{ salesOrder.customer_address }}</p>
                    <p v-if="salesOrder.customer_phone" class="text-sm text-gray-600">Telp: {{ salesOrder.customer_phone }}</p>
                  </div>
                  <div class="text-right">
                    <div class="mb-2">
                      <span class="text-sm font-semibold text-gray-500 uppercase">Tanggal SO: </span>
                      <span class="text-sm font-medium text-gray-800">{{ formatDate(salesOrder.tgl_order) }}</span>
                    </div>
                    <div>
                      <span class="text-sm font-semibold text-gray-500 uppercase">Status: </span>
                      <span :class="['text-sm font-medium', getStatusColor(salesOrder.status)]">
                        {{ getStatusLabel(salesOrder.status) }}
                      </span>
                    </div>
                  </div>
                </div>

              <!-- Items Table -->
              <div class="overflow-x-auto mb-8">
                <table class="w-full min-w-max">
                  <thead class="border-b border-gray-300">
                    <tr>
                      <th class="px-4 py-3 text-left text-sm font-medium text-gray-600 uppercase">Nama Barang</th>
                      <th class="px-4 py-3 text-center text-sm font-medium text-gray-600 uppercase">Dipesan</th>
                      <th class="px-4 py-3 text-center text-sm font-medium text-gray-600 uppercase">Diterima</th>
                      <th class="px-4 py-3 text-right text-sm font-medium text-gray-600 uppercase">Harga Satuan</th>
                      <th class="px-4 py-3 text-right text-sm font-medium text-gray-600 uppercase">Subtotal</th>
                    </tr>
                  </thead>
                  <tbody class="divide-y divide-gray-200">
                    <tr v-for="item in salesOrder.items" :key="item.id">
                      <td class="px-4 py-4 text-sm font-medium text-gray-900">{{ item.barang?.nama || '-' }}</td>
                      <td class="px-4 py-4 text-sm text-gray-800 text-center">{{ item.qty }}</td>
                      <td class="px-4 py-4 text-sm font-bold text-gray-900 text-center">{{ item.qty }}</td>
                      <td class="px-4 py-4 text-sm text-gray-800 text-right">{{ formatCurrency(item.harga_satuan) }}</td>
                      <td class="px-4 py-4 text-sm font-medium text-gray-900 text-right">{{ formatCurrency(item.subtotal) }}</td>
                    </tr>
                  </tbody>
                  <tfoot class="border-t-2 border-gray-300">
                    <tr>
                      <td colspan="4" class="px-4 py-3 text-right text-sm font-medium text-gray-600 uppercase">Subtotal</td>
                      <td class="px-4 py-3 text-right text-sm font-semibold text-gray-900">{{ formatCurrency(salesOrder.subtotal) }}</td>
                    </tr>
                    <tr>
                      <td colspan="4" class="px-4 py-3 text-right text-sm font-medium text-gray-600 uppercase">PPN ({{ ppnPercent }}%)</td>
                      <td class="px-4 py-3 text-right text-sm font-semibold text-gray-900">{{ formatCurrency(salesOrder.ppn) }}</td>
                    </tr>
                    <tr class="bg-gray-50">
                      <td colspan="4" class="px-4 py-3 text-right text-base font-bold text-gray-900 uppercase">Grand Total</td>
                      <td class="px-4 py-3 text-right text-base font-bold text-gray-900">{{ formatCurrency(salesOrder.total) }}</td>
                    </tr>
                  </tfoot>
                </table>
              </div>

                <!-- Tanda Tangan -->
                <div class="grid grid-cols-3 gap-8 pt-6 border-t border-gray-200 print-no-break">
                  <div class="text-center">
                    <p class="text-sm text-gray-700 mb-16">Diajukan oleh,</p>
                    <p class="text-sm font-medium text-gray-900 border-t border-gray-400 pt-1">({{ salesOrder.creator?.name || 'Staff' }})</p>
                    <p class="text-xs text-gray-500">Staff / Admin</p>
                  </div>
                  <div class="text-center">
                    <p class="text-sm text-gray-700 mb-16">Disetujui oleh,</p>
                    <p class="text-sm font-medium text-gray-900 border-t border-gray-400 pt-1">({{ salesOrder.approver?.name || 'Admin' }})</p>
                    <p class="text-xs text-gray-500">Manajer / Owner</p>
                  </div>
                  <div class="text-center">
                    <p class="text-sm text-gray-700 mb-16">Customer,</p>
                    <p class="text-sm font-medium text-gray-400 border-t border-dashed border-gray-300 pt-1"></p>
                    <p class="text-xs text-gray-700">{{ salesOrder.customer_name }}</p>
                  </div>
                </div>
              </div>

              <!-- Bukti Barang Keluar (jika status completed) -->
              <div v-if="salesOrder.status === 'completed' && salesOrder.outgoing_item" class="bg-white p-8 rounded-lg shadow-lg border border-gray-200 mt-6" id="bukti-barang-keluar">
                <!-- Header Dokumen -->
                <div class="flex justify-between items-start pb-6 border-b-2 border-gray-900">
                  <div>
                    <h2 class="text-3xl font-bold text-gray-900">BUKTI BARANG KELUAR</h2>
                    <p class="text-lg font-semibold text-blue-600">{{ salesOrder.outgoing_item.no_dokumen }}</p>
                  </div>
                  <div class="text-right">
                    <img src="https://placehold.co/150x50/000000/FFFFFF?text=LOGO+PERUSAHAAN" alt="Logo Perusahaan" class="h-12 mb-2 ml-auto">
                    <p class="text-sm font-semibold text-gray-800">Nama Perusahaan Anda</p>
                    <p class="text-sm text-gray-600">Jl. Jend. Sudirman No. 1, Jakarta</p>
                    <p class="text-sm text-gray-600">Telepon: (021) 123456</p>
                  </div>
                </div>

                <!-- Info Transaksi -->
                <div class="grid grid-cols-2 gap-8 my-6">
                  <div>
                    <p class="text-sm font-semibold text-gray-500 uppercase mb-2">DITERIMA OLEH:</p>
                    <p class="text-lg font-bold text-gray-900">{{ salesOrder.customer_name }}</p>
                    <p v-if="salesOrder.customer_address" class="text-sm text-gray-600">{{ salesOrder.customer_address }}</p>
                    <p v-if="salesOrder.customer_phone" class="text-sm text-gray-600">Telp: {{ salesOrder.customer_phone }}</p>
                  </div>
                  <div>
                    <p class="text-sm font-semibold text-gray-500 uppercase mb-2">DETAIL:</p>
                    <p class="text-sm text-gray-700"><span class="font-medium">Tanggal Transaksi:</span> {{ formatDate(salesOrder.outgoing_item.tanggal) }}</p>
                    <p class="text-sm text-gray-700"><span class="font-medium">Referensi SO:</span> {{ salesOrder.no_so }}</p>
                    <p class="text-sm text-gray-700"><span class="font-medium">Dicatat Oleh:</span> {{ salesOrder.outgoing_item.dicatat_oleh || '-' }}</p>
                    <p v-if="salesOrder.outgoing_item.catatan" class="text-sm text-gray-700"><span class="font-medium">Keterangan:</span> {{ salesOrder.outgoing_item.catatan }}</p>
                  </div>
                </div>

              <!-- Items Table -->
              <div class="overflow-x-auto mb-8">
                <table class="w-full min-w-max">
                  <thead class="border-b border-gray-300">
                    <tr>
                      <th class="px-4 py-3 text-left text-sm font-medium text-gray-600 uppercase">Nama Barang</th>
                      <th class="px-4 py-3 text-center text-sm font-medium text-gray-600 uppercase">Dipesan</th>
                      <th class="px-4 py-3 text-center text-sm font-medium text-gray-600 uppercase">Diterima</th>
                      <th class="px-4 py-3 text-right text-sm font-medium text-gray-600 uppercase">Harga Satuan</th>
                      <th class="px-4 py-3 text-right text-sm font-medium text-gray-600 uppercase">Subtotal</th>
                    </tr>
                  </thead>
                  <tbody class="divide-y divide-gray-200">
                    <tr v-for="item in salesOrder.outgoing_item.items" :key="item.id">
                      <td class="px-4 py-4 text-sm font-medium text-gray-900">{{ item.barang?.nama || '-' }}</td>
                      <td class="px-4 py-4 text-sm text-gray-800 text-center">{{ item.qty_issued }}</td>
                      <td class="px-4 py-4 text-sm font-bold text-gray-900 text-center">{{ item.qty_issued }}</td>
                      <td class="px-4 py-4 text-sm text-gray-800 text-right">{{ formatCurrency(item.harga_satuan) }}</td>
                      <td class="px-4 py-4 text-sm font-medium text-gray-900 text-right">{{ formatCurrency(item.subtotal) }}</td>
                    </tr>
                  </tbody>
                  <tfoot class="border-t-2 border-gray-300">
                    <tr>
                      <td colspan="4" class="px-4 py-3 text-right text-sm font-medium text-gray-600 uppercase">Subtotal</td>
                      <td class="px-4 py-3 text-right text-sm font-semibold text-gray-900">{{ formatCurrency(salesOrder.subtotal) }}</td>
                    </tr>
                    <tr>
                      <td colspan="4" class="px-4 py-3 text-right text-sm font-medium text-gray-600 uppercase">PPN ({{ ppnPercent }}%)</td>
                      <td class="px-4 py-3 text-right text-sm font-semibold text-gray-900">{{ formatCurrency(salesOrder.ppn) }}</td>
                    </tr>
                    <tr class="bg-gray-50">
                      <td colspan="4" class="px-4 py-3 text-right text-base font-bold text-gray-900 uppercase">Grand Total</td>
                      <td class="px-4 py-3 text-right text-base font-bold text-gray-900">{{ formatCurrency(salesOrder.total) }}</td>
                    </tr>
                  </tfoot>
                </table>
              </div>

                <!-- Tanda Tangan -->
                <div class="grid grid-cols-3 gap-8 pt-6 border-t border-gray-200 print-no-break">
                  <div class="text-center">
                    <p class="text-sm text-gray-700 mb-16">Diserahkan Oleh,</p>
                    <p class="text-sm font-medium text-gray-900 border-t border-gray-400 pt-1">({{ salesOrder.outgoing_item.dicatat_oleh || 'Staff Gudang' }})</p>
                    <p class="text-xs text-gray-500">Staff Inventori</p>
                  </div>
                  <div class="text-center">
                    <p class="text-sm text-gray-700 mb-16">Diterima Oleh,</p>
                    <p class="text-sm font-medium text-gray-400 border-t border-dashed border-gray-300 pt-1"></p>
                    <p class="text-xs text-gray-700">{{ salesOrder.customer_name }}</p>
                  </div>
                  <div class="text-center">
                    <p class="text-sm text-gray-700 mb-16">Diketahui Oleh,</p>
                    <p class="text-sm font-medium text-gray-900 border-t border-gray-400 pt-1">({{ salesOrder.approver?.name || 'Admin' }})</p>
                    <p class="text-xs text-gray-500">Manajer</p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Kolom Kanan: Info & Riwayat (Non-Cetak) -->
            <div class="lg:col-span-4 space-y-6 print-hidden">
              
              <!-- Status SO -->
              <div class="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
                <h3 class="text-lg font-semibold text-gray-900 mb-4">Status SO</h3>
                <span :class="[getStatusBadgeClass(salesOrder.status), 'px-4 py-1.5 inline-flex text-base font-medium rounded-full']">
                  {{ getStatusLabel(salesOrder.status) }}
                </span>
                <p class="text-sm text-gray-500 mt-2">
                  Diajukan oleh {{ salesOrder.creator?.name || '-' }} pada {{ formatDate(salesOrder.created_at) }}.
                </p>
                
                <!-- Tombol Aksi Admin -->
                <div v-if="salesOrder.status === 'pending'" class="mt-6 flex space-x-3">
                  <button @click="openApproveModal" class="w-full flex-1 bg-green-600 hover:bg-green-700 text-white font-medium py-2 px-4 rounded-lg transition duration-150">
                    Setujui
                  </button>
                  <button @click="openRejectModal" class="w-full flex-1 bg-red-600 hover:bg-red-700 text-white font-medium py-2 px-4 rounded-lg transition duration-150">
                    Tolak
                  </button>
                </div>
              </div>

              <!-- Riwayat Status -->
              <div class="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
                <h3 class="text-lg font-semibold text-gray-900 mb-4">Riwayat Status</h3>
                <ol class="relative border-l border-gray-200">
                  <li class="ml-4">
                    <div class="absolute w-3 h-3 bg-blue-600 rounded-full mt-1.5 -left-1.5 border border-white"></div>
                    <time class="mb-1 text-sm font-normal leading-none text-gray-500">{{ formatDate(salesOrder.created_at) }}</time>
                    <h3 class="text-base font-semibold text-gray-900">Dibuat & Diajukan</h3>
                    <p class="text-sm font-normal text-gray-500">
                      SO dibuat oleh {{ salesOrder.creator?.name || '-' }} dan menunggu persetujuan Admin.
                    </p>
                  </li>
                  <li v-if="salesOrder.approved_at" class="ml-4 mt-4">
                    <div class="absolute w-3 h-3 bg-green-600 rounded-full mt-1.5 -left-1.5 border border-white"></div>
                    <time class="mb-1 text-sm font-normal leading-none text-gray-500">{{ formatDate(salesOrder.approved_at) }}</time>
                    <h3 class="text-base font-semibold text-gray-900">Disetujui</h3>
                    <p class="text-sm font-normal text-gray-500">
                      SO disetujui oleh {{ salesOrder.approver?.name || 'Admin' }}.
                    </p>
                  </li>
                  <li v-if="salesOrder.status === 'completed' && salesOrder.completed_at" class="ml-4 mt-4">
                    <div class="absolute w-3 h-3 bg-purple-600 rounded-full mt-1.5 -left-1.5 border border-white"></div>
                    <time class="mb-1 text-sm font-normal leading-none text-gray-500">{{ formatDate(salesOrder.completed_at) }}</time>
                    <h3 class="text-base font-semibold text-gray-900">Diproses & Diselesaikan</h3>
                    <p class="text-sm font-normal text-gray-500">
                      Barang telah dikeluarkan dan SO selesai. Bukti barang keluar: {{ salesOrder.outgoing_item?.no_dokumen || '-' }}.
                    </p>
                  </li>
                  <li v-if="salesOrder.status === 'rejected' && salesOrder.rejected_at" class="ml-4 mt-4">
                    <div class="absolute w-3 h-3 bg-red-600 rounded-full mt-1.5 -left-1.5 border border-white"></div>
                    <time class="mb-1 text-sm font-normal leading-none text-gray-500">{{ formatDate(salesOrder.rejected_at) }}</time>
                    <h3 class="text-base font-semibold text-gray-900">Ditolak</h3>
                    <p class="text-sm font-normal text-gray-500">
                      SO ditolak oleh Admin. Alasan: {{ salesOrder.reject_reason || '-' }}
                    </p>
                  </li>
                </ol>
              </div>

              <!-- Informasi Penerima -->
              <div class="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
                <h3 class="text-lg font-semibold text-gray-900 mb-4">Info Penerima</h3>
                <dl>
                  <dt class="text-sm font-medium text-gray-500">Nama/Divisi</dt>
                  <dd class="text-base text-gray-900 font-medium mb-2">{{ salesOrder.customer_name }}</dd>
                  <dt v-if="salesOrder.customer_phone" class="text-sm font-medium text-gray-500">Kontak</dt>
                  <dd v-if="salesOrder.customer_phone" class="text-base text-gray-900 font-medium mb-2">{{ salesOrder.customer_phone }}</dd>
                  <dt v-if="salesOrder.customer_address" class="text-sm font-medium text-gray-500">Lokasi</dt>
                  <dd v-if="salesOrder.customer_address" class="text-base text-gray-900 font-medium">{{ salesOrder.customer_address }}</dd>
                </dl>
              </div>
              
            </div>
          </div>
        </div>

        <div v-else class="text-center py-8">
          <p class="text-gray-600">Data tidak ditemukan</p>
        </div>

        <Footer />
      </main>
    </div>

    <!-- Modal Approve -->
    <div
      v-if="showApproveModal"
      class="fixed inset-0 bg-gray-600 bg-opacity-75 flex items-center justify-center p-4 z-50 transition-opacity duration-300"
      @click.self="closeApproveModal"
    >
      <div class="bg-white rounded-lg shadow-xl w-full max-w-md transform transition-all">
        <div class="p-6 border-b border-gray-200">
          <h3 class="text-lg font-medium leading-6 text-gray-900">Setujui Sales Order</h3>
        </div>
        <div class="p-6">
          <p class="text-sm text-gray-600">
            Apakah Anda yakin ingin menyetujui Sales Order <strong>{{ salesOrder?.no_so }}</strong>?
          </p>
          <p class="text-sm text-gray-600 mt-2">
            Stok barang akan dikurangi setelah disetujui.
          </p>
        </div>
        <div class="px-6 py-4 bg-gray-50 rounded-b-lg flex justify-end space-x-3">
          <button
            @click="closeApproveModal"
            type="button"
            class="bg-white hover:bg-gray-100 text-gray-700 font-medium py-2 px-4 rounded-lg border border-gray-300 transition duration-150"
          >
            Batal
          </button>
          <button
            @click="confirmApprove"
            type="button"
            class="bg-green-600 hover:bg-green-700 text-white font-medium py-2 px-4 rounded-lg transition duration-150"
          >
            Ya, Setujui
          </button>
        </div>
      </div>
    </div>

    <!-- Modal Reject -->
    <div
      v-if="showRejectModal"
      class="fixed inset-0 bg-gray-600 bg-opacity-75 flex items-center justify-center p-4 z-50 transition-opacity duration-300"
      @click.self="closeRejectModal"
    >
      <div class="bg-white rounded-lg shadow-xl w-full max-w-md transform transition-all">
        <div class="p-6 border-b border-gray-200">
          <h3 class="text-lg font-medium leading-6 text-gray-900">Tolak Sales Order</h3>
        </div>
        <div class="p-6">
          <p class="text-sm text-gray-600 mb-4">
            Anda akan menolak Sales Order <strong>{{ salesOrder?.no_so }}</strong>.
            Silakan berikan alasan penolakan:
          </p>
          <textarea
            v-model="rejectReason"
            rows="4"
            class="w-full rounded-md border-gray-300 shadow-sm p-2 focus:border-blue-500 focus:ring-blue-500"
            placeholder="Alasan penolakan..."
          ></textarea>
          <span v-if="rejectReasonError" class="text-red-500 text-xs mt-1 block">{{ rejectReasonError }}</span>
        </div>
        <div class="px-6 py-4 bg-gray-50 rounded-b-lg flex justify-end space-x-3">
          <button
            @click="closeRejectModal"
            type="button"
            class="bg-white hover:bg-gray-100 text-gray-700 font-medium py-2 px-4 rounded-lg border border-gray-300 transition duration-150"
          >
            Batal
          </button>
          <button
            @click="confirmReject"
            type="button"
            class="bg-red-600 hover:bg-red-700 text-white font-medium py-2 px-4 rounded-lg transition duration-150"
          >
            Ya, Tolak
          </button>
        </div>
      </div>
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
import { ref, computed, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import AdminNavigation from '@/components/AdminNavigation.vue'
import Header from '@/components/Header.vue'
import Footer from '@/components/Footer.vue'
import salesOrderService from '@/services/salesOrder.service'

const router = useRouter()
const route = useRoute()

const loading = ref(false)
const salesOrder = ref<any>(null)
const showApproveModal = ref(false)
const showRejectModal = ref(false)
const rejectReason = ref('')
const rejectReasonError = ref('')

const message = ref({
  show: false,
  text: '',
  isError: false
})

const toggleSidebar = () => {
  const sidebar = document.getElementById('sidebar')
  const overlay = document.getElementById('overlay')
  if (sidebar && overlay) {
    sidebar.classList.toggle('-translate-x-full')
    overlay.classList.toggle('hidden')
  }
}

const goBack = () => {
  router.push('/admin/sales-orders')
}

const printDocument = () => {
  window.print()
}

const formatDate = (date: string) => {
  if (!date) return '-'
  return new Date(date).toLocaleDateString('id-ID', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  })
}

const formatCurrency = (value: number) => {
  return new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    minimumFractionDigits: 0
  }).format(value || 0)
}

const ppnPercent = computed(() => {
  if (!salesOrder.value || !salesOrder.value.subtotal || salesOrder.value.subtotal === 0) return 0
  return Math.round((salesOrder.value.ppn / salesOrder.value.subtotal) * 100)
})

const getStatusLabel = (status: string) => {
  const labels: Record<string, string> = {
    pending: 'Approved (Pending)',
    approved: 'Approved (Pending)',
    rejected: 'Reject',
    completed: 'Done'
  }
  return labels[status] || status
}

const getStatusBadgeClass = (status: string) => {
  const classes: Record<string, string> = {
    pending: 'bg-purple-100 text-purple-800',
    approved: 'bg-yellow-100 text-yellow-800',
    rejected: 'bg-red-100 text-red-800',
    completed: 'bg-green-100 text-green-800'
  }
  return classes[status] || 'bg-gray-100 text-gray-800'
}

const getStatusColor = (status: string) => {
  const colors: Record<string, string> = {
    pending: 'text-purple-700',
    approved: 'text-yellow-700',
    rejected: 'text-red-700',
    completed: 'text-green-700'
  }
  return colors[status] || 'text-gray-700'
}

const openApproveModal = () => {
  showApproveModal.value = true
}

const closeApproveModal = () => {
  showApproveModal.value = false
}

const confirmApprove = async () => {
  if (!salesOrder.value?.id) return
  
  loading.value = true
  try {
    const response = await salesOrderService.approve(salesOrder.value.id)
    if (response.success) {
      showMessage('Sales order berhasil disetujui', false)
      closeApproveModal()
      await fetchSalesOrder()
    }
  } catch (error: any) {
    console.error('Error approving order:', error)
    showMessage(error.response?.data?.message || 'Gagal menyetujui sales order', true)
  } finally {
    loading.value = false
  }
}

const openRejectModal = () => {
  rejectReason.value = ''
  rejectReasonError.value = ''
  showRejectModal.value = true
}

const closeRejectModal = () => {
  showRejectModal.value = false
  rejectReason.value = ''
  rejectReasonError.value = ''
}

const confirmReject = async () => {
  if (!salesOrder.value?.id) return
  
  if (!rejectReason.value.trim()) {
    rejectReasonError.value = 'Alasan penolakan harus diisi'
    return
  }
  
  loading.value = true
  try {
    const response = await salesOrderService.reject(salesOrder.value.id, rejectReason.value)
    if (response.success) {
      showMessage('Sales order berhasil ditolak', false)
      closeRejectModal()
      await fetchSalesOrder()
    }
  } catch (error: any) {
    console.error('Error rejecting order:', error)
    showMessage(error.response?.data?.message || 'Gagal menolak sales order', true)
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

const fetchSalesOrder = async () => {
  loading.value = true
  try {
    const id = route.params.id as string
    const type = route.query.type as string | undefined
    const response = await salesOrderService.adminGetById(parseInt(id), type)
    if (response.success && !Array.isArray(response.data)) {
      salesOrder.value = response.data
    }
  } catch (error: any) {
    console.error('Error fetching sales order:', error)
    showMessage('Gagal memuat data sales order', true)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchSalesOrder()
})
</script>

<style scoped>
@media print {
  /* Sembunyikan elemen yang tidak perlu dicetak */
  .print-hidden {
    display: none !important;
  }
  
  /* Pastikan area cetak ditampilkan */
  #printable-area {
    display: block !important;
    margin: 0;
    padding: 0;
    width: 100%;
    font-size: 12pt;
    color: #000;
  }
  
  /* Pastikan tidak ada bayangan atau border saat cetak */
  #printable-area-content {
    box-shadow: none !important;
    border: none !important;
  }
  
  /* Hindari tabel terpotong */
  tr, td, th {
    page-break-inside: avoid;
  }
  
  thead {
    display: table-header-group;
  }
  
  tfoot {
    display: table-footer-group;
  }
}
</style>
