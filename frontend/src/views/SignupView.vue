<template>
  <div class="min-h-screen flex items-center justify-center bg-gradient-to-br from-primary-50 to-primary-100 dark:from-secondary-900 dark:to-secondary-800 px-4">
    <div class="max-w-md w-full">
      <div class="card">
        <div class="text-center mb-8">
          <h1 class="text-3xl font-bold text-secondary-900 dark:text-white mb-2">
            Create Account
          </h1>
          <p class="text-secondary-600 dark:text-secondary-300">
            Join Production & Maintenance Tracker
          </p>
        </div>

        <form @submit.prevent="handleSignup" class="space-y-6">
          <!-- Full Name -->
          <div>
            <label for="fullName" class="block text-sm font-medium text-secondary-700 dark:text-secondary-200 mb-2">
              Full Name
            </label>
            <input
              id="fullName"
              v-model="fullName"
              type="text"
              required
              class="w-full px-4 py-2 border border-secondary-300 dark:border-secondary-600 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent dark:bg-secondary-700 dark:text-white"
              placeholder="John Doe"
            />
          </div>

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
              minlength="6"
              class="w-full px-4 py-2 border border-secondary-300 dark:border-secondary-600 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent dark:bg-secondary-700 dark:text-white"
              placeholder="••••••••"
            />
            <p class="mt-1 text-xs text-secondary-500 dark:text-secondary-400">
              Minimum 6 characters
            </p>
          </div>

          <!-- Role Selection -->
          <div>
            <label for="role" class="block text-sm font-medium text-secondary-700 dark:text-secondary-200 mb-2">
              Role
            </label>
            <select
              id="role"
              v-model="role"
              class="w-full px-4 py-2 border border-secondary-300 dark:border-secondary-600 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent dark:bg-secondary-700 dark:text-white"
            >
              <option value="Technician">Technician</option>
              <option value="Manager">Manager</option>
              <option value="Admin">Admin</option>
            </select>
            <p class="mt-1 text-xs text-secondary-500 dark:text-secondary-400">
              Select your role in the organization
            </p>
          </div>

          <!-- Error Message -->
          <div v-if="errorMessage" class="bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 text-red-700 dark:text-red-300 px-4 py-3 rounded-lg">
            {{ errorMessage }}
          </div>

          <!-- Success Message -->
          <div v-if="successMessage" class="bg-green-50 dark:bg-green-900/20 border border-green-200 dark:border-green-800 text-green-700 dark:text-green-300 px-4 py-3 rounded-lg">
            {{ successMessage }}
          </div>

          <!-- Submit Button -->
          <button
            type="submit"
            :disabled="loading"
            class="w-full btn-primary disabled:opacity-50 disabled:cursor-not-allowed"
          >
            <span v-if="loading">Creating account...</span>
            <span v-else>Sign Up</span>
          </button>
        </form>

        <!-- Sign In Link -->
        <div class="mt-6 text-center">
          <p class="text-secondary-600 dark:text-secondary-300">
            Already have an account?
            <router-link to="/login" class="text-primary-600 hover:text-primary-700 font-medium">
              Sign in
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

const fullName = ref('')
const email = ref('')
const password = ref('')
const role = ref('Technician')
const loading = ref(false)
const errorMessage = ref('')
const successMessage = ref('')

const handleSignup = async () => {
  loading.value = true
  errorMessage.value = ''
  successMessage.value = ''

  const { data, error } = await authStore.signUp(
    email.value,
    password.value,
    fullName.value,
    role.value
  )

  if (error) {
    errorMessage.value = error.message || 'Failed to create account. Please try again.'
    loading.value = false
  } else {
    successMessage.value = 'Account created successfully! Please check your email to confirm your account.'
    // Redirect to login after 2 seconds
    setTimeout(() => {
      router.push('/login')
    }, 2000)
  }
}
</script>
