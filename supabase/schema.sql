-- =====================================================
-- My Sea App - Supabase Database Schema
-- =====================================================
-- 이 SQL을 Supabase Dashboard > SQL Editor에서 실행하세요
-- =====================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- 1. PROFILES 테이블 (사용자 프로필)
-- =====================================================
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  username TEXT UNIQUE,
  level INTEGER DEFAULT 1,
  exp INTEGER DEFAULT 0,
  buddy_name TEXT,
  buddy_color TEXT DEFAULT '#0288D1',
  theme_color TEXT DEFAULT '#0288D1',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- RLS (Row Level Security) 활성화
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- 프로필 정책: 본인만 조회/수정 가능
CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

-- 새 사용자 가입 시 자동으로 프로필 생성하는 함수
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, username)
  VALUES (NEW.id, NEW.email);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 트리거: auth.users에 새 사용자 추가 시 profiles 자동 생성
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- =====================================================
-- 2. DIVES 테이블 (다이브 로그)
-- =====================================================
CREATE TABLE IF NOT EXISTS dives (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  date DATE NOT NULL DEFAULT CURRENT_DATE,
  site_name TEXT NOT NULL,
  location TEXT,
  depth_max NUMERIC(5,1) DEFAULT 0,
  depth_avg NUMERIC(5,1) DEFAULT 0,
  duration INTEGER DEFAULT 0, -- 분 단위
  visibility INTEGER DEFAULT 0, -- 미터 단위
  coordinates JSONB, -- { lat: number, lng: number }
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 인덱스
CREATE INDEX IF NOT EXISTS idx_dives_user_id ON dives(user_id);
CREATE INDEX IF NOT EXISTS idx_dives_date ON dives(date DESC);

-- RLS 활성화
ALTER TABLE dives ENABLE ROW LEVEL SECURITY;

-- 다이브 정책
CREATE POLICY "Users can view own dives" ON dives
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own dives" ON dives
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own dives" ON dives
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own dives" ON dives
  FOR DELETE USING (auth.uid() = user_id);

-- =====================================================
-- 3. DIVE_DETAILS 테이블 (다이브 상세 정보)
-- =====================================================
CREATE TABLE IF NOT EXISTS dive_details (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  dive_id UUID NOT NULL REFERENCES dives(id) ON DELETE CASCADE,
  tank_start INTEGER DEFAULT 200, -- bar
  tank_end INTEGER DEFAULT 50,
  weight NUMERIC(4,1) DEFAULT 0, -- kg
  suit_type TEXT,
  temp_surface NUMERIC(4,1), -- 수면 온도 °C
  temp_bottom NUMERIC(4,1), -- 수중 온도 °C
  weather TEXT,
  wind TEXT,
  current TEXT,
  tide TEXT,
  entry_type TEXT, -- boat, shore 등
  dive_profile JSONB DEFAULT '[]' -- [{ time: number, depth: number }]
);

-- 인덱스
CREATE INDEX IF NOT EXISTS idx_dive_details_dive_id ON dive_details(dive_id);

-- RLS 활성화
ALTER TABLE dive_details ENABLE ROW LEVEL SECURITY;

-- dive_details는 dives를 통해 접근 제어
CREATE POLICY "Users can view own dive details" ON dive_details
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM dives WHERE dives.id = dive_details.dive_id AND dives.user_id = auth.uid())
  );

CREATE POLICY "Users can insert own dive details" ON dive_details
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM dives WHERE dives.id = dive_details.dive_id AND dives.user_id = auth.uid())
  );

CREATE POLICY "Users can update own dive details" ON dive_details
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM dives WHERE dives.id = dive_details.dive_id AND dives.user_id = auth.uid())
  );

CREATE POLICY "Users can delete own dive details" ON dive_details
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM dives WHERE dives.id = dive_details.dive_id AND dives.user_id = auth.uid())
  );

-- =====================================================
-- 4. MARINE_SPECIES 테이블 (해양 생물 도감)
-- =====================================================
CREATE TYPE marine_category AS ENUM ('Fish', 'Mollusk', 'Crustacean', 'Mammal', 'Reptile', 'Coral', 'Other');
CREATE TYPE rarity_level AS ENUM ('Common', 'Uncommon', 'Rare', 'Epic', 'Legendary');

