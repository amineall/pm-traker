-- Production & Maintenance Tracker Database Schema
-- Migration 003: Enable Realtime

-- =====================================================
-- ENABLE REALTIME FOR MAINTENANCE_TASKS
-- =====================================================

-- Enable realtime for maintenance_tasks table
ALTER PUBLICATION supabase_realtime ADD TABLE maintenance_tasks;

-- Note: You may also need to enable this in the Supabase Dashboard:
-- 1. Go to Database > Replication
-- 2. Enable replication for the maintenance_tasks table
-- 3. Select the events you want to listen to (INSERT, UPDATE, DELETE)
