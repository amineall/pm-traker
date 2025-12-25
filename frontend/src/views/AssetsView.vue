<template>
  <div class="space-y-6">
    <!-- Header with animation -->
    <div class="flex items-center justify-between animate-fade-in">
      <div>
        <h2 class="text-3xl font-bold text-secondary-900 dark:text-white">Assets</h2>
        <p class="text-sm text-secondary-600 dark:text-secondary-400 mt-1">Manage and track your equipment inventory</p>
      </div>
      <button
        v-if="canCreate"
        @click="showModal = true"
        class="btn-primary flex items-center gap-2 group"
      >
        <svg class="w-5 h-5 transform group-hover:rotate-90 transition-transform duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
        </svg>
        Add Asset
      </button>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <div v-for="i in 6" :key="i" class="card p-6 space-y-4 animate-pulse">
        <div class="flex items-center justify-between">
          <div class="w-12 h-12 rounded-lg skeleton-shimmer"></div>
          <div class="w-20 h-6 rounded-full skeleton-shimmer"></div>
        </div>
        <div class="space-y-2">
          <div class="h-6 w-3/4 rounded skeleton-shimmer"></div>
          <div class="h-4 w-1/2 rounded skeleton-shimmer"></div>
        </div>
        <div class="pt-4 border-t border-secondary-100 dark:border-secondary-700 flex justify-between">
          <div class="h-4 w-1/3 rounded skeleton-shimmer"></div>
          <div class="h-4 w-1/4 rounded skeleton-shimmer"></div>
        </div>
      </div>
    </div>

    <!-- Empty State -->
    <div v-else-if="assets.length === 0" class="text-center py-16 animate-fade-in">
      <div class="w-24 h-24 bg-secondary-100 dark:bg-secondary-800 rounded-full flex items-center justify-center mx-auto mb-6">
        <svg class="w-12 h-12 text-secondary-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4" />
        </svg>
      </div>
      <h3 class="text-xl font-medium text-secondary-900 dark:text-white mb-2">No assets found</h3>
      <p class="text-secondary-500 dark:text-secondary-400 mb-6">Get started by adding your first asset to the inventory.</p>
      <button v-if="canCreate" @click="showModal = true" class="btn-primary">
        Create Asset
      </button>
    </div>

    <!-- Assets Grid -->
    <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <div
        v-for="(asset, index) in assets"
        :key="asset.id"
        class="card group hover:-translate-y-1 transition-all duration-300 animate-slide-up"
        :class="`stagger-${(index % 5) + 1}`"
      >
        <div class="p-6">
          <div class="flex items-start justify-between mb-4">
            <div class="w-12 h-12 rounded-xl bg-gradient-to-br from-blue-500 to-blue-600 flex items-center justify-center text-white shadow-lg shadow-blue-500/30 group-hover:scale-110 transition-transform duration-300">
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
              </svg>
            </div>
            <span
              class="px-3 py-1 rounded-full text-xs font-semibold border"
              :class="{
                'bg-green-100 text-green-800 border-green-200 dark:bg-green-900/30 dark:text-green-300 dark:border-green-800': asset.status === 'Operational',
                'bg-yellow-100 text-yellow-800 border-yellow-200 dark:bg-yellow-900/30 dark:text-yellow-300 dark:border-yellow-800 animate-pulse-glow': asset.status === 'Maintenance',
                'bg-red-100 text-red-800 border-red-200 dark:bg-red-900/30 dark:text-red-300 dark:border-red-800': asset.status === 'Decommissioned'
              }"
            >
              {{ asset.status }}
            </span>
          </div>

          <h3 class="text-lg font-bold text-secondary-900 dark:text-white mb-1 group-hover:text-primary-600 dark:group-hover:text-primary-400 transition-colors">
            {{ asset.asset_name }}
          </h3>
          <p class="text-sm text-secondary-500 dark:text-secondary-400 mb-4 font-mono">
            SN: {{ asset.serial_number || 'N/A' }}
          </p>

          <div class="flex items-center text-sm text-secondary-600 dark:text-secondary-300 mb-6">
            <svg class="w-4 h-4 mr-2 text-secondary-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
            </svg>
            {{ asset.location || 'Unknown Location' }}
          </div>

          <div class="pt-4 border-t border-secondary-100 dark:border-secondary-700 flex justify-end space-x-2 opacity-0 group-hover:opacity-100 transition-opacity duration-200">
            <button
              v-if="canEdit"
              @click="editAsset(asset)"
              class="p-2 text-secondary-400 hover:text-primary-600 dark:hover:text-primary-400 transition-colors rounded-lg hover:bg-secondary-50 dark:hover:bg-secondary-700"
              title="Edit Asset"
            >
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
              </svg>
            </button>
            <button
              v-if="canDelete"
              @click="deleteAsset(asset.id)"
              class="p-2 text-secondary-400 hover:text-red-600 dark:hover:text-red-400 transition-colors rounded-lg hover:bg-red-50 dark:hover:bg-red-900/20"
              title="Delete Asset"
            >
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
              </svg>
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal -->
    <div v-if="showModal" class="modal-backdrop fixed inset-0 z-50 overflow-y-auto animate-fade-in" @click.self="closeModal">
      <div class="flex items-center justify-center min-h-screen px-4">
        <div class="fixed inset-0 bg-black/60 backdrop-blur-sm"></div>
        <div class="relative bg-white dark:bg-secondary-800 rounded-2xl shadow-2xl max-w-md w-full p-6 animate-slide-up">
          <h3 class="text-xl font-bold text-secondary-900 dark:text-white mb-6 flex items-center gap-3">
            <div class="w-10 h-10 rounded-lg bg-primary-100 dark:bg-primary-900/50 flex items-center justify-center text-primary-600 dark:text-primary-400">
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
              </svg>
            </div>
            {{ editingAsset ? 'Edit Asset' : 'Add New Asset' }}
          </h3>
          
          <form @submit.prevent="saveAsset" class="space-y-5">
            <div>
              <label class="block text-sm font-medium text-secondary-700 dark:text-secondary-200 mb-2">Asset Name *</label>
              <input
                v-model="form.asset_name"
                type="text"
                required
                placeholder="e.g. CNC Machine X1"
                class="w-full px-4 py-2.5 border border-secondary-300 dark:border-secondary-600 rounded-xl focus:ring-2 focus:ring-primary-500 dark:bg-secondary-700 dark:text-white transition-shadow"
              />
            </div>
            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-secondary-700 dark:text-secondary-200 mb-2">Serial Number</label>
                <input
                  v-model="form.serial_number"
                  type="text"
                  placeholder="SN-12345"
                  class="w-full px-4 py-2.5 border border-secondary-300 dark:border-secondary-600 rounded-xl focus:ring-2 focus:ring-primary-500 dark:bg-secondary-700 dark:text-white transition-shadow"
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-secondary-700 dark:text-secondary-200 mb-2">Status *</label>
                <select
                  v-model="form.status"
                  required
                  class="w-full px-4 py-2.5 border border-secondary-300 dark:border-secondary-600 rounded-xl focus:ring-2 focus:ring-primary-500 dark:bg-secondary-700 dark:text-white transition-shadow"
                >
                  <option value="Operational">Operational</option>
                  <option value="Maintenance">Maintenance</option>
                  <option value="Decommissioned">Decommissioned</option>
                </select>
              </div>
            </div>
            <div>
              <label class="block text-sm font-medium text-secondary-700 dark:text-secondary-200 mb-2">Location</label>
              <input
                v-model="form.location"
                type="text"
                placeholder="e.g. Building A, Floor 2"
                class="w-full px-4 py-2.5 border border-secondary-300 dark:border-secondary-600 rounded-xl focus:ring-2 focus:ring-primary-500 dark:bg-secondary-700 dark:text-white transition-shadow"
              />
            </div>
            
            <div v-if="error" class="p-3 bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 text-sm rounded-lg flex items-center gap-2">
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
              {{ error }}
            </div>

            <div class="flex justify-end space-x-3 pt-4 border-t border-secondary-100 dark:border-secondary-700">
              <button type="button" @click="closeModal" class="btn-secondary">Cancel</button>
              <button type="submit" class="btn-primary" :disabled="saving">
                {{ saving ? 'Saving...' : 'Save Asset' }}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { supabase } from '../utils/supabase'
