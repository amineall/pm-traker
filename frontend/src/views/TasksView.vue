<template>
  <div class="space-y-6">
    <!-- Header with animation -->
    <div class="flex items-center justify-between animate-fade-in">
      <div>
        <h2 class="text-3xl font-bold text-secondary-900 dark:text-white">Maintenance Tasks</h2>
        <p class="text-sm text-secondary-600 dark:text-secondary-400 mt-1">Manage and track all maintenance activities</p>
      </div>
      <button
        v-if="canCreate"
        @click="showModal = true"
        class="btn-primary flex items-center gap-2"
      >
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
        </svg>
        Add Task
      </button>
    </div>


    <!-- Tasks Grid -->
    <div v-if="loading" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <!-- Loading Skeletons -->
      <div v-for="i in 6" :key="i" class="skeleton-shimmer h-64 rounded-xl"></div>
    </div>
    <div v-else-if="tasks.length === 0" class="card text-center py-16 animate-fade-in">
      <svg class="w-20 h-20 mx-auto text-secondary-300 dark:text-secondary-600 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
      </svg>
      <p class="text-secondary-500 dark:text-secondary-400 text-lg">No tasks found. Create your first task!</p>
    </div>
    <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <div
        v-for="(task, index) in tasks"
        :key="task.id"
        class="card group animate-slide-up"
        :class="`stagger-${Math.min((index % 6) + 1, 5)}`"
      >
        <div class="flex items-start justify-between mb-3">
          <div class="flex-1">
            <h3 class="font-semibold text-secondary-900 dark:text-white mb-1">
              {{ task.asset?.asset_name || 'Unknown Asset' }}
            </h3>
            <p class="text-sm text-secondary-600 dark:text-secondary-300">
              {{ task.task_description }}
            </p>
          </div>
        </div>

        <div class="space-y-2 mb-4">
          <div class="flex items-center text-sm text-secondary-600 dark:text-secondary-400">
            <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
            </svg>
            {{ formatDate(task.scheduled_date) }}
          </div>
          <div v-if="task.assigned_user" class="flex items-center text-sm text-secondary-600 dark:text-secondary-400">
            <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
            </svg>
            {{ task.assigned_user?.full_name || 'Unassigned' }}
          </div>
        </div>

        <div class="flex items-center justify-between">
          <div class="flex space-x-2">
            <span :class="`badge badge-${task.priority.toLowerCase()}`">
              {{ task.priority }}
            </span>
            <span :class="`badge badge-${task.status.toLowerCase().replace(' ', '-')}`">
              {{ task.status }}
            </span>
          </div>
          <div class="flex space-x-2">
            <button
              v-if="canEditTask(task)"
              @click="editTask(task)"
              class="text-primary-600 hover:text-primary-900 dark:text-primary-400 text-sm"
            >
              Edit
            </button>
            <button
              v-if="canDelete"
              @click="deleteTask(task.id)"
              class="text-red-600 hover:text-red-900 dark:text-red-400 text-sm"
            >
              Delete
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal with improved backdrop -->
    <div v-if="showModal" class="modal-backdrop fixed inset-0 z-50 overflow-y-auto animate-fade-in" @click.self="closeModal">
      <div class="flex items-center justify-center min-h-screen px-4">
        <div class="fixed inset-0 bg-black/60 backdrop-blur-sm"></div>
        <div class="relative bg-white dark:bg-secondary-800 rounded-2xl shadow-2xl max-w-md w-full p-6 animate-slide-up">
          <h3 class="text-xl font-semibold text-secondary-900 dark:text-white mb-6">
            {{ editingTask ? 'Edit Task' : 'Add New Task' }}
          </h3>
          <form @submit.prevent="saveTask" class="space-y-4">
            <div>
              <label class="block text-sm font-medium text-secondary-700 dark:text-secondary-200 mb-2">Asset *</label>
              <select
                v-model="form.asset_id"
                required
                :disabled="isTechnician"
                class="w-full px-4 py-2 border border-secondary-300 dark:border-secondary-600 rounded-lg focus:ring-2 focus:ring-primary-500 dark:bg-secondary-700 dark:text-white"
              >
                <option value="">Select an asset</option>
                <option v-for="asset in availableAssets" :key="asset.id" :value="asset.id">
                  {{ asset.asset_name }}
                </option>
              </select>
            </div>
            <div>
              <label class="block text-sm font-medium text-secondary-700 dark:text-secondary-200 mb-2">Description *</label>
              <textarea
                v-model="form.task_description"
                required
                :disabled="isTechnician"
                rows="3"
                class="w-full px-4 py-2 border border-secondary-300 dark:border-secondary-600 rounded-lg focus:ring-2 focus:ring-primary-500 dark:bg-secondary-700 dark:text-white"
              ></textarea>
            </div>
            <div>
              <label class="block text-sm font-medium text-secondary-700 dark:text-secondary-200 mb-2">Scheduled Date</label>
              <input
                v-model="form.scheduled_date"
                type="datetime-local"
                :disabled="isTechnician"
                class="w-full px-4 py-2 border border-secondary-300 dark:border-secondary-600 rounded-lg focus:ring-2 focus:ring-primary-500 dark:bg-secondary-700 dark:text-white"
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-secondary-700 dark:text-secondary-200 mb-2">Priority *</label>
              <select
                v-model="form.priority"
                required
                :disabled="isTechnician"
                class="w-full px-4 py-2 border border-secondary-300 dark:border-secondary-600 rounded-lg focus:ring-2 focus:ring-primary-500 dark:bg-secondary-700 dark:text-white"
              >
                <option value="Low">Low</option>
                <option value="Medium">Medium</option>
                <option value="High">High</option>
              </select>
            </div>
            <div>
              <label class="block text-sm font-medium text-secondary-700 dark:text-secondary-200 mb-2">Status *</label>
              <select
                v-model="form.status"
                required
                class="w-full px-4 py-2 border border-secondary-300 dark:border-secondary-600 rounded-lg focus:ring-2 focus:ring-primary-500 dark:bg-secondary-700 dark:text-white"
              >
                <option value="Pending">Pending</option>
                <option value="In Progress">In Progress</option>
                <option value="Completed">Completed</option>
              </select>
            </div>
            <div v-if="!isTechnician">
              <label class="block text-sm font-medium text-secondary-700 dark:text-secondary-200 mb-2">Assign To</label>
              <select
                v-model="form.assigned_user_id"
                class="w-full px-4 py-2 border border-secondary-300 dark:border-secondary-600 rounded-lg focus:ring-2 focus:ring-primary-500 dark:bg-secondary-700 dark:text-white"
              >
                <option value="">Unassigned</option>
                <option v-for="user in technicians" :key="user.id" :value="user.id">
                  {{ user.full_name }} ({{ user.role }})
                </option>
              </select>
            </div>
            <div v-if="form.status === 'Completed'">
              <label class="block text-sm font-medium text-secondary-700 dark:text-secondary-200 mb-2">Completed Date</label>
              <input
                v-model="form.completed_date"
                type="datetime-local"
                class="w-full px-4 py-2 border border-secondary-300 dark:border-secondary-600 rounded-lg focus:ring-2 focus:ring-primary-500 dark:bg-secondary-700 dark:text-white"
              />
            </div>
            <div v-if="error" class="text-red-600 dark:text-red-400 text-sm">{{ error }}</div>
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
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { supabase } from '../utils/supabase'
import { useAuthStore } from '../stores/authStore'
import { permissions } from '../utils/permissions'

