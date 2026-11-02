
-- Create a table for tracking profile downloads (horoscope, etc.)
CREATE TABLE IF NOT EXISTS profile_downloads (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id),
  profile_id UUID REFERENCES profiles(id),
  download_type TEXT, -- 'horoscope', 'contact_view', etc.
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE profile_downloads ENABLE ROW LEVEL SECURITY;

-- Policy to allow users to insert their own download records
DROP POLICY IF EXISTS "Users can insert their own downloads" ON profile_downloads;
CREATE POLICY "Users can insert their own downloads"
ON profile_downloads FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- Policy to allow users to view their own download records (for limit checking)
DROP POLICY IF EXISTS "Users can view their own downloads" ON profile_downloads;
CREATE POLICY "Users can view their own downloads"
ON profile_downloads FOR SELECT
USING (auth.uid() = user_id);
