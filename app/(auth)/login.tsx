import React, { useState } from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  KeyboardAvoidingView,
  Platform,
  ScrollView,
  Alert,
} from 'react-native';
import { useRouter } from 'expo-router';
import { LinearGradient } from 'expo-linear-gradient';
import { Mail, Lock, Eye, EyeOff } from 'lucide-react-native';
import { Button, Input } from '@/components/ui';
import { signIn, signUp } from '@/lib/supabase';
import { useAuthStore } from '@/store/useAuthStore';

export default function LoginScreen() {
  const router = useRouter();
  const { setUser, fetchProfile } = useAuthStore();
  const [isLogin, setIsLogin] = useState(true);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);

  const handleSubmit = async () => {
    if (!email.trim() || !password.trim()) {
      Alert.alert('알림', '이메일과 비밀번호를 입력해주세요.');
      return;
    }

    if (!isLogin && password !== confirmPassword) {
      Alert.alert('알림', '비밀번호가 일치하지 않습니다.');
      return;
    }

    setIsLoading(true);

    try {
      if (isLogin) {
        const { data, error } = await signIn(email, password);
        if (error) throw error;
        setUser(data.user);
        await fetchProfile();
        router.replace('/(tabs)');
      } else {
        const { data, error } = await signUp(email, password);
        if (error) throw error;
        Alert.alert(
          '회원가입 완료',
          '이메일 인증 후 로그인해주세요.',
          [{ text: '확인', onPress: () => setIsLogin(true) }]
        );
      }
    } catch (error: any) {
      Alert.alert('오류', error.message || '로그인에 실패했습니다.');
    } finally {
      setIsLoading(false);
    }
  };

  const handleSkip = () => {
    // Demo mode - skip authentication
    router.replace('/(tabs)');
  };

  return (
    <LinearGradient
      colors={['#E0F7FA', '#4FC3F7', '#0288D1']}
      className="flex-1"
    >
      <KeyboardAvoidingView
        className="flex-1"
        behavior={Platform.OS === 'ios' ? 'padding' : undefined}
      >
        <ScrollView
          contentContainerStyle={{ flexGrow: 1, justifyContent: 'center' }}
          keyboardShouldPersistTaps="handled"
        >
          <View className="px-8 py-12">
            {/* Logo */}
            <View className="items-center mb-12">
              <View className="w-24 h-24 rounded-full bg-white/90 items-center justify-center shadow-lg mb-4">
                <Text className="text-5xl">🦭</Text>
              </View>
              <Text className="text-3xl font-bold text-white">My Sea</Text>
              <Text className="text-white/80 mt-2">나만의 바다를 만들어요</Text>
            </View>

            {/* Form Card */}
            <View className="bg-white rounded-3xl p-6 shadow-xl">
              {/* Toggle */}
              <View className="flex-row bg-gray-100 rounded-2xl p-1 mb-6">
                <TouchableOpacity
                  onPress={() => setIsLogin(true)}
                  className={`flex-1 py-3 rounded-xl ${
                    isLogin ? 'bg-white shadow-sm' : ''
                  }`}
                >
                  <Text
                    className={`text-center font-medium ${
                      isLogin ? 'text-secondary' : 'text-text-sub'
                    }`}
                  >
                    로그인
                  </Text>
                </TouchableOpacity>
                <TouchableOpacity
                  onPress={() => setIsLogin(false)}
                  className={`flex-1 py-3 rounded-xl ${
                    !isLogin ? 'bg-white shadow-sm' : ''
                  }`}
                >
                  <Text
                    className={`text-center font-medium ${
                      !isLogin ? 'text-secondary' : 'text-text-sub'
                    }`}
                  >
                    회원가입
                  </Text>
                </TouchableOpacity>
              </View>

              {/* Email Input */}
              <View className="mb-4">
                <Input
                  placeholder="이메일"
                  keyboardType="email-address"
                  autoCapitalize="none"
                  value={email}
                  onChangeText={setEmail}
                  leftIcon={<Mail color="#78909C" size={20} />}
                />
              </View>

              {/* Password Input */}
              <View className="mb-4">
                <Input
                  placeholder="비밀번호"
                  secureTextEntry={!showPassword}
                  value={password}
                  onChangeText={setPassword}
                  leftIcon={<Lock color="#78909C" size={20} />}
                  rightIcon={
                    <TouchableOpacity onPress={() => setShowPassword(!showPassword)}>
                      {showPassword ? (
                        <EyeOff color="#78909C" size={20} />
                      ) : (
                        <Eye color="#78909C" size={20} />
                      )}
                    </TouchableOpacity>
                  }
                />
              </View>

              {/* Confirm Password (Sign Up only) */}
              {!isLogin && (
                <View className="mb-4">
                  <Input
                    placeholder="비밀번호 확인"
                    secureTextEntry={!showPassword}
                    value={confirmPassword}
                    onChangeText={setConfirmPassword}
                    leftIcon={<Lock color="#78909C" size={20} />}
                  />
                </View>
              )}

              {/* Submit Button */}
              <Button
                title={isLogin ? '로그인' : '회원가입'}
                onPress={handleSubmit}
                isLoading={isLoading}
                className="mt-4"
              />

              {/* Forgot Password */}
              {isLogin && (
                <TouchableOpacity className="mt-4">
                  <Text className="text-center text-text-sub">
                    비밀번호를 잊으셨나요?
                  </Text>
                </TouchableOpacity>
              )}
            </View>

            {/* Skip Button */}
            <TouchableOpacity onPress={handleSkip} className="mt-6">
              <Text className="text-center text-white/80">
                둘러보기 (데모 모드)
              </Text>
            </TouchableOpacity>
          </View>
        </ScrollView>
      </KeyboardAvoidingView>
    </LinearGradient>
  );
}