CREATE TABLE IF NOT EXISTS marine_species (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name_kr TEXT NOT NULL,
  name_en TEXT,
  scientific_name TEXT,
  category marine_category DEFAULT 'Other',
  description TEXT,
  size_range TEXT,
  season TEXT,
  depth_range TEXT,
  habitat TEXT,
  image_url TEXT,
  rarity rarity_level DEFAULT 'Common',
  is_dangerous BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- RLS 활성화 (모든 사용자가 읽기 가능)
ALTER TABLE marine_species ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view marine species" ON marine_species
  FOR SELECT USING (true);

-- =====================================================
-- 5. MARINE_SIGHTINGS 테이블 (다이브 중 발견한 생물)
-- =====================================================
CREATE TABLE IF NOT EXISTS marine_sightings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  dive_id UUID NOT NULL REFERENCES dives(id) ON DELETE CASCADE,
  species_id UUID NOT NULL REFERENCES marine_species(id) ON DELETE CASCADE,
  count INTEGER DEFAULT 1,
  photo_url TEXT,
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 인덱스
CREATE INDEX IF NOT EXISTS idx_marine_sightings_dive_id ON marine_sightings(dive_id);
CREATE INDEX IF NOT EXISTS idx_marine_sightings_species_id ON marine_sightings(species_id);

-- RLS 활성화
ALTER TABLE marine_sightings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own sightings" ON marine_sightings
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM dives WHERE dives.id = marine_sightings.dive_id AND dives.user_id = auth.uid())
  );

CREATE POLICY "Users can insert own sightings" ON marine_sightings
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM dives WHERE dives.id = marine_sightings.dive_id AND dives.user_id = auth.uid())
  );

CREATE POLICY "Users can update own sightings" ON marine_sightings
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM dives WHERE dives.id = marine_sightings.dive_id AND dives.user_id = auth.uid())
  );

CREATE POLICY "Users can delete own sightings" ON marine_sightings
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM dives WHERE dives.id = marine_sightings.dive_id AND dives.user_id = auth.uid())
  );

-- =====================================================
-- 6. BADGES 테이블 (뱃지 정의)
-- =====================================================
CREATE TABLE IF NOT EXISTS badges (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT,
  condition_type TEXT NOT NULL, -- 'dive_count', 'depth', 'species_count' 등
  condition_value INTEGER NOT NULL,
  icon_url TEXT,
  color TEXT DEFAULT '#0288D1',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- RLS (모든 사용자 읽기 가능)
ALTER TABLE badges ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view badges" ON badges
  FOR SELECT USING (true);

-- =====================================================
-- 7. USER_BADGES 테이블 (사용자가 획득한 뱃지)
-- =====================================================
CREATE TABLE IF NOT EXISTS user_badges (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  badge_id UUID NOT NULL REFERENCES badges(id) ON DELETE CASCADE,
  earned_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, badge_id)
);

-- 인덱스
CREATE INDEX IF NOT EXISTS idx_user_badges_user_id ON user_badges(user_id);

-- RLS 활성화
ALTER TABLE user_badges ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own badges" ON user_badges
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own badges" ON user_badges
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- =====================================================
-- 8. DIARY_ENTRIES 테이블 (다이어리)
-- =====================================================
CREATE TABLE IF NOT EXISTS diary_entries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  dive_id UUID REFERENCES dives(id) ON DELETE SET NULL,
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  elements JSONB DEFAULT '[]', -- DiaryElement 배열
  background_type TEXT DEFAULT 'grid',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 인덱스
CREATE INDEX IF NOT EXISTS idx_diary_entries_user_id ON diary_entries(user_id);
CREATE INDEX IF NOT EXISTS idx_diary_entries_dive_id ON diary_entries(dive_id);

-- RLS 활성화
ALTER TABLE diary_entries ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own diary entries" ON diary_entries
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own diary entries" ON diary_entries
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own diary entries" ON diary_entries
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own diary entries" ON diary_entries
  FOR DELETE USING (auth.uid() = user_id);

