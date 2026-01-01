import React, { useState, useRef } from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  Dimensions,
  TextInput,
  ScrollView,
  Modal,
} from 'react-native';
import { useRouter } from 'expo-router';
import {
  X,
  Check,
  Type,
  Image as ImageIcon,
  Sticker,
  Palette,
  RotateCcw,
  Trash2,
  Plus,
} from 'lucide-react-native';
import Animated, {
  useSharedValue,
  useAnimatedStyle,
  withSpring,
} from 'react-native-reanimated';
import {
  Gesture,
  GestureDetector,
  GestureHandlerRootView,
} from 'react-native-gesture-handler';
import * as ImagePicker from 'expo-image-picker';

const { width, height } = Dimensions.get('window');

interface DiaryElement {
  id: string;
  type: 'text' | 'sticker' | 'photo';
  x: number;
  y: number;
  rotation: number;
  scale: number;
  content: string;
  style?: {
    fontSize?: number;
    color?: string;
    fontWeight?: string;
  };
}

const stickerOptions = [
  '🐠', '🐢', '🐙', '🦈', '🐬', '🦭', '🪼', '🦀', '⭐', '🌊',
  '🤿', '🏝️', '⚓', '🐚', '🪸', '🐋', '🐡', '🦑', '💙', '✨',
];

const colorOptions = [
  '#263238', '#0288D1', '#FFAB91', '#4CAF50', '#9C27B0', '#FF5722', '#FFFFFF',
];

