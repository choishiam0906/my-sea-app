import React, { useState, useRef } from 'react';
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  Dimensions,
  Alert,
} from 'react-native';
import { useRouter } from 'expo-router';
import { LinearGradient } from 'expo-linear-gradient';
import Carousel from 'react-native-reanimated-carousel';
import Animated, {
  useSharedValue,
  useAnimatedStyle,
  withSpring,
} from 'react-native-reanimated';
import { ChevronRight, ChevronLeft, Check } from 'lucide-react-native';
import { Button, Card, Input } from '@/components/ui';
import { useAuthStore } from '@/store/useAuthStore';
import { BuddyColors } from '@/constants/theme';

const { width, height } = Dimensions.get('window');

interface OnboardingSlide {
  id: number;
  title: string;
  description: string;
  emoji: string;
}

const slides: OnboardingSlide[] = [
  {
    id: 1,
    title: 'My Sea에 오신 것을 환영해요!',
    description: '당신만의 특별한 바다를 만들어보세요.\n다이빙의 모든 순간을 기록하고 추억해요.',
    emoji: '🌊',
  },
  {
    id: 2,
    title: '나만의 버디를 만들어요',
    description: '함께 바다를 탐험할 귀여운 물범 친구에게\n이름을 지어주세요!',
    emoji: '🦭',
  },
  {
    id: 3,
    title: '버디 꾸미기',
    description: '버디의 장비 색상을 선택해주세요.\n언제든 프로필에서 변경할 수 있어요!',
    emoji: '🎨',
  },
];

