import React from 'react';
import { View, Text, ScrollView, TouchableOpacity, Alert } from 'react-native';
import { useRouter } from 'expo-router';
import {
  Settings,
  Award,
  Heart,
  Share2,
  HelpCircle,
  LogOut,
  ChevronRight,
  Bell,
  Moon,
  Globe,
} from 'lucide-react-native';
import { Card, Button } from '@/components/ui';
import { useAuthStore } from '@/store/useAuthStore';

// Sample badges for demo
const sampleBadges = [
  { id: '1', name: '첫 다이브', icon: '🏊', earned: true },
  { id: '2', name: '10회 달성', icon: '🎯', earned: true },
  { id: '3', name: '심해 탐험가', icon: '🌊', earned: false },
  { id: '4', name: '생물 수집가', icon: '🐠', earned: false },
  { id: '5', name: '7일 연속', icon: '🔥', earned: false },
  { id: '6', name: '마스터 다이버', icon: '👑', earned: false },
];

export default function ProfileScreen() {
  const router = useRouter();
  const { profile, signOut } = useAuthStore();

  const handleSignOut = () => {
    Alert.alert('로그아웃', '정말 로그아웃 하시겠어요?', [
      { text: '취소', style: 'cancel' },
      {
        text: '로그아웃',
        style: 'destructive',
        onPress: () => signOut(),
      },
    ]);
  };

  const menuItems = [
    {
      icon: <Bell color="#0288D1" size={22} />,
      title: '알림 설정',
      subtitle: '푸시 알림 관리',
    },
    {
      icon: <Moon color="#0288D1" size={22} />,
      title: '다크 모드',
      subtitle: '시스템 설정 따르기',
    },
    {
      icon: <Globe color="#0288D1" size={22} />,
      title: '언어',
      subtitle: '한국어',
    },
    {
      icon: <Share2 color="#0288D1" size={22} />,
      title: '앱 공유하기',
      subtitle: '친구에게 추천하기',
    },
    {
      icon: <HelpCircle color="#0288D1" size={22} />,
      title: '도움말',
      subtitle: '사용 가이드 및 FAQ',
    },
  ];

  return (
    <ScrollView className="flex-1 bg-primary">
      {/* Profile Header */}
      <View className="items-center pt-6 pb-8">
        <View className="w-24 h-24 rounded-full bg-surface items-center justify-center shadow-lg mb-4">
          <Text className="text-5xl">🦭</Text>
        </View>
        <Text className="text-2xl font-bold text-text-main">
          {profile?.buddy_name || '바다친구'}
        </Text>
        <Text className="text-text-sub">@{profile?.username || 'diver'}</Text>

        {/* Level Badge */}
        <View className="flex-row items-center mt-3 bg-surface px-4 py-2 rounded-full shadow-sm">
          <View className="w-8 h-8 rounded-full bg-accent items-center justify-center mr-2">
            <Text className="text-white font-bold">{profile?.level || 1}</Text>
          </View>
          <Text className="text-text-main font-medium">초보 다이버</Text>
        </View>
      </View>

      {/* Stats */}
      <View className="px-4 mb-6">
        <Card className="flex-row justify-around py-4">
          <View className="items-center">
            <Text className="text-2xl font-bold text-secondary">23</Text>
            <Text className="text-text-sub text-sm">다이브</Text>
          </View>
          <View className="w-px h-12 bg-gray-200" />
          <View className="items-center">
            <Text className="text-2xl font-bold text-secondary">12</Text>
            <Text className="text-text-sub text-sm">발견 생물</Text>
          </View>
          <View className="w-px h-12 bg-gray-200" />
          <View className="items-center">
            <Text className="text-2xl font-bold text-secondary">2</Text>
            <Text className="text-text-sub text-sm">뱃지</Text>
          </View>
        </Card>
      </View>

      {/* Badges Section */}
      <View className="px-4 mb-6">
        <View className="flex-row justify-between items-center mb-4">
          <Text className="text-lg font-bold text-text-main">나의 뱃지</Text>
          <TouchableOpacity>
            <Text className="text-secondary">모두 보기</Text>
          </TouchableOpacity>
        </View>
        <ScrollView
          horizontal
          showsHorizontalScrollIndicator={false}
          contentContainerStyle={{ paddingRight: 16 }}
        >
          {sampleBadges.map((badge) => (
            <View
              key={badge.id}
              className={`w-20 h-24 mr-3 rounded-2xl items-center justify-center ${
                badge.earned ? 'bg-surface shadow-sm' : 'bg-gray-100'
              }`}
            >
              <Text className={`text-3xl ${!badge.earned ? 'opacity-30' : ''}`}>
                {badge.icon}
              </Text>
              <Text
                className={`text-xs text-center mt-2 px-1 ${
                  badge.earned ? 'text-text-main' : 'text-text-sub'
                }`}
                numberOfLines={1}
              >
                {badge.name}
              </Text>
            </View>
          ))}
        </ScrollView>
      </View>

      {/* Menu Items */}
      <View className="px-4 mb-6">
        <Card padding="none">
          {menuItems.map((item, index) => (
            <TouchableOpacity
              key={index}
              className={`flex-row items-center py-4 px-4 ${
                index !== menuItems.length - 1 ? 'border-b border-gray-100' : ''
              }`}
            >
              <View className="w-10 h-10 rounded-full bg-primary items-center justify-center mr-4">
                {item.icon}
              </View>
              <View className="flex-1">
                <Text className="text-text-main font-medium">{item.title}</Text>
                <Text className="text-text-sub text-sm">{item.subtitle}</Text>
              </View>
              <ChevronRight color="#78909C" size={20} />
            </TouchableOpacity>
          ))}
        </Card>
      </View>

      {/* Sign Out */}
      <View className="px-4 mb-8">
        <TouchableOpacity
          onPress={handleSignOut}
          className="flex-row items-center justify-center py-4 bg-surface rounded-2xl"
        >
          <LogOut color="#F44336" size={20} />
          <Text className="text-red-500 font-medium ml-2">로그아웃</Text>
        </TouchableOpacity>
      </View>

      {/* App Info */}
      <View className="items-center pb-8">
        <Text className="text-text-sub text-sm">My Sea v1.0.0</Text>
        <Text className="text-text-sub text-xs mt-1">Made with 💙 for divers</Text>
      </View>
    </ScrollView>
  );
}