export default function DiaryEditorScreen() {
  const router = useRouter();
  const [elements, setElements] = useState<DiaryElement[]>([]);
  const [selectedElement, setSelectedElement] = useState<string | null>(null);
  const [showStickerModal, setShowStickerModal] = useState(false);
  const [showTextModal, setShowTextModal] = useState(false);
  const [newText, setNewText] = useState('');
  const [selectedColor, setSelectedColor] = useState('#263238');

  const addElement = (type: DiaryElement['type'], content: string, style?: any) => {
    const newElement: DiaryElement = {
      id: Date.now().toString(),
      type,
      x: width / 2 - 50,
      y: height / 3,
      rotation: 0,
      scale: 1,
      content,
      style,
    };
    setElements([...elements, newElement]);
    setShowStickerModal(false);
    setShowTextModal(false);
    setNewText('');
  };

  const updateElement = (id: string, updates: Partial<DiaryElement>) => {
    setElements(
      elements.map((el) => (el.id === id ? { ...el, ...updates } : el))
    );
  };

  const deleteElement = (id: string) => {
    setElements(elements.filter((el) => el.id !== id));
    setSelectedElement(null);
  };

  const pickImage = async () => {
    const result = await ImagePicker.launchImageLibraryAsync({
      mediaTypes: ImagePicker.MediaTypeOptions.Images,
      quality: 0.8,
    });

    if (!result.canceled) {
      addElement('photo', result.assets[0].uri);
    }
  };

  const DraggableElement = ({ element }: { element: DiaryElement }) => {
    const translateX = useSharedValue(element.x);
    const translateY = useSharedValue(element.y);
    const scale = useSharedValue(element.scale);
    const rotation = useSharedValue(element.rotation);

    const panGesture = Gesture.Pan()
      .onUpdate((e) => {
        translateX.value = element.x + e.translationX;
        translateY.value = element.y + e.translationY;
      })
      .onEnd(() => {
        updateElement(element.id, {
          x: translateX.value,
          y: translateY.value,
        });
      });

    const pinchGesture = Gesture.Pinch()
      .onUpdate((e) => {
        scale.value = element.scale * e.scale;
      })
      .onEnd(() => {
        updateElement(element.id, { scale: scale.value });
      });

    const rotationGesture = Gesture.Rotation()
      .onUpdate((e) => {
        rotation.value = element.rotation + (e.rotation * 180) / Math.PI;
      })
      .onEnd(() => {
        updateElement(element.id, { rotation: rotation.value });
      });

    const tapGesture = Gesture.Tap().onEnd(() => {
      setSelectedElement(element.id === selectedElement ? null : element.id);
    });

    const composed = Gesture.Simultaneous(
      panGesture,
      pinchGesture,
      rotationGesture,
      tapGesture
    );

    const animatedStyle = useAnimatedStyle(() => ({
      transform: [
        { translateX: translateX.value },
        { translateY: translateY.value },
        { scale: scale.value },
        { rotate: `${rotation.value}deg` },
      ],
    }));

    return (
      <GestureDetector gesture={composed}>
        <Animated.View
          style={animatedStyle}
          className={`absolute ${
            selectedElement === element.id ? 'border-2 border-secondary' : ''
          }`}
        >
          {element.type === 'sticker' && (
            <Text style={{ fontSize: 50 }}>{element.content}</Text>
          )}
          {element.type === 'text' && (
            <Text
              style={{
                fontSize: element.style?.fontSize || 24,
                color: element.style?.color || '#263238',
                fontWeight: element.style?.fontWeight || 'normal',
              }}
            >
              {element.content}
            </Text>
          )}
          {element.type === 'photo' && (
            <View className="bg-white p-2 shadow-lg" style={{ transform: [{ rotate: '-2deg' }] }}>
              <Animated.Image
                source={{ uri: element.content }}
                style={{ width: 150, height: 150 }}
                resizeMode="cover"
              />
              <Text className="text-center text-xs text-text-sub mt-1">
                {new Date().toLocaleDateString('ko-KR')}
              </Text>
            </View>
          )}
        </Animated.View>
      </GestureDetector>
    );
  };

  return (
    <GestureHandlerRootView style={{ flex: 1 }}>
      <View className="flex-1 bg-primary">
        {/* Header */}
        <View className="flex-row justify-between items-center px-4 pt-12 pb-4 bg-surface shadow-sm">
          <TouchableOpacity onPress={() => router.back()}>
            <X color="#263238" size={24} />
          </TouchableOpacity>
          <Text className="text-lg font-bold text-text-main">다이어리 꾸미기</Text>
          <TouchableOpacity onPress={() => router.back()}>
            <Check color="#0288D1" size={24} />
          </TouchableOpacity>
        </View>

        {/* Canvas */}
        <View
          className="flex-1 bg-white"
          style={{
            backgroundImage: 'linear-gradient(#E0F7FA 1px, transparent 1px), linear-gradient(90deg, #E0F7FA 1px, transparent 1px)',
            backgroundSize: '20px 20px',
          }}
        >
          {/* Grid background overlay */}
          <View
            className="absolute inset-0"
            style={{
              backgroundColor: 'transparent',
              opacity: 0.3,
            }}
          />

          {/* Date Header */}
          <View className="absolute top-4 left-4 right-4">
            <Text className="text-2xl font-bold text-secondary">
              🌊 2025.12.28
            </Text>
            <Text className="text-text-sub">제주 서귀포 문섬</Text>
          </View>

          {/* Draggable Elements */}
          {elements.map((element) => (
            <DraggableElement key={element.id} element={element} />
          ))}
        </View>

        {/* Toolbar */}
        <View className="bg-surface px-4 py-4 border-t border-gray-100">
          {selectedElement ? (
            <View className="flex-row justify-center">
              <TouchableOpacity
                onPress={() => deleteElement(selectedElement)}
                className="w-12 h-12 rounded-full bg-red-50 items-center justify-center mx-2"
              >
                <Trash2 color="#F44336" size={24} />
              </TouchableOpacity>
              <TouchableOpacity
                onPress={() => setSelectedElement(null)}
                className="w-12 h-12 rounded-full bg-gray-100 items-center justify-center mx-2"
              >
                <X color="#78909C" size={24} />
              </TouchableOpacity>
            </View>
          ) : (
            <View className="flex-row justify-center">
              <TouchableOpacity
                onPress={() => setShowTextModal(true)}
                className="w-14 h-14 rounded-full bg-secondary items-center justify-center mx-3"
              >
                <Type color="#FFFFFF" size={24} />
              </TouchableOpacity>
              <TouchableOpacity
                onPress={() => setShowStickerModal(true)}
                className="w-14 h-14 rounded-full bg-accent items-center justify-center mx-3"
              >
                <Sticker color="#FFFFFF" size={24} />
              </TouchableOpacity>
              <TouchableOpacity
                onPress={pickImage}
                className="w-14 h-14 rounded-full bg-primary-dark items-center justify-center mx-3"
                style={{ backgroundColor: '#0288D1' }}
              >
                <ImageIcon color="#FFFFFF" size={24} />
              </TouchableOpacity>
            </View>
          )}
        </View>

        {/* Sticker Modal */}
        <Modal visible={showStickerModal} transparent animationType="slide">
          <View className="flex-1 justify-end bg-black/50">
            <View className="bg-surface rounded-t-3xl p-6">
              <View className="flex-row justify-between items-center mb-4">
                <Text className="text-lg font-bold text-text-main">스티커</Text>
                <TouchableOpacity onPress={() => setShowStickerModal(false)}>
                  <X color="#78909C" size={24} />
                </TouchableOpacity>
              </View>
              <View className="flex-row flex-wrap justify-center">
                {stickerOptions.map((sticker, index) => (
                  <TouchableOpacity
                    key={index}
                    onPress={() => addElement('sticker', sticker)}
                    className="w-14 h-14 m-2 rounded-xl bg-primary items-center justify-center"
                  >
                    <Text className="text-3xl">{sticker}</Text>
                  </TouchableOpacity>
                ))}
              </View>
            </View>
          </View>
        </Modal>

        {/* Text Modal */}
        <Modal visible={showTextModal} transparent animationType="slide">
          <View className="flex-1 justify-end bg-black/50">
            <View className="bg-surface rounded-t-3xl p-6">
              <View className="flex-row justify-between items-center mb-4">
                <Text className="text-lg font-bold text-text-main">텍스트</Text>
                <TouchableOpacity onPress={() => setShowTextModal(false)}>
                  <X color="#78909C" size={24} />
                </TouchableOpacity>
              </View>

              <TextInput
                className="bg-primary rounded-xl p-4 text-text-main text-lg mb-4"
                placeholder="텍스트를 입력하세요"
                placeholderTextColor="#78909C"
                value={newText}
                onChangeText={setNewText}
                multiline
              />

              <View className="flex-row justify-center mb-4">
                {colorOptions.map((color) => (
                  <TouchableOpacity
                    key={color}
                    onPress={() => setSelectedColor(color)}
                    className={`w-10 h-10 rounded-full mx-1 ${
                      selectedColor === color ? 'border-2 border-secondary' : ''
                    }`}
                    style={{ backgroundColor: color, borderWidth: color === '#FFFFFF' ? 1 : 0, borderColor: '#E0E0E0' }}
                  />
                ))}
              </View>

              <TouchableOpacity
                onPress={() =>
                  newText && addElement('text', newText, { color: selectedColor })
                }
                className="bg-secondary py-4 rounded-xl items-center"
              >
                <Text className="text-white font-semibold">추가하기</Text>
              </TouchableOpacity>
            </View>
          </View>
        </Modal>
      </View>
    </GestureHandlerRootView>
  );
}
