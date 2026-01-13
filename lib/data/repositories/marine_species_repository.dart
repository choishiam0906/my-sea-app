import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/marine_species_model.dart';

/// Marine Species Repository for Supabase operations
class MarineSpeciesRepository {
  final SupabaseClient _client;

  MarineSpeciesRepository(this._client);

  /// Get all marine species (paginated)
  Future<List<MarineSpeciesModel>> getAllSpecies({int limit = 50, int offset = 0}) async {
    final response = await _client
        .from('marine_species')
        .select()
        .order('name_kr', ascending: true)
        .range(offset, offset + limit - 1);

    return (response as List)
        .map((data) => MarineSpeciesModel.fromSupabase(data))
        .toList();
  }

  /// Get species by ID
  Future<MarineSpeciesModel?> getSpeciesById(String speciesId) async {
    final response = await _client
        .from('marine_species')
        .select()
        .eq('id', speciesId)
        .maybeSingle();

    if (response == null) return null;
    return MarineSpeciesModel.fromSupabase(response);
  }

  /// Search species by name (Korean or English)
  Future<List<MarineSpeciesModel>> searchSpecies(String query) async {
    final response = await _client
        .from('marine_species')
        .select()
        .or('name_kr.ilike.%$query%,name_en.ilike.%$query%,scientific_name.ilike.%$query%')
        .order('name_kr', ascending: true);

    return (response as List)
        .map((data) => MarineSpeciesModel.fromSupabase(data))
        .toList();
  }

  /// Get species by category
  Future<List<MarineSpeciesModel>> getSpeciesByCategory(MarineCategory category) async {
    final response = await _client
        .from('marine_species')
        .select()
        .eq('category', category.name)
        .order('name_kr', ascending: true);

    return (response as List)
        .map((data) => MarineSpeciesModel.fromSupabase(data))
        .toList();
  }

  /// Get species by rarity
  Future<List<MarineSpeciesModel>> getSpeciesByRarity(RarityLevel rarity) async {
    final response = await _client
        .from('marine_species')
        .select()
        .eq('rarity', rarity.name)
        .order('name_kr', ascending: true);

    return (response as List)
        .map((data) => MarineSpeciesModel.fromSupabase(data))
        .toList();
  }

  /// Get dangerous species
  Future<List<MarineSpeciesModel>> getDangerousSpecies() async {
    final response = await _client
        .from('marine_species')
        .select()
        .eq('is_dangerous', true)
        .order('name_kr', ascending: true);

    return (response as List)
        .map((data) => MarineSpeciesModel.fromSupabase(data))
        .toList();
  }

  /// Get rare and legendary species
  Future<List<MarineSpeciesModel>> getRareSpecies() async {
    final response = await _client
        .from('marine_species')
        .select()
        .or('rarity.eq.rare,rarity.eq.epic,rarity.eq.legendary')
        .order('rarity', ascending: false);

    return (response as List)
        .map((data) => MarineSpeciesModel.fromSupabase(data))
        .toList();
  }

  // ---- Marine Sightings ----

  /// Get user's sightings
  Future<List<MarineSightingModel>> getUserSightings(String userId, {int limit = 50, int offset = 0}) async {
    final response = await _client
        .from('marine_sightings')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return (response as List)
        .map((data) => MarineSightingModel.fromSupabase(data))
        .toList();
  }

  /// Get sightings for a dive
  Future<List<MarineSightingModel>> getDiveSightings(String diveId) async {
    final response = await _client
        .from('marine_sightings')
        .select()
        .eq('dive_id', diveId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((data) => MarineSightingModel.fromSupabase(data))
        .toList();
  }

  /// Record a sighting
  Future<MarineSightingModel> recordSighting(MarineSightingModel sighting) async {
    final response = await _client
        .from('marine_sightings')
        .insert(sighting.toSupabase())
        .select()
        .single();

    return MarineSightingModel.fromSupabase(response);
  }

  /// Delete a sighting
  Future<void> deleteSighting(String sightingId) async {
    await _client
        .from('marine_sightings')
        .delete()
        .eq('id', sightingId);
  }

  // ---- User Species Collection ----

  /// Get user's collected species
  Future<List<UserSpeciesCollectionModel>> getUserCollection(String userId) async {
    final response = await _client
        .from('user_species_collections')
        .select()
        .eq('user_id', userId)
        .order('last_seen_at', ascending: false);

    return (response as List)
        .map((data) => UserSpeciesCollectionModel.fromSupabase(data))
        .toList();
  }

  /// Get user's collection count
  Future<int> getUserCollectionCount(String userId) async {
    final response = await _client
        .from('user_species_collections')
        .select()
        .eq('user_id', userId)
        .count();

    return response.count;
  }

  /// Add species to user's collection (or update if exists)
  Future<void> addToCollection(String userId, String speciesId, {String? photoUrl}) async {
    // Check if already in collection
    final existing = await _client
        .from('user_species_collections')
        .select()
        .eq('user_id', userId)
        .eq('species_id', speciesId)
        .maybeSingle();

    if (existing != null) {
      // Update existing
      await _client
          .from('user_species_collections')
          .update({
            'total_sightings': (existing['total_sightings'] as int) + 1,
            'last_seen_at': DateTime.now().toIso8601String(),
            if (photoUrl != null) 'best_photo_url': photoUrl,
          })
          .eq('id', existing['id']);
    } else {
      // Create new
      await _client
          .from('user_species_collections')
          .insert({
            'user_id': userId,
            'species_id': speciesId,
            'total_sightings': 1,
            'first_seen_at': DateTime.now().toIso8601String(),
            'last_seen_at': DateTime.now().toIso8601String(),
            'best_photo_url': photoUrl,
          });
    }
  }

  /// Check if user has collected a species
  Future<bool> hasCollectedSpecies(String userId, String speciesId) async {
    final response = await _client
        .from('user_species_collections')
        .select()
        .eq('user_id', userId)
        .eq('species_id', speciesId)
        .maybeSingle();

    return response != null;
  }

  /// Get collection statistics
  Future<Map<String, dynamic>> getCollectionStatistics(String userId) async {
    final collection = await getUserCollection(userId);

    if (collection.isEmpty) {
      return {
        'total_species': 0,
        'total_sightings': 0,
        'by_rarity': {},
      };
    }

    // Get species details for rarity count
    final speciesIds = collection.map((c) => c.speciesId).toList();
    final speciesResponse = await _client
        .from('marine_species')
        .select('id, rarity')
        .filter('id', 'in', '(${speciesIds.join(",")})');

    final rarityCounts = <String, int>{};
    for (final species in speciesResponse as List) {
      final rarity = species['rarity'] as String;
      rarityCounts[rarity] = (rarityCounts[rarity] ?? 0) + 1;
    }

    return {
      'total_species': collection.length,
      'total_sightings': collection.fold(0, (sum, c) => sum + c.totalSightings),
      'by_rarity': rarityCounts,
    };
  }

  /// Upload sighting photo
  Future<String> uploadSightingPhoto(String userId, List<int> imageBytes, String fileName) async {
    final path = '$userId/${DateTime.now().millisecondsSinceEpoch}_$fileName';

    await _client.storage
        .from('sighting-photos')
        .uploadBinary(path, imageBytes as dynamic);

    return _client.storage
        .from('sighting-photos')
        .getPublicUrl(path);
  }
}
