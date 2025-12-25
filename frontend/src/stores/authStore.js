import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { supabase } from '../utils/supabase'

export const useAuthStore = defineStore('auth', () => {
    const user = ref(null)
    const userProfile = ref(null)
    const loading = ref(true)

    const isAuthenticated = computed(() => !!user.value)
    const userRole = computed(() => userProfile.value?.role || null)
    const isAdmin = computed(() => userRole.value === 'Admin')
    const isManager = computed(() => userRole.value === 'Manager')
    const isTechnician = computed(() => userRole.value === 'Technician')

    async function initAuth() {
        try {
            loading.value = true
            const { data: { session } } = await supabase.auth.getSession()

            if (session?.user) {
                user.value = session.user
                await fetchUserProfile(session.user.id)
            }

            supabase.auth.onAuthStateChange(async (event, session) => {
                user.value = session?.user || null

                if (session?.user) {
                    await fetchUserProfile(session.user.id)
                } else {
                    userProfile.value = null
                }
            })
        } catch (error) {
            console.error('Error initializing auth:', error)
        } finally {
            loading.value = false
        }
    }

    async function fetchUserProfile(userId) {
        try {
            const { data, error } = await supabase
                .from('user_profiles')
                .select('*')
                .eq('id', userId)
                .single()

            if (error) throw error
            userProfile.value = data
        } catch (error) {
            console.error('Error fetching user profile:', error)
        }
    }

    async function signIn(email, password) {
        try {
            const { data, error } = await supabase.auth.signInWithPassword({
                email,
                password
            })

            if (error) throw error
            return { data, error: null }
        } catch (error) {
            return { data: null, error }
        }
    }

    async function signUp(email, password, fullName, role = 'Technician') {
        try {
            const { data, error } = await supabase.auth.signUp({
                email,
                password,
                options: {
                    data: {
                        full_name: fullName,
                        role: role
                    }
                }
            })

            if (error) throw error
            return { data, error: null }
        } catch (error) {
            return { data: null, error }
        }
    }

    async function signOut() {
        try {
            const { error } = await supabase.auth.signOut()
            if (error) throw error
            user.value = null
            userProfile.value = null
            return { error: null }
        } catch (error) {
            console.error('Error signing out:', error)
            throw error
        }
    }

    return {
        user,
        userProfile,
        loading,
        isAuthenticated,
        userRole,
        isAdmin,
        isManager,
        isTechnician,
        initAuth,
        signIn,
        signUp,
        signOut,
        fetchUserProfile
    }
})
