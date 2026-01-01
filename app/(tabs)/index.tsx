import React from 'react';
import { View, Text, ScrollView, TouchableOpacity, Image } from 'react-native';
import { Link, useRouter } from 'expo-router';
import { Plus, Award, TrendingUp, Calendar } from 'lucide-react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { Card, Button } from '@/components/ui';
import { useAuthStore } from '@/store/useAuthStore';
import { useDiveStore } from '@/store/useDiveStore';

export default function HomeScreen() {
  const router = useRouter();
  const { profile } = useAuthStore();
  const { dives } = useDiveStore();

  const totalDives = dives.length;
  const totalTime = dives.reduce((acc, dive) => acc + (dive.duration || 0), 0);
  const maxDepth = Math.max(...dives.map((d) => d.depth_max || 0), 0);

  return (
    <ScrollView className="flex-1 bg-primary">
      {/* Header with Buddy */}
      <LinearGradient
        colors={['#E0F7FA', '#4FC3F7', '#0288D1']}
        className="px-6 pt-6 pb-12 rounded-b-[40px]"
      >
        <View className="flex-row justify-between items-start mb-6">
          <View>
            <Text className="text-text-sub text-sm">안녕하세요!</Text>
            <Text className="text-text-main text-2xl font-bold">
              {profile?.buddy_name || '다이버'}님의 바다
            </Text>
          </View>
          <View className="w-12 h-12 rounded-full bg-surface items-center justify-center shadow-md">
            <Text className="text-2xl">🦭</Text>
          </View>
        </View>

        {/* Quick Stats */}
        <View className="flex-row justify-between">
          <Card className="flex-1 mr-2 items-center">
            <TrendingUp color="#0288D1" size={20} />
            <Text className="text-2xl font-bold text-text-main mt-1">
              {totalDives}
            </Text>
            <Text className="text-xs text-text-sub">총 다이브</Text>
          </Card>
          <Card className="flex-1 mx-1 items-center">
            <Calendar color="#0288D1" size={20} />
            <Text className="text-2xl font-bold text-text-main mt-1">
              {Math.floor(totalTime / 60)}분
            </Text>
            <Text className="text-xs text-text-sub">총 수중시간</Text>
          </Card>
          <Card className="flex-1 ml-2 items-center">
            <Award color="#FFAB91" size={20} />
            <Text className="text-2xl font-bold text-text-main mt-1">
              {maxDepth}m
            </Text>
            <Text className="text-xs text-text-sub">최대 수심</Text>
          </Card>
        </View>
      </LinearGradient>

      <View className="px-6 -mt-4">
        {/* Add New Dive Button */}
        <TouchableOpacity
          onPress={() => router.push('/log/new')}
          className="bg-secondary rounded-2xl p-4 flex-row items-center justify-center shadow-lg mb-6"
        >
          <Plus color="#FFFFFF" size={24} />
          <Text className="text-white font-semibold text-lg ml-2">
            새 다이브 기록하기
          </Text>
        </TouchableOpacity>

        {/* Recent Dives */}
        <View className="mb-6">
          <View className="flex-row justify-between items-center mb-4">
            <Text className="text-lg font-bold text-text-main">최근 다이브</Text>
            <Link href="/logs" asChild>
              <TouchableOpacity>
                <Text className="text-secondary">모두 보기</Text>
              </TouchableOpacity>
            </Link>
          </View>

          {dives.length === 0 ? (
            <Card className="items-center py-8">
              <Text className="text-6xl mb-4">🌊</Text>
              <Text className="text-text-main font-medium text-center">
                아직 기록된 다이브가 없어요
              </Text>
              <Text className="text-text-sub text-sm text-center mt-1">
                첫 다이브를 기록해보세요!
              </Text>
            </Card>
          ) : (
            dives.slice(0, 3).map((dive) => (
              <TouchableOpacity
                key={dive.id}
                onPress={() => router.push(`/logs/${dive.id}`)}
              >
                <Card className="mb-3 flex-row items-center">
                  <View className="w-12 h-12 rounded-xl bg-primary items-center justify-center mr-4">
                    <Text className="text-2xl">🤿</Text>
                  </View>
                  <View className="flex-1">
                    <Text className="font-semibold text-text-main">
                      {dive.site_name}
                    </Text>
                    <Text className="text-text-sub text-sm">
                      {dive.date} · {dive.depth_max}m · {dive.duration}분
                    </Text>
                  </View>
                </Card>
              </TouchableOpacity>
            ))
          )}
        </View>

        {/* Sea Friends Collection */}
        <View className="mb-6">
          <Text className="text-lg font-bold text-text-main mb-4">
            발견한 바다 친구들 🐠
          </Text>
          <Card>
            <View className="flex-row flex-wrap justify-center">
              {['🐢', '🐠', '🐙', '🦈', '🐬', '🦭', '🪼', '🦀', '⭐'].map(
                (emoji, index) => (
                  <View
                    key={index}
                    className={`w-12 h-12 rounded-full items-center justify-center m-1 ${
                      index < 3 ? 'bg-primary' : 'bg-gray-100'
                    }`}
                  >
                    <Text className={`text-2xl ${index >= 3 ? 'opacity-30' : ''}`}>
                      {emoji}
                    </Text>
                  </View>
                )
              )}
            </View>
            <Text className="text-center text-text-sub text-sm mt-3">
              3 / 20 종 발견
            </Text>
          </Card>
        </View>

        {/* Level Progress */}
        <Card className="mb-8">
          <View className="flex-row items-center mb-3">
            <View className="w-10 h-10 rounded-full bg-accent items-center justify-center mr-3">
              <Text className="text-lg font-bold text-white">
                {profile?.level || 1}
              </Text>
            </View>
            <View className="flex-1">
              <Text className="font-semibold text-text-main">초보 다이버</Text>
              <Text className="text-text-sub text-xs">다음 레벨까지 150 EXP</Text>
            </View>
          </View>
          <View className="h-3 bg-gray-100 rounded-full overflow-hidden">
            <View
              className="h-full bg-secondary rounded-full"
              style={{ width: `${((profile?.exp || 0) / 500) * 100}%` }}
            />
          </View>
        </Card>
      </View>
    </ScrollView>
  );
}
