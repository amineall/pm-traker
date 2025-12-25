<template>
  <div class="min-h-screen bg-secondary-50 dark:bg-secondary-900">
    <!-- Sidebar -->
    <aside
      :class="[
        'fixed inset-y-0 left-0 z-50 w-64 bg-white dark:bg-secondary-800 border-r border-secondary-200 dark:border-secondary-700 transform transition-transform duration-200 ease-in-out',
        sidebarOpen ? 'translate-x-0' : '-translate-x-full md:translate-x-0'
      ]"
    >
      <div class="flex flex-col h-full">
        <!-- Logo/Brand -->
        <div class="flex items-center justify-between h-16 px-6 border-b border-secondary-200 dark:border-secondary-700">
          <div class="flex items-center gap-3">
            <div class="w-8 h-8 bg-gradient-to-br from-primary-500 to-primary-700 rounded-lg flex items-center justify-center shadow-lg shadow-primary-500/30">
              <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
              </svg>
            </div>
            <h1 class="text-xl font-bold text-secondary-900 dark:text-white tracking-tight">
              PM Tracker
            </h1>
          </div>
          <button
            @click="sidebarOpen = false"
            class="md:hidden text-secondary-500 hover:text-secondary-700 dark:text-secondary-400 dark:hover:text-secondary-200"
          >
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        <!-- Navigation -->
        <nav class="flex-1 px-4 py-6 space-y-2 overflow-y-auto">
          <router-link
            v-for="item in navigation"
            :key="item.name"
            :to="item.path"
            v-slot="{ isActive }"
            class="block"
          >
            <div
              :class="[
                'flex items-center px-4 py-3 text-sm font-medium rounded-lg transition-colors',
                isActive
                  ? 'bg-primary-50 dark:bg-primary-900/20 text-primary-700 dark:text-primary-400'
                  : 'text-secondary-700 dark:text-secondary-300 hover:bg-secondary-100 dark:hover:bg-secondary-700'
              ]"
            >
              <component :is="item.icon" class="w-5 h-5 mr-3" />
              {{ item.name }}
            </div>
          </router-link>
        </nav>

        <!-- User Profile -->
        <div class="p-4 border-t border-secondary-200 dark:border-secondary-700">
          <div class="flex items-center justify-between">
            <div class="flex items-center space-x-3">
              <div class="w-10 h-10 rounded-full bg-primary-100 dark:bg-primary-900 flex items-center justify-center">
                <span class="text-primary-700 dark:text-primary-300 font-medium">
                  {{ userInitials }}
                </span>
              </div>
              <div class="flex-1 min-w-0">
                <p class="text-sm font-medium text-secondary-900 dark:text-white truncate">
                  {{ authStore.userProfile?.full_name || 'User' }}
                </p>
                <p class="text-xs text-secondary-500 dark:text-secondary-400">
                  {{ authStore.userRole }}
                </p>
              </div>
            </div>
            <button
              @click="handleSignOut"
              class="text-secondary-500 hover:text-secondary-700 dark:text-secondary-400 dark:hover:text-secondary-200"
              title="Sign out"
            >
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.75 9V5.25A2.25 2.25 0 0013.5 3h-6a2.25 2.25 0 00-2.25 2.25v13.5A2.25 2.25 0 007.5 21h6a2.25 2.25 0 002.25-2.25V15M12 9l-3 3m0 0l3 3m-3-3h12.75" />
              </svg>
            </button>
          </div>
        </div>
      </div>
    </aside>

    <!-- Main Content -->
    <div class="md:pl-64">
      <!-- Top Header -->
      <header class="sticky top-0 z-40 bg-white dark:bg-secondary-800 border-b border-secondary-200 dark:border-secondary-700">
        <div class="flex items-center justify-between h-16 px-4 sm:px-6">
          <!-- Mobile Menu Button -->
          <button
            @click="sidebarOpen = !sidebarOpen"
            class="md:hidden text-secondary-500 hover:text-secondary-700 dark:text-secondary-400 dark:hover:text-secondary-200"
          >
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
            </svg>
          </button>

          <!-- Page Title -->
          <h2 class="text-xl font-semibold text-secondary-900 dark:text-white">
            {{ currentPageTitle }}
          </h2>

          <!-- Theme Toggle -->
          <button
            @click="toggleTheme"
            class="p-2 rounded-lg text-secondary-500 hover:bg-secondary-100 dark:text-secondary-400 dark:hover:bg-secondary-700"
            title="Toggle theme"
          >
            <svg v-if="isDark" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z" />
            </svg>
            <svg v-else class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z" />
            </svg>
          </button>
        </div>
      </header>

      <!-- Page Content -->
      <main class="p-4 sm:p-6">
        <router-view />
      </main>
    </div>

    <!-- Mobile Sidebar Overlay -->
    <div
      v-if="sidebarOpen"
      @click="sidebarOpen = false"
      class="fixed inset-0 z-40 bg-black bg-opacity-50 md:hidden"
    ></div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useAuthStore } from '../../stores/authStore'

const router = useRouter()
const route = useRoute()
const authStore = useAuthStore()

const sidebarOpen = ref(false)
const isDark = ref(false)

// Navigation items
const navigation = computed(() => {
  const items = [
    { name: 'Dashboard', path: '/', icon: 'DashboardIcon' },
    { name: 'Assets', path: '/assets', icon: 'AssetsIcon' },
    { name: 'Tasks', path: '/tasks', icon: 'TasksIcon' },
    { name: 'Profile', path: '/profile', icon: 'ProfileIcon' }
  ]

  // Add Users link for Admin only
  if (authStore.isAdmin) {
    items.push({ name: 'Users', path: '/users', icon: 'UsersIcon' })
  }

  return items
})

// Current page title
const currentPageTitle = computed(() => {
  return route.name || 'Dashboard'
})

// User initials
const userInitials = computed(() => {
  const name = authStore.userProfile?.full_name || 'U'
  return name
    .split(' ')
    .map(n => n[0])
    .join('')
    .toUpperCase()
    .slice(0, 2)
})

// Theme management
const toggleTheme = () => {
  isDark.value = !isDark.value
  document.documentElement.classList.toggle('dark', isDark.value)
  localStorage.setItem('theme', isDark.value ? 'dark' : 'light')
}

// Initialize theme
onMounted(() => {
  const savedTheme = localStorage.getItem('theme')
  isDark.value = savedTheme === 'dark' || (!savedTheme && window.matchMedia('(prefers-color-scheme: dark)').matches)
  document.documentElement.classList.toggle('dark', isDark.value)
})

// Sign out
const handleSignOut = async () => {
  try {
    await authStore.signOut()
    // Force navigation to login
    await router.push('/login')
  } catch (error) {
    console.error('Error during sign out:', error)
  }
}
</script>

<script>
// Premium icon components
const DashboardIcon = {
  template: `<svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z" /></svg>`
}

const AssetsIcon = {
  template: `<svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4" /></svg>`
}

const TasksIcon = {
  template: `<svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01" /></svg>`
}

const ProfileIcon = {
  template: `<svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5.121 17.804A13.937 13.937 0 0112 16c2.5 0 4.847.655 6.879 1.804M15 10a3 3 0 11-6 0 3 3 0 016 0zm6 2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>`
}

const UsersIcon = {
  template: `<svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" /></svg>`
}

export default {
  components: {
    DashboardIcon,
    AssetsIcon,
    TasksIcon,
    ProfileIcon,
    UsersIcon
  }
}
</script>
