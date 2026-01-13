import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/certification_model.dart';

/// Certification Repository for Supabase operations
class CertificationRepository {
  final SupabaseClient _client;

  CertificationRepository(this._client);

  /// Get all certifications for a user
  Future<List<CertificationModel>> getUserCertifications(String userId) async {
    final response = await _client
        .from('certifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((data) => CertificationModel.fromSupabase(data))
        .toList();
  }

  /// Get certification by ID
  Future<CertificationModel?> getCertificationById(String certId) async {
    final response = await _client
        .from('certifications')
        .select()
        .eq('id', certId)
        .maybeSingle();

    if (response == null) return null;
    return CertificationModel.fromSupabase(response);
  }

  /// Create a new certification
  Future<CertificationModel> createCertification(CertificationModel cert) async {
    final response = await _client
        .from('certifications')
        .insert(cert.toSupabase())
        .select()
        .single();

    return CertificationModel.fromSupabase(response);
  }

  /// Update a certification
  Future<CertificationModel> updateCertification(CertificationModel cert) async {
    final response = await _client
        .from('certifications')
        .update(cert.toSupabase())
        .eq('id', cert.certId)
        .select()
        .single();

    return CertificationModel.fromSupabase(response);
  }

  /// Delete a certification
  Future<void> deleteCertification(String certId) async {
    await _client
        .from('certifications')
        .delete()
        .eq('id', certId);
  }

  /// Get user's highest certification level
  Future<CertificationModel?> getUserHighestCertification(String userId) async {
    final certs = await getUserCertifications(userId);
    if (certs.isEmpty) return null;

    // Priority order for common certification levels
    const levelPriority = {
      'Instructor': 10,
      'Divemaster': 9,
      'Master Scuba Diver': 8,
      'Rescue Diver': 7,
      'Deep Diver': 6,
      'Advanced Open Water': 5,
      'AOW': 5,
      'Open Water': 4,
      'OW': 4,
      'Scuba Diver': 3,
      'Basic': 2,
      'Discover Scuba': 1,
    };

    CertificationModel? highest;
    int highestPriority = 0;

    for (final cert in certs) {
      final priority = levelPriority.entries
          .where((e) => cert.level.toLowerCase().contains(e.key.toLowerCase()))
          .map((e) => e.value)
          .fold(0, (a, b) => a > b ? a : b);

      if (priority > highestPriority) {
        highestPriority = priority;
        highest = cert;
      }
    }

    return highest ?? certs.first;
  }

  /// Get verified certifications only
  Future<List<CertificationModel>> getVerifiedCertifications(String userId) async {
    final response = await _client
        .from('certifications')
        .select()
        .eq('user_id', userId)
        .eq('verification_status', 'verified')
        .order('created_at', ascending: false);

    return (response as List)
        .map((data) => CertificationModel.fromSupabase(data))
        .toList();
  }

  /// Get certifications by agency
  Future<List<CertificationModel>> getCertificationsByAgency(String userId, String agency) async {
    final response = await _client
        .from('certifications')
        .select()
        .eq('user_id', userId)
        .ilike('agency', '%$agency%')
        .order('created_at', ascending: false);

    return (response as List)
        .map((data) => CertificationModel.fromSupabase(data))
        .toList();
  }

  /// Update certification verification status
  Future<void> updateVerificationStatus(
    String certId,
    CertVerificationStatus status, {
    String? verifiedBy,
  }) async {
    final updates = {
      'verification_status': status.name,
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (status == CertVerificationStatus.verified) {
      updates['verified_at'] = DateTime.now().toIso8601String();
      if (verifiedBy != null) {
        updates['verified_by'] = verifiedBy;
      }
    }

    await _client
        .from('certifications')
        .update(updates)
        .eq('id', certId);
  }

  /// Upload certification card image
  Future<String> uploadCertificationImage(String userId, List<int> imageBytes, String fileName) async {
    final path = '$userId/${DateTime.now().millisecondsSinceEpoch}_$fileName';

    await _client.storage
        .from('cert-images')
        .uploadBinary(path, imageBytes as dynamic);

    return _client.storage
        .from('cert-images')
        .getPublicUrl(path);
  }

  /// Save OCR extracted data
  Future<void> saveOcrData(String certId, OcrExtractedData ocrData) async {
    await _client
        .from('certifications')
        .update({
          'ocr_data': ocrData.toMap(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', certId);
  }

  // ---- Specialty Certifications ----

  /// Get user's specialty certifications
  Future<List<SpecialtyCertModel>> getUserSpecialties(String userId) async {
    final response = await _client
        .from('specialty_certifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((data) => SpecialtyCertModel.fromSupabase(data))
        .toList();
  }

  /// Add specialty certification
  Future<SpecialtyCertModel> addSpecialtyCert(SpecialtyCertModel specialty) async {
    final response = await _client
        .from('specialty_certifications')
        .insert(specialty.toSupabase())
        .select()
        .single();

    return SpecialtyCertModel.fromSupabase(response);
  }

  /// Delete specialty certification
  Future<void> deleteSpecialtyCert(String specialtyId) async {
    await _client
        .from('specialty_certifications')
        .delete()
        .eq('id', specialtyId);
  }
}
