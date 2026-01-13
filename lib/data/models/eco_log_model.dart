/// AI Verification Status
enum VerificationStatus {
  pending,
  passed,
  rejected,
  manualReview,
}

/// Detected Trash Item
class DetectedTrashItem {
  final String type;
  final double confidence;
  final Map<String, double>? boundingBox;

  DetectedTrashItem({
    required this.type,
    required this.confidence,
    this.boundingBox,
  });

  factory DetectedTrashItem.fromMap(Map<String, dynamic> map) {
    return DetectedTrashItem(
      type: map['type'] as String,
      confidence: (map['confidence'] as num).toDouble(),
      boundingBox: map['bounding_box'] != null
          ? Map<String, double>.from(map['bounding_box'] as Map)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'confidence': confidence,
      'bounding_box': boundingBox,
    };
  }

  /// Get points for trash type
  int get points {
    switch (type) {
      case 'fishing_net':
        return 50;
      case 'plastic_bottle':
      case 'can':
        return 10;
      case 'plastic_bag':
        return 8;
      case 'glass_bottle':
        return 15;
      case 'rope':
        return 20;
      case 'tire':
        return 100;
      default:
        return 5;
    }
  }
}

/// Eco Log Model (Good Diving Points System)
/// Based on PRD ECO-01
class EcoLogModel {
  final String logId;
  final String userId;
  final String? diveId;
  final String imageUrlTrash;
  final String imageUrlRecycle;
  final VerificationStatus aiVerificationStatus;
  final VerificationStatus adminVerificationStatus;
  final List<DetectedTrashItem> detectedItems;
  final int pointsAwarded;
  final Map<String, double>? location;
  final DateTime? photoTimestamp;
  final String? rejectionReason;
  final DateTime createdAt;
  final DateTime updatedAt;

  EcoLogModel({
    required this.logId,
    required this.userId,
    this.diveId,
    required this.imageUrlTrash,
    required this.imageUrlRecycle,
    this.aiVerificationStatus = VerificationStatus.pending,
    this.adminVerificationStatus = VerificationStatus.pending,
    this.detectedItems = const [],
    this.pointsAwarded = 0,
    this.location,
    this.photoTimestamp,
    this.rejectionReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory EcoLogModel.fromSupabase(Map<String, dynamic> data) {
    return EcoLogModel(
      logId: data['id'] as String,
      userId: data['user_id'] as String,
      diveId: data['dive_id'] as String?,
      imageUrlTrash: data['image_url_trash'] as String,
      imageUrlRecycle: data['image_url_recycle'] as String,
      aiVerificationStatus: VerificationStatus.values.firstWhere(
        (e) => e.name.toUpperCase() == (data['ai_verification_status'] as String?)?.toUpperCase(),
        orElse: () => VerificationStatus.pending,
      ),
      adminVerificationStatus: VerificationStatus.values.firstWhere(
        (e) => e.name.toUpperCase() == (data['admin_verification_status'] as String?)?.toUpperCase(),
        orElse: () => VerificationStatus.pending,
      ),
      detectedItems: (data['detected_items'] as List<dynamic>?)
              ?.map((item) => DetectedTrashItem.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      pointsAwarded: data['points_awarded'] as int? ?? 0,
      location: data['location'] != null
          ? Map<String, double>.from(data['location'] as Map)
          : null,
      photoTimestamp: data['photo_timestamp'] != null ? DateTime.parse(data['photo_timestamp'] as String) : null,
      rejectionReason: data['rejection_reason'] as String?,
      createdAt: data['created_at'] != null ? DateTime.parse(data['created_at'] as String) : DateTime.now(),
      updatedAt: data['updated_at'] != null ? DateTime.parse(data['updated_at'] as String) : DateTime.now(),
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'user_id': userId,
      'dive_id': diveId,
      'image_url_trash': imageUrlTrash,
      'image_url_recycle': imageUrlRecycle,
      'ai_verification_status': aiVerificationStatus.name.toUpperCase(),
      'admin_verification_status': adminVerificationStatus.name.toUpperCase(),
      'detected_items': detectedItems.map((item) => item.toMap()).toList(),
      'points_awarded': pointsAwarded,
      'location': location,
      'photo_timestamp': photoTimestamp?.toIso8601String(),
      'rejection_reason': rejectionReason,
      'created_at': createdAt.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  /// Calculate total points from detected items
  int calculateTotalPoints() {
    return detectedItems.fold(0, (sum, item) => sum + item.points);
  }

  /// Check if both verification passed
  bool get isFullyVerified =>
      aiVerificationStatus == VerificationStatus.passed &&
      adminVerificationStatus == VerificationStatus.passed;

  EcoLogModel copyWith({
    String? logId,
    String? userId,
    String? diveId,
    String? imageUrlTrash,
    String? imageUrlRecycle,
    VerificationStatus? aiVerificationStatus,
    VerificationStatus? adminVerificationStatus,
    List<DetectedTrashItem>? detectedItems,
    int? pointsAwarded,
    Map<String, double>? location,
    DateTime? photoTimestamp,
    String? rejectionReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EcoLogModel(
      logId: logId ?? this.logId,
      userId: userId ?? this.userId,
      diveId: diveId ?? this.diveId,
      imageUrlTrash: imageUrlTrash ?? this.imageUrlTrash,
      imageUrlRecycle: imageUrlRecycle ?? this.imageUrlRecycle,
      aiVerificationStatus: aiVerificationStatus ?? this.aiVerificationStatus,
      adminVerificationStatus: adminVerificationStatus ?? this.adminVerificationStatus,
      detectedItems: detectedItems ?? this.detectedItems,
      pointsAwarded: pointsAwarded ?? this.pointsAwarded,
      location: location ?? this.location,
      photoTimestamp: photoTimestamp ?? this.photoTimestamp,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Point Transaction Model
class PointTransactionModel {
  final String transactionId;
  final String userId;
  final int amount;
  final String type; // 'earn', 'spend', 'refund'
  final String source; // 'eco_log', 'coupon_redeem', 'admin'
  final String? referenceId;
  final String? description;
  final DateTime createdAt;

  PointTransactionModel({
    required this.transactionId,
    required this.userId,
    required this.amount,
    required this.type,
    required this.source,
    this.referenceId,
    this.description,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory PointTransactionModel.fromSupabase(Map<String, dynamic> data) {
    return PointTransactionModel(
      transactionId: data['id'] as String,
      userId: data['user_id'] as String,
      amount: data['amount'] as int,
      type: data['type'] as String,
      source: data['source'] as String,
      referenceId: data['reference_id'] as String?,
      description: data['description'] as String?,
      createdAt: data['created_at'] != null ? DateTime.parse(data['created_at'] as String) : DateTime.now(),
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'user_id': userId,
      'amount': amount,
      'type': type,
      'source': source,
      'reference_id': referenceId,
      'description': description,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
