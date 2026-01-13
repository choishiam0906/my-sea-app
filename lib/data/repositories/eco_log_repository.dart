import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/eco_log_model.dart';

/// Eco Log Repository for Supabase operations
class EcoLogRepository {
  final SupabaseClient _client;

  EcoLogRepository(this._client);

  /// Get all eco logs for a user
  Future<List<EcoLogModel>> getUserEcoLogs(String userId, {int limit = 50, int offset = 0}) async {
    final response = await _client
        .from('eco_logs')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return (response as List)
        .map((data) => EcoLogModel.fromSupabase(data))
        .toList();
  }

  /// Get an eco log by ID
  Future<EcoLogModel?> getEcoLogById(String logId) async {
    final response = await _client
        .from('eco_logs')
        .select()
        .eq('id', logId)
        .maybeSingle();

    if (response == null) return null;
    return EcoLogModel.fromSupabase(response);
  }

  /// Create a new eco log
  Future<EcoLogModel> createEcoLog(EcoLogModel ecoLog) async {
    final response = await _client
        .from('eco_logs')
        .insert(ecoLog.toSupabase())
        .select()
        .single();

    return EcoLogModel.fromSupabase(response);
  }

  /// Update an eco log
  Future<EcoLogModel> updateEcoLog(EcoLogModel ecoLog) async {
    final response = await _client
        .from('eco_logs')
        .update(ecoLog.toSupabase())
        .eq('id', ecoLog.logId)
        .select()
        .single();

    return EcoLogModel.fromSupabase(response);
  }

  /// Get user's total eco points
  Future<int> getUserTotalEcoPoints(String userId) async {
    final logs = await getUserEcoLogs(userId, limit: 1000);
    return logs
        .where((log) => log.isFullyVerified)
        .fold<int>(0, (sum, log) => sum + log.pointsAwarded);
  }

  /// Get pending eco logs (awaiting verification)
  Future<List<EcoLogModel>> getPendingEcoLogs(String userId) async {
    final response = await _client
        .from('eco_logs')
        .select()
        .eq('user_id', userId)
        .eq('ai_verification_status', 'PENDING')
        .order('created_at', ascending: false);

    return (response as List)
        .map((data) => EcoLogModel.fromSupabase(data))
        .toList();
  }

  /// Get verified eco logs
  Future<List<EcoLogModel>> getVerifiedEcoLogs(String userId) async {
    final response = await _client
        .from('eco_logs')
        .select()
        .eq('user_id', userId)
        .eq('ai_verification_status', 'PASSED')
        .eq('admin_verification_status', 'PASSED')
        .order('created_at', ascending: false);

    return (response as List)
        .map((data) => EcoLogModel.fromSupabase(data))
        .toList();
  }

  /// Get eco logs by dive
  Future<List<EcoLogModel>> getEcoLogsByDive(String diveId) async {
    final response = await _client
        .from('eco_logs')
        .select()
        .eq('dive_id', diveId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((data) => EcoLogModel.fromSupabase(data))
        .toList();
  }

  /// Upload eco photo (trash photo)
  Future<String> uploadEcoPhoto(String userId, List<int> imageBytes, String fileName) async {
    final path = '$userId/${DateTime.now().millisecondsSinceEpoch}_$fileName';

    await _client.storage
        .from('eco-photos')
        .uploadBinary(path, imageBytes as dynamic);

    return _client.storage
        .from('eco-photos')
        .getPublicUrl(path);
  }

  /// Get eco statistics for user
  Future<Map<String, dynamic>> getEcoStatistics(String userId) async {
    final logs = await getUserEcoLogs(userId, limit: 1000);
    final verifiedLogs = logs.where((log) => log.isFullyVerified).toList();

    if (logs.isEmpty) {
      return {
        'total_submissions': 0,
        'verified_count': 0,
        'pending_count': 0,
        'total_points': 0,
        'items_collected': {},
      };
    }

    // Count items by type
    final itemCounts = <String, int>{};
    for (final log in verifiedLogs) {
      for (final item in log.detectedItems) {
        itemCounts[item.type] = (itemCounts[item.type] ?? 0) + 1;
      }
    }

    return {
      'total_submissions': logs.length,
      'verified_count': verifiedLogs.length,
      'pending_count': logs.where((log) =>
          log.aiVerificationStatus == VerificationStatus.pending ||
          log.adminVerificationStatus == VerificationStatus.pending
      ).length,
      'total_points': verifiedLogs.fold(0, (sum, log) => sum + log.pointsAwarded),
      'items_collected': itemCounts,
    };
  }

  /// Create point transaction
  Future<void> createPointTransaction(PointTransactionModel transaction) async {
    await _client
        .from('point_transactions')
        .insert(transaction.toSupabase());
  }

  /// Get user's point transactions
  Future<List<PointTransactionModel>> getUserPointTransactions(String userId, {int limit = 50}) async {
    final response = await _client
        .from('point_transactions')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(limit);

    return (response as List)
        .map((data) => PointTransactionModel.fromSupabase(data))
        .toList();
  }
}
