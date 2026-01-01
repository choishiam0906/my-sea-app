import React, { useEffect, useState } from 'react';
import { View, Text, ScrollView, TouchableOpacity, Dimensions } from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { LinearGradient } from 'expo-linear-gradient';
import {
  ArrowLeft,
  MapPin,
  Calendar,
  Clock,
  ArrowDown,
  Eye,
  Thermometer,
  Wind,
  Waves,
  Cloud,
  Edit3,
  Share2,
  Trash2,
} from 'lucide-react-native';
import { LineChart } from 'react-native-gifted-charts';
import { Card } from '@/components/ui';

const { width } = Dimensions.get('window');

// Sample dive profile data
const sampleDiveProfile = [
  { value: 0, label: '0' },
  { value: 5, label: '5' },
  { value: 12, label: '10' },
  { value: 18, label: '15' },
  { value: 22, label: '20' },
  { value: 25, label: '25' },
  { value: 24, label: '30' },
  { value: 20, label: '35' },
  { value: 15, label: '40' },
  { value: 8, label: '45' },
  { value: 5, label: '48' },
  { value: 0, label: '50' },
];

// Sample data
const sampleDive = {
  id: '1',
  date: '2025-12-28',
  site_name: '제주 서귀포 문섬',
  location: '제주도',
  depth_max: 25,
  depth_avg: 18,
  duration: 48,
  visibility: 15,
  temp_surface: 24,
  temp_bottom: 20,
  weather: '☀️ 맑음',
  wind: '약함',
  current: '보통',
  tank_start: 200,
  tank_end: 50,
  weight: 6,
  suit_type: '5mm 웻슈트',
  notes: '오늘 문섬에서 정말 환상적인 다이빙을 했어요! 연산호 군락이 너무 예뻤고, 흰동가리와 바다거북도 봤어요. 시야가 좋아서 멀리까지 볼 수 있었습니다. 🐢🐠',
  sightings: [
    { id: '1', name: '흰동가리', emoji: '🐠', count: 5 },
    { id: '2', name: '바다거북', emoji: '🐢', count: 1 },
    { id: '3', name: '문어', emoji: '🐙', count: 2 },
  ],
};

