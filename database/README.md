# Database Schema Documentation

This directory contains the database schema and migration scripts for the Production & Maintenance Tracker application.

## Database Structure

### Tables

#### `user_profiles`
Links Supabase Auth users to custom application roles.

**Fields:**
- `id` (UUID, PK): References auth.users(id)
- `full_name` (VARCHAR): User's full name
- `role` (VARCHAR): User role - 'Admin', 'Manager', or 'Technician'
- `created_at`, `updated_at` (TIMESTAMPTZ): Timestamps

#### `assets`
Physical production assets (machines, equipment).

**Fields:**
- `id` (UUID, PK): Auto-generated
- `asset_name` (VARCHAR): Name of the asset
- `serial_number` (VARCHAR, UNIQUE): Serial number
- `status` (VARCHAR): 'Operational', 'Maintenance', or 'Decommissioned'
- `location` (VARCHAR): Physical location
- `created_by` (UUID, FK): User who created the asset
- `created_at`, `updated_at` (TIMESTAMPTZ): Timestamps

#### `maintenance_tasks`
Scheduled or reactive maintenance activities.

**Fields:**
- `id` (UUID, PK): Auto-generated
- `asset_id` (UUID, FK): References assets(id)
- `task_description` (TEXT): Description of the task
- `scheduled_date` (TIMESTAMPTZ): When task is scheduled
- `completed_date` (TIMESTAMPTZ): When task was completed
- `assigned_user_id` (UUID, FK): User assigned to the task
- `priority` (VARCHAR): 'Low', 'Medium', or 'High'
- `status` (VARCHAR): 'Pending', 'In Progress', or 'Completed'
- `created_by` (UUID, FK): User who created the task
- `created_at`, `updated_at` (TIMESTAMPTZ): Timestamps

## Row-Level Security (RLS) Policies

### Admin Role
- **Full access** to all tables
- Can create, read, update, and delete all records
- Can manage user roles

### Manager Role
- **Assets**: Full CRUD access
- **Tasks**: Full CRUD access
- **Users**: Read-only access to user profiles

### Technician Role
- **Assets**: Read-only access
- **Tasks**: Can only view and update tasks assigned to them
- **Users**: Can view and update their own profile only

## Migration Files

Run these SQL scripts in order on your Supabase database:

1. **001_create_tables.sql**: Creates all tables, indexes, and triggers
2. **002_enable_rls.sql**: Enables Row-Level Security and creates policies
3. **003_enable_realtime.sql**: Enables Realtime for maintenance_tasks

## Running Migrations

### Option 1: Supabase Dashboard
1. Go to your Supabase project dashboard
2. Navigate to SQL Editor
3. Copy and paste each migration file in order
4. Execute each script

### Option 2: Supabase CLI
```bash
# Install Supabase CLI if not already installed
npm install -g supabase

# Login to Supabase
supabase login

# Link to your project
supabase link --project-ref your-project-ref

# Run migrations
supabase db push
```

### Option 3: Direct PostgreSQL Connection
```bash
psql "postgresql://postgres.gttgonubdhkbujhknqkq:amineallagui1@aws-1-eu-west-1.pooler.supabase.com:6543/postgres" -f 001_create_tables.sql
psql "postgresql://postgres.gttgonubdhkbujhknqkq:amineallagui1@aws-1-eu-west-1.pooler.supabase.com:6543/postgres" -f 002_enable_rls.sql
psql "postgresql://postgres.gttgonubdhkbujhknqkq:amineallagui1@aws-1-eu-west-1.pooler.supabase.com:6543/postgres" -f 003_enable_realtime.sql
```

## Testing RLS Policies

After running migrations, test the RLS policies:

1. Create test users with different roles (Admin, Manager, Technician)
2. Try to perform various operations with each role
3. Verify that permissions are enforced correctly

## Realtime Configuration

After running the migrations, you may need to enable Realtime in the Supabase Dashboard:

1. Go to **Database** > **Replication**
2. Find the `maintenance_tasks` table
3. Enable replication
4. Select events: INSERT, UPDATE, DELETE

This allows the frontend to receive real-time updates when tasks are created or modified.
