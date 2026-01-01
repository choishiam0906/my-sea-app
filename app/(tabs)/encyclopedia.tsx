import React, { useEffect, useState } from 'react';
import {
  View,
  Text,
  ScrollView,
  TouchableOpacity,
  FlatList,
  Image,
  TextInput,
} from 'react-native';
import { Search, Filter } from 'lucide-react-native';
import BottomSheet, { BottomSheetView } from '@gorhom/bottom-sheet';
import { useRef, useCallback, useMemo } from 'react';
import { Card, Input } from '@/components/ui';
import { useSpeciesStore } from '@/store/useSpeciesStore';
import { MarineCategories, Colors } from '@/constants/theme';
import type { MarineSpecies } from '@/types/database';

// Sample data for demo
const sampleSpecies: MarineSpecies[] = [
  {
    id: '1',
    name_kr: '흰동가리',
    name_en: 'Clownfish',
    scientific_name: 'Amphiprioninae',
    category: 'Fish',
    description: '말미잘과 공생하는 작고 귀여운 열대어입니다.',
    size_range: '10-15cm',
    season: '연중',
    depth_range: '1-15m',
    habitat: '산호초, 말미잘',
    image_url: '',
    rarity: 'Common',
    is_dangerous: false,
  },
  {
    id: '2',
    name_kr: '바다거북',
    name_en: 'Sea Turtle',
    scientific_name: 'Chelonioidea',
    category: 'Reptile',
    description: '우아하게 헤엄치는 바다의 장수 동물입니다.',
    size_range: '60-180cm',
    season: '5-10월',
    depth_range: '1-40m',
    habitat: '산호초, 해초지대',
    image_url: '',
    rarity: 'Rare',
    is_dangerous: false,
  },
  {
    id: '3',
    name_kr: '문어',
    name_en: 'Octopus',
    scientific_name: 'Octopoda',
    category: 'Mollusk',
    description: '8개의 다리와 뛰어난 지능을 가진 연체동물입니다.',
    size_range: '30-100cm',
    season: '연중',
    depth_range: '5-50m',
    habitat: '암초, 동굴',
    image_url: '',
    rarity: 'Uncommon',
    is_dangerous: false,
  },
  {
    id: '4',
    name_kr: '해파리',
    name_en: 'Jellyfish',
    scientific_name: 'Scyphozoa',
    category: 'Other',
    description: '투명한 몸체로 물속을 떠다니는 신비로운 생물입니다.',
    size_range: '5-100cm',
    season: '여름',
    depth_range: '0-30m',
    habitat: '개방 수역',
    image_url: '',
    rarity: 'Common',
    is_dangerous: true,
  },
];

const getEmojiForCategory = (category: string) => {
  const emojiMap: Record<string, string> = {
    Fish: '🐠',
    Mollusk: '🐙',
    Crustacean: '🦀',
    Mammal: '🐬',
    Reptile: '🐢',
    Coral: '🪸',
    Other: '🪼',
  };
  return emojiMap[category] || '🌊';
};

