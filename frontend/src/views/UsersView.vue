<template>
  <div class="space-y-6">
    <!-- Header with animation -->
    <div class="flex items-center justify-between animate-fade-in">
      <div>
        <h2 class="text-3xl font-bold text-secondary-900 dark:text-white">User Management</h2>
        <p class="text-sm text-secondary-600 dark:text-secondary-400 mt-1">Manage system access and user roles</p>
      </div>
      <button
        @click="openAddUserModal"
        class="btn-primary flex items-center gap-2"
      >
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z" />
        </svg>
        Add User
      </button>
    </div>

    <!-- Users Table Card -->
    <div class="card overflow-hidden animate-slide-up stagger-1">
      <div v-if="loading" class="p-8">
        <div v-for="i in 5" :key="i" class="skeleton-shimmer h-12 rounded-lg mb-4 last:mb-0"></div>
      </div>
      <div v-else class="overflow-x-auto">
        <table class="min-w-full divide-y divide-secondary-200 dark:divide-secondary-700">
          <thead class="bg-secondary-50 dark:bg-secondary-800/50">
            <tr>
              <th class="px-6 py-4 text-left text-xs font-semibold text-secondary-500 dark:text-secondary-400 uppercase tracking-wider">User</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-secondary-500 dark:text-secondary-400 uppercase tracking-wider">Role</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-secondary-500 dark:text-secondary-400 uppercase tracking-wider">Status</th>
              <th class="px-6 py-4 text-right text-xs font-semibold text-secondary-500 dark:text-secondary-400 uppercase tracking-wider">Actions</th>
            </tr>
          </thead>
          <tbody class="bg-white dark:bg-secondary-800 divide-y divide-secondary-200 dark:divide-secondary-700">
            <tr 
              v-for="(user, index) in users" 
              :key="user.id"
              class="group hover:bg-secondary-50 dark:hover:bg-secondary-700/50 transition-colors duration-150"
            >
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="flex items-center">
                  <div class="flex-shrink-0 h-10 w-10 rounded-full bg-gradient-to-br from-primary-100 to-primary-200 dark:from-primary-900/30 dark:to-primary-800/30 flex items-center justify-center text-primary-700 dark:text-primary-300 font-bold text-lg">
                    {{ user.full_name?.charAt(0).toUpperCase() || 'U' }}
                  </div>
                  <div class="ml-4">
                    <div class="text-sm font-medium text-secondary-900 dark:text-white">{{ user.full_name }}</div>
                    <div class="text-sm text-secondary-500 dark:text-secondary-400">{{ user.email }}</div>
                  </div>
                </div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <span 
                  class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full"
                  :class="{
                    'bg-purple-100 text-purple-800 dark:bg-purple-900/30 dark:text-purple-300': user.role === 'Admin',
                    'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-300': user.role === 'Manager',
                    'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-300': user.role === 'Technician'
                  }"
                >
                  {{ user.role }}
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <span class="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400">
                  <span class="w-1.5 h-1.5 rounded-full bg-green-500 animate-pulse"></span>
                  Active
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                <button
                  @click="editUserRole(user)"
                  class="text-primary-600 hover:text-primary-900 dark:text-primary-400 dark:hover:text-primary-300 transition-colors"
                >
                  Change Role
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Add/Edit User Modal -->
    <div v-if="showModal" class="modal-backdrop fixed inset-0 z-50 overflow-y-auto animate-fade-in" @click.self="closeModal">
      <div class="flex items-center justify-center min-h-screen px-4">
        <div class="fixed inset-0 bg-black/60 backdrop-blur-sm"></div>
        <div class="relative bg-white dark:bg-secondary-800 rounded-2xl shadow-2xl max-w-md w-full p-6 animate-slide-up">
          <h3 class="text-xl font-semibold text-secondary-900 dark:text-white mb-6">
            {{ isAddingUser ? 'Add New User' : 'Change User Role' }}
          </h3>
          
          <form @submit.prevent="handleSubmit" class="space-y-4">
            <div v-if="isAddingUser">
              <label class="block text-sm font-medium text-secondary-700 dark:text-secondary-200 mb-2">Full Name</label>
              <input
                v-model="newUser.fullName"
                type="text"
                required
                class="w-full px-4 py-2 border border-secondary-300 dark:border-secondary-600 rounded-lg focus:ring-2 focus:ring-primary-500 dark:bg-secondary-700 dark:text-white"
                placeholder="John Doe"
              />
            </div>

            <div v-if="isAddingUser">
              <label class="block text-sm font-medium text-secondary-700 dark:text-secondary-200 mb-2">Email</label>
              <input
                v-model="newUser.email"
                type="email"
                required
                class="w-full px-4 py-2 border border-secondary-300 dark:border-secondary-600 rounded-lg focus:ring-2 focus:ring-primary-500 dark:bg-secondary-700 dark:text-white"
                placeholder="john@example.com"
              />
            </div>

            <div v-if="isAddingUser">
              <label class="block text-sm font-medium text-secondary-700 dark:text-secondary-200 mb-2">Password</label>
              <input
                v-model="newUser.password"
                type="password"
                required
                class="w-full px-4 py-2 border border-secondary-300 dark:border-secondary-600 rounded-lg focus:ring-2 focus:ring-primary-500 dark:bg-secondary-700 dark:text-white"
                placeholder="••••••••"
              />
            </div>

            <div>
              <label class="block text-sm font-medium text-secondary-700 dark:text-secondary-200 mb-2">
                {{ isAddingUser ? 'Role' : `Role for ${editingUser?.full_name}` }}
              </label>
              <select
                v-model="selectedRole"
                class="w-full px-4 py-2 border border-secondary-300 dark:border-secondary-600 rounded-lg focus:ring-2 focus:ring-primary-500 dark:bg-secondary-700 dark:text-white"
              >
                <option value="Technician">Technician</option>
                <option value="Manager">Manager</option>
                <option value="Admin">Admin</option>
              </select>
            </div>

            <div v-if="error" class="p-3 bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm rounded-lg">
              {{ error }}
            </div>

            <div class="flex justify-end space-x-3 pt-4">
              <button type="button" @click="closeModal" class="btn-secondary">Cancel</button>
              <button type="submit" class="btn-primary" :disabled="saving">
                {{ saving ? 'Saving...' : 'Save' }}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { supabase } from '../utils/supabase'
