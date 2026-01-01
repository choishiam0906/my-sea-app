export type MarineCategory =
  | 'Fish'
  | 'Mollusk'
  | 'Crustacean'
  | 'Mammal'
  | 'Reptile'
  | 'Coral'
  | 'Other';

export type RarityLevel = 'Common' | 'Uncommon' | 'Rare' | 'Epic' | 'Legendary';

export interface Profile {
  id: string;
  username: string;
  level: number;
  exp: number;
  buddy_name: string;
  buddy_color: string;
  theme_color: string;
  created_at: string;
  updated_at: string;
}

export interface Dive {
  id: string;
  user_id: string;
  date: string;
  site_name: string;
  location: string;
  depth_max: number;
  depth_avg: number;
  duration: number;
  coordinates: { lat: number; lng: number } | null;
  visibility: number;
  notes: string;
  created_at: string;
  updated_at: string;
}

export interface DiveDetail {
  id: string;
  dive_id: string;
  tank_start: number;
  tank_end: number;
  weight: number;
  suit_type: string;
  temp_surface: number;
  temp_bottom: number;
  weather: string;
  wind: string;
  current: string;
  tide: string;
  entry_type: string;
  dive_profile: DiveProfilePoint[];
}

export interface DiveProfilePoint {
  time: number; // seconds
  depth: number; // meters
}

export interface MarineSpecies {
  id: string;
  name_kr: string;
  name_en: string;
  scientific_name: string;
  category: MarineCategory;
  description: string;
  size_range: string;
  season: string;
  depth_range: string;
  habitat: string;
  image_url: string;
  rarity: RarityLevel;
  is_dangerous: boolean;
}

export interface MarineSighting {
  id: string;
  dive_id: string;
  species_id: string;
  count: number;
  photo_url: string | null;
  notes: string;
  species?: MarineSpecies;
}

export interface Badge {
  id: string;
  name: string;
  description: string;
  condition_type: string;
  condition_value: number;
  icon_url: string;
  color: string;
}

export interface UserBadge {
  id: string;
  user_id: string;
  badge_id: string;
  earned_at: string;
  badge?: Badge;
}

export interface DiaryEntry {
  id: string;
  dive_id: string;
  user_id: string;
  elements: DiaryElement[];
  background_type: string;
  created_at: string;
  updated_at: string;
}

export interface DiaryElement {
  id: string;
  type: 'text' | 'sticker' | 'photo';
  x: number;
  y: number;
  rotation: number;
  scale: number;
  zIndex: number;
  content: string;
  style?: {
    fontFamily?: string;
    fontSize?: number;
    color?: string;
    textAlign?: string;
  };
}
