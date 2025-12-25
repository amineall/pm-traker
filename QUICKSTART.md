# Quick Start Guide

## Prerequisites
- Node.js v16+ installed
- Supabase account created
- Git (optional)

## Step 1: Database Setup

1. Go to [Supabase Dashboard](https://app.supabase.com)
2. Navigate to **SQL Editor**
3. Run these migration files in order:
   - Copy content from `database/migrations/001_create_tables.sql` → Execute
   - Copy content from `database/migrations/002_enable_rls.sql` → Execute
   - Copy content from `database/migrations/003_enable_realtime.sql` → Execute

4. Enable Realtime:
   - Go to **Database** → **Replication**
   - Find `maintenance_tasks` table
   - Toggle ON
   - Select events: INSERT, UPDATE, DELETE

## Step 2: Get Supabase Credentials

1. In Supabase Dashboard, go to **Settings** → **API**
2. Copy these values:
   - **Project URL** (e.g., `https://xxxxx.supabase.co`)
   - **anon public** key (safe for frontend)
   - **service_role** key (keep secret, for backend only)

## Step 3: Configure Frontend

```bash
cd frontend

# Install dependencies
npm install

# Create .env file
copy .env.example .env

# Edit .env and add your Supabase credentials:
# VITE_SUPABASE_URL=https://gttgonubdhkbujhknqkq.supabase.co
# VITE_SUPABASE_ANON_KEY=your_anon_public_key_here
# VITE_API_URL=http://localhost:3000

# Start development server
npm run dev
```

Frontend will be available at: **http://localhost:5173**

## Step 4: Configure Backend (Optional)

The backend is optional since most operations use Supabase directly.

```bash
cd backend

# Install dependencies
npm install

# The .env file is already configured with your database URL
# Just add the service key if you need server-side operations

# Start development server
npm run dev
```

Backend will be available at: **http://localhost:3000**

## Step 5: Create First Admin User

1. Open the frontend: http://localhost:5173
2. Click **Sign up**
3. Fill in the form:
   - Full Name: Your Name
   - Email: your@email.com
   - Password: (minimum 6 characters)
   - Role: **Admin**
4. Click **Sign Up**

5. **Important**: Check your email for confirmation link from Supabase
   - If email confirmation is disabled in Supabase, you can skip this
   - To disable: Supabase Dashboard → Authentication → Settings → Email Auth → Disable "Confirm email"

6. After confirming (or if disabled), you can login!

## Step 6: Start Using the App

1. **Login** with your credentials
2. **Dashboard**: View stats and charts
3. **Assets**: Add your first production asset
4. **Tasks**: Create a maintenance task
5. **Users** (Admin only): Manage user roles

## Troubleshooting

### Can't login after signup?
- Check if email confirmation is required in Supabase settings
- Check browser console for errors
- Verify Supabase credentials in `.env` are correct

### Database errors?
- Ensure all 3 migration scripts ran successfully
- Check that RLS is enabled on all tables
- Verify database URL is correct

### Charts not showing?
- Open browser console to check for errors
- Ensure Chart.js is installed: `npm list chart.js`
- Try refreshing the page

### Realtime not working?
- Verify Realtime is enabled for `maintenance_tasks` in Supabase Dashboard
- Check browser console for subscription errors
- Ensure you're using the correct Supabase URL

## Next Steps

1. **Create more users** with different roles (Manager, Technician)
2. **Add sample data** (assets and tasks)
3. **Test permissions** by logging in as different roles
4. **Customize** the theme colors in `tailwind.config.js`
5. **Deploy** to production (see README.md for deployment guide)

## Need Help?

- Check the [README.md](./README.md) for detailed documentation
- Review the [walkthrough.md](./walkthrough.md) for implementation details
- Check the [database/README.md](./database/README.md) for database schema info

---

**Enjoy your Production & Maintenance Tracker! 🚀**
