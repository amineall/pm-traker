<template>
  <div class="space-y-6">
    <!-- Stats Cards with Gradient Backgrounds -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <!-- Total Assets -->
      <div class="stat-card from-blue-500 to-blue-700 animate-slide-up stagger-1">
        <div class="flex items-center justify-between relative z-10">
          <div>
            <p class="text-sm font-medium text-blue-100 mb-1">Total Assets</p>
            <p ref="totalAssetsRef" class="text-4xl font-bold text-white mt-2 animate-fade-in stagger-2">
              {{ displayStats.totalAssets }}
            </p>
          </div>
          <div class="w-16 h-16 bg-white/20 backdrop-blur-sm rounded-2xl flex items-center justify-center">
            <svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
            </svg>
          </div>
        </div>
      </div>

      <!-- Active Tasks -->
      <div class="stat-card from-purple-500 to-purple-700 animate-slide-up stagger-2">
        <div class="flex items-center justify-between relative z-10">
          <div>
            <p class="text-sm font-medium text-purple-100 mb-1">Active Tasks</p>
            <p ref="activeTasksRef" class="text-4xl font-bold text-white mt-2 animate-fade-in stagger-3">
              {{ displayStats.activeTasks }}
            </p>
          </div>
          <div class="w-16 h-16 bg-white/20 backdrop-blur-sm rounded-2xl flex items-center justify-center">
            <svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4" />
            </svg>
          </div>
        </div>
      </div>

      <!-- Overdue Tasks -->
      <div class="stat-card from-red-500 to-rose-700 animate-slide-up stagger-3" :class="{ 'animate-pulse-glow': stats.overdueTasks > 0 }">
        <div class="flex items-center justify-between relative z-10">
          <div>
            <p class="text-sm font-medium text-red-100 mb-1">Overdue Tasks</p>
            <p ref="overdueTasksRef" class="text-4xl font-bold text-white mt-2 animate-fade-in stagger-4">
              {{ displayStats.overdueTasks }}
            </p>
          </div>
          <div class="w-16 h-16 bg-white/20 backdrop-blur-sm rounded-2xl flex items-center justify-center">
            <svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          </div>
        </div>
      </div>
    </div>

    <!-- Charts Row with enhanced cards -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
      <!-- Asset Status Chart -->
      <div class="card animate-slide-up stagger-4">
        <div class="flex items-center justify-between mb-4">
          <h3 class="text-lg font-semibold text-secondary-900 dark:text-white flex items-center gap-2">
            <svg class="w-5 h-5 text-primary-600 dark:text-primary-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
            </svg>
            Asset Status
          </h3>
        </div>
        <div class="h-64 flex items-center justify-center">
          <canvas ref="assetChartCanvas"></canvas>
        </div>
      </div>

      <!-- Task Priority Chart -->
      <div class="card animate-slide-up stagger-5">
        <div class="flex items-center justify-between mb-4">
          <h3 class="text-lg font-semibold text-secondary-900 dark:text-white flex items-center gap-2">
            <svg class="w-5 h-5 text-purple-600 dark:text-purple-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6" />
            </svg>
            Tasks by Priority
          </h3>
        </div>
        <div class="h-64 flex items-center justify-center">
          <canvas ref="taskChartCanvas"></canvas>
        </div>
      </div>
    </div>

    <!-- Recent Tasks with improved layout -->
    <div class="card animate-slide-up stagger-6">
      <div class="flex items-center justify-between mb-4">
        <h3 class="text-lg font-semibold text-secondary-900 dark:text-white flex items-center gap-2">
          <svg class="w-5 h-5 text-green-600 dark:text-green-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
          Recent Tasks
        </h3>
      </div>
      <div v-if="loading" class="space-y-3">
        <!-- Loading Skeletons -->
        <div v-for="i in 3" :key="i" class="skeleton-shimmer h-20 rounded-lg"></div>
      </div>
      <div v-else-if="recentTasks.length === 0" class="text-center py-12">
        <svg class="w-16 h-16 mx-auto text-secondary-300 dark:text-secondary-600 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
        </svg>
        <p class="text-secondary-500 dark:text-secondary-400">No recent tasks</p>
      </div>
      <div v-else class="space-y-3">
        <div
          v-for="(task, index) in recentTasks"
          :key="task.id"
          class="flex items-center justify-between p-4 bg-gradient-to-r from-secondary-50 to-secondary-100 dark:from-secondary-700/30 dark:to-secondary-800/30 rounded-xl hover:shadow-md transition-all duration-200 hover:scale-[1.02] animate-slide-up"
          :class="`stagger-${Math.min(index + 1, 5)}`"
        >
          <div class="flex-1 min-w-0">
            <div class="flex items-start gap-3">
              <div class="flex-shrink-0 w-10 h-10 bg-primary-100 dark:bg-primary-900/30 rounded-lg flex items-center justify-center">
                <svg class="w-5 h-5 text-primary-600 dark:text-primary-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
              </div>
              <div class="flex-1 min-w-0">
                <p class="font-medium text-secondary-900 dark:text-white truncate">{{ task.task_description }}</p>
                <p class="text-sm text-secondary-600 dark:text-secondary-400 mt-1 flex items-center gap-1">
                  <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
                  </svg>
                  {{ task.asset?.asset_name || 'N/A' }}
                </p>
              </div>
            </div>
          </div>
          <div class="flex items-center gap-2 flex-shrink-0 ml-4">
            <span :class="`badge badge-${task.priority.toLowerCase()}`">
              {{ task.priority }}
            </span>
            <span :class="`badge badge-${task.status.toLowerCase().replace(' ', '-')}`">
              {{ task.status }}
            </span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { supabase } from '../utils/supabase'
import { Chart, registerables } from 'chart.js'

