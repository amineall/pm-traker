-- Production & Maintenance Tracker Database Schema
-- Migration 001: Create Tables

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- USER PROFILES TABLE
-- =====================================================
-- Links Supabase Auth users to custom roles
CREATE TABLE IF NOT EXISTS user_profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name VARCHAR(255),
  role VARCHAR(50) NOT NULL DEFAULT 'Technician',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT valid_role CHECK (role IN ('Admin', 'Manager', 'Technician'))
);

-- Create index on role for faster queries
CREATE INDEX idx_user_profiles_role ON user_profiles(role);

-- =====================================================
-- ASSETS TABLE
-- =====================================================
-- Physical production assets (machines, equipment)
CREATE TABLE IF NOT EXISTS assets (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  asset_name VARCHAR(255) NOT NULL,
  serial_number VARCHAR(255) UNIQUE,
  status VARCHAR(50) NOT NULL DEFAULT 'Operational',
  location VARCHAR(100),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  created_by UUID REFERENCES user_profiles(id),
  CONSTRAINT valid_status CHECK (status IN ('Operational', 'Maintenance', 'Decommissioned'))
);

-- Create indexes for common queries
CREATE INDEX idx_assets_status ON assets(status);
CREATE INDEX idx_assets_location ON assets(location);
CREATE INDEX idx_assets_serial_number ON assets(serial_number);

-- =====================================================
-- MAINTENANCE TASKS TABLE
-- =====================================================
-- Scheduled or reactive maintenance activities
CREATE TABLE IF NOT EXISTS maintenance_tasks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  asset_id UUID NOT NULL REFERENCES assets(id) ON DELETE CASCADE,
  task_description TEXT NOT NULL,
  scheduled_date TIMESTAMPTZ,
  completed_date TIMESTAMPTZ,
  assigned_user_id UUID REFERENCES user_profiles(id) ON DELETE SET NULL,
  priority VARCHAR(20) NOT NULL DEFAULT 'Medium',
  status VARCHAR(50) NOT NULL DEFAULT 'Pending',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  created_by UUID REFERENCES user_profiles(id),
  CONSTRAINT valid_priority CHECK (priority IN ('Low', 'Medium', 'High')),
  CONSTRAINT valid_task_status CHECK (status IN ('Pending', 'In Progress', 'Completed'))
);

-- Create indexes for common queries
CREATE INDEX idx_maintenance_tasks_asset_id ON maintenance_tasks(asset_id);
CREATE INDEX idx_maintenance_tasks_assigned_user_id ON maintenance_tasks(assigned_user_id);
CREATE INDEX idx_maintenance_tasks_status ON maintenance_tasks(status);
CREATE INDEX idx_maintenance_tasks_priority ON maintenance_tasks(priority);
CREATE INDEX idx_maintenance_tasks_scheduled_date ON maintenance_tasks(scheduled_date);

-- =====================================================
-- TRIGGERS FOR UPDATED_AT
-- =====================================================
-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply trigger to all tables
CREATE TRIGGER update_user_profiles_updated_at
  BEFORE UPDATE ON user_profiles
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_assets_updated_at
  BEFORE UPDATE ON assets
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_maintenance_tasks_updated_at
  BEFORE UPDATE ON maintenance_tasks
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- FUNCTION TO AUTO-CREATE USER PROFILE
-- =====================================================
-- Automatically create user_profile when a new user signs up
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.user_profiles (id, full_name, role)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email),
    COALESCE(NEW.raw_user_meta_data->>'role', 'Technician')
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to create user profile on signup
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();
