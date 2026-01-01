-- My Sea Database Schema
-- 게이미피케이션 다이빙 로그 앱

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ENUM Types
CREATE TYPE marine_category AS ENUM (
  'Fish', 'Mollusk', 'Crustacean', 'Mammal', 'Reptile', 'Coral', 'Other'
);

CREATE TYPE rarity_level AS ENUM (
  'Common', 'Uncommon', 'Rare', 'Epic', 'Legendary'
);

-- Profiles Table (사용자 프로필)
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  username TEXT UNIQUE,
  level INTEGER DEFAULT 1,
  exp INTEGER DEFAULT 0,
  buddy_name TEXT,
  buddy_color TEXT DEFAULT '#0288D1',
  theme_color TEXT DEFAULT '#E0F7FA',
  avatar_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Dives Table (다이브 로그)
CREATE TABLE dives (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  date DATE NOT NULL,
  site_name TEXT NOT NULL,
  location TEXT,
  depth_max DECIMAL(5,2),
  depth_avg DECIMAL(5,2),
  duration INTEGER, -- minutes
  visibility INTEGER, -- meters
  coordinates JSONB, -- {lat, lng}
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Dive Details Table (다이브 상세 정보)
CREATE TABLE dive_details (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  dive_id UUID REFERENCES dives(id) ON DELETE CASCADE UNIQUE NOT NULL,
  tank_start INTEGER, -- bar
  tank_end INTEGER, -- bar
  weight DECIMAL(4,1), -- kg
  suit_type TEXT,
  temp_surface DECIMAL(4,1),
  temp_bottom DECIMAL(4,1),
  weather TEXT,
  wind TEXT,
  current TEXT,
  tide TEXT,
  entry_type TEXT,
  dive_profile JSONB -- [{time, depth}, ...]
);

-- Marine Species Table (해양 생물 백과)
CREATE TABLE marine_species (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name_kr TEXT NOT NULL,
  name_en TEXT,
  scientific_name TEXT,
  category marine_category NOT NULL,
  description TEXT,
  size_range TEXT,
  season TEXT,
  depth_range TEXT,
  habitat TEXT,
  image_url TEXT,
  rarity rarity_level DEFAULT 'Common',
  is_dangerous BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Marine Sightings Table (다이브 중 발견 생물)
CREATE TABLE marine_sightings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  dive_id UUID REFERENCES dives(id) ON DELETE CASCADE NOT NULL,
  species_id UUID REFERENCES marine_species(id) ON DELETE CASCADE NOT NULL,
  count INTEGER DEFAULT 1,
  photo_url TEXT,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Badges Table (뱃지 정의)
CREATE TABLE badges (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  name_en TEXT,
  description TEXT,
  condition_type TEXT NOT NULL, -- 'dive_count', 'species_count', 'depth', 'streak', etc.
  condition_value INTEGER NOT NULL,
  icon_url TEXT,
  color TEXT DEFAULT '#FFAB91',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- User Badges Table (사용자 획득 뱃지)
CREATE TABLE user_badges (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  badge_id UUID REFERENCES badges(id) ON DELETE CASCADE NOT NULL,
  earned_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, badge_id)
);

-- Diary Entries Table (다이어리 꾸미기)
CREATE TABLE diary_entries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  dive_id UUID REFERENCES dives(id) ON DELETE CASCADE,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  elements JSONB, -- [{id, type, x, y, rotation, scale, zIndex, content, style}, ...]
  background_type TEXT DEFAULT 'grid',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_dives_user_id ON dives(user_id);
CREATE INDEX idx_dives_date ON dives(date DESC);
CREATE INDEX idx_marine_sightings_dive_id ON marine_sightings(dive_id);
CREATE INDEX idx_marine_species_category ON marine_species(category);
CREATE INDEX idx_user_badges_user_id ON user_badges(user_id);

-- Row Level Security (RLS)
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE dives ENABLE ROW LEVEL SECURITY;
ALTER TABLE dive_details ENABLE ROW LEVEL SECURITY;
ALTER TABLE marine_sightings ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_badges ENABLE ROW LEVEL SECURITY;
ALTER TABLE diary_entries ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view their own profile"
  ON profiles FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = id);

CREATE POLICY "Users can insert their own profile"
  ON profiles FOR INSERT
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can view their own dives"
  ON dives FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own dives"
  ON dives FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own dives"
  ON dives FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own dives"
  ON dives FOR DELETE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can view dive details for their dives"
  ON dive_details FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM dives WHERE dives.id = dive_details.dive_id AND dives.user_id = auth.uid()
  ));

CREATE POLICY "Users can manage dive details for their dives"
  ON dive_details FOR ALL
  USING (EXISTS (
    SELECT 1 FROM dives WHERE dives.id = dive_details.dive_id AND dives.user_id = auth.uid()
  ));

CREATE POLICY "Marine species are viewable by everyone"
  ON marine_species FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Users can view sightings for their dives"
  ON marine_sightings FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM dives WHERE dives.id = marine_sightings.dive_id AND dives.user_id = auth.uid()
  ));