export default function DiveDetailScreen() {
  const { id } = useLocalSearchParams();
  const router = useRouter();
  const [dive, setDive] = useState(sampleDive);

  return (
    <View className="flex-1 bg-primary">
      {/* Header */}
      <LinearGradient
        colors={['#0288D1', '#4FC3F7', '#E0F7FA']}
        className="pt-12 pb-6 px-4"
      >
        <View className="flex-row justify-between items-center mb-4">
          <TouchableOpacity
            onPress={() => router.back()}
            className="w-10 h-10 rounded-full bg-white/20 items-center justify-center"
          >
            <ArrowLeft color="#FFFFFF" size={24} />
          </TouchableOpacity>
          <View className="flex-row">
            <TouchableOpacity className="w-10 h-10 rounded-full bg-white/20 items-center justify-center mr-2">
              <Share2 color="#FFFFFF" size={20} />
            </TouchableOpacity>
            <TouchableOpacity className="w-10 h-10 rounded-full bg-white/20 items-center justify-center">
              <Edit3 color="#FFFFFF" size={20} />
            </TouchableOpacity>
          </View>
        </View>

        <Text className="text-white text-2xl font-bold mb-2">{dive.site_name}</Text>
        <View className="flex-row items-center">
          <MapPin color="#FFFFFF" size={16} />
          <Text className="text-white/80 ml-1">{dive.location}</Text>
          <View className="w-1 h-1 rounded-full bg-white/50 mx-3" />
          <Calendar color="#FFFFFF" size={16} />
          <Text className="text-white/80 ml-1">{dive.date}</Text>
        </View>
      </LinearGradient>

      <ScrollView className="flex-1" showsVerticalScrollIndicator={false}>
        {/* Quick Stats */}
        <View className="px-4 -mt-4">
          <Card className="flex-row justify-around py-4">
            <View className="items-center">
              <ArrowDown color="#0288D1" size={24} />
              <Text className="text-2xl font-bold text-text-main mt-1">
                {dive.depth_max}m
              </Text>
              <Text className="text-xs text-text-sub">최대수심</Text>
            </View>
            <View className="w-px h-16 bg-gray-200" />
            <View className="items-center">
              <Clock color="#0288D1" size={24} />
              <Text className="text-2xl font-bold text-text-main mt-1">
                {dive.duration}분
              </Text>
              <Text className="text-xs text-text-sub">잠수시간</Text>
            </View>
            <View className="w-px h-16 bg-gray-200" />
            <View className="items-center">
              <Eye color="#0288D1" size={24} />
              <Text className="text-2xl font-bold text-text-main mt-1">
                {dive.visibility}m
              </Text>
              <Text className="text-xs text-text-sub">시야</Text>
            </View>
          </Card>
        </View>

        {/* Dive Profile Chart */}
        <View className="px-4 mt-6">
          <Card>
            <Text className="font-semibold text-text-main mb-4">📈 다이브 프로필</Text>
            <View className="items-center">
              <LineChart
                data={sampleDiveProfile}
                width={width - 80}
                height={180}
                curved
                color="#0288D1"
                thickness={3}
                startFillColor="#0288D1"
                endFillColor="#E0F7FA"
                startOpacity={0.4}
                endOpacity={0.1}
                areaChart
                yAxisColor="#E0F7FA"
                xAxisColor="#E0F7FA"
                yAxisTextStyle={{ color: '#78909C', fontSize: 10 }}
                xAxisLabelTextStyle={{ color: '#78909C', fontSize: 10 }}
                hideDataPoints
                hideRules
                noOfSections={5}
                yAxisSuffix="m"
                invertYAxis
              />
            </View>
            <Text className="text-center text-text-sub text-xs mt-2">
              시간 (분)
            </Text>
          </Card>
        </View>

        {/* Environment Info */}
        <View className="px-4 mt-4">
          <Card>
            <Text className="font-semibold text-text-main mb-4">🌊 환경 정보</Text>
            <View className="flex-row flex-wrap">
              <View className="w-1/2 flex-row items-center mb-4">
                <View className="w-10 h-10 rounded-full bg-primary items-center justify-center mr-3">
                  <Thermometer color="#FFAB91" size={20} />
                </View>
                <View>
                  <Text className="text-text-sub text-xs">수면 온도</Text>
                  <Text className="text-text-main font-medium">
                    {dive.temp_surface}°C
                  </Text>
                </View>
              </View>
              <View className="w-1/2 flex-row items-center mb-4">
                <View className="w-10 h-10 rounded-full bg-primary items-center justify-center mr-3">
                  <Thermometer color="#0288D1" size={20} />
                </View>
                <View>
                  <Text className="text-text-sub text-xs">수중 온도</Text>
                  <Text className="text-text-main font-medium">
                    {dive.temp_bottom}°C
                  </Text>
                </View>
              </View>
              <View className="w-1/2 flex-row items-center mb-4">
                <View className="w-10 h-10 rounded-full bg-primary items-center justify-center mr-3">
                  <Cloud color="#78909C" size={20} />
                </View>
                <View>
                  <Text className="text-text-sub text-xs">날씨</Text>
                  <Text className="text-text-main font-medium">{dive.weather}</Text>
                </View>
              </View>
              <View className="w-1/2 flex-row items-center mb-4">
                <View className="w-10 h-10 rounded-full bg-primary items-center justify-center mr-3">
                  <Waves color="#0288D1" size={20} />
                </View>
                <View>
                  <Text className="text-text-sub text-xs">조류</Text>
                  <Text className="text-text-main font-medium">{dive.current}</Text>
                </View>
              </View>
            </View>
          </Card>
        </View>

        {/* Equipment */}
        <View className="px-4 mt-4">
          <Card>
            <Text className="font-semibold text-text-main mb-4">🤿 장비 정보</Text>
            <View className="flex-row justify-between mb-3">
              <Text className="text-text-sub">탱크 압력</Text>
              <Text className="text-text-main font-medium">
                {dive.tank_start} → {dive.tank_end} bar
              </Text>
            </View>
            <View className="h-3 bg-gray-100 rounded-full overflow-hidden mb-4">
              <View
                className="h-full bg-secondary rounded-full"
                style={{ width: `${(dive.tank_end / dive.tank_start) * 100}%` }}
              />
            </View>
            <View className="flex-row justify-between mb-2">
              <Text className="text-text-sub">웨이트</Text>
              <Text className="text-text-main font-medium">{dive.weight}kg</Text>
            </View>
            <View className="flex-row justify-between">
              <Text className="text-text-sub">슈트</Text>
              <Text className="text-text-main font-medium">{dive.suit_type}</Text>
            </View>
          </Card>
        </View>

        {/* Sea Friends */}
        <View className="px-4 mt-4">
          <Card>
            <Text className="font-semibold text-text-main mb-4">
              🐠 발견한 바다 친구들
            </Text>
            <View className="flex-row flex-wrap">
              {dive.sightings.map((sighting) => (
                <View
                  key={sighting.id}
                  className="flex-row items-center bg-primary rounded-full px-4 py-2 mr-2 mb-2"
                >
                  <Text className="text-xl mr-2">{sighting.emoji}</Text>
                  <Text className="text-text-main font-medium">
                    {sighting.name}
                  </Text>
                  <View className="w-5 h-5 rounded-full bg-secondary ml-2 items-center justify-center">
                    <Text className="text-white text-xs">{sighting.count}</Text>
                  </View>
                </View>
              ))}
            </View>
          </Card>
        </View>

        {/* Notes */}
        <View className="px-4 mt-4 mb-8">
          <Card>
            <Text className="font-semibold text-text-main mb-4">📝 다이빙 메모</Text>
            <Text className="text-text-main leading-6">{dive.notes}</Text>
          </Card>
        </View>

        {/* Diary Button */}
        <View className="px-4 mb-8">
          <TouchableOpacity
            onPress={() => router.push('/diary/editor')}
            className="bg-accent py-4 rounded-2xl items-center"
          >
            <Text className="text-white font-semibold text-lg">
              🎨 다이어리 꾸미기
            </Text>
          </TouchableOpacity>
        </View>
      </ScrollView>
    </View>
  );
}