import { useAuthStore } from '../stores/authStore'
import { permissions } from '../utils/permissions'

const authStore = useAuthStore()
const assets = ref([])
const loading = ref(true)
const showModal = ref(false)
const editingAsset = ref(null)
const saving = ref(false)
const error = ref('')

const form = ref({
  asset_name: '',
  serial_number: '',
  status: 'Operational',
  location: ''
})

const canCreate = computed(() => permissions.canCreateAsset(authStore.userRole))
const canEdit = computed(() => permissions.canEditAsset(authStore.userRole))
const canDelete = computed(() => permissions.canDeleteAsset(authStore.userRole))

const fetchAssets = async () => {
  try {
    loading.value = true
    const { data, error: fetchError } = await supabase
      .from('assets')
      .select('*')
      .order('created_at', { ascending: false })

    if (fetchError) throw fetchError
    assets.value = data || []
  } catch (err) {
    console.error('Error fetching assets:', err)
    error.value = 'Failed to load assets'
  } finally {
    loading.value = false
  }
}

const editAsset = (asset) => {
  editingAsset.value = asset
  form.value = { ...asset }
  showModal.value = true
}

const closeModal = () => {
  showModal.value = false
  editingAsset.value = null
  form.value = {
    asset_name: '',
    serial_number: '',
    status: 'Operational',
    location: ''
  }
  error.value = ''
}

const saveAsset = async () => {
  try {
    saving.value = true
    error.value = ''

    if (editingAsset.value) {
      const { error: updateError } = await supabase
        .from('assets')
        .update(form.value)
        .eq('id', editingAsset.value.id)

      if (updateError) throw updateError
    } else {
      const { error: insertError } = await supabase
        .from('assets')
        .insert([{ ...form.value, created_by: authStore.user.id }])

      if (insertError) throw insertError
    }

    await fetchAssets()
    closeModal()
  } catch (err) {
    console.error('Error saving asset:', err)
    error.value = err.message || 'Failed to save asset'
  } finally {
    saving.value = false
  }
}

const deleteAsset = async (id) => {
  if (!confirm('Are you sure you want to delete this asset?')) return

  try {
    const { error: deleteError } = await supabase
      .from('assets')
      .delete()
      .eq('id', id)

    if (deleteError) throw deleteError
    await fetchAssets()
  } catch (err) {
    console.error('Error deleting asset:', err)
    alert('Failed to delete asset')
  }
}

onMounted(() => {
  fetchAssets()
})
</script>