CREATE POLICY "Users can manage sightings for their dives"
  ON marine_sightings FOR ALL
  USING (EXISTS (
    SELECT 1 FROM dives WHERE dives.id = marine_sightings.dive_id AND dives.user_id = auth.uid()
  ));

CREATE POLICY "Badges are viewable by everyone"
  ON badges FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Users can view their own badges"
  ON user_badges FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can manage their own diary entries"
  ON diary_entries FOR ALL
  USING (auth.uid() = user_id);

-- Trigger to update updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_profiles_updated_at
  BEFORE UPDATE ON profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_dives_updated_at
  BEFORE UPDATE ON dives
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_diary_entries_updated_at
  BEFORE UPDATE ON diary_entries
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Initial Badges Data
INSERT INTO badges (name, name_en, description, condition_type, condition_value, color) VALUES
  ('첫 다이브', 'First Dive', '첫 번째 다이브를 기록했어요!', 'dive_count', 1, '#4CAF50'),
  ('10회 달성', '10 Dives', '다이브 10회를 달성했어요!', 'dive_count', 10, '#2196F3'),
  ('50회 달성', '50 Dives', '다이브 50회를 달성했어요!', 'dive_count', 50, '#9C27B0'),
  ('100회 달성', '100 Dives', '다이브 100회를 달성했어요!', 'dive_count', 100, '#FF9800'),
  ('심해 탐험가', 'Deep Explorer', '수심 30m 이상을 기록했어요!', 'depth', 30, '#01579B'),
  ('어둠의 심연', 'Into the Abyss', '수심 40m 이상을 기록했어요!', 'depth', 40, '#1A237E'),
  ('생물 수집가', 'Species Collector', '10종 이상의 해양 생물을 발견했어요!', 'species_count', 10, '#4DB6AC'),
  ('해양 박사', 'Marine Expert', '30종 이상의 해양 생물을 발견했어요!', 'species_count', 30, '#00897B'),
  ('7일 연속', 'Week Streak', '7일 연속 다이브를 기록했어요!', 'streak', 7, '#FF5722'),
  ('마라톤 다이버', 'Marathon Diver', '한 번의 다이브에서 60분 이상!', 'duration', 60, '#E91E63');

-- Initial Marine Species Data (샘플)
INSERT INTO marine_species (name_kr, name_en, scientific_name, category, description, size_range, season, depth_range, habitat, rarity, is_dangerous) VALUES
  ('흰동가리', 'Clownfish', 'Amphiprioninae', 'Fish', '말미잘과 공생하는 작고 귀여운 열대어입니다.', '10-15cm', '연중', '1-15m', '산호초, 말미잘', 'Common', false),
  ('바다거북', 'Sea Turtle', 'Chelonioidea', 'Reptile', '우아하게 헤엄치는 바다의 장수 동물입니다.', '60-180cm', '5-10월', '1-40m', '산호초, 해초지대', 'Rare', false),
  ('문어', 'Octopus', 'Octopoda', 'Mollusk', '8개의 다리와 뛰어난 지능을 가진 연체동물입니다.', '30-100cm', '연중', '5-50m', '암초, 동굴', 'Uncommon', false),
  ('해파리', 'Jellyfish', 'Scyphozoa', 'Other', '투명한 몸체로 물속을 떠다니는 신비로운 생물입니다.', '5-100cm', '여름', '0-30m', '개방 수역', 'Common', true),
  ('만타가오리', 'Manta Ray', 'Mobula birostris', 'Fish', '세계에서 가장 큰 가오리로 날개 폭이 7m에 달합니다.', '3-7m', '연중', '10-40m', '산호초, 개방 수역', 'Epic', false),
  ('고래상어', 'Whale Shark', 'Rhincodon typus', 'Fish', '세계에서 가장 큰 물고기로 온순한 성격을 가졌습니다.', '5-12m', '여름', '0-100m', '개방 수역', 'Legendary', false),
  ('청새치', 'Blue Marlin', 'Makaira nigricans', 'Fish', '빠른 속도와 화려한 외모를 가진 대형 어류입니다.', '2-4m', '여름', '0-200m', '개방 수역', 'Rare', false),
  ('해마', 'Seahorse', 'Hippocampus', 'Fish', '독특한 모양과 수컷이 새끼를 낳는 신기한 물고기입니다.', '2-35cm', '연중', '1-30m', '해초, 산호', 'Uncommon', false),
  ('갯민숭달팽이', 'Nudibranch', 'Nudibranchia', 'Mollusk', '화려한 색상을 가진 바다 달팽이입니다.', '1-30cm', '연중', '1-40m', '암초, 해조류', 'Common', false),
  ('돌고래', 'Dolphin', 'Delphinidae', 'Mammal', '지능이 높고 사회성이 강한 해양 포유류입니다.', '1.5-4m', '연중', '0-300m', '개방 수역', 'Rare', false);
