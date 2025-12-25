-- Production & Maintenance Tracker Database Schema
-- Migration 002: Enable Row-Level Security (RLS)

-- =====================================================
-- ENABLE RLS ON ALL TABLES
-- =====================================================
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE assets ENABLE ROW LEVEL SECURITY;
ALTER TABLE maintenance_tasks ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- HELPER FUNCTION: Get User Role
-- =====================================================
CREATE OR REPLACE FUNCTION public.get_user_role(user_id UUID)
RETURNS VARCHAR AS $$
  SELECT role FROM public.user_profiles WHERE id = user_id;
$$ LANGUAGE SQL SECURITY DEFINER;

-- =====================================================
-- USER_PROFILES RLS POLICIES
-- =====================================================

-- Admin can view all user profiles
CREATE POLICY "Admins can view all user profiles"
  ON user_profiles FOR SELECT
  TO authenticated
  USING (get_user_role(auth.uid()) = 'Admin');

-- Users can view their own profile
CREATE POLICY "Users can view own profile"
  ON user_profiles FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

-- Admin can update any user profile (including role changes)
CREATE POLICY "Admins can update all user profiles"
  ON user_profiles FOR UPDATE
  TO authenticated
  USING (get_user_role(auth.uid()) = 'Admin');

-- Users can update their own profile (except role)
CREATE POLICY "Users can update own profile"
  ON user_profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (
    auth.uid() = id AND
    role = (SELECT role FROM user_profiles WHERE id = auth.uid())
  );

-- Admin can insert user profiles
CREATE POLICY "Admins can insert user profiles"
  ON user_profiles FOR INSERT
  TO authenticated
  WITH CHECK (get_user_role(auth.uid()) = 'Admin');

-- Allow new users to create their own profile (via trigger)
CREATE POLICY "Users can insert own profile"
  ON user_profiles FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

-- =====================================================
-- ASSETS RLS POLICIES
-- =====================================================

-- Everyone can view assets (Technicians need read access)
CREATE POLICY "Authenticated users can view assets"
  ON assets FOR SELECT
  TO authenticated
  USING (true);

-- Admin and Manager can create assets
CREATE POLICY "Admins and Managers can create assets"
  ON assets FOR INSERT
  TO authenticated
  WITH CHECK (
    get_user_role(auth.uid()) IN ('Admin', 'Manager')
  );

-- Admin and Manager can update assets
CREATE POLICY "Admins and Managers can update assets"
  ON assets FOR UPDATE
  TO authenticated
  USING (
    get_user_role(auth.uid()) IN ('Admin', 'Manager')
  );

-- Only Admin can delete assets
CREATE POLICY "Admins can delete assets"
  ON assets FOR DELETE
  TO authenticated
  USING (get_user_role(auth.uid()) = 'Admin');

-- =====================================================
-- MAINTENANCE_TASKS RLS POLICIES
-- =====================================================

-- Admin and Manager can view all tasks
CREATE POLICY "Admins and Managers can view all tasks"
  ON maintenance_tasks FOR SELECT
  TO authenticated
  USING (
    get_user_role(auth.uid()) IN ('Admin', 'Manager')
  );

-- Technicians can only view tasks assigned to them
CREATE POLICY "Technicians can view assigned tasks"
  ON maintenance_tasks FOR SELECT
  TO authenticated
  USING (
    get_user_role(auth.uid()) = 'Technician' AND
    assigned_user_id = auth.uid()
  );

-- Admin and Manager can create tasks
CREATE POLICY "Admins and Managers can create tasks"
  ON maintenance_tasks FOR INSERT
  TO authenticated
  WITH CHECK (
    get_user_role(auth.uid()) IN ('Admin', 'Manager')
  );

-- Admin and Manager can update any task
CREATE POLICY "Admins and Managers can update all tasks"
  ON maintenance_tasks FOR UPDATE
  TO authenticated
  USING (
    get_user_role(auth.uid()) IN ('Admin', 'Manager')
  );

-- Technicians can only update status and completed_date of their assigned tasks
CREATE POLICY "Technicians can update assigned tasks"
  ON maintenance_tasks FOR UPDATE
  TO authenticated
  USING (
    get_user_role(auth.uid()) = 'Technician' AND
    assigned_user_id = auth.uid()
  )
  WITH CHECK (
    get_user_role(auth.uid()) = 'Technician' AND
    assigned_user_id = auth.uid()
  );

-- Admin and Manager can delete tasks
CREATE POLICY "Admins and Managers can delete tasks"
  ON maintenance_tasks FOR DELETE
  TO authenticated
  USING (
    get_user_role(auth.uid()) IN ('Admin', 'Manager')
  );
