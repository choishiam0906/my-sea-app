import React, { useState } from 'react';
import {
  View,
  Text,
  ScrollView,
  TouchableOpacity,
  FlatList,
} from 'react-native';
import { useRouter } from 'expo-router';
import { Plus, Calendar, MapPin, Clock, ArrowDown } from 'lucide-react-native';
import { Card } from '@/components/ui';
import { useDiveStore } from '@/store/useDiveStore';
import type { Dive } from '@/types/database';

// Sample data for demo
const sampleDives: Dive[] = [
  {
    id: '1',
    user_id: '1',
    date: '2025-12-28',
    site_name: '제주 서귀포 문섬',
    location: '제주도',
    depth_max: 25,
    depth_avg: 18,
    duration: 48,
    visibility: 15,
    notes: '멋진 연산호 군락을 봤어요!',
    coordinates: null,
    created_at: '',
    updated_at: '',
  },
  {
    id: '2',
    user_id: '1',
    date: '2025-12-15',
    site_name: '울릉도 행남등대',
    location: '울릉도',
    depth_max: 32,
    depth_avg: 22,
    duration: 42,
    visibility: 20,
    notes: '투명한 물에서 환상적인 다이빙!',
    coordinates: null,
    created_at: '',
    updated_at: '',
  },
  {
    id: '3',
    user_id: '1',
    date: '2025-12-01',
    site_name: '통영 비진도',
    location: '통영',
    depth_max: 18,
    depth_avg: 12,
    duration: 55,
    visibility: 8,
    notes: '아기 문어를 발견했어요!',
    coordinates: null,
    created_at: '',
    updated_at: '',
  },
];

export default function LogsScreen() {
  const router = useRouter();
  const [sortOrder, setSortOrder] = useState<'newest' | 'oldest'>('newest');

  const sortedDives = [...sampleDives].sort((a, b) => {
    if (sortOrder === 'newest') {
      return new Date(b.date).getTime() - new Date(a.date).getTime();
    }
    return new Date(a.date).getTime() - new Date(b.date).getTime();
  });

  const renderDiveCard = ({ item }: { item: Dive }) => (
    <TouchableOpacity
      onPress={() => router.push(`/logs/${item.id}`)}
      className="mb-4"
    >
      <Card className="overflow-hidden">
        {/* Header with Date Badge */}
        <View className="flex-row justify-between items-start mb-3">
          <View className="bg-secondary px-3 py-1 rounded-full">
            <Text className="text-white text-sm font-medium">{item.date}</Text>
          </View>
          <View className="flex-row items-center">
            <MapPin color="#78909C" size={14} />
            <Text className="text-text-sub text-sm ml-1">{item.location}</Text>
          </View>
        </View>

        {/* Site Name */}
        <Text className="text-xl font-bold text-text-main mb-3">
          {item.site_name}
        </Text>

        {/* Stats Row */}
        <View className="flex-row justify-between bg-primary rounded-xl p-3">
          <View className="items-center flex-1">
            <ArrowDown color="#0288D1" size={18} />
            <Text className="text-lg font-bold text-text-main mt-1">
              {item.depth_max}m
            </Text>
            <Text className="text-xs text-text-sub">최대수심</Text>
          </View>
          <View className="w-px bg-gray-200" />
          <View className="items-center flex-1">
            <Clock color="#0288D1" size={18} />
            <Text className="text-lg font-bold text-text-main mt-1">
              {item.duration}분
            </Text>
            <Text className="text-xs text-text-sub">잠수시간</Text>
          </View>
          <View className="w-px bg-gray-200" />
          <View className="items-center flex-1">
            <Text className="text-lg">👁️</Text>
            <Text className="text-lg font-bold text-text-main mt-1">
              {item.visibility}m
            </Text>
            <Text className="text-xs text-text-sub">시야</Text>
          </View>
        </View>

        {/* Notes Preview */}
        {item.notes && (
          <Text className="text-text-sub text-sm mt-3" numberOfLines={2}>
            📝 {item.notes}
          </Text>
        )}
      </Card>
    </TouchableOpacity>
  );

  return (
    <View className="flex-1 bg-primary">
      {/* Header */}
      <View className="px-4 py-3 flex-row justify-between items-center">
        <Text className="text-2xl font-bold text-text-main">다이브 로그</Text>
        <TouchableOpacity
          onPress={() => setSortOrder(sortOrder === 'newest' ? 'oldest' : 'newest')}
          className="flex-row items-center bg-surface px-3 py-2 rounded-full"
        >
          <Calendar color="#0288D1" size={16} />
          <Text className="text-secondary text-sm ml-1">
            {sortOrder === 'newest' ? '최신순' : '오래된순'}
          </Text>
        </TouchableOpacity>
      </View>

      {/* Stats Summary */}
      <View className="px-4 mb-4">
        <Card className="flex-row justify-around py-4">
          <View className="items-center">
            <Text className="text-3xl font-bold text-secondary">
              {sampleDives.length}
            </Text>
            <Text className="text-text-sub text-sm">총 다이브</Text>
          </View>
          <View className="w-px h-12 bg-gray-200" />
          <View className="items-center">
            <Text className="text-3xl font-bold text-secondary">
              {sampleDives.reduce((acc, d) => acc + d.duration, 0)}분
            </Text>
            <Text className="text-text-sub text-sm">총 수중시간</Text>
          </View>
          <View className="w-px h-12 bg-gray-200" />
          <View className="items-center">
            <Text className="text-3xl font-bold text-secondary">
              {Math.max(...sampleDives.map((d) => d.depth_max))}m
            </Text>
            <Text className="text-text-sub text-sm">최대수심</Text>
          </View>
        </Card>
      </View>

      {/* Dive List */}
      <FlatList
        data={sortedDives}
        renderItem={renderDiveCard}
        keyExtractor={(item) => item.id}
        contentContainerStyle={{ padding: 16 }}
        showsVerticalScrollIndicator={false}
        ListEmptyComponent={
          <View className="items-center py-12">
            <Text className="text-6xl mb-4">🤿</Text>
            <Text className="text-text-main font-medium text-lg">
              아직 기록된 다이브가 없어요
            </Text>
            <Text className="text-text-sub text-center mt-2">
              새 다이브를 기록해보세요!
            </Text>
          </View>
        }
      />

      {/* FAB */}
      <TouchableOpacity
        onPress={() => router.push('/log/new')}
        className="absolute bottom-6 right-6 w-14 h-14 bg-secondary rounded-full items-center justify-center shadow-lg"
        style={{
          shadowColor: '#0288D1',
          shadowOffset: { width: 0, height: 4 },
          shadowOpacity: 0.3,
          shadowRadius: 8,
          elevation: 8,
        }}
      >
        <Plus color="#FFFFFF" size={28} />
      </TouchableOpacity>
    </View>
  );
}