-- =====================================================
-- 9. 초기 데이터 삽입 (해양 생물 도감)
-- =====================================================
INSERT INTO marine_species (name_kr, name_en, scientific_name, category, description, size_range, season, depth_range, habitat, rarity, is_dangerous) VALUES
  ('흰동가리', 'Clownfish', 'Amphiprioninae', 'Fish', '말미잘과 공생하는 작고 귀여운 열대어입니다.', '10-15cm', '연중', '1-15m', '산호초, 말미잘', 'Common', false),
  ('바다거북', 'Sea Turtle', 'Chelonioidea', 'Reptile', '우아하게 헤엄치는 바다의 장수 동물입니다.', '60-180cm', '5-10월', '1-40m', '산호초, 해초지대', 'Rare', false),
  ('문어', 'Octopus', 'Octopoda', 'Mollusk', '8개의 다리와 뛰어난 지능을 가진 연체동물입니다.', '30-100cm', '연중', '5-50m', '암초, 동굴', 'Uncommon', false),
  ('해파리', 'Jellyfish', 'Scyphozoa', 'Other', '투명한 몸체로 물속을 떠다니는 신비로운 생물입니다.', '5-100cm', '여름', '0-30m', '개방 수역', 'Common', true),
  ('돌고래', 'Dolphin', 'Delphinidae', 'Mammal', '지능이 높고 친근한 해양 포유류입니다.', '150-400cm', '연중', '0-100m', '개방 수역', 'Epic', false),
  ('쥐가오리', 'Manta Ray', 'Mobula birostris', 'Fish', '거대하고 우아한 날개를 가진 가오리입니다.', '300-700cm', '연중', '10-40m', '개방 수역, 산호초', 'Legendary', false),
  ('해마', 'Seahorse', 'Hippocampus', 'Fish', '독특한 외형과 수직으로 헤엄치는 작은 물고기입니다.', '5-15cm', '연중', '1-20m', '해초지대, 산호초', 'Rare', false),
  ('갑오징어', 'Cuttlefish', 'Sepiida', 'Mollusk', '색을 자유자재로 바꾸는 신기한 연체동물입니다.', '15-50cm', '연중', '5-30m', '암초, 모래 바닥', 'Uncommon', false),
  ('불가사리', 'Starfish', 'Asteroidea', 'Other', '5개의 팔을 가진 아름다운 극피동물입니다.', '10-30cm', '연중', '0-50m', '암초, 모래 바닥', 'Common', false),
  ('랍스터', 'Lobster', 'Nephropidae', 'Crustacean', '큰 집게를 가진 야행성 갑각류입니다.', '20-60cm', '연중', '5-50m', '암초, 동굴', 'Uncommon', false)
ON CONFLICT DO NOTHING;

-- =====================================================
-- 10. 초기 뱃지 데이터 삽입
-- =====================================================
INSERT INTO badges (name, description, condition_type, condition_value, color) VALUES
  ('첫 다이브', '첫 번째 다이브를 기록했습니다!', 'dive_count', 1, '#4CAF50'),
  ('10회 달성', '10번의 다이브를 완료했습니다!', 'dive_count', 10, '#2196F3'),
  ('50회 달성', '50번의 다이브를 완료했습니다!', 'dive_count', 50, '#9C27B0'),
  ('100회 달성', '100번의 다이브를 완료했습니다!', 'dive_count', 100, '#FF9800'),
  ('심해 탐험가', '30m 이상 수심을 경험했습니다!', 'max_depth', 30, '#0288D1'),
  ('어둠 속으로', '40m 이상 수심을 경험했습니다!', 'max_depth', 40, '#01579B'),
  ('생물 수집가', '10종 이상의 해양 생물을 발견했습니다!', 'species_count', 10, '#FFAB91'),
  ('도감 마스터', '20종 이상의 해양 생물을 발견했습니다!', 'species_count', 20, '#FFD700'),
  ('7일 연속', '7일 연속으로 다이브를 기록했습니다!', 'consecutive_days', 7, '#F44336'),
  ('마스터 다이버', '레벨 10에 도달했습니다!', 'level', 10, '#9C27B0')
ON CONFLICT DO NOTHING;

-- =====================================================
-- 11. updated_at 자동 갱신 함수
-- =====================================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- updated_at 트리거 적용
CREATE TRIGGER update_profiles_updated_at
  BEFORE UPDATE ON profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_dives_updated_at
  BEFORE UPDATE ON dives
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_diary_entries_updated_at
  BEFORE UPDATE ON diary_entries
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- 완료! 🎉
-- =====================================================
