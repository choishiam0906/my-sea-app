import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';

/// User Repository for Supabase operations
class UserRepository {
  final SupabaseClient _client;

  UserRepository(this._client);

  /// Get current authenticated user profile
  Future<UserModel?> getCurrentUser() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    final response = await _client
        .from('users')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (response == null) return null;
    return UserModel.fromSupabase(response);
  }

  /// Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    final response = await _client
        .from('users')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response == null) return null;
    return UserModel.fromSupabase(response);
  }

  /// Create user profile
  Future<UserModel> createUser(UserModel user) async {
    final response = await _client
        .from('users')
        .insert(user.toSupabase())
        .select()
        .single();

    return UserModel.fromSupabase(response);
  }

  /// Update user profile
  Future<UserModel> updateUser(UserModel user) async {
    final response = await _client
        .from('users')
        .update(user.toSupabase())
        .eq('id', user.uid)
        .select()
        .single();

    return UserModel.fromSupabase(response);
  }

  /// Update specific user fields
  Future<void> updateUserFields(String userId, Map<String, dynamic> fields) async {
    fields['updated_at'] = DateTime.now().toIso8601String();
    await _client
        .from('users')
        .update(fields)
        .eq('id', userId);
  }

  /// Add leaf points to user
  Future<void> addLeafPoints(String userId, int points) async {
    final user = await getUserById(userId);
    if (user == null) return;

    await _client
        .from('users')
        .update({
          'leaf_points': user.leafPoints + points,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', userId);
  }

  /// Update user's total dives count
  Future<void> incrementDiveCount(String userId) async {
    final user = await getUserById(userId);
    if (user == null) return;

    await _client
        .from('users')
        .update({
          'total_dives': user.totalDives + 1,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', userId);
  }

  /// Add species to user's collection
  Future<void> addSpeciesToCollection(String userId, String speciesId) async {
    final user = await getUserById(userId);
    if (user == null) return;

    if (!user.speciesCollected.contains(speciesId)) {
      final updatedSpecies = [...user.speciesCollected, speciesId];
      await _client
          .from('users')
          .update({
            'species_collected': updatedSpecies,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);
    }
  }

  /// Update user's eco score
  Future<void> updateEcoScore(String userId, int additionalScore) async {
    final user = await getUserById(userId);
    if (user == null) return;

    await _client
        .from('users')
        .update({
          'total_eco_score': user.totalEcoScore + additionalScore,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', userId);
  }

  /// Set user's crew
  Future<void> setUserCrew(String userId, String? crewId) async {
    await _client
        .from('users')
        .update({
          'crew_id': crewId,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', userId);
  }

  /// Upload profile image and update URL
  Future<String> uploadProfileImage(String userId, List<int> imageBytes, String fileName) async {
    final path = '$userId/$fileName';

    await _client.storage
        .from('avatars')
        .uploadBinary(path, imageBytes as dynamic);

    final imageUrl = _client.storage
        .from('avatars')
        .getPublicUrl(path);

    await updateUserFields(userId, {'profile_image_url': imageUrl});

    return imageUrl;
  }
}
