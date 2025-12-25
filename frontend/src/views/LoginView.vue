<template>
  <div class="min-h-screen flex items-center justify-center bg-gradient-to-br from-primary-50 to-primary-100 dark:from-secondary-900 dark:to-secondary-800 px-4">
    <div class="max-w-md w-full">
      <div class="card">
        <div class="text-center mb-8">
          <h1 class="text-3xl font-bold text-secondary-900 dark:text-white mb-2">
            Welcome Back
          </h1>
          <p class="text-secondary-600 dark:text-secondary-300">
            Sign in to Production & Maintenance Tracker
          </p>
        </div>

        <form @submit.prevent="handleLogin" class="space-y-6">
          <!-- Email -->
          <div>
            <label for="email" class="block text-sm font-medium text-secondary-700 dark:text-secondary-200 mb-2">
              Email Address
            </label>
            <input
              id="email"
              v-model="email"
              type="email"
              required
              class="w-full px-4 py-2 border border-secondary-300 dark:border-secondary-600 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent dark:bg-secondary-700 dark:text-white"
              placeholder="you@example.com"
            />
          </div>

          <!-- Password -->
          <div>
            <label for="password" class="block text-sm font-medium text-secondary-700 dark:text-secondary-200 mb-2">
              Password
            </label>
            <input
              id="password"
              v-model="password"
              type="password"
              required
              class="w-full px-4 py-2 border border-secondary-300 dark:border-secondary-600 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent dark:bg-secondary-700 dark:text-white"
              placeholder="••••••••"
            />
          </div>

          <!-- Error Message -->
          <div v-if="errorMessage" class="bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 text-red-700 dark:text-red-300 px-4 py-3 rounded-lg">
            {{ errorMessage }}
          </div>

          <!-- Submit Button -->
          <button
            type="submit"
            :disabled="loading"
            class="w-full btn-primary disabled:opacity-50 disabled:cursor-not-allowed"
          >
            <span v-if="loading">Signing in...</span>
            <span v-else>Sign In</span>
          </button>
        </form>

        <!-- Sign Up Link -->
        <div class="mt-6 text-center">
          <p class="text-secondary-600 dark:text-secondary-300">
            Don't have an account?
            <router-link to="/signup" class="text-primary-600 hover:text-primary-700 font-medium">
              Sign up
            </router-link>
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/authStore'

const router = useRouter()
const authStore = useAuthStore()

const email = ref('')
const password = ref('')
const loading = ref(false)
const errorMessage = ref('')

const handleLogin = async () => {
  loading.value = true
  errorMessage.value = ''

  const { data, error } = await authStore.signIn(email.value, password.value)

  if (error) {
    errorMessage.value = error.message || 'Failed to sign in. Please check your credentials.'
    loading.value = false
  } else {
    // Redirect to dashboard or the page they were trying to access
    const redirect = router.currentRoute.value.query.redirect || '/'
    router.push(redirect)
  }
}
</script>
