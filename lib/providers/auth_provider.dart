import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/models/user_model.dart';
import 'repository_providers.dart';

/// Supabase Auth State Provider
final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(supabaseClientProvider).auth.onAuthStateChange;
});

/// Current User Provider (Supabase User)
final supabaseUserProvider = Provider<User?>((ref) {
  return ref.watch(supabaseClientProvider).auth.currentUser;
});

/// Current User Model Provider
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final client = ref.watch(supabaseClientProvider);
  final user = client.auth.currentUser;

  if (user == null) return null;

  final response = await client
      .from('users')
      .select()
      .eq('id', user.id)
      .maybeSingle();

  if (response == null) {
    // Create new user profile if doesn't exist
    final newUser = UserModel(
      uid: user.id,
      email: user.email,
      nickname: user.userMetadata?['nickname'] ?? 'Diver',
      profileImageUrl: user.userMetadata?['avatar_url'],
    );
    await client.from('users').insert(newUser.toSupabase());
    return newUser;
  }

  return UserModel.fromSupabase(response);
});

/// Auth Notifier for Authentication Actions
class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final SupabaseClient _client;

  AuthNotifier(this._client) : super(const AsyncValue.data(null));

  /// Sign in with email and password
  Future<void> signInWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      state = const AsyncValue.data(null);
    } on AuthException catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Register with email and password
  Future<bool> registerWithEmail({
    required String email,
    required String password,
    required String nickname,
  }) async {
    state = const AsyncValue.loading();
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'nickname': nickname},
      );

      // Check if email confirmation is required
      final needsConfirmation = response.user?.emailConfirmedAt == null;

      // Create user profile in users table (if user created)
      if (response.user != null) {
        try {
          final user = UserModel(
            uid: response.user!.id,
            email: email,
            nickname: nickname,
          );
          await _client.from('users').upsert(user.toSupabase());
        } catch (e) {
          // Ignore if user profile already exists or RLS blocks it
          // Profile will be created on first login via currentUserProvider
        }
      }

      state = const AsyncValue.data(null);
      return needsConfirmation;
    } on AuthException catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _client.auth.signOut();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    state = const AsyncValue.loading();
    try {
      await _client.auth.resetPasswordForEmail(email);
      state = const AsyncValue.data(null);
    } on AuthException catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Update user profile
  Future<void> updateProfile({
    String? nickname,
    String? profileImageUrl,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception('Not authenticated');

      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };
      if (nickname != null) {
        updates['nickname'] = nickname;
        await _client.auth.updateUser(UserAttributes(data: {'nickname': nickname}));
      }
      if (profileImageUrl != null) {
        updates['profile_image_url'] = profileImageUrl;
        await _client.auth.updateUser(UserAttributes(data: {'avatar_url': profileImageUrl}));
      }

      await _client.from('users').update(updates).eq('id', user.id);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

/// Auth Notifier Provider
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue<void>>((ref) {
  return AuthNotifier(ref.watch(supabaseClientProvider));
});

/// Error message helper for Supabase Auth errors
String getAuthErrorMessage(dynamic error) {
  if (error is AuthException) {
    final message = error.message.toLowerCase();
    if (message.contains('user not found') || message.contains('invalid login')) {
      return '이메일 또는 비밀번호가 올바르지 않습니다.';
    }
    if (message.contains('email already') || message.contains('already registered')) {
      return '이미 가입된 이메일이에요. 로그인해주세요!';
    }
    if (message.contains('password') && !message.contains('invalid')) {
      return '비밀번호가 너무 약해요. 6자 이상 입력해주세요.';
    }
    if (message.contains('invalid email')) {
      return '올바른 이메일 형식이 아니에요.';
    }
    // Rate limiting / Security delay errors
    if (message.contains('rate limit') ||
        message.contains('too many') ||
        message.contains('security purposes') ||
        message.contains('after') && message.contains('seconds')) {
      // Extract seconds from message if available
      final secondsMatch = RegExp(r'(\d+)\s*seconds?').firstMatch(message);
      if (secondsMatch != null) {
        final seconds = secondsMatch.group(1);
        return '보안을 위해 $seconds초 후에 다시 시도해주세요. 🔒';
      }
      return '잠시 후 다시 시도해주세요. 🔒';
    }
    if (message.contains('email not confirmed')) {
      return '이메일 인증이 필요해요. 받은편지함을 확인해주세요! 📧';
    }
    if (message.contains('invalid credentials') || message.contains('invalid login credentials')) {
      return '이메일 또는 비밀번호가 올바르지 않아요.';
    }
    return '오류가 발생했어요: ${error.message}';
  }
  return '오류가 발생했어요. 다시 시도해주세요.';
}
