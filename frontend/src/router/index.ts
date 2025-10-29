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
import PurchaseOrderDetailAdmin from '@/views/admin/PurchaseOrderDetailAdmin.vue'
import SalesOrdersAdmin from '@/views/admin/SalesOrdersAdmin.vue'
import SalesOrderDetailAdmin from '@/views/admin/SalesOrderDetailAdmin.vue'
import UserManagement from '@/views/admin/UserManagement.vue'
import FormUserManagement from '@/views/admin/FormUserManagement.vue'
import SupplierManagement from '@/views/admin/SupplierManagement.vue'
import FormSupplier from '@/views/admin/FormSupplier.vue'
import AuditLog from '@/views/admin/AuditLog.vue'

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
      path: '/admin/purchase-orders/detail/:id',
      name: 'admin-purchase-order-detail',
      component: PurchaseOrderDetailAdmin,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/sales-orders',
      name: 'admin-sales-orders',
      component: SalesOrdersAdmin,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/admin/sales-orders/detail/:id',
      name: 'admin-sales-order-detail',
      component: SalesOrderDetailAdmin,
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
      path: '/admin/audit-log',
      name: 'admin-audit-log',
      component: AuditLog,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/staff/dashboard',
      name: 'staff-dashboard',
      component: StaffDashboard,
      meta: { requiresAuth: true, requiresStaff: true }
    },
    {
      path: '/staff/barang',
      name: 'staff-barang',
      component: BarangListStaff,
      meta: { requiresAuth: true, requiresStaff: true }
    },
    {
      path: '/staff/purchase-order',
      name: 'staff-purchase-order',
      component: PurchaseOrderList,
      meta: { requiresAuth: true, requiresStaff: true }
    },
    {
      path: '/staff/purchase-order/create',
      name: 'staff-purchase-order-create',
      component: FormPurchaseOrder,
      meta: { requiresAuth: true, requiresStaff: true }
    },
    {
      path: '/staff/purchase-order/edit/:id',
      name: 'staff-purchase-order-edit',
      component: FormPurchaseOrder,
      meta: { requiresAuth: true, requiresStaff: true }
    },
    {
      path: '/staff/purchase-order/:id',
      name: 'staff-purchase-order-detail',
      component: () => import('../views/staff/PurchaseOrderDetail.vue'),
      meta: { requiresAuth: true, requiresStaff: true }
    },
    {
      path: '/staff/sales-order',
      name: 'staff-sales-order',
      component: SalesOrderList,
      meta: { requiresAuth: true, requiresStaff: true }
    },
    {
      path: '/staff/sales-order/create',
      name: 'staff-sales-order-create',
      component: FormSalesOrder,
      meta: { requiresAuth: true, requiresStaff: true }
    },
    {
      path: '/staff/sales-order/edit/:id',
      name: 'staff-sales-order-edit',
      component: FormSalesOrder,
      meta: { requiresAuth: true, requiresStaff: true }
    },
    {
      path: '/staff/sales-order/detail/:id',
      name: 'staff-sales-order-detail',
      component: SalesOrderDetail,
      meta: { requiresAuth: true, requiresStaff: true }
    },
    {
      path: '/staff/purchase-orders',
      name: 'staff-purchase-orders',
      component: () => import('@/views/staff/PurchaseOrderList.vue'),
      meta: { requiresAuth: true, requiresStaff: true }
    },
    {
      path: '/staff/aktivitas',
      name: 'staff-aktivitas',
      component: () => import('@/views/staff/MyActivities.vue'),
      meta: { requiresAuth: true, requiresStaff: true }
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
