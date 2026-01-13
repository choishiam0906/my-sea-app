import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/dive_log_model.dart';

/// Dive Log Repository for Supabase operations
class DiveLogRepository {
  final SupabaseClient _client;

  DiveLogRepository(this._client);

  /// Get all dive logs for a user
  Future<List<DiveLogModel>> getUserDiveLogs(String userId, {int limit = 50, int offset = 0}) async {
    final response = await _client
        .from('dive_logs')
        .select()
        .eq('user_id', userId)
        .order('timestamp', ascending: false)
        .range(offset, offset + limit - 1);

    return (response as List)
        .map((data) => DiveLogModel.fromSupabase(data))
        .toList();
  }

  /// Get a single dive log by ID
  Future<DiveLogModel?> getDiveLogById(String diveId) async {
    final response = await _client
        .from('dive_logs')
        .select()
        .eq('id', diveId)
        .maybeSingle();

    if (response == null) return null;
    return DiveLogModel.fromSupabase(response);
  }

  /// Create a new dive log
  Future<DiveLogModel> createDiveLog(DiveLogModel diveLog) async {
    final response = await _client
        .from('dive_logs')
        .insert(diveLog.toSupabase())
        .select()
        .single();

    return DiveLogModel.fromSupabase(response);
  }

  /// Update an existing dive log
  Future<DiveLogModel> updateDiveLog(DiveLogModel diveLog) async {
    final response = await _client
        .from('dive_logs')
        .update(diveLog.toSupabase())
        .eq('id', diveLog.diveId)
        .select()
        .single();

    return DiveLogModel.fromSupabase(response);
  }

  /// Delete a dive log
  Future<void> deleteDiveLog(String diveId) async {
    await _client
        .from('dive_logs')
        .delete()
        .eq('id', diveId);
  }

  /// Get user's dive count
  Future<int> getUserDiveCount(String userId) async {
    final response = await _client
        .from('dive_logs')
        .select()
        .eq('user_id', userId)
        .count();

    return response.count;
  }

  /// Get user's total bottom time (in minutes)
  Future<int> getUserTotalBottomTime(String userId) async {
    final logs = await getUserDiveLogs(userId, limit: 1000);
    return logs.fold<int>(0, (sum, log) => sum + log.bottomTime);
  }

  /// Get dive logs by date range
  Future<List<DiveLogModel>> getDiveLogsByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final response = await _client
        .from('dive_logs')
        .select()
        .eq('user_id', userId)
        .gte('timestamp', startDate.toIso8601String())
        .lte('timestamp', endDate.toIso8601String())
        .order('timestamp', ascending: false);

    return (response as List)
        .map((data) => DiveLogModel.fromSupabase(data))
        .toList();
  }

  /// Get dive logs by site name
  Future<List<DiveLogModel>> getDiveLogsBySite(String userId, String siteName) async {
    final response = await _client
        .from('dive_logs')
        .select()
        .eq('user_id', userId)
        .ilike('site_name', '%$siteName%')
        .order('timestamp', ascending: false);

    return (response as List)
        .map((data) => DiveLogModel.fromSupabase(data))
        .toList();
  }

  /// Get recent dive logs
  Future<List<DiveLogModel>> getRecentDiveLogs(String userId, {int count = 5}) async {
    final response = await _client
        .from('dive_logs')
        .select()
        .eq('user_id', userId)
        .order('timestamp', ascending: false)
        .limit(count);

    return (response as List)
        .map((data) => DiveLogModel.fromSupabase(data))
        .toList();
  }

  /// Get dive statistics
  Future<Map<String, dynamic>> getDiveStatistics(String userId) async {
    final logs = await getUserDiveLogs(userId, limit: 1000);

    if (logs.isEmpty) {
      return {
        'total_dives': 0,
        'total_bottom_time': 0,
        'max_depth': 0.0,
        'avg_depth': 0.0,
        'favorite_site': null,
      };
    }

    final totalBottomTime = logs.fold(0, (sum, log) => sum + log.bottomTime);
    final maxDepth = logs.map((log) => log.maxDepth).reduce((a, b) => a > b ? a : b);
    final avgDepth = logs.map((log) => log.avgDepth ?? log.maxDepth).reduce((a, b) => a + b) / logs.length;

    // Find favorite site
    final siteCounts = <String, int>{};
    for (final log in logs) {
      siteCounts[log.siteName] = (siteCounts[log.siteName] ?? 0) + 1;
    }
    final favoriteSite = siteCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    return {
      'total_dives': logs.length,
      'total_bottom_time': totalBottomTime,
      'max_depth': maxDepth,
      'avg_depth': avgDepth,
      'favorite_site': favoriteSite,
    };
  }

  /// Upload dive photos
  Future<List<String>> uploadDivePhotos(String diveId, List<Map<String, dynamic>> photos) async {
    final urls = <String>[];

    for (int i = 0; i < photos.length; i++) {
      final photo = photos[i];
      final bytes = photo['bytes'] as List<int>;
      final fileName = photo['fileName'] as String;
      final path = '$diveId/${DateTime.now().millisecondsSinceEpoch}_$fileName';

      await _client.storage
          .from('dive-photos')
          .uploadBinary(path, bytes as dynamic);

      final url = _client.storage
          .from('dive-photos')
          .getPublicUrl(path);

      urls.add(url);
    }

    return urls;
  }
}
