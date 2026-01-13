/// User Profile Model
/// Compatible with Supabase PostgreSQL schema
class UserModel {
  final String uid;
  final String? email;
  final String nickname;
  final String? profileImageUrl;
  final String? crewId;
  final int leafPoints;
  final String? certLevel;
  final bool isVerified;
  final List<String> badges;
  final List<String> speciesCollected;
  final int totalDives;
  final int totalEcoScore;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.uid,
    this.email,
    required this.nickname,
    this.profileImageUrl,
    this.crewId,
    this.leafPoints = 0,
    this.certLevel,
    this.isVerified = false,
    this.badges = const [],
    this.speciesCollected = const [],
    this.totalDives = 0,
    this.totalEcoScore = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Create UserModel from Supabase row
  factory UserModel.fromSupabase(Map<String, dynamic> data) {
    return UserModel(
      uid: data['id'] as String,
      email: data['email'] as String?,
      nickname: data['nickname'] as String? ?? 'Diver',
      profileImageUrl: data['profile_image_url'] as String?,
      crewId: data['crew_id'] as String?,
      leafPoints: data['leaf_points'] as int? ?? 0,
      certLevel: data['cert_level'] as String?,
      isVerified: data['is_verified'] as bool? ?? false,
      badges: List<String>.from(data['badges'] ?? []),
      speciesCollected: List<String>.from(data['species_collected'] ?? []),
      totalDives: data['total_dives'] as int? ?? 0,
      totalEcoScore: data['total_eco_score'] as int? ?? 0,
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'] as String)
          : DateTime.now(),
      updatedAt: data['updated_at'] != null
          ? DateTime.parse(data['updated_at'] as String)
          : DateTime.now(),
    );
  }

  /// Convert to Supabase insert/update map
  Map<String, dynamic> toSupabase() {
    return {
      'id': uid,
      'email': email,
      'nickname': nickname,
      'profile_image_url': profileImageUrl,
      'crew_id': crewId,
      'leaf_points': leafPoints,
      'cert_level': certLevel,
      'is_verified': isVerified,
      'badges': badges,
      'species_collected': speciesCollected,
      'total_dives': totalDives,
      'total_eco_score': totalEcoScore,
      'created_at': createdAt.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? nickname,
    String? profileImageUrl,
    String? crewId,
    int? leafPoints,
    String? certLevel,
    bool? isVerified,
    List<String>? badges,
    List<String>? speciesCollected,
    int? totalDives,
    int? totalEcoScore,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      crewId: crewId ?? this.crewId,
      leafPoints: leafPoints ?? this.leafPoints,
      certLevel: certLevel ?? this.certLevel,
      isVerified: isVerified ?? this.isVerified,
      badges: badges ?? this.badges,
      speciesCollected: speciesCollected ?? this.speciesCollected,
      totalDives: totalDives ?? this.totalDives,
      totalEcoScore: totalEcoScore ?? this.totalEcoScore,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
