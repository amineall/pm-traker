<template>
  <div>
    <!-- Show layout for authenticated routes -->
    <AppLayout v-if="authStore.isAuthenticated && !isAuthRoute">
      <router-view />
    </AppLayout>
    
    <!-- Show plain router-view for auth routes (login/signup) -->
    <router-view v-else />
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import { useAuthStore } from './stores/authStore'
import AppLayout from './components/layout/AppLayout.vue'

const route = useRoute()
const authStore = useAuthStore()

const isAuthRoute = computed(() => {
  return route.name === 'Login' || route.name === 'Signup'
})
</script>

