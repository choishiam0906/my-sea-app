/// Crew Badge Tier
enum CrewTier {
  bronze, // 5-19 members
  silver, // 20-49 members
  gold,   // 50+ members
}

/// Crew Model
/// Based on PRD SOC-01
class CrewModel {
  final String crewId;
  final String crewName;
  final String? description;
  final String? imageUrl;
  final String leaderId;
  final int memberCount;
  final CrewTier badgeTier;
  final int totalEcoScore;
  final List<String> memberIds;
  final List<String> badges;
  final bool isPublic;
  final String? region;
  final DateTime createdAt;
  final DateTime updatedAt;

  CrewModel({
    required this.crewId,
    required this.crewName,
    this.description,
    this.imageUrl,
    required this.leaderId,
    this.memberCount = 1,
    this.badgeTier = CrewTier.bronze,
    this.totalEcoScore = 0,
    this.memberIds = const [],
    this.badges = const [],
    this.isPublic = true,
    this.region,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory CrewModel.fromSupabase(Map<String, dynamic> data) {
    return CrewModel(
      crewId: data['id'] as String,
      crewName: data['crew_name'] as String,
      description: data['description'] as String?,
      imageUrl: data['image_url'] as String?,
      leaderId: data['leader_id'] as String,
      memberCount: data['member_count'] as int? ?? 1,
      badgeTier: CrewTier.values.firstWhere(
        (e) => e.name.toUpperCase() == (data['badge_tier'] as String?)?.toUpperCase(),
        orElse: () => CrewTier.bronze,
      ),
      totalEcoScore: data['total_eco_score'] as int? ?? 0,
      memberIds: List<String>.from(data['member_ids'] ?? []),
      badges: List<String>.from(data['badges'] ?? []),
      isPublic: data['is_public'] as bool? ?? true,
      region: data['region'] as String?,
      createdAt: data['created_at'] != null ? DateTime.parse(data['created_at'] as String) : DateTime.now(),
      updatedAt: data['updated_at'] != null ? DateTime.parse(data['updated_at'] as String) : DateTime.now(),
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'crew_name': crewName,
      'description': description,
      'image_url': imageUrl,
      'leader_id': leaderId,
      'member_count': memberCount,
      'badge_tier': badgeTier.name.toUpperCase(),
      'total_eco_score': totalEcoScore,
      'member_ids': memberIds,
      'badges': badges,
      'is_public': isPublic,
      'region': region,
      'created_at': createdAt.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  /// Determine crew tier based on member count
  static CrewTier calculateTier(int memberCount) {
    if (memberCount >= 50) return CrewTier.gold;
    if (memberCount >= 20) return CrewTier.silver;
    return CrewTier.bronze;
  }

  /// Get point multiplier based on tier
  double get pointMultiplier {
    switch (badgeTier) {
      case CrewTier.gold:
        return 1.3;
      case CrewTier.silver:
        return 1.1;
      case CrewTier.bronze:
        return 1.0;
    }
  }

  CrewModel copyWith({
    String? crewId,
    String? crewName,
    String? description,
    String? imageUrl,
    String? leaderId,
    int? memberCount,
    CrewTier? badgeTier,
    int? totalEcoScore,
    List<String>? memberIds,
    List<String>? badges,
    bool? isPublic,
    String? region,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CrewModel(
      crewId: crewId ?? this.crewId,
      crewName: crewName ?? this.crewName,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      leaderId: leaderId ?? this.leaderId,
      memberCount: memberCount ?? this.memberCount,
      badgeTier: badgeTier ?? this.badgeTier,
      totalEcoScore: totalEcoScore ?? this.totalEcoScore,
      memberIds: memberIds ?? this.memberIds,
      badges: badges ?? this.badges,
      isPublic: isPublic ?? this.isPublic,
      region: region ?? this.region,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Crew Member Role
enum CrewMemberRole {
  leader,
  admin,
  member,
}

/// Crew Member Model
class CrewMemberModel {
  final String memberId;
  final String crewId;
  final String userId;
  final CrewMemberRole role;
  final int contributedEcoScore;
  final DateTime joinedAt;

  CrewMemberModel({
    required this.memberId,
    required this.crewId,
    required this.userId,
    this.role = CrewMemberRole.member,
    this.contributedEcoScore = 0,
    DateTime? joinedAt,
  }) : joinedAt = joinedAt ?? DateTime.now();

  factory CrewMemberModel.fromSupabase(Map<String, dynamic> data) {
    return CrewMemberModel(
      memberId: data['id'] as String,
      crewId: data['crew_id'] as String,
      userId: data['user_id'] as String,
      role: CrewMemberRole.values.firstWhere(
        (e) => e.name == data['role'],
        orElse: () => CrewMemberRole.member,
      ),
      contributedEcoScore: data['contributed_eco_score'] as int? ?? 0,
      joinedAt: data['joined_at'] != null ? DateTime.parse(data['joined_at'] as String) : DateTime.now(),
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'crew_id': crewId,
      'user_id': userId,
      'role': role.name,
      'contributed_eco_score': contributedEcoScore,
      'joined_at': joinedAt.toIso8601String(),
    };
  }
}
