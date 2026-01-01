import React, { useState, useRef } from 'react';
import {
  View,
  Text,
  ScrollView,
  TextInput,
  TouchableOpacity,
  KeyboardAvoidingView,
  Platform,
  Image,
} from 'react-native';
import { Send, Camera, ImageIcon, Mic } from 'lucide-react-native';
import * as ImagePicker from 'expo-image-picker';
import { Card } from '@/components/ui';

interface Message {
  id: string;
  type: 'user' | 'ai';
  content: string;
  image?: string;
  timestamp: Date;
}

const initialMessages: Message[] = [
  {
    id: '1',
    type: 'ai',
    content:
      '안녕하세요! 저는 My Sea의 AI 해양 가이드예요. 🐠\n\n다이빙 중 발견한 해양 생물 사진을 보내주시면 식별해드리고, 궁금한 점이 있으시면 무엇이든 물어보세요!',
    timestamp: new Date(),
  },
];

export default function ChatScreen() {
  const [messages, setMessages] = useState<Message[]>(initialMessages);
  const [inputText, setInputText] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const scrollViewRef = useRef<ScrollView>(null);

  const sendMessage = async () => {
    if (!inputText.trim()) return;

    const userMessage: Message = {
      id: Date.now().toString(),
      type: 'user',
      content: inputText,
      timestamp: new Date(),
    };

    setMessages((prev) => [...prev, userMessage]);
    setInputText('');
    setIsLoading(true);

    // Simulate AI response
    setTimeout(() => {
      const aiResponse: Message = {
        id: (Date.now() + 1).toString(),
        type: 'ai',
        content: getAIResponse(inputText),
        timestamp: new Date(),
      };
      setMessages((prev) => [...prev, aiResponse]);
      setIsLoading(false);
    }, 1500);
  };

  const getAIResponse = (query: string): string => {
    const lowerQuery = query.toLowerCase();

    if (lowerQuery.includes('흰동가리') || lowerQuery.includes('니모')) {
      return '흰동가리(Clownfish)는 니모로도 잘 알려진 열대어예요! 🐠\n\n• 크기: 10-15cm\n• 서식지: 말미잘과 공생\n• 특징: 밝은 주황색과 흰 줄무늬\n\n말미잘의 독에 면역이 있어서 그 안에서 안전하게 살아요. 정말 신기하죠?';
    }

    if (lowerQuery.includes('상어')) {
      return '상어에 대해 궁금하시군요! 🦈\n\n상어는 4억년 이상 지구에 살아온 고대 생물이에요. 대부분의 상어는 인간에게 위험하지 않으며, 오히려 해양 생태계에서 중요한 역할을 해요.\n\n다이빙 중 상어를 만나면 침착하게 행동하고, 갑작스러운 움직임을 피하세요!';
    }

    if (lowerQuery.includes('거북') || lowerQuery.includes('터틀')) {
      return '바다거북은 정말 우아한 동물이에요! 🐢\n\n• 수명: 80년 이상\n• 크기: 최대 180cm\n• 먹이: 해초, 해파리\n\n제주도 근해에서도 가끔 볼 수 있어요. 만약 만나게 된다면 조용히 관찰하고, 절대 만지지 마세요!';
    }

    return '좋은 질문이에요! 🌊\n\n더 자세한 정보를 드리려면 해양 생물 사진을 보내주시거나, 구체적인 생물 이름을 알려주세요. 다이빙 팁이나 장비에 대한 질문도 환영해요!';
  };

  const pickImage = async () => {
    const result = await ImagePicker.launchImageLibraryAsync({
      mediaTypes: ImagePicker.MediaTypeOptions.Images,
      quality: 0.8,
    });

    if (!result.canceled) {
      const userMessage: Message = {
        id: Date.now().toString(),
        type: 'user',
        content: '이 생물이 뭔가요?',
        image: result.assets[0].uri,
        timestamp: new Date(),
      };

      setMessages((prev) => [...prev, userMessage]);
      setIsLoading(true);

      // Simulate AI analysis
      setTimeout(() => {
        const aiResponse: Message = {
          id: (Date.now() + 1).toString(),
          type: 'ai',
          content:
            '사진을 분석했어요! 📸\n\n이것은 **흰동가리(Clownfish)**로 보여요!\n\n• 학명: Amphiprioninae\n• 희귀도: 흔함\n• 위험도: 안전\n\n말미잘 근처에서 살며, 화려한 주황색이 특징이에요. 니모 영화의 주인공이기도 하죠! 😊',
          timestamp: new Date(),
        };
        setMessages((prev) => [...prev, aiResponse]);
        setIsLoading(false);
      }, 2000);
    }
  };

  const renderMessage = (message: Message) => (
    <View
      key={message.id}
      className={`mb-4 ${message.type === 'user' ? 'items-end' : 'items-start'}`}
    >
      <View
        className={`max-w-[85%] rounded-3xl px-4 py-3 ${
          message.type === 'user' ? 'bg-secondary' : 'bg-surface'
        }`}
        style={
          message.type === 'ai'
            ? {
                shadowColor: '#000',
                shadowOffset: { width: 0, height: 1 },
                shadowOpacity: 0.1,
                shadowRadius: 2,
                elevation: 2,
              }
            : {}
        }
      >
        {message.image && (
          <Image
            source={{ uri: message.image }}
            className="w-48 h-48 rounded-2xl mb-2"
            resizeMode="cover"
          />
        )}
        <Text
          className={`text-base leading-6 ${
            message.type === 'user' ? 'text-white' : 'text-text-main'
          }`}
        >
          {message.content}
        </Text>
      </View>
      <Text className="text-text-sub text-xs mt-1 mx-2">
        {message.timestamp.toLocaleTimeString('ko-KR', {
          hour: '2-digit',
          minute: '2-digit',
        })}
      </Text>
    </View>
  );

  return (
    <KeyboardAvoidingView
      className="flex-1 bg-primary"
      behavior={Platform.OS === 'ios' ? 'padding' : undefined}
      keyboardVerticalOffset={90}
    >
      {/* Chat Messages */}
      <ScrollView
        ref={scrollViewRef}
        className="flex-1 px-4 pt-4"
        onContentSizeChange={() =>
          scrollViewRef.current?.scrollToEnd({ animated: true })
        }
      >
        {messages.map(renderMessage)}

        {isLoading && (
          <View className="items-start mb-4">
            <View className="bg-surface rounded-3xl px-4 py-3 shadow-sm">
              <Text className="text-text-sub">분석 중... 🔍</Text>
            </View>
          </View>
        )}
      </ScrollView>

      {/* Input Area */}
      <View className="px-4 py-3 bg-surface border-t border-gray-100">
        <View className="flex-row items-end">
          <TouchableOpacity
            onPress={pickImage}
            className="w-10 h-10 rounded-full bg-primary items-center justify-center mr-2"
          >
            <ImageIcon color="#0288D1" size={20} />
          </TouchableOpacity>

          <View className="flex-1 flex-row items-end bg-primary rounded-3xl px-4 py-2">
            <TextInput
              className="flex-1 text-text-main text-base max-h-24"
              placeholder="메시지를 입력하세요..."
              placeholderTextColor="#78909C"
              value={inputText}
              onChangeText={setInputText}
              multiline
              onSubmitEditing={sendMessage}
            />
          </View>

          <TouchableOpacity
            onPress={sendMessage}
            disabled={!inputText.trim()}
            className={`w-10 h-10 rounded-full items-center justify-center ml-2 ${
              inputText.trim() ? 'bg-secondary' : 'bg-gray-200'
            }`}
          >
            <Send color={inputText.trim() ? '#FFFFFF' : '#78909C'} size={20} />
          </TouchableOpacity>
        </View>
      </View>
    </KeyboardAvoidingView>
  );
}
