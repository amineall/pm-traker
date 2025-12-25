import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '../stores/authStore'

const routes = [
    {
        path: '/login',
        name: 'Login',
        component: () => import('../views/LoginView.vue'),
        meta: { requiresAuth: false }
    },
    {
        path: '/signup',
        name: 'Signup',
        component: () => import('../views/SignupView.vue'),
        meta: { requiresAuth: false }
    },
    {
        path: '/',
        name: 'Dashboard',
        component: () => import('../views/DashboardView.vue'),
        meta: { requiresAuth: true }
    },
    {
        path: '/assets',
        name: 'Assets',
        component: () => import('../views/AssetsView.vue'),
        meta: { requiresAuth: true }
    },
    {
        path: '/tasks',
        name: 'Tasks',
        component: () => import('../views/TasksView.vue'),
        meta: { requiresAuth: true }
    },
    {
        path: '/profile',
        name: 'Profile',
        component: () => import('../views/ProfileView.vue'),
        meta: { requiresAuth: true }
    },
    {
        path: '/users',
        name: 'Users',
        component: () => import('../views/UsersView.vue'),
        meta: { requiresAuth: true, requiresAdmin: true }
    }
]

const router = createRouter({
    history: createWebHistory(),
    routes
})

// Navigation guard for authentication
router.beforeEach(async (to, from, next) => {
    const authStore = useAuthStore()

    // Wait for auth to initialize
    if (authStore.loading) {
        await new Promise(resolve => {
            const unwatch = authStore.$subscribe(() => {
                if (!authStore.loading) {
                    unwatch()
                    resolve()
                }
            })
        })
    }

    const requiresAuth = to.matched.some(record => record.meta.requiresAuth)
    const requiresAdmin = to.matched.some(record => record.meta.requiresAdmin)

    if (requiresAuth && !authStore.isAuthenticated) {
        // Redirect to login if not authenticated
        next({ name: 'Login', query: { redirect: to.fullPath } })
    } else if (requiresAdmin && !authStore.isAdmin) {
        // Redirect to dashboard if not admin
        next({ name: 'Dashboard' })
    } else if ((to.name === 'Login' || to.name === 'Signup') && authStore.isAuthenticated) {
        // Redirect to dashboard if already logged in
        next({ name: 'Dashboard' })
    } else {
        next()
    }
})

export default router
