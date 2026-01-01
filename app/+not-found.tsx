import { Link, Stack } from 'expo-router';
import { View, Text, StyleSheet } from 'react-native';

export default function NotFoundScreen() {
  return (
    <>
      <Stack.Screen options={{ title: '페이지를 찾을 수 없어요' }} />
      <View style={styles.container}>
        <Text style={styles.emoji}>🌊</Text>
        <Text style={styles.title}>이 페이지는 존재하지 않아요</Text>
        <Text style={styles.subtitle}>바다 깊은 곳으로 사라진 것 같아요...</Text>

        <Link href="/" style={styles.link}>
          <Text style={styles.linkText}>홈으로 돌아가기</Text>
        </Link>
      </View>
    </>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 20,
    backgroundColor: '#E0F7FA',
  },
  emoji: {
    fontSize: 80,
    marginBottom: 20,
  },
  title: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#263238',
    marginBottom: 8,
  },
  subtitle: {
    fontSize: 14,
    color: '#78909C',
    marginBottom: 20,
  },
  link: {
    marginTop: 15,
    paddingVertical: 15,
    paddingHorizontal: 30,
    backgroundColor: '#0288D1',
    borderRadius: 24,
  },
  linkText: {
    fontSize: 16,
    color: '#FFFFFF',
    fontWeight: '600',
  },
});
