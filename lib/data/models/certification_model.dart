/// Verification Method
enum CertVerificationMethod {
  ocrScan,
  apiSync,
  manualVerify,
  proVerify,
}

/// Certification Verification Status
enum CertVerificationStatus {
  unverified,
  pending,
  verified,
  rejected,
}

/// Certification Model
/// Based on PRD CERT-01
class CertificationModel {
  final String certId;
  final String userId;
  final String agency; // PADI, SSI, NAUI, etc.
  final String level; // Open Water, Advanced, etc.
  final String? certNumber;
  final String? diverName;
  final DateTime? issueDate;
  final String? imageUrl;
  final CertVerificationMethod verificationMethod;
  final CertVerificationStatus verificationStatus;
  final String? verifiedBy; // Pro instructor ID
  final DateTime? verifiedAt;
  final OcrExtractedData? ocrData;
  final DateTime createdAt;
  final DateTime updatedAt;

  CertificationModel({
    required this.certId,
    required this.userId,
    required this.agency,
    required this.level,
    this.certNumber,
    this.diverName,
    this.issueDate,
    this.imageUrl,
    this.verificationMethod = CertVerificationMethod.ocrScan,
    this.verificationStatus = CertVerificationStatus.unverified,
    this.verifiedBy,
    this.verifiedAt,
    this.ocrData,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory CertificationModel.fromSupabase(Map<String, dynamic> data) {
    return CertificationModel(
      certId: data['id'] as String,
      userId: data['user_id'] as String,
      agency: data['agency'] as String,
      level: data['level'] as String,
      certNumber: data['cert_number'] as String?,
      diverName: data['diver_name'] as String?,
      issueDate: data['issue_date'] != null ? DateTime.parse(data['issue_date'] as String) : null,
      imageUrl: data['image_url'] as String?,
      verificationMethod: CertVerificationMethod.values.firstWhere(
        (e) => e.name == data['verification_method'],
        orElse: () => CertVerificationMethod.ocrScan,
      ),
      verificationStatus: CertVerificationStatus.values.firstWhere(
        (e) => e.name == data['verification_status'],
        orElse: () => CertVerificationStatus.unverified,
      ),
      verifiedBy: data['verified_by'] as String?,
      verifiedAt: data['verified_at'] != null ? DateTime.parse(data['verified_at'] as String) : null,
      ocrData: data['ocr_data'] != null
          ? OcrExtractedData.fromMap(data['ocr_data'] as Map<String, dynamic>)
          : null,
      createdAt: data['created_at'] != null ? DateTime.parse(data['created_at'] as String) : DateTime.now(),
      updatedAt: data['updated_at'] != null ? DateTime.parse(data['updated_at'] as String) : DateTime.now(),
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'user_id': userId,
      'agency': agency,
      'level': level,
      'cert_number': certNumber,
      'diver_name': diverName,
      'issue_date': issueDate?.toIso8601String(),
      'image_url': imageUrl,
      'verification_method': verificationMethod.name,
      'verification_status': verificationStatus.name,
      'verified_by': verifiedBy,
      'verified_at': verifiedAt?.toIso8601String(),
      'ocr_data': ocrData?.toMap(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  bool get isVerified => verificationStatus == CertVerificationStatus.verified;

  /// Get display title (e.g., "PADI Advanced Open Water")
  String get displayTitle => '$agency $level';

  CertificationModel copyWith({
    String? certId,
    String? userId,
    String? agency,
    String? level,
    String? certNumber,
    String? diverName,
    DateTime? issueDate,
    String? imageUrl,
    CertVerificationMethod? verificationMethod,
    CertVerificationStatus? verificationStatus,
    String? verifiedBy,
    DateTime? verifiedAt,
    OcrExtractedData? ocrData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CertificationModel(
      certId: certId ?? this.certId,
      userId: userId ?? this.userId,
      agency: agency ?? this.agency,
      level: level ?? this.level,
      certNumber: certNumber ?? this.certNumber,
      diverName: diverName ?? this.diverName,
      issueDate: issueDate ?? this.issueDate,
      imageUrl: imageUrl ?? this.imageUrl,
      verificationMethod: verificationMethod ?? this.verificationMethod,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      verifiedBy: verifiedBy ?? this.verifiedBy,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      ocrData: ocrData ?? this.ocrData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// OCR Extracted Data from Certification Card
class OcrExtractedData {
  final String? rawText;
  final String? extractedName;
  final String? extractedNumber;
  final String? extractedAgency;
  final String? extractedLevel;
  final String? extractedDate;
  final double confidence;

  OcrExtractedData({
    this.rawText,
    this.extractedName,
    this.extractedNumber,
    this.extractedAgency,
    this.extractedLevel,
    this.extractedDate,
    this.confidence = 0.0,
  });

  factory OcrExtractedData.fromMap(Map<String, dynamic> map) {
    return OcrExtractedData(
      rawText: map['raw_text'] as String?,
      extractedName: map['extracted_name'] as String?,
      extractedNumber: map['extracted_number'] as String?,
      extractedAgency: map['extracted_agency'] as String?,
      extractedLevel: map['extracted_level'] as String?,
      extractedDate: map['extracted_date'] as String?,
      confidence: (map['confidence'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'raw_text': rawText,
      'extracted_name': extractedName,
      'extracted_number': extractedNumber,
      'extracted_agency': extractedAgency,
      'extracted_level': extractedLevel,
      'extracted_date': extractedDate,
      'confidence': confidence,
    };
  }

  /// Validate PADI certificate number format
  /// PADI numbers are typically 10-12 alphanumeric characters
  static bool isValidPadiNumber(String? number) {
    if (number == null || number.isEmpty) return false;
    final regex = RegExp(r'^[A-Z0-9]{10,12}$');
    return regex.hasMatch(number.toUpperCase());
  }

  /// Validate SSI certificate number format
  static bool isValidSsiNumber(String? number) {
    if (number == null || number.isEmpty) return false;
    final regex = RegExp(r'^\d{6,10}$');
    return regex.hasMatch(number);
  }
}

/// Specialty Certification
class SpecialtyCertModel {
  final String specialtyId;
  final String userId;
  final String name;
  final String agency;
  final DateTime? issueDate;
  final String? imageUrl;
  final bool isVerified;

  SpecialtyCertModel({
    required this.specialtyId,
    required this.userId,
    required this.name,
    required this.agency,
    this.issueDate,
    this.imageUrl,
    this.isVerified = false,
  });

  factory SpecialtyCertModel.fromSupabase(Map<String, dynamic> data) {
    return SpecialtyCertModel(
      specialtyId: data['id'] as String,
      userId: data['user_id'] as String,
      name: data['name'] as String,
      agency: data['agency'] as String,
      issueDate: data['issue_date'] != null ? DateTime.parse(data['issue_date'] as String) : null,
      imageUrl: data['image_url'] as String?,
      isVerified: data['is_verified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'user_id': userId,
      'name': name,
      'agency': agency,
      'issue_date': issueDate?.toIso8601String(),
      'image_url': imageUrl,
      'is_verified': isVerified,
    };
  }
}
