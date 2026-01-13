# Supabase Setup Guide for BlueNexus

## Prerequisites
- Supabase account at https://supabase.com
- Your Supabase project created

## Configuration

### 1. Get your Supabase credentials

From your Supabase dashboard:
1. Go to Project Settings > API
2. Copy the **Project URL** and **anon public key**
3. Update `lib/main.dart`:

```dart
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',  // e.g., https://guwuszjpjvlnqglcrbvh.supabase.co
  anonKey: 'YOUR_SUPABASE_ANON_KEY',  // From API settings
);
```

### 2. Create Database Tables

Go to SQL Editor in Supabase Dashboard and run the following SQL:

```sql
-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table
CREATE TABLE users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT,
  nickname TEXT NOT NULL DEFAULT 'Diver',
  profile_image_url TEXT,
  crew_id UUID,
  leaf_points INTEGER DEFAULT 0,
  cert_level TEXT,
  is_verified BOOLEAN DEFAULT FALSE,
  badges TEXT[] DEFAULT '{}',
  species_collected TEXT[] DEFAULT '{}',
  total_dives INTEGER DEFAULT 0,
  total_eco_score INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Users policies
CREATE POLICY "Users can view their own profile" ON users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile" ON users
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert their own profile" ON users
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Dive logs table
CREATE TABLE dive_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
  dive_number INTEGER,
  dive_date TIMESTAMPTZ NOT NULL,
  entry_time TIMESTAMPTZ,
  exit_time TIMESTAMPTZ,
  dive_site TEXT,
  location TEXT,
  country TEXT,
  geo_point JSONB, -- {lat: number, lng: number}
  max_depth DECIMAL,
  avg_depth DECIMAL,
  bottom_time INTEGER, -- in minutes
  surface_interval INTEGER, -- in minutes
  water_temp DECIMAL,
  visibility TEXT,
  current TEXT,
  waves TEXT,
  dive_type TEXT,
  gas_type TEXT,
  tank_size DECIMAL,
  start_pressure DECIMAL,
  end_pressure DECIMAL,
  sac_rate DECIMAL,
  notes TEXT,
  buddy_name TEXT,
  is_public BOOLEAN DEFAULT FALSE,
  photo_urls TEXT[] DEFAULT '{}',
  telemetry_data_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE dive_logs ENABLE ROW LEVEL SECURITY;

-- Dive logs policies
CREATE POLICY "Users can view their own dive logs" ON dive_logs
  FOR SELECT USING (auth.uid() = user_id OR is_public = true);

CREATE POLICY "Users can insert their own dive logs" ON dive_logs
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own dive logs" ON dive_logs
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own dive logs" ON dive_logs
  FOR DELETE USING (auth.uid() = user_id);

-- Eco logs table
CREATE TABLE eco_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
  dive_log_id UUID REFERENCES dive_logs(id) ON DELETE SET NULL,
  photo_url TEXT NOT NULL,
  location JSONB, -- {lat: number, lng: number}
  location_name TEXT,
  detected_items JSONB DEFAULT '[]', -- [{type, count, points, confidence}]
  total_points INTEGER DEFAULT 0,
  ai_verification_status TEXT DEFAULT 'pending', -- pending, verified, rejected
  ai_verification_notes TEXT,
  verified_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE eco_logs ENABLE ROW LEVEL SECURITY;

-- Eco logs policies
CREATE POLICY "Users can view their own eco logs" ON eco_logs
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own eco logs" ON eco_logs
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Crews table
CREATE TABLE crews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT,
  leader_id UUID REFERENCES users(id) ON DELETE SET NULL,
  profile_image_url TEXT,
  region TEXT,
  total_members INTEGER DEFAULT 1,
  total_dives INTEGER DEFAULT 0,
  total_eco_points INTEGER DEFAULT 0,
  tier TEXT DEFAULT 'none', -- none, bronze, silver, gold
  point_multiplier DECIMAL DEFAULT 1.0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE crews ENABLE ROW LEVEL SECURITY;

-- Crews policies
CREATE POLICY "Anyone can view crews" ON crews
  FOR SELECT USING (true);

CREATE POLICY "Leaders can update their crews" ON crews
  FOR UPDATE USING (auth.uid() = leader_id);

CREATE POLICY "Authenticated users can create crews" ON crews
  FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);

-- Crew members table
CREATE TABLE crew_members (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  crew_id UUID REFERENCES crews(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
  role TEXT DEFAULT 'member', -- leader, admin, member
  joined_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(crew_id, user_id)
);

-- Enable RLS
ALTER TABLE crew_members ENABLE ROW LEVEL SECURITY;

-- Crew members policies
CREATE POLICY "Anyone can view crew members" ON crew_members
  FOR SELECT USING (true);

CREATE POLICY "Leaders can manage crew members" ON crew_members
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM crews WHERE id = crew_members.crew_id AND leader_id = auth.uid()
    )
  );

-- Certifications table
CREATE TABLE certifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
  agency TEXT NOT NULL, -- PADI, SSI, NAUI, CMAS, etc.
  level TEXT NOT NULL, -- OW, AOW, Rescue, etc.
  certification_number TEXT,
  issue_date DATE,
  expiry_date DATE,
  is_verified BOOLEAN DEFAULT FALSE,
  verification_status TEXT DEFAULT 'pending', -- pending, verified, rejected
  card_image_url TEXT,
  ocr_raw_data JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE certifications ENABLE ROW LEVEL SECURITY;

-- Certifications policies
CREATE POLICY "Users can view their own certifications" ON certifications
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can manage their own certifications" ON certifications
  FOR ALL USING (auth.uid() = user_id);

-- Marine species table (reference data)
CREATE TABLE marine_species (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  korean_name TEXT NOT NULL,
  english_name TEXT,
  scientific_name TEXT,
  category TEXT, -- fish, coral, invertebrate, mammal, etc.
  rarity TEXT DEFAULT 'common', -- common, uncommon, rare, legendary
  description TEXT,
  habitat TEXT,
  max_size TEXT,
  depth_range TEXT,
  conservation_status TEXT,
  badge_points INTEGER DEFAULT 5,
  image_url TEXT,
  common_locations TEXT[] DEFAULT '{}'
);

-- Enable RLS (read-only for users)
ALTER TABLE marine_species ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view marine species" ON marine_species
  FOR SELECT USING (true);

-- Marine sightings table
CREATE TABLE marine_sightings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
  species_id UUID REFERENCES marine_species(id) ON DELETE CASCADE NOT NULL,
  dive_log_id UUID REFERENCES dive_logs(id) ON DELETE SET NULL,
  photo_url TEXT,
  location JSONB,
  ai_confidence DECIMAL,
  notes TEXT,
  sighted_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE marine_sightings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own sightings" ON marine_sightings
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can manage their own sightings" ON marine_sightings
  FOR ALL USING (auth.uid() = user_id);

-- Point transactions table
CREATE TABLE point_transactions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
  amount INTEGER NOT NULL,
  transaction_type TEXT NOT NULL, -- earn, spend, crew_bonus, admin_adjustment
  source_type TEXT, -- eco_log, species_sighting, crew_activity, reward_redemption
  source_id UUID,
  description TEXT,
  crew_id UUID REFERENCES crews(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE point_transactions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own transactions" ON point_transactions
  FOR SELECT USING (auth.uid() = user_id);

-- Create trigger function to auto-create user profile
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, nickname)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'nickname', 'Diver')
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger for new user signup
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- Create indexes for better performance
CREATE INDEX idx_dive_logs_user_id ON dive_logs(user_id);
CREATE INDEX idx_dive_logs_dive_date ON dive_logs(dive_date DESC);
CREATE INDEX idx_eco_logs_user_id ON eco_logs(user_id);
CREATE INDEX idx_certifications_user_id ON certifications(user_id);
CREATE INDEX idx_crew_members_crew_id ON crew_members(crew_id);
CREATE INDEX idx_crew_members_user_id ON crew_members(user_id);
CREATE INDEX idx_marine_sightings_user_id ON marine_sightings(user_id);
CREATE INDEX idx_point_transactions_user_id ON point_transactions(user_id);
```

### 3. Enable Authentication

In Supabase Dashboard:
1. Go to Authentication > Providers
2. Enable **Email** provider
3. (Optional) Enable **Google** provider for social login

### 4. Storage Setup (for images)

1. Go to Storage in Supabase Dashboard
2. Create buckets:
   - `avatars` - for user profile images
   - `dive-photos` - for dive log photos
   - `eco-photos` - for eco verification photos
   - `cert-images` - for certification card images

3. Set bucket policies for each (example for avatars):
```sql
CREATE POLICY "Avatar images are publicly accessible"
ON storage.objects FOR SELECT
USING (bucket_id = 'avatars');

CREATE POLICY "Users can upload their own avatar"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'avatars' AND
  auth.uid()::text = (storage.foldername(name))[1]
);
```

## Running the App

```bash
cd C:\Users\chois\bluenexus
flutter run
```

## Notes

- Make sure to keep your anon key secure (it can be public but don't expose service role key)
- For production, consider using environment variables for credentials
- The RLS policies ensure users can only access their own data
