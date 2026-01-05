import React, { useState } from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  Alert,
  ActivityIndicator,
} from 'react-native';
import { useRouter } from 'expo-router';
import { LinearGradient } from 'expo-linear-gradient';
import { signInWithGoogle, signInWithKakao, signInWithNaver } from '@/lib/supabase';
import { useAuthStore } from '@/store/useAuthStore';

export default function LoginScreen() {
  const router = useRouter();
  const { setUser, fetchProfile } = useAuthStore();
  const [isLoading, setIsLoading] = useState<string | null>(null);

  const handleSocialLogin = async (provider: 'google' | 'kakao' | 'naver') => {
    setIsLoading(provider);

    try {
      let result;
      switch (provider) {
        case 'google':
          result = await signInWithGoogle();
          break;
        case 'kakao':
          result = await signInWithKakao();
          break;
        case 'naver':
          result = await signInWithNaver();
          break;
      }

      if (result?.error) {
        throw result.error;
      }

      // OAuth will redirect, so we wait for the callback
      // The auth state listener will handle the rest
    } catch (error: any) {
      Alert.alert('로그인 오류', error.message || '로그인에 실패했습니다.');
    } finally {
      setIsLoading(null);
    }
  };

  const handleSkip = () => {
    // Demo mode - skip authentication
    router.replace('/(tabs)');
  };

  return (
    <LinearGradient
      colors={['#0D47A1', '#1565C0', '#1976D2', '#42A5F5']}
      className="flex-1"
    >
      <View className="flex-1 justify-center px-8">
        {/* Logo & App Name */}
        <View className="items-center mb-16">
          <View className="w-28 h-28 rounded-full bg-white/95 items-center justify-center shadow-2xl mb-6">
            <Text className="text-6xl">🤿</Text>
          </View>
          <Text className="text-4xl font-bold text-white tracking-wide">MyDeepDive</Text>
          <Text className="text-white/80 mt-3 text-lg">나만의 깊은 바다 여행</Text>
        </View>

        {/* Social Login Buttons */}
        <View className="bg-white/95 rounded-3xl p-6 shadow-2xl">
          <Text className="text-center text-gray-600 mb-6 text-base">
            간편 로그인으로 시작하세요
          </Text>

          {/* Google Login */}
          <TouchableOpacity
            onPress={() => handleSocialLogin('google')}
            disabled={isLoading !== null}
            className="flex-row items-center justify-center bg-white border border-gray-300 rounded-2xl py-4 px-6 mb-3 shadow-sm"
          >
            {isLoading === 'google' ? (
              <ActivityIndicator color="#4285F4" />
            ) : (
              <>
                <View className="w-6 h-6 mr-3 items-center justify-center">
                  <Text className="text-xl">🔵</Text>
                </View>
                <Text className="text-gray-700 font-semibold text-base">Google로 계속하기</Text>
              </>
            )}
          </TouchableOpacity>

          {/* Kakao Login */}
          <TouchableOpacity
            onPress={() => handleSocialLogin('kakao')}
            disabled={isLoading !== null}
            className="flex-row items-center justify-center bg-[#FEE500] rounded-2xl py-4 px-6 mb-3 shadow-sm"
          >
            {isLoading === 'kakao' ? (
              <ActivityIndicator color="#3C1E1E" />
            ) : (
              <>
                <View className="w-6 h-6 mr-3 items-center justify-center">
                  <Text className="text-xl">💬</Text>
                </View>
                <Text className="text-[#3C1E1E] font-semibold text-base">카카오로 계속하기</Text>
              </>
            )}
          </TouchableOpacity>

          {/* Naver Login */}
          <TouchableOpacity
            onPress={() => handleSocialLogin('naver')}
            disabled={isLoading !== null}
            className="flex-row items-center justify-center bg-[#03C75A] rounded-2xl py-4 px-6 shadow-sm"
          >
            {isLoading === 'naver' ? (
              <ActivityIndicator color="#FFFFFF" />
            ) : (
              <>
                <View className="w-6 h-6 mr-3 items-center justify-center">
                  <Text className="text-xl font-bold text-white">N</Text>
                </View>
                <Text className="text-white font-semibold text-base">네이버로 계속하기</Text>
              </>
            )}
          </TouchableOpacity>
        </View>

        {/* Terms Notice */}
        <Text className="text-center text-white/60 text-xs mt-6 px-4">
          로그인 시 서비스 이용약관 및 개인정보 처리방침에 동의하게 됩니다
        </Text>

        {/* Skip Button (Demo Mode) */}
        <TouchableOpacity onPress={handleSkip} className="mt-8">
          <Text className="text-center text-white/70 text-base underline">
            둘러보기 (데모 모드)
          </Text>
        </TouchableOpacity>
      </View>
    </LinearGradient>
  );
}
