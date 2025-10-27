import { createRouter, createWebHistory } from 'vue-router'
import Login from '@/views/auth/Login.vue'
import AdminDashboard from '@/views/admin/Dashboard.vue'
import StaffDashboard from '@/views/staff/Dashboard.vue'
import BarangManager from '@/views/admin/BarangManager.vue'
import AddBarang from '@/views/admin/AddBarang.vue'
import ManagementCategory from '@/views/admin/ManagementCategory.vue'
import FormCategory from '@/views/admin/FormCategory.vue'
import PurchaseOrdersAdmin from '@/views/admin/PurchaseOrdersAdmin.vue'
import SalesOrdersAdmin from '@/views/admin/SalesOrdersAdmin.vue'

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
      path: '/admin/sales-orders',
      name: 'admin-sales-orders',
      component: SalesOrdersAdmin,
      meta: { requiresAuth: true, requiresAdmin: true }
    },
    {
      path: '/staff/dashboard',
      name: 'staff-dashboard',
      component: StaffDashboard,
      meta: { requiresAuth: true, requiresStaff: true }
    }
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
