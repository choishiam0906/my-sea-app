export const Colors = {
  primary: {
    light: '#E0F7FA',
    dark: '#0288D1',
  },
  secondary: '#0288D1',
  surface: '#FFFFFF',
  accent: {
    coral: '#FFAB91',
  },
  text: {
    main: '#263238',
    sub: '#78909C',
  },
  ocean: {
    shallow: '#E0F7FA',
    mid: '#4FC3F7',
    deep: '#0288D1',
    abyss: '#01579B',
  },
  status: {
    success: '#4CAF50',
    warning: '#FF9800',
    error: '#F44336',
    info: '#2196F3',
  },
  rarity: {
    Common: '#9E9E9E',
    Uncommon: '#4CAF50',
    Rare: '#2196F3',
    Epic: '#9C27B0',
    Legendary: '#FF9800',
  },
};

export const Spacing = {
  xs: 4,
  sm: 8,
  md: 16,
  lg: 24,
  xl: 32,
  xxl: 48,
};

export const BorderRadius = {
  sm: 8,
  md: 12,
  lg: 16,
  xl: 24,
  full: 9999,
};

export const Shadows = {
  sm: {
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.1,
    shadowRadius: 2,
    elevation: 2,
  },
  md: {
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.15,
    shadowRadius: 4,
    elevation: 4,
  },
  lg: {
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.2,
    shadowRadius: 8,
    elevation: 8,
  },
};

export const MarineCategories = [
  { id: 'Fish', label: '어류', icon: 'fish' },
  { id: 'Mollusk', label: '연체동물', icon: 'shell' },
  { id: 'Crustacean', label: '갑각류', icon: 'bug' },
  { id: 'Mammal', label: '포유류', icon: 'cat' },
  { id: 'Reptile', label: '파충류', icon: 'turtle' },
  { id: 'Coral', label: '산호', icon: 'flower' },
  { id: 'Other', label: '기타', icon: 'sparkles' },
] as const;

export const SeaFriends = [
  { id: 'turtle', name: '바다거북', emoji: '🐢', icon: 'turtle' },
  { id: 'clownfish', name: '흰동가리', emoji: '🐠', icon: 'fish' },
  { id: 'octopus', name: '문어', emoji: '🐙', icon: 'octagon' },
  { id: 'pufferfish', name: '복어', emoji: '🐡', icon: 'circle-dot' },
  { id: 'whale', name: '고래', emoji: '🐋', icon: 'fish' },
  { id: 'dolphin', name: '돌고래', emoji: '🐬', icon: 'fish' },
  { id: 'shark', name: '상어', emoji: '🦈', icon: 'triangle' },
  { id: 'jellyfish', name: '해파리', emoji: '🪼', icon: 'cloud' },
  { id: 'seahorse', name: '해마', emoji: '🦑', icon: 'anchor' },
  { id: 'crab', name: '게', emoji: '🦀', icon: 'bug' },
  { id: 'starfish', name: '불가사리', emoji: '⭐', icon: 'star' },
  { id: 'seal', name: '물범', emoji: '🦭', icon: 'circle' },
];

export const BuddyColors = [
  { id: 'blue', name: '오션 블루', color: '#0288D1' },
  { id: 'coral', name: '코랄 핑크', color: '#FFAB91' },
  { id: 'mint', name: '민트 그린', color: '#80CBC4' },
  { id: 'gold', name: '골든 옐로우', color: '#FFD54F' },
  { id: 'purple', name: '딥 퍼플', color: '#9575CD' },
  { id: 'teal', name: '틸 블루', color: '#4DB6AC' },
];
