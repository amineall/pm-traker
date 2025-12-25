import { ref, computed } from 'vue'
import { supabase } from '../utils/supabase'

const user = ref(null)
const userProfile = ref(null)
const loading = ref(true)

export function useAuth() {
    const isAuthenticated = computed(() => !!user.value)
    const userRole = computed(() => userProfile.value?.role || null)
    const isAdmin = computed(() => userRole.value === 'Admin')
    const isManager = computed(() => userRole.value === 'Manager')
    const isTechnician = computed(() => userRole.value === 'Technician')

    // Initialize auth state
    const initAuth = async () => {
        try {
            loading.value = true
            const { data: { session } } = await supabase.auth.getSession()

            if (session?.user) {
                user.value = session.user
                await fetchUserProfile(session.user.id)
            }

            // Listen for auth changes
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

    // Fetch user profile with role
    const fetchUserProfile = async (userId) => {
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

    // Sign up
    const signUp = async (email, password, fullName, role = 'Technician') => {
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
            console.error('Error signing up:', error)
            return { data: null, error }
        }
    }

    // Sign in
    const signIn = async (email, password) => {
        try {
            const { data, error } = await supabase.auth.signInWithPassword({
                email,
                password
            })

            if (error) throw error
            return { data, error: null }
        } catch (error) {
            console.error('Error signing in:', error)
            return { data: null, error }
        }
    }

    // Sign out
    const signOut = async () => {
        try {
            const { error } = await supabase.auth.signOut()
            if (error) throw error
            user.value = null
            userProfile.value = null
        } catch (error) {
            console.error('Error signing out:', error)
        }
    }

    // Update user profile
    const updateProfile = async (updates) => {
        try {
            const { data, error } = await supabase
                .from('user_profiles')
                .update(updates)
                .eq('id', user.value.id)
                .select()
                .single()

            if (error) throw error
            userProfile.value = data
            return { data, error: null }
        } catch (error) {
            console.error('Error updating profile:', error)
            return { data: null, error }
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
        signUp,
        signIn,
        signOut,
        updateProfile,
        fetchUserProfile
    }
}
