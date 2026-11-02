-- Create a table for user profiles
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  full_name TEXT,
  gender TEXT,
  date_of_birth DATE,
  marital_status TEXT,
  religion TEXT,
  mother_tongue TEXT,
  caste TEXT,
  sub_caste TEXT,
  gothram TEXT,
  country TEXT,
  state TEXT,
  city TEXT,
  highest_education TEXT,
  occupation TEXT,
  company_name TEXT,
  annual_income TEXT,
  fathers_occupation TEXT,
  mothers_occupation TEXT,
  number_of_siblings INT,
  family_values TEXT,
  about_me TEXT,
  profile_picture TEXT, -- URL to storage
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create a table for partner preferences
CREATE TABLE preferences (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  partner_age_from INT,
  partner_age_to INT,
  partner_marital_status TEXT,
  partner_religion TEXT,
  partner_mother_tongue TEXT,
  partner_caste TEXT,
  partner_country TEXT,
  partner_state TEXT,
  partner_city TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create a table for interests (who expressed interest in whom)
CREATE TABLE interests (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  sender_id UUID REFERENCES profiles(id),
  receiver_id UUID REFERENCES profiles(id),
  status TEXT DEFAULT 'pending', -- 'pending', 'accepted', 'rejected'
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create a table for messages
CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  sender_id UUID REFERENCES profiles(id),
  receiver_id UUID REFERENCES profiles(id),
  content TEXT,
  sent_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security (RLS) for privacy
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE preferences ENABLE ROW LEVEL SECURITY;
ALTER TABLE interests ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

-- Create policies for profiles table
CREATE POLICY "Public profiles are viewable by everyone."
  ON profiles FOR SELECT
  USING (true);

CREATE POLICY "Users can insert their own profile."
  ON profiles FOR INSERT
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update their own profile."
  ON profiles FOR UPDATE
  USING (auth.uid() = id);

-- Create policies for preferences table
CREATE POLICY "User preferences are viewable by authenticated users."
  ON preferences FOR SELECT
  USING (auth.uid() IS NOT NULL);

CREATE POLICY "Users can insert their own preferences."
  ON preferences FOR INSERT
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update their own preferences."
  ON preferences FOR UPDATE
  USING (auth.uid() = id);

-- Create policies for interests table
CREATE POLICY "Users can send interests."
  ON interests FOR INSERT
  WITH CHECK (auth.uid() = sender_id);

CREATE POLICY "Users can view their sent/received interests."
  ON interests FOR SELECT
  USING (auth.uid() = sender_id OR auth.uid() = receiver_id);

CREATE POLICY "Users can update their received interests (accept/reject)."
  ON interests FOR UPDATE
  USING (auth.uid() = receiver_id);

-- Create policies for messages table
CREATE POLICY "Users can send messages."
  ON messages FOR INSERT
  WITH CHECK (auth.uid() = sender_id);

CREATE POLICY "Users can view their messages."
  ON messages FOR SELECT
  USING (auth.uid() = sender_id OR auth.uid() = receiver_id);