Chart.register(...registerables)

const assetChartCanvas = ref(null)
const taskChartCanvas = ref(null)
const loading = ref(true)
const recentTasks = ref([])

const totalAssetsRef = ref(null)
const activeTasksRef = ref(null)
const overdueTasksRef = ref(null)

const stats = ref({
  totalAssets: 0,
  activeTasks: 0,
  overdueTasks: 0
})

const displayStats = ref({
  totalAssets: 0,
  activeTasks: 0,
  overdueTasks: 0
})

let assetChart = null
let taskChart = null

// Animated count-up function
const animateCount = (targetRef, targetValue, duration = 1000) => {
  const startValue = 0
  const startTime = performance.now()
  
  const animate = (currentTime) => {
    const elapsed = currentTime - startTime
    const progress = Math.min(elapsed / duration, 1)
    
    const easeOut = 1 - Math.pow(1 - progress, 3)
    const currentValue = Math.floor(startValue + (targetValue - startValue) * easeOut)
    
    if (targetRef.value) {
      displayStats.value[targetRef.value.dataset.stat || 'totalAssets'] = currentValue
    }
    
    if (progress < 1) {
      requestAnimationFrame(animate)
    }
  }
  
  requestAnimationFrame(animate)
}

const fetchDashboardData = async () => {
  try {
    loading.value = true

    // Fetch assets count
    const { count: assetCount } = await supabase
      .from('assets')
      .select('*', { count: 'exact', head: true })

    stats.value.totalAssets = assetCount || 0

    // Fetch active tasks count
    const { count: activeTaskCount } = await supabase
      .from('maintenance_tasks')
      .select('*', { count: 'exact', head: true })
      .in('status', ['Pending', 'In Progress'])

    stats.value.activeTasks = activeTaskCount || 0

    // Fetch overdue tasks count
    const { count: overdueCount } = await supabase
      .from('maintenance_tasks')
      .select('*', { count: 'exact', head: true })
      .lt('scheduled_date', new Date().toISOString())
      .neq('status', 'Completed')

    stats.value.overdueTasks = overdueCount || 0

    // Animate the numbers
    setTimeout(() => {
      if (totalAssetsRef.value) {
        totalAssetsRef.value.dataset.stat = 'totalAssets'
        animateCount(totalAssetsRef, stats.value.totalAssets, 1200)
      }
      if (activeTasksRef.value) {
        activeTasksRef.value.dataset.stat = 'activeTasks'
        animateCount(activeTasksRef, stats.value.activeTasks, 1400)
      }
      if (overdueTasksRef.value) {
        overdueTasksRef.value.dataset.stat = 'overdueTasks'
        animateCount(overdueTasksRef, stats.value.overdueTasks, 1600)
      }
    }, 300)

    // Fetch recent tasks
    const { data: tasks } = await supabase
      .from('maintenance_tasks')
      .select(`
        *,
        asset:assets(asset_name)
      `)
      .order('created_at', { ascending: false })
      .limit(5)

    recentTasks.value = tasks || []

    // Fetch data for charts
    await createCharts()
  } catch (error) {
    console.error('Error fetching dashboard data:', error)
  } finally {
    loading.value = false
  }
}

const createCharts = async () => {
  // Asset Status Chart
  const { data: assets } = await supabase
    .from('assets')
    .select('status')

  const statusCounts = {
    Operational: 0,
    Maintenance: 0,
    Decommissioned: 0
  }

  assets?.forEach(asset => {
    statusCounts[asset.status] = (statusCounts[asset.status] || 0) + 1
  })

  if (assetChartCanvas.value) {
    assetChart = new Chart(assetChartCanvas.value, {
      type: 'doughnut',
      data: {
        labels: ['Operational', 'Maintenance', 'Decommissioned'],
        datasets: [{
          data: [statusCounts.Operational, statusCounts.Maintenance, statusCounts.Decommissioned],
          backgroundColor: [
            'rgba(16, 185, 129, 0.8)',
            'rgba(245, 158, 11, 0.8)',
            'rgba(107, 114, 128, 0.8)'
          ],
          borderWidth: 0,
          borderRadius: 8
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: 'bottom',
            labels: {
              padding: 15,
              usePointStyle: true,
              pointStyle: 'circle'
            }
          }
        },
        cutout: '70%'
      }
    })
  }

  // Task Priority Chart
  const { data: tasks } = await supabase
    .from('maintenance_tasks')
    .select('priority')

  const priorityCounts = {
    Low: 0,
    Medium: 0,
    High: 0
  }

  tasks?.forEach(task => {
    priorityCounts[task.priority] = (priorityCounts[task.priority] || 0) + 1
  })

  if (taskChartCanvas.value) {
    taskChart = new Chart(taskChartCanvas.value, {
      type: 'bar',
      data: {
        labels: ['Low', 'Medium', 'High'],
        datasets: [{
          label: 'Tasks',
          data: [priorityCounts.Low, priorityCounts.Medium, priorityCounts.High],
          backgroundColor: [
            'rgba(107, 114, 128, 0.8)',
            'rgba(245, 158, 11, 0.8)',
            'rgba(239, 68, 68, 0.8)'
          ],
          borderRadius: 8,
          borderSkipped: false
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            display: false
          }
        },
        scales: {
          y: {
            beginAtZero: true,
            ticks: {
              stepSize: 1
            },
            grid: {
              display: true,
              color: 'rgba(0, 0, 0, 0.05)'
            }
          },
          x: {
            grid: {
              display: false
            }
          }
        }
      }
    })
  }
}

onMounted(() => {
  fetchDashboardData()
})

onUnmounted(() => {
  if (assetChart) assetChart.destroy()
  if (taskChart) taskChart.destroy()
})
</script>
