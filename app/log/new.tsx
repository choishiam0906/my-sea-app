import React, { useState } from 'react';
import {
  View,
  Text,
  ScrollView,
  TouchableOpacity,
  TextInput,
  Alert,
} from 'react-native';
import { useRouter } from 'expo-router';
import { LinearGradient } from 'expo-linear-gradient';
import {
  Calendar,
  MapPin,
  ArrowDown,
  Clock,
  Eye,
  Thermometer,
  Wind,
  Waves,
  X,
  Check,
} from 'lucide-react-native';
import { Card, Button, Input } from '@/components/ui';
import { SeaFriends } from '@/constants/theme';
import { useDiveStore } from '@/store/useDiveStore';

export default function NewDiveScreen() {
  const router = useRouter();
  const { createDive } = useDiveStore();

  // Basic Info
  const [date, setDate] = useState(new Date().toISOString().split('T')[0]);
  const [siteName, setSiteName] = useState('');
  const [location, setLocation] = useState('');

  // Dive Stats
  const [depthMax, setDepthMax] = useState('');
  const [depthAvg, setDepthAvg] = useState('');
  const [duration, setDuration] = useState('');
  const [visibility, setVisibility] = useState('');

  // Environment
  const [tempSurface, setTempSurface] = useState('');
  const [tempBottom, setTempBottom] = useState('');
  const [weather, setWeather] = useState('');
  const [current, setCurrent] = useState('');

  // Equipment
  const [tankStart, setTankStart] = useState('200');
  const [tankEnd, setTankEnd] = useState('');
  const [weight, setWeight] = useState('');

  // Sea Friends
  const [selectedFriends, setSelectedFriends] = useState<string[]>([]);

  // Notes
  const [notes, setNotes] = useState('');

  const [isLoading, setIsLoading] = useState(false);

  const toggleFriend = (id: string) => {
    setSelectedFriends((prev) =>
      prev.includes(id) ? prev.filter((f) => f !== id) : [...prev, id]
    );
  };

  const handleSave = async () => {
    if (!siteName.trim()) {
      Alert.alert('알림', '다이브 포인트를 입력해주세요.');
      return;
    }

    setIsLoading(true);

    try {
      const dive = await createDive({
        date,
        site_name: siteName,
        location,
        depth_max: parseFloat(depthMax) || 0,
        depth_avg: parseFloat(depthAvg) || 0,
        duration: parseInt(duration) || 0,
        visibility: parseInt(visibility) || 0,
        notes,
      });

      if (dive) {
        Alert.alert('완료', '다이브가 기록되었습니다!', [
          { text: '확인', onPress: () => router.back() },
        ]);
      }
    } catch (error) {
      Alert.alert('오류', '저장에 실패했습니다.');
    } finally {
      setIsLoading(false);
    }
  };

  const weatherOptions = ['☀️ 맑음', '⛅ 구름', '☁️ 흐림', '🌧️ 비'];
  const currentOptions = ['없음', '약함', '보통', '강함'];

  return (
    <View className="flex-1 bg-primary">
      {/* Header */}
      <LinearGradient
        colors={['#E0F7FA', '#4FC3F7']}
        className="pt-4 pb-6 px-4"
      >
        <View className="flex-row justify-between items-center">
          <TouchableOpacity onPress={() => router.back()}>
            <X color="#263238" size={24} />
          </TouchableOpacity>
          <Text className="text-lg font-bold text-text-main">
            새 다이브 기록
          </Text>
          <TouchableOpacity onPress={handleSave} disabled={isLoading}>
            <Check color="#0288D1" size={24} />
          </TouchableOpacity>
        </View>
      </LinearGradient>

      <ScrollView className="flex-1 px-4" showsVerticalScrollIndicator={false}>
        {/* Date & Location */}
        <Card className="mt-4 mb-4">
          <Text className="font-semibold text-text-main mb-4">📍 기본 정보</Text>

          <View className="mb-4">
            <Text className="text-text-sub text-sm mb-2">날짜</Text>
            <View className="flex-row items-center bg-primary rounded-xl px-4 py-3">
              <Calendar color="#0288D1" size={20} />
              <TextInput
                className="flex-1 ml-3 text-text-main"
                value={date}
                onChangeText={setDate}
                placeholder="YYYY-MM-DD"
              />
            </View>
          </View>

          <View className="mb-4">
            <Text className="text-text-sub text-sm mb-2">다이브 포인트</Text>
            <Input
              placeholder="예: 제주 서귀포 문섬"
              value={siteName}
              onChangeText={setSiteName}
              leftIcon={<MapPin color="#78909C" size={20} />}
            />
          </View>

          <View>
            <Text className="text-text-sub text-sm mb-2">지역</Text>
            <Input
              placeholder="예: 제주도"
              value={location}
              onChangeText={setLocation}
            />
          </View>
        </Card>

        {/* Dive Stats */}
        <Card className="mb-4">
          <Text className="font-semibold text-text-main mb-4">📊 다이브 정보</Text>

          <View className="flex-row mb-4">
            <View className="flex-1 mr-2">
              <Text className="text-text-sub text-sm mb-2">최대 수심 (m)</Text>
              <View className="flex-row items-center bg-primary rounded-xl px-4 py-3">
                <ArrowDown color="#0288D1" size={20} />
                <TextInput
                  className="flex-1 ml-3 text-text-main"
                  keyboardType="numeric"
                  value={depthMax}
                  onChangeText={setDepthMax}
                  placeholder="25"
                />
              </View>
            </View>
            <View className="flex-1 ml-2">
              <Text className="text-text-sub text-sm mb-2">평균 수심 (m)</Text>
              <View className="flex-row items-center bg-primary rounded-xl px-4 py-3">
                <ArrowDown color="#78909C" size={20} />
                <TextInput
                  className="flex-1 ml-3 text-text-main"
                  keyboardType="numeric"
                  value={depthAvg}
                  onChangeText={setDepthAvg}
                  placeholder="18"
                />
              </View>
            </View>
          </View>

          <View className="flex-row">
            <View className="flex-1 mr-2">
              <Text className="text-text-sub text-sm mb-2">잠수 시간 (분)</Text>
              <View className="flex-row items-center bg-primary rounded-xl px-4 py-3">
                <Clock color="#0288D1" size={20} />
                <TextInput
                  className="flex-1 ml-3 text-text-main"
                  keyboardType="numeric"
                  value={duration}
                  onChangeText={setDuration}
                  placeholder="45"
                />
              </View>
            </View>
            <View className="flex-1 ml-2">
              <Text className="text-text-sub text-sm mb-2">시야 (m)</Text>
              <View className="flex-row items-center bg-primary rounded-xl px-4 py-3">
                <Eye color="#0288D1" size={20} />
                <TextInput
                  className="flex-1 ml-3 text-text-main"
                  keyboardType="numeric"
                  value={visibility}
                  onChangeText={setVisibility}
                  placeholder="15"
                />
              </View>
            </View>
          </View>
        </Card>

        {/* Environment */}
        <Card className="mb-4">
          <Text className="font-semibold text-text-main mb-4">🌊 환경 정보</Text>

          <View className="flex-row mb-4">
            <View className="flex-1 mr-2">
              <Text className="text-text-sub text-sm mb-2">수면 온도 (°C)</Text>
              <View className="flex-row items-center bg-primary rounded-xl px-4 py-3">
                <Thermometer color="#FFAB91" size={20} />
                <TextInput
                  className="flex-1 ml-3 text-text-main"
                  keyboardType="numeric"
                  value={tempSurface}
                  onChangeText={setTempSurface}
                  placeholder="24"
                />
              </View>
            </View>
            <View className="flex-1 ml-2">
              <Text className="text-text-sub text-sm mb-2">수중 온도 (°C)</Text>
              <View className="flex-row items-center bg-primary rounded-xl px-4 py-3">
                <Thermometer color="#0288D1" size={20} />
                <TextInput
                  className="flex-1 ml-3 text-text-main"
                  keyboardType="numeric"
                  value={tempBottom}
                  onChangeText={setTempBottom}
                  placeholder="20"
                />
              </View>
            </View>
          </View>

          <View className="mb-4">
            <Text className="text-text-sub text-sm mb-2">날씨</Text>
            <ScrollView horizontal showsHorizontalScrollIndicator={false}>
              {weatherOptions.map((option) => (
                <TouchableOpacity
                  key={option}
                  onPress={() => setWeather(option)}
                  className={`mr-2 px-4 py-2 rounded-full ${
                    weather === option ? 'bg-secondary' : 'bg-primary'
                  }`}
                >
                  <Text
                    className={weather === option ? 'text-white' : 'text-text-main'}
                  >
                    {option}
                  </Text>
                </TouchableOpacity>
              ))}
            </ScrollView>
          </View>

          <View>
            <Text className="text-text-sub text-sm mb-2">조류</Text>
            <ScrollView horizontal showsHorizontalScrollIndicator={false}>
              {currentOptions.map((option) => (
                <TouchableOpacity
                  key={option}
                  onPress={() => setCurrent(option)}
                  className={`mr-2 px-4 py-2 rounded-full ${
                    current === option ? 'bg-secondary' : 'bg-primary'
                  }`}
                >
                  <Text
                    className={current === option ? 'text-white' : 'text-text-main'}
                  >
                    {option}
                  </Text>
                </TouchableOpacity>
              ))}
            </ScrollView>
          </View>
        </Card>

        {/* Sea Friends */}
        <Card className="mb-4">
          <Text className="font-semibold text-text-main mb-4">
            🐠 발견한 바다 친구들
          </Text>
          <View className="flex-row flex-wrap">
            {SeaFriends.map((friend) => (
              <TouchableOpacity
                key={friend.id}
                onPress={() => toggleFriend(friend.id)}
                className="w-1/4 items-center mb-4"
              >
                <View
                  className={`w-14 h-14 rounded-full items-center justify-center ${
                    selectedFriends.includes(friend.id)
                      ? 'bg-secondary'
                      : 'bg-primary'
                  }`}
                >
                  <Text className="text-2xl">{friend.emoji}</Text>
                </View>
                <Text
                  className={`text-xs mt-1 ${
                    selectedFriends.includes(friend.id)
                      ? 'text-secondary font-medium'
                      : 'text-text-sub'
                  }`}
                >
                  {friend.name}
                </Text>
              </TouchableOpacity>
            ))}
          </View>
        </Card>

        {/* Notes */}
        <Card className="mb-8">
          <Text className="font-semibold text-text-main mb-4">📝 메모</Text>
          <TextInput
            className="bg-primary rounded-xl p-4 text-text-main min-h-[100px]"
            placeholder="오늘의 다이빙은 어땠나요?"
            placeholderTextColor="#78909C"
            multiline
            textAlignVertical="top"
            value={notes}
            onChangeText={setNotes}
          />
        </Card>

        {/* Save Button */}
        <Button
          title="다이브 저장하기"
          onPress={handleSave}
          isLoading={isLoading}
          className="mb-8"
          size="lg"
        />
      </ScrollView>
    </View>
  );
}