const authStore = useAuthStore()
const tasks = ref([])
const availableAssets = ref([])
const technicians = ref([])
const loading = ref(true)
const showModal = ref(false)
const editingTask = ref(null)
const saving = ref(false)
const error = ref('')

const form = ref({
  asset_id: '',
  task_description: '',
  scheduled_date: '',
  completed_date: '',
  assigned_user_id: '',
  priority: 'Medium',
  status: 'Pending'
})

const canCreate = computed(() => permissions.canCreateTask(authStore.userRole))
const canDelete = computed(() => permissions.canDeleteTask(authStore.userRole))
const isTechnician = computed(() => authStore.isTechnician)

const canEditTask = (task) => {
  return permissions.canEditTask(authStore.userRole, task, authStore.user?.id)
}

const formatDate = (dateString) => {
  if (!dateString) return 'Not scheduled'
  return new Date(dateString).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  })
}

const fetchTasks = async () => {
  try {
    loading.value = true
    let query = supabase
      .from('maintenance_tasks')
      .select(`
        *,
        asset:assets(asset_name),
        assigned_user:user_profiles!assigned_user_id(full_name)
      `)
      .order('created_at', { ascending: false })

    // Technicians only see their assigned tasks
    if (authStore.isTechnician) {
      query = query.eq('assigned_user_id', authStore.user.id)
    }

    const { data, error: fetchError } = await query

    if (fetchError) throw fetchError
    tasks.value = data || []
  } catch (err) {
    console.error('Error fetching tasks:', err)
    error.value = 'Failed to load tasks'
  } finally {
    loading.value = false
  }
}