export default function OnboardingScreen() {
  const router = useRouter();
  const { updateProfile, setIsOnboarded } = useAuthStore();
  const [currentIndex, setCurrentIndex] = useState(0);
  const [buddyName, setBuddyName] = useState('');
  const [selectedColor, setSelectedColor] = useState(BuddyColors[0]);
  const [isLoading, setIsLoading] = useState(false);
  const carouselRef = useRef<any>(null);

  const handleNext = () => {
    if (currentIndex < slides.length - 1) {
      carouselRef.current?.scrollTo({ index: currentIndex + 1, animated: true });
    }
  };

  const handlePrev = () => {
    if (currentIndex > 0) {
      carouselRef.current?.scrollTo({ index: currentIndex - 1, animated: true });
    }
  };

  const handleComplete = async () => {
    if (!buddyName.trim()) {
      Alert.alert('알림', '버디 이름을 입력해주세요!');
      return;
    }

    if (buddyName.length > 10) {
      Alert.alert('알림', '버디 이름은 10자 이내로 입력해주세요!');
      return;
    }

    Alert.alert(
      '확인',
      `"${buddyName}"로 이름을 정할까요?\n한 번 정한 이름은 변경할 수 없어요!`,
      [
        { text: '취소', style: 'cancel' },
        {
          text: '확인',
          onPress: async () => {
            setIsLoading(true);
            try {
              await updateProfile({
                buddy_name: buddyName,
                buddy_color: selectedColor.color,
              });
              setIsOnboarded(true);
              router.replace('/(tabs)');
            } catch (error) {
              Alert.alert('오류', '프로필 저장에 실패했어요. 다시 시도해주세요.');
            } finally {
              setIsLoading(false);
            }
          },
        },
      ]
    );
  };

  const renderSlide = ({ item, index }: { item: OnboardingSlide; index: number }) => {
    if (index === 0) {
      // Welcome slide
      return (
        <View className="flex-1 items-center justify-center px-8">
          <Text className="text-8xl mb-8">{item.emoji}</Text>
          <Text className="text-3xl font-bold text-text-main text-center mb-4">
            {item.title}
          </Text>
          <Text className="text-text-sub text-center text-lg leading-7">
            {item.description}
          </Text>
        </View>
      );
    }

    if (index === 1) {
      // Buddy name input slide
      return (
        <View className="flex-1 items-center justify-center px-8">
          <View className="w-32 h-32 rounded-full bg-surface items-center justify-center shadow-lg mb-6">
            <Text className="text-7xl">{item.emoji}</Text>
          </View>
          <Text className="text-2xl font-bold text-text-main text-center mb-4">
            {item.title}
          </Text>
          <Text className="text-text-sub text-center mb-8">
            {item.description}
          </Text>

          <View className="w-full">
            <View className="bg-surface rounded-3xl px-6 py-4 shadow-md">
              <TextInput
                className="text-xl text-center text-text-main"
                placeholder="버디 이름 입력"
                placeholderTextColor="#78909C"
                value={buddyName}
                onChangeText={setBuddyName}
                maxLength={10}
              />
            </View>
            <Text className="text-center text-text-sub text-sm mt-2">
              {buddyName.length}/10자
            </Text>
          </View>
        </View>
      );
    }

    // Color selection slide
    return (
      <View className="flex-1 items-center justify-center px-8">
        <View
          className="w-32 h-32 rounded-full items-center justify-center shadow-lg mb-6"
          style={{ backgroundColor: selectedColor.color + '30' }}
        >
          <Text className="text-7xl">🦭</Text>
        </View>
        <Text className="text-xl font-bold text-text-main mb-2">
          {buddyName || '버디'}
        </Text>
        <Text className="text-text-sub text-center mb-8">
          {item.description}
        </Text>

        <View className="flex-row flex-wrap justify-center">
          {BuddyColors.map((color) => (
            <TouchableOpacity
              key={color.id}
              onPress={() => setSelectedColor(color)}
              className="m-2"
            >
              <View
                className={`w-16 h-16 rounded-full items-center justify-center ${
                  selectedColor.id === color.id
                    ? 'border-4 border-white shadow-lg'
                    : ''
                }`}
                style={{ backgroundColor: color.color }}
              >
                {selectedColor.id === color.id && (
                  <Check color="#FFFFFF" size={24} />
                )}
              </View>
              <Text className="text-center text-xs text-text-sub mt-1">
                {color.name}
              </Text>
            </TouchableOpacity>
          ))}
        </View>
      </View>
    );
  };

  return (
    <LinearGradient
      colors={['#E0F7FA', '#4FC3F7', '#0288D1']}
      className="flex-1"
      start={{ x: 0, y: 0 }}
      end={{ x: 0, y: 1 }}
    >
      {/* Carousel */}
      <View className="flex-1">
        <Carousel
          ref={carouselRef}
          data={slides}
          renderItem={renderSlide}
          width={width}
          height={height * 0.7}
          loop={false}
          onSnapToItem={setCurrentIndex}
          enabled={false}
        />
      </View>

      {/* Progress Dots */}
      <View className="flex-row justify-center mb-6">
        {slides.map((_, index) => (
          <View
            key={index}
            className={`w-3 h-3 rounded-full mx-1 ${
              index === currentIndex ? 'bg-white' : 'bg-white/40'
            }`}
          />
        ))}
      </View>

      {/* Navigation Buttons */}
      <View className="flex-row justify-between items-center px-6 pb-12">
        {currentIndex > 0 ? (
          <TouchableOpacity
            onPress={handlePrev}
            className="w-14 h-14 rounded-full bg-white/30 items-center justify-center"
          >
            <ChevronLeft color="#FFFFFF" size={28} />
          </TouchableOpacity>
        ) : (
          <View className="w-14" />
        )}

        {currentIndex < slides.length - 1 ? (
          <TouchableOpacity
            onPress={handleNext}
            disabled={currentIndex === 1 && !buddyName.trim()}
            className={`w-14 h-14 rounded-full items-center justify-center ${
              currentIndex === 1 && !buddyName.trim()
                ? 'bg-white/20'
                : 'bg-white'
            }`}
          >
            <ChevronRight
              color={currentIndex === 1 && !buddyName.trim() ? '#FFFFFF80' : '#0288D1'}
              size={28}
            />
          </TouchableOpacity>
        ) : (
          <TouchableOpacity
            onPress={handleComplete}
            disabled={isLoading}
            className="bg-white px-8 py-4 rounded-full flex-row items-center"
          >
            <Text className="text-secondary font-bold text-lg mr-2">
              {isLoading ? '저장 중...' : '시작하기'}
            </Text>
            {!isLoading && <Check color="#0288D1" size={24} />}
          </TouchableOpacity>
        )}
      </View>
    </LinearGradient>
  );
}
