import { createRouter, createWebHistory } from 'vue-router'
import Login from '@/views/auth/Login.vue'
import AdminDashboard from '@/views/admin/Dashboard.vue'
import StaffDashboard from '@/views/staff/Dashboard.vue'
import BarangListStaff from '@/views/staff/BarangList.vue'
import PurchaseOrderList from '@/views/staff/PurchaseOrderList.vue'
import FormPurchaseOrder from '@/views/staff/FormPurchaseOrder.vue'
import SalesOrderList from '@/views/staff/SalesOrderList.vue'
import FormSalesOrder from '@/views/staff/FormSalesOrder.vue'
import SalesOrderDetail from '@/views/staff/SalesOrderDetail.vue'
import BarangManager from '@/views/admin/BarangManager.vue'
import AddBarang from '@/views/admin/AddBarang.vue'
import ManagementCategory from '@/views/admin/ManagementCategory.vue'
import FormCategory from '@/views/admin/FormCategory.vue'
import PurchaseOrdersAdmin from '@/views/admin/PurchaseOrdersAdmin.vue'
import FormPurchaseOrderAdmin from '@/views/admin/FormPurchaseOrderAdmin.vue'
import PurchaseOrderDetailAdmin from '@/views/admin/PurchaseOrderDetailAdmin.vue'
import SalesOrdersAdmin from '@/views/admin/SalesOrdersAdmin.vue'
import FormSalesOrderAdmin from '@/views/admin/FormSalesOrderAdmin.vue'
import SalesOrderDetailAdmin from '@/views/admin/SalesOrderDetailAdmin.vue'
import UserManagement from '@/views/admin/UserManagement.vue'
import FormUserManagement from '@/views/admin/FormUserManagement.vue'
import SupplierManagement from '@/views/admin/SupplierManagement.vue'
import FormSupplier from '@/views/admin/FormSupplier.vue'
import AuditLog from '@/views/admin/AuditLog.vue'
import ReportDashboard from '@/views/admin/ReportDashboard.vue'
import ReportUsers from '@/views/admin/ReportUsers.vue'
import ReportStock from '@/views/admin/ReportStock.vue'
import ReportIncoming from '@/views/admin/ReportIncoming.vue'
import ReportOutgoing from '@/views/admin/ReportOutgoing.vue'
import StaffReportDashboard from '@/views/staff/StaffReportDashboard.vue'
import StaffReportStock from '@/views/staff/StaffReportStock.vue'
import StaffReportIncoming from '@/views/staff/StaffReportIncoming.vue'
import StaffReportOutgoing from '@/views/staff/StaffReportOutgoing.vue'
import StaffLayout from '@/components/StaffLayout.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      redirect: '/login'
    },
    {
      path: '/login',
      name: 'login',
      component: Login,
      meta: { requiresAuth: false }
    },
    {
      path: '/admin/dashboard',
      name: 'admin-dashboard',
      component: AdminDashboard,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/barang',
      name: 'admin-barang',
      component: BarangManager,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/barang/add',
      name: 'admin-barang-add',
      component: AddBarang,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/kategori',
      name: 'admin-kategori',
      component: ManagementCategory,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/kategori/add',
      name: 'admin-kategori-add',
      component: FormCategory,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/kategori/edit/:id',
      name: 'admin-kategori-edit',
      component: FormCategory,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/purchase-orders',
      name: 'admin-purchase-orders',
      component: PurchaseOrdersAdmin,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/purchase-orders/create',
      name: 'admin-purchase-order-create',
      component: FormPurchaseOrderAdmin,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/purchase-orders/detail/:id',
      name: 'admin-purchase-order-detail',
      component: PurchaseOrderDetailAdmin,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/purchase-orders/:id/receive',
      name: 'admin-purchase-order-receive',
      component: () => import('@/views/admin/ReceivePurchaseOrderAdmin.vue'),
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/purchase-orders/:id/print',
      name: 'admin-purchase-order-print',
      component: () => import('@/views/admin/PrintPurchaseOrder.vue'),
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/purchase-orders/:id/print-receipt',
      name: 'admin-purchase-order-print-receipt',
      component: () => import('@/views/admin/PrintReceivePurchaseOrder.vue'),
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/sales-orders',
      name: 'admin-sales-orders',
      component: SalesOrdersAdmin,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/sales-orders/create',
      name: 'admin-sales-order-create',
      component: FormSalesOrderAdmin,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/sales-orders/detail/:id',
      name: 'admin-sales-order-detail',
      component: SalesOrderDetailAdmin,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/sales-orders/:id/process',
      name: 'admin-sales-order-process',
      component: () => import('@/views/admin/ProcessSalesOrderAdmin.vue'),
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/sales-orders/:id/print-issue',
      name: 'admin-sales-order-print-issue',
      component: () => import('@/views/admin/PrintIssueSalesOrder.vue'),
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/users',
      name: 'admin-users',
      component: UserManagement,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/users/add',
      name: 'admin-users-add',
      component: FormUserManagement,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/users/edit/:id',
      name: 'admin-users-edit',
      component: FormUserManagement,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/supplier',
      name: 'admin-supplier',
      component: SupplierManagement,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/supplier/add',
      name: 'admin-supplier-add',
      component: FormSupplier,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/supplier/edit/:id',
      name: 'admin-supplier-edit',
      component: FormSupplier,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/customers',
      name: 'admin-customers',
      component: () => import('@/views/admin/CustomerManagement.vue'),
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/customers/create',
      name: 'admin-customers-create',
      component: () => import('@/views/admin/CustomerForm.vue'),
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/customers/:id/edit',
      name: 'admin-customers-edit',
      component: () => import('@/views/admin/CustomerForm.vue'),
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/audit-log',
      name: 'admin-audit-log',
      component: AuditLog,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/laporan',
      name: 'admin-laporan',
      component: ReportDashboard,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/laporan/pengguna',
      name: 'admin-laporan-pengguna',
      component: ReportUsers,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/laporan/stok',
      name: 'admin-laporan-stok',
      component: ReportStock,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/laporan/barang-masuk',
      name: 'admin-laporan-barang-masuk',
      component: ReportIncoming,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/laporan/barang-keluar',
      name: 'admin-laporan-barang-keluar',
      component: ReportOutgoing,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/received-items',
      name: 'admin-received-items',
      component: () => import('@/views/admin/ReceivedItemsHistory.vue'),
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/outgoing-items',
      name: 'admin-outgoing-items',
      component: () => import('@/views/admin/RiwayatBarangKeluar.vue'),
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/non-po/receipt/create',
      name: 'admin-non-po-receipt-create',
      component: () => import('@/views/admin/NonPoReceiptForm.vue'),
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/non-po/receipt/:id/detail',
      name: 'admin-non-po-receipt-detail',
      component: () => import('@/views/admin/NonPoReceiptDetailAdmin.vue'),
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/non-po/receipt/:id/receive',
      name: 'admin-non-po-receipt-receive',
      component: () => import('@/views/admin/ReceiveNonPoReceipt.vue'),
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/non-po/receipt/:id/print',
      name: 'admin-non-po-receipt-print',
      component: () => import('@/views/admin/PrintNonPoReceipt.vue'),
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/non-po/issue/create',
      name: 'admin-non-po-issue-create',
      component: () => import('@/views/admin/NonPoIssueForm.vue'),
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/non-po/issue/:id/detail',
      name: 'admin-non-po-issue-detail',
      component: () => import('@/views/admin/NonPoIssueDetailAdmin.vue'),
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/non-po/issue/:id/print',
      name: 'admin-non-po-issue-print',
      component: () => import('@/views/admin/PrintNonPoIssue.vue'),
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    // Staff Routes - Nested under StaffLayout
    {
      path: '/staff',
      component: StaffLayout,
      meta: { requiresAuth: true, requiresStaff: true },
      children: [
        {
          path: 'dashboard',
          name: 'staff-dashboard',
          component: StaffDashboard,
          meta: { requiresAuth: true, requiresStaff: true }
        },
        {
          path: 'barang',
          name: 'staff-barang',
          component: BarangListStaff,
          meta: { requiresAuth: true, requiresStaff: true }
        },
        {
          path: 'purchase-order',
          name: 'staff-purchase-order',
          component: PurchaseOrderList,
          meta: { requiresAuth: true, requiresStaff: true }
        },
        {
          path: 'purchase-order/create',
          name: 'staff-purchase-order-create',
          component: FormPurchaseOrder,
          meta: { requiresAuth: true, requiresStaff: true }
        },
        {
          path: 'purchase-order/edit/:id',
          name: 'staff-purchase-order-edit',
          component: FormPurchaseOrder,
          meta: { requiresAuth: true, requiresStaff: true }
        },
        {
          path: 'purchase-order/:id',
          name: 'staff-purchase-order-detail',
          component: () => import('../views/staff/PurchaseOrderDetail.vue'),
          meta: { requiresAuth: true, requiresStaff: true }
        },
        {
          path: 'purchase-orders/:id/print-receipt',
          name: 'staff-purchase-order-print-receipt',
          component: () => import('@/views/staff/PrintReceivePurchaseOrder.vue'),
          meta: { requiresAuth: true, requiresStaff: true }
        },
        {
          path: 'sales-order',
          name: 'staff-sales-order',
          component: SalesOrderList,
          meta: { requiresAuth: true, requiresStaff: true }
        },
        {
          path: 'sales-order/create',
          name: 'staff-sales-order-create',
          component: FormSalesOrder,
          meta: { requiresAuth: true, requiresStaff: true }
        },
        {
          path: 'sales-order/edit/:id',
          name: 'staff-sales-order-edit',
          component: FormSalesOrder,
          meta: { requiresAuth: true, requiresStaff: true }
        },
        {
          path: 'sales-order/detail/:id',
          name: 'staff-sales-order-detail',
          component: SalesOrderDetail,
          meta: { requiresAuth: true, requiresStaff: true }
        },
        {
          path: 'sales-orders/:id/print-issue',
          name: 'staff-sales-order-print-issue',
          component: () => import('@/views/staff/PrintIssueSalesOrder.vue'),
          meta: { requiresAuth: true, requiresStaff: true }
        },
        {
          path: 'purchase-orders',
          name: 'staff-purchase-orders',
          component: () => import('@/views/staff/PurchaseOrderList.vue'),
          meta: { requiresAuth: true, requiresStaff: true }
        },
        {
          path: 'aktivitas',
          name: 'staff-aktivitas',
          component: () => import('@/views/staff/MyActivities.vue'),
          meta: { requiresAuth: true, requiresStaff: true }
        },
        {
          path: 'received-items',
          name: 'staff-received-items',
          component: () => import('@/views/staff/ReceivedItemsHistoryStaff.vue'),
          meta: { requiresAuth: true, requiresStaff: true }
        },
        {
          path: 'outgoing-items',
          name: 'staff-outgoing-items',
          component: () => import('@/views/staff/OutgoingItemsHistoryStaff.vue'),
          meta: { requiresAuth: true, requiresStaff: true }
        },
        {
          path: 'non-po/receipt/create',
          name: 'staff-non-po-receipt-create',
          component: () => import('@/views/staff/NonPoReceiptFormStaff.vue'),
          meta: { requiresAuth: true, requiresStaff: true }
        },
        {
          path: 'non-po/receipt/:id/detail',
          name: 'staff-non-po-receipt-detail',
          component: () => import('@/views/staff/NonPoReceiptDetailStaff.vue'),
          meta: { requiresAuth: true, requiresStaff: true }
        },
        {
          path: 'non-po/receipt/:id/print',
          name: 'staff-non-po-receipt-print',
          component: () => import('@/views/staff/PrintNonPoReceiptStaff.vue'),
          meta: { requiresAuth: true, requiresStaff: true }
        },
        {
          path: 'non-po/issue/create',
          name: 'staff-non-po-issue-create',
          component: () => import('@/views/staff/NonPoIssueFormStaff.vue'),
          meta: { requiresAuth: true, requiresStaff: true }
        },
        {
          path: 'non-po/issue/:id/detail',
          name: 'staff-non-po-issue-detail',
          component: () => import('@/views/staff/NonPoIssueDetailStaff.vue'),
          meta: { requiresAuth: true, requiresStaff: true }
        },
        {
          path: 'non-po/issue/:id/print',
          name: 'staff-non-po-issue-print',
          component: () => import('@/views/staff/PrintNonPoIssueStaff.vue'),
          meta: { requiresAuth: true, requiresStaff: true }
        },
        {
          path: 'laporan',
          name: 'staff-laporan',
          component: StaffReportDashboard,
          meta: { requiresAuth: true, requiresStaff: true }
        },
        {
          path: 'laporan/stok',
          name: 'staff-laporan-stok',
          component: StaffReportStock,
          meta: { requiresAuth: true, requiresStaff: true }
        },
        {
          path: 'laporan/barang-masuk',
          name: 'staff-laporan-barang-masuk',
          component: StaffReportIncoming,
          meta: { requiresAuth: true, requiresStaff: true }
        },
        {
          path: 'laporan/barang-keluar',
          name: 'staff-laporan-barang-keluar',
          component: StaffReportOutgoing,
          meta: { requiresAuth: true, requiresStaff: true }
        },
      ]
    },
  ]
})

// Navigation Guard
router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('token')
  const user = JSON.parse(localStorage.getItem('user') || '{}')

  // If route requires auth and user is not logged in
  if (to.meta.requiresAuth && !token) {
    next('/login')
    return
  }

  // If route requires admin role and user is not admin
  if (to.meta.requiresAdmin && user.role !== 'admin') {
    next('/staff/dashboard')
    return
  }

  // If route requires staff role and user is not staff
  if (to.meta.requiresStaff && user.role !== 'staff') {
    next('/admin/dashboard')
    return
  }

  // If user is logged in and tries to access login page
  if (to.path === '/login' && token) {
    next(user.role === 'admin' ? '/admin/dashboard' : '/staff/dashboard')
    return
  }

  next()
})

export default router