const fetchAssets = async () => {
  const { data } = await supabase
    .from('assets')
    .select('id, asset_name')
    .order('asset_name')
  availableAssets.value = data || []
}

const fetchTechnicians = async () => {
  const { data } = await supabase
    .from('user_profiles')
    .select('id, full_name, role')
    .eq('role', 'Technician')
    .order('full_name')
  technicians.value = data || []
}

const editTask = (task) => {
  editingTask.value = task
  form.value = {
    asset_id: task.asset_id,
    task_description: task.task_description,
    scheduled_date: task.scheduled_date ? task.scheduled_date.slice(0, 16) : '',
    completed_date: task.completed_date ? task.completed_date.slice(0, 16) : '',
    assigned_user_id: task.assigned_user_id || '',
    priority: task.priority,
    status: task.status
  }
  showModal.value = true
}

const closeModal = () => {
  showModal.value = false
  editingTask.value = null
  form.value = {
    asset_id: '',
    task_description: '',
    scheduled_date: '',
    completed_date: '',
    assigned_user_id: '',
    priority: 'Medium',
    status: 'Pending'
  }
  error.value = ''
}

const saveTask = async () => {
  try {
    saving.value = true
    error.value = ''

    const taskData = { ...form.value }
    
    // Convert empty strings to null for UUID and timestamp fields
    if (!taskData.assigned_user_id) taskData.assigned_user_id = null
    if (!taskData.scheduled_date) taskData.scheduled_date = null
    if (!taskData.completed_date) taskData.completed_date = null
    
    // Auto-set completed date if status is Completed
    if (taskData.status === 'Completed' && !taskData.completed_date) {
      taskData.completed_date = new Date().toISOString()
    }

    if (editingTask.value) {
      const { error: updateError } = await supabase
        .from('maintenance_tasks')
        .update(taskData)
        .eq('id', editingTask.value.id)

      if (updateError) throw updateError
    } else {
      const { error: insertError } = await supabase
        .from('maintenance_tasks')
        .insert([{ ...taskData, created_by: authStore.user.id }])

      if (insertError) throw insertError
    }

    await fetchTasks()
    closeModal()
  } catch (err) {
    console.error('Error saving task:', err)
    error.value = err.message || 'Failed to save task'
  } finally {
    saving.value = false
  }
}

const deleteTask = async (id) => {
  if (!confirm('Are you sure you want to delete this task?')) return

  try {
    const { error: deleteError } = await supabase
      .from('maintenance_tasks')
      .delete()
      .eq('id', id)

    if (deleteError) throw deleteError
    await fetchTasks()
  } catch (err) {
    console.error('Error deleting task:', err)
    alert('Failed to delete task')
  }
}

// Realtime subscription
let subscription = null

onMounted(async () => {
  await fetchAssets()
  await fetchTechnicians()
  await fetchTasks()

  // Subscribe to realtime updates
  subscription = supabase
    .channel('maintenance_tasks_changes')
    .on('postgres_changes', {
      event: '*',
      schema: 'public',
      table: 'maintenance_tasks'
    }, () => {
      fetchTasks()
    })
    .subscribe()
})

onUnmounted(() => {
  if (subscription) {
    supabase.removeChannel(subscription)
  }
})
</script>
