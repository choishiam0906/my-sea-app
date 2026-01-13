import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/crew_model.dart';

/// Crew Repository for Supabase operations
class CrewRepository {
  final SupabaseClient _client;

  CrewRepository(this._client);

  /// Get all public crews
  Future<List<CrewModel>> getPublicCrews({int limit = 50, int offset = 0}) async {
    final response = await _client
        .from('crews')
        .select()
        .eq('is_public', true)
        .order('member_count', ascending: false)
        .range(offset, offset + limit - 1);

    return (response as List)
        .map((data) => CrewModel.fromSupabase(data))
        .toList();
  }

  /// Get crew by ID
  Future<CrewModel?> getCrewById(String crewId) async {
    final response = await _client
        .from('crews')
        .select()
        .eq('id', crewId)
        .maybeSingle();

    if (response == null) return null;
    return CrewModel.fromSupabase(response);
  }

  /// Create a new crew
  Future<CrewModel> createCrew(CrewModel crew) async {
    final response = await _client
        .from('crews')
        .insert(crew.toSupabase())
        .select()
        .single();

    return CrewModel.fromSupabase(response);
  }

  /// Update a crew
  Future<CrewModel> updateCrew(CrewModel crew) async {
    final response = await _client
        .from('crews')
        .update(crew.toSupabase())
        .eq('id', crew.crewId)
        .select()
        .single();

    return CrewModel.fromSupabase(response);
  }

  /// Delete a crew
  Future<void> deleteCrew(String crewId) async {
    await _client
        .from('crews')
        .delete()
        .eq('id', crewId);
  }

  /// Get crews by region
  Future<List<CrewModel>> getCrewsByRegion(String region) async {
    final response = await _client
        .from('crews')
        .select()
        .eq('is_public', true)
        .ilike('region', '%$region%')
        .order('member_count', ascending: false);

    return (response as List)
        .map((data) => CrewModel.fromSupabase(data))
        .toList();
  }

  /// Search crews by name
  Future<List<CrewModel>> searchCrews(String query) async {
    final response = await _client
        .from('crews')
        .select()
        .eq('is_public', true)
        .ilike('crew_name', '%$query%')
        .order('member_count', ascending: false);

    return (response as List)
        .map((data) => CrewModel.fromSupabase(data))
        .toList();
  }

  /// Get top crews by eco score
  Future<List<CrewModel>> getTopCrewsByEcoScore({int limit = 10}) async {
    final response = await _client
        .from('crews')
        .select()
        .eq('is_public', true)
        .order('total_eco_score', ascending: false)
        .limit(limit);

    return (response as List)
        .map((data) => CrewModel.fromSupabase(data))
        .toList();
  }

  /// Get user's crew
  Future<CrewModel?> getUserCrew(String userId) async {
    // First, get the user's crew_id
    final userResponse = await _client
        .from('users')
        .select('crew_id')
        .eq('id', userId)
        .maybeSingle();

    if (userResponse == null || userResponse['crew_id'] == null) return null;

    return getCrewById(userResponse['crew_id'] as String);
  }

  // ---- Crew Members ----

  /// Get crew members
  Future<List<CrewMemberModel>> getCrewMembers(String crewId) async {
    final response = await _client
        .from('crew_members')
        .select()
        .eq('crew_id', crewId)
        .order('joined_at', ascending: true);

    return (response as List)
        .map((data) => CrewMemberModel.fromSupabase(data))
        .toList();
  }

  /// Add member to crew
  Future<CrewMemberModel> addCrewMember(CrewMemberModel member) async {
    final response = await _client
        .from('crew_members')
        .insert(member.toSupabase())
        .select()
        .single();

    // Update crew member count
    await _updateCrewMemberCount(member.crewId);

    return CrewMemberModel.fromSupabase(response);
  }

  /// Remove member from crew
  Future<void> removeCrewMember(String crewId, String userId) async {
    await _client
        .from('crew_members')
        .delete()
        .eq('crew_id', crewId)
        .eq('user_id', userId);

    // Update crew member count
    await _updateCrewMemberCount(crewId);
  }

  /// Update member role
  Future<void> updateMemberRole(String crewId, String userId, CrewMemberRole role) async {
    await _client
        .from('crew_members')
        .update({'role': role.name})
        .eq('crew_id', crewId)
        .eq('user_id', userId);
  }

  /// Check if user is member of crew
  Future<bool> isCrewMember(String crewId, String userId) async {
    final response = await _client
        .from('crew_members')
        .select()
        .eq('crew_id', crewId)
        .eq('user_id', userId)
        .maybeSingle();

    return response != null;
  }

  /// Get user's role in crew
  Future<CrewMemberRole?> getUserRoleInCrew(String crewId, String userId) async {
    final response = await _client
        .from('crew_members')
        .select('role')
        .eq('crew_id', crewId)
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) return null;

    return CrewMemberRole.values.firstWhere(
      (e) => e.name == response['role'],
      orElse: () => CrewMemberRole.member,
    );
  }

  /// Update crew member count
  Future<void> _updateCrewMemberCount(String crewId) async {
    final members = await getCrewMembers(crewId);
    final count = members.length;
    final tier = CrewModel.calculateTier(count);

    await _client
        .from('crews')
        .update({
          'member_count': count,
          'badge_tier': tier.name.toUpperCase(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', crewId);
  }

  /// Update crew's total eco score
  Future<void> updateCrewEcoScore(String crewId, int additionalScore) async {
    final crew = await getCrewById(crewId);
    if (crew == null) return;

    await _client
        .from('crews')
        .update({
          'total_eco_score': crew.totalEcoScore + additionalScore,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', crewId);
  }

  /// Upload crew image
  Future<String> uploadCrewImage(String crewId, List<int> imageBytes, String fileName) async {
    final path = '$crewId/$fileName';

    await _client.storage
        .from('crew-images')
        .uploadBinary(path, imageBytes as dynamic);

    return _client.storage
        .from('crew-images')
        .getPublicUrl(path);
  }
}