export default function EncyclopediaScreen() {
  const [selectedCategory, setSelectedCategory] = useState<string>('All');
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedSpecies, setSelectedSpecies] = useState<MarineSpecies | null>(null);
  const bottomSheetRef = useRef<BottomSheet>(null);

  const snapPoints = useMemo(() => ['50%', '85%'], []);

  const filteredSpecies = useMemo(() => {
    let result = sampleSpecies;

    if (selectedCategory !== 'All') {
      result = result.filter((s) => s.category === selectedCategory);
    }

    if (searchQuery) {
      const query = searchQuery.toLowerCase();
      result = result.filter(
        (s) =>
          s.name_kr.includes(query) ||
          s.name_en.toLowerCase().includes(query)
      );
    }

    return result;
  }, [selectedCategory, searchQuery]);

  const handleOpenSheet = useCallback((species: MarineSpecies) => {
    setSelectedSpecies(species);
    bottomSheetRef.current?.expand();
  }, []);

  const renderSpeciesCard = ({ item }: { item: MarineSpecies }) => (
    <TouchableOpacity
      className="flex-1 m-2"
      onPress={() => handleOpenSheet(item)}
    >
      <Card className="items-center">
        <View className="w-20 h-20 rounded-full bg-primary items-center justify-center mb-3">
          <Text className="text-4xl">{getEmojiForCategory(item.category)}</Text>
        </View>
        <Text className="font-semibold text-text-main text-center">
          {item.name_kr}
        </Text>
        <Text className="text-xs text-text-sub">{item.name_en}</Text>
        <View
          className="mt-2 px-2 py-1 rounded-full"
          style={{ backgroundColor: Colors.rarity[item.rarity] + '20' }}
        >
          <Text
            className="text-xs font-medium"
            style={{ color: Colors.rarity[item.rarity] }}
          >
            {item.rarity}
          </Text>
        </View>
      </Card>
    </TouchableOpacity>
  );

  return (
    <View className="flex-1 bg-primary">
      {/* Search Bar */}
      <View className="px-4 py-3">
        <View className="flex-row items-center bg-surface rounded-2xl px-4 shadow-sm">
          <Search color="#78909C" size={20} />
          <TextInput
            className="flex-1 py-3 ml-3 text-text-main"
            placeholder="해양 생물 검색..."
            placeholderTextColor="#78909C"
            value={searchQuery}
            onChangeText={setSearchQuery}
          />
        </View>
      </View>

      {/* Category Tabs */}
      <ScrollView
        horizontal
        showsHorizontalScrollIndicator={false}
        className="px-4 mb-4"
        contentContainerStyle={{ paddingRight: 16 }}
      >
        <TouchableOpacity
          onPress={() => setSelectedCategory('All')}
          className={`mr-2 px-4 py-2 rounded-full ${
            selectedCategory === 'All' ? 'bg-secondary' : 'bg-surface'
          }`}
        >
          <Text
            className={`font-medium ${
              selectedCategory === 'All' ? 'text-white' : 'text-text-main'
            }`}
          >
            전체
          </Text>
        </TouchableOpacity>
        {MarineCategories.map((cat) => (
          <TouchableOpacity
            key={cat.id}
            onPress={() => setSelectedCategory(cat.id)}
            className={`mr-2 px-4 py-2 rounded-full ${
              selectedCategory === cat.id ? 'bg-secondary' : 'bg-surface'
            }`}
          >
            <Text
              className={`font-medium ${
                selectedCategory === cat.id ? 'text-white' : 'text-text-main'
              }`}
            >
              {cat.label}
            </Text>
          </TouchableOpacity>
        ))}
      </ScrollView>

      {/* Species Grid */}
      <FlatList
        data={filteredSpecies}
        renderItem={renderSpeciesCard}
        keyExtractor={(item) => item.id}
        numColumns={2}
        contentContainerStyle={{ padding: 8 }}
        showsVerticalScrollIndicator={false}
        ListEmptyComponent={
          <View className="items-center py-12">
            <Text className="text-5xl mb-4">🔍</Text>
            <Text className="text-text-main font-medium">
              검색 결과가 없습니다
            </Text>
          </View>
        }
      />

      {/* Species Detail Bottom Sheet */}
      <BottomSheet
        ref={bottomSheetRef}
        index={-1}
        snapPoints={snapPoints}
        enablePanDownToClose
        backgroundStyle={{ backgroundColor: '#FFFFFF' }}
        handleIndicatorStyle={{ backgroundColor: '#78909C' }}
      >
        <BottomSheetView className="flex-1 px-6 py-4">
          {selectedSpecies && (
            <>
              <View className="items-center mb-6">
                <View className="w-24 h-24 rounded-full bg-primary items-center justify-center mb-4">
                  <Text className="text-5xl">
                    {getEmojiForCategory(selectedSpecies.category)}
                  </Text>
                </View>
                <Text className="text-2xl font-bold text-text-main">
                  {selectedSpecies.name_kr}
                </Text>
                <Text className="text-text-sub">{selectedSpecies.name_en}</Text>
                <Text className="text-text-sub text-sm italic">
                  {selectedSpecies.scientific_name}
                </Text>
              </View>

              <View className="flex-row flex-wrap mb-6">
                <View className="w-1/2 mb-4">
                  <Text className="text-text-sub text-xs mb-1">크기</Text>
                  <Text className="text-text-main font-medium">
                    {selectedSpecies.size_range}
                  </Text>
                </View>
                <View className="w-1/2 mb-4">
                  <Text className="text-text-sub text-xs mb-1">시즌</Text>
                  <Text className="text-text-main font-medium">
                    {selectedSpecies.season}
                  </Text>
                </View>
                <View className="w-1/2 mb-4">
                  <Text className="text-text-sub text-xs mb-1">수심</Text>
                  <Text className="text-text-main font-medium">
                    {selectedSpecies.depth_range}
                  </Text>
                </View>
                <View className="w-1/2 mb-4">
                  <Text className="text-text-sub text-xs mb-1">서식지</Text>
                  <Text className="text-text-main font-medium">
                    {selectedSpecies.habitat}
                  </Text>
                </View>
              </View>

              <View className="mb-6">
                <Text className="text-text-sub text-xs mb-2">설명</Text>
                <Text className="text-text-main leading-6">
                  {selectedSpecies.description}
                </Text>
              </View>

              {selectedSpecies.is_dangerous && (
                <View className="bg-red-50 p-4 rounded-2xl flex-row items-center">
                  <Text className="text-2xl mr-3">⚠️</Text>
                  <Text className="text-red-600 flex-1">
                    주의: 이 생물은 위험할 수 있습니다. 가까이 접근하지 마세요.
                  </Text>
                </View>
              )}
            </>
          )}
        </BottomSheetView>
      </BottomSheet>
    </View>
  );
}
