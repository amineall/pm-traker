-- Migration 004: Create get_users_with_email function

CREATE OR REPLACE FUNCTION get_users_with_email()
RETURNS TABLE (
  id UUID,
  full_name VARCHAR,
  role VARCHAR,
  email VARCHAR
)
SECURITY DEFINER
SET search_path = public, auth
AS $$
BEGIN
  -- Check if the requesting user is an Admin
  IF NOT EXISTS (
    SELECT 1 FROM public.user_profiles up
    WHERE up.id = auth.uid() AND up.role = 'Admin'
  ) THEN
    RAISE EXCEPTION 'Access denied. Only Admins can view user list.';
  END IF;

  RETURN QUERY
  SELECT 
    p.id,
    p.full_name,
    p.role,
    u.email::VARCHAR
  FROM public.user_profiles p
  JOIN auth.users u ON p.id = u.id
  ORDER BY p.full_name;
END;
$$ LANGUAGE plpgsql;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION get_users_with_email TO authenticated;
