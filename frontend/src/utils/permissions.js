/**
 * Permission utility functions for role-based access control
 */

export const permissions = {
    // Asset permissions
    canViewAssets: (role) => {
        return ['Admin', 'Manager', 'Technician'].includes(role)
    },

    canCreateAsset: (role) => {
        return ['Admin', 'Manager'].includes(role)
    },

    canEditAsset: (role) => {
        return ['Admin', 'Manager'].includes(role)
    },

    canDeleteAsset: (role) => {
        return role === 'Admin'
    },

    // Task permissions
    canViewAllTasks: (role) => {
        return ['Admin', 'Manager'].includes(role)
    },

    canViewOwnTasks: (role) => {
        return role === 'Technician'
    },

    canCreateTask: (role) => {
        return ['Admin', 'Manager'].includes(role)
    },

    canEditTask: (role, task, userId) => {
        if (['Admin', 'Manager'].includes(role)) {
            return true
        }
        // Technicians can only edit their assigned tasks
        if (role === 'Technician' && task.assigned_user_id === userId) {
            return true
        }
        return false
    },

    canDeleteTask: (role) => {
        return ['Admin', 'Manager'].includes(role)
    },

    // User management permissions
    canViewAllUsers: (role) => {
        return role === 'Admin'
    },

    canEditUserRole: (role) => {
        return role === 'Admin'
    }
}

// Helper function to check if user has permission
export function hasPermission(permission, ...args) {
    if (typeof permissions[permission] === 'function') {
        return permissions[permission](...args)
    }
    return false
}