import { createClient } from '@supabase/supabase-js'

const users = ref([])
const loading = ref(true)
const showModal = ref(false)
const isAddingUser = ref(false)
const editingUser = ref(null)
const selectedRole = ref('Technician')
const saving = ref(false)
const error = ref('')

const newUser = ref({
  email: '',
  password: '',
  fullName: ''
})

const fetchUsers = async () => {
  try {
    loading.value = true
    const { data, error } = await supabase.rpc('get_users_with_email')
    if (error) throw error
    users.value = data || []
  } catch (err) {
    console.error('Error fetching users:', err)
  } finally {
    loading.value = false
  }
}

const openAddUserModal = () => {
  isAddingUser.value = true
  editingUser.value = null
  selectedRole.value = 'Technician'
  newUser.value = { email: '', password: '', fullName: '' }
  showModal.value = true
  error.value = ''
}

const editUserRole = (user) => {
  isAddingUser.value = false
  editingUser.value = user
  selectedRole.value = user.role
  showModal.value = true
  error.value = ''
}

const closeModal = () => {
  showModal.value = false
  editingUser.value = null
  newUser.value = { email: '', password: '', fullName: '' }
  error.value = ''
}

const handleSubmit = async () => {
  if (isAddingUser.value) {
    await createUser()
  } else {
    await saveRole()
  }
}

const createUser = async () => {
  try {
    saving.value = true
    error.value = ''

    // Create a temporary client to avoid logging out the admin
    const tempClient = createClient(
      import.meta.env.VITE_SUPABASE_URL,
      import.meta.env.VITE_SUPABASE_ANON_KEY,
      {
        auth: {
          persistSession: false, // Don't persist session to storage
          autoRefreshToken: false,
          detectSessionInUrl: false
        }
      }
    )

    // Sign up the new user
    const { data: authData, error: signUpError } = await tempClient.auth.signUp({
      email: newUser.value.email,
      password: newUser.value.password,
      options: {
        data: {
          full_name: newUser.value.fullName,
          role: selectedRole.value
        }
      }
    })

    if (signUpError) throw signUpError

    if (authData.user) {
      // The trigger handle_new_user should have created the profile
      // But we might need to update the role if the trigger defaults to Technician
      // and we selected something else.
      // However, we passed role in metadata, so if the trigger uses it, we are good.
      // Let's explicitly update it to be safe if we have admin rights.
      
      // Wait a moment for trigger
      await new Promise(resolve => setTimeout(resolve, 1000))

      // We can try to update the role using our main admin client
      const { error: updateError } = await supabase
        .from('user_profiles')
        .update({ role: selectedRole.value })
        .eq('id', authData.user.id)
      
      if (updateError) {
        console.warn('Could not update role immediately (might need to wait for trigger):', updateError)
      }
    }

    await fetchUsers()
    closeModal()
  } catch (err) {
    console.error('Error creating user:', err)
    error.value = err.message || 'Failed to create user'
  } finally {
    saving.value = false
  }
}

const saveRole = async () => {
  try {
    saving.value = true
    error.value = ''

    const { error: updateError } = await supabase
      .from('user_profiles')
      .update({ role: selectedRole.value })
      .eq('id', editingUser.value.id)

    if (updateError) throw updateError

    await fetchUsers()
    closeModal()
  } catch (err) {
    console.error('Error updating role:', err)
    error.value = err.message || 'Failed to update role'
  } finally {
    saving.value = false
  }
}

onMounted(() => {
  fetchUsers()
})
</script>
