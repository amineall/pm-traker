<template>
  <div class="max-w-2xl mx-auto space-y-6">
    <h2 class="text-2xl font-bold text-secondary-900 dark:text-white">Profile</h2>

    <div class="card">
      <form @submit.prevent="updateProfile" class="space-y-6">
        <div>
          <label class="block text-sm font-medium text-secondary-700 dark:text-secondary-200 mb-2">
            Full Name
          </label>
          <input
            v-model="form.full_name"
            type="text"
            class="w-full px-4 py-2 border border-secondary-300 dark:border-secondary-600 rounded-lg focus:ring-2 focus:ring-primary-500 dark:bg-secondary-700 dark:text-white"
          />
        </div>

        <div>
          <label class="block text-sm font-medium text-secondary-700 dark:text-secondary-200 mb-2">
            Email
          </label>
          <input
            :value="authStore.user?.email"
            type="email"
            disabled
            class="w-full px-4 py-2 border border-secondary-300 dark:border-secondary-600 rounded-lg bg-secondary-100 dark:bg-secondary-700 text-secondary-500 dark:text-secondary-400"
          />
        </div>

        <div>
          <label class="block text-sm font-medium text-secondary-700 dark:text-secondary-200 mb-2">
            Role
          </label>
          <input
            :value="authStore.userRole"
            type="text"
            disabled
            class="w-full px-4 py-2 border border-secondary-300 dark:border-secondary-600 rounded-lg bg-secondary-100 dark:bg-secondary-700 text-secondary-500 dark:text-secondary-400"
          />
        </div>

        <div v-if="message" :class="messageClass" class="px-4 py-3 rounded-lg">
          {{ message }}
        </div>

        <button type="submit" class="btn-primary" :disabled="saving">
          {{ saving ? 'Saving...' : 'Update Profile' }}
        </button>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useAuthStore } from '../stores/authStore'

const authStore = useAuthStore()
const saving = ref(false)
const message = ref('')
const isError = ref(false)

const form = ref({
  full_name: ''
})

const messageClass = computed(() => {
  return isError.value
    ? 'bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 text-red-700 dark:text-red-300'
    : 'bg-green-50 dark:bg-green-900/20 border border-green-200 dark:border-green-800 text-green-700 dark:text-green-300'
})

const updateProfile = async () => {
  try {
    saving.value = true
    message.value = ''
    isError.value = false

    const { error } = await authStore.updateProfile(form.value)

    if (error) {
      isError.value = true
      message.value = error.message || 'Failed to update profile'
    } else {
      message.value = 'Profile updated successfully!'
      setTimeout(() => {
        message.value = ''
      }, 3000)
    }
  } catch (err) {
    isError.value = true
    message.value = 'An error occurred'
  } finally {
    saving.value = false
  }
}

onMounted(() => {
  form.value.full_name = authStore.userProfile?.full_name || ''
})
</script>
