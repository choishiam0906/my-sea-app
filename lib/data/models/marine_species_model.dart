/// Marine Species Rarity Level
enum RarityLevel {
  common,
  uncommon,
  rare,
  epic,
  legendary,
}

/// Marine Species Category
enum MarineCategory {
  fish,
  mollusk,
  crustacean,
  mammal,
  reptile,
  coral,
  other,
}

/// Marine Species Model
/// Based on PRD AI-01 (Fish ID)
class MarineSpeciesModel {
  final String speciesId;
  final String nameKr;
  final String? nameEn;
  final String? scientificName;
  final MarineCategory category;
  final String? description;
  final String? sizeRange;
  final String? season;
  final String? depthRange;
  final String? habitat;
  final String? imageUrl;
  final RarityLevel rarity;
  final bool isDangerous;
  final DateTime createdAt;

  MarineSpeciesModel({
    required this.speciesId,
    required this.nameKr,
    this.nameEn,
    this.scientificName,
    this.category = MarineCategory.other,
    this.description,
    this.sizeRange,
    this.season,
    this.depthRange,
    this.habitat,
    this.imageUrl,
    this.rarity = RarityLevel.common,
    this.isDangerous = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory MarineSpeciesModel.fromSupabase(Map<String, dynamic> data) {
    return MarineSpeciesModel(
      speciesId: data['id'] as String,
      nameKr: data['name_kr'] as String,
      nameEn: data['name_en'] as String?,
      scientificName: data['scientific_name'] as String?,
      category: MarineCategory.values.firstWhere(
        (e) => e.name.toLowerCase() == (data['category'] as String?)?.toLowerCase(),
        orElse: () => MarineCategory.other,
      ),
      description: data['description'] as String?,
      sizeRange: data['size_range'] as String?,
      season: data['season'] as String?,
      depthRange: data['depth_range'] as String?,
      habitat: data['habitat'] as String?,
      imageUrl: data['image_url'] as String?,
      rarity: RarityLevel.values.firstWhere(
        (e) => e.name.toLowerCase() == (data['rarity'] as String?)?.toLowerCase(),
        orElse: () => RarityLevel.common,
      ),
      isDangerous: data['is_dangerous'] as bool? ?? false,
      createdAt: data['created_at'] != null ? DateTime.parse(data['created_at'] as String) : DateTime.now(),
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'name_kr': nameKr,
      'name_en': nameEn,
      'scientific_name': scientificName,
      'category': category.name,
      'description': description,
      'size_range': sizeRange,
      'season': season,
      'depth_range': depthRange,
      'habitat': habitat,
      'image_url': imageUrl,
      'rarity': rarity.name,
      'is_dangerous': isDangerous,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Get display name (Korean with English in parentheses)
  String get displayName {
    if (nameEn != null && nameEn!.isNotEmpty) {
      return '$nameKr ($nameEn)';
    }
    return nameKr;
  }

  /// Get badge points based on rarity
  int get badgePoints {
    switch (rarity) {
      case RarityLevel.legendary:
        return 500;
      case RarityLevel.epic:
        return 200;
      case RarityLevel.rare:
        return 100;
      case RarityLevel.uncommon:
        return 50;
      case RarityLevel.common:
        return 20;
    }
  }
}

/// Marine Sighting Model
/// Records when a user spots a marine species during a dive
class MarineSightingModel {
  final String sightingId;
  final String diveId;
  final String userId;
  final String speciesId;
  final int count;
  final String? photoUrl;
  final double? confidence; // AI confidence if auto-detected
  final Map<String, double>? boundingBox;
  final String? notes;
  final DateTime createdAt;

  MarineSightingModel({
    required this.sightingId,
    required this.diveId,
    required this.userId,
    required this.speciesId,
    this.count = 1,
    this.photoUrl,
    this.confidence,
    this.boundingBox,
    this.notes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory MarineSightingModel.fromSupabase(Map<String, dynamic> data) {
    return MarineSightingModel(
      sightingId: data['id'] as String,
      diveId: data['dive_id'] as String,
      userId: data['user_id'] as String,
      speciesId: data['species_id'] as String,
      count: data['count'] as int? ?? 1,
      photoUrl: data['photo_url'] as String?,
      confidence: (data['confidence'] as num?)?.toDouble(),
      boundingBox: data['bounding_box'] != null
          ? Map<String, double>.from(data['bounding_box'] as Map)
          : null,
      notes: data['notes'] as String?,
      createdAt: data['created_at'] != null ? DateTime.parse(data['created_at'] as String) : DateTime.now(),
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'dive_id': diveId,
      'user_id': userId,
      'species_id': speciesId,
      'count': count,
      'photo_url': photoUrl,
      'confidence': confidence,
      'bounding_box': boundingBox,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// User's collected species (for encyclopedia/badge)
class UserSpeciesCollectionModel {
  final String collectionId;
  final String userId;
  final String speciesId;
  final int totalSightings;
  final DateTime firstSeenAt;
  final DateTime lastSeenAt;
  final String? bestPhotoUrl;

  UserSpeciesCollectionModel({
    required this.collectionId,
    required this.userId,
    required this.speciesId,
    this.totalSightings = 1,
    DateTime? firstSeenAt,
    DateTime? lastSeenAt,
    this.bestPhotoUrl,
  })  : firstSeenAt = firstSeenAt ?? DateTime.now(),
        lastSeenAt = lastSeenAt ?? DateTime.now();

  factory UserSpeciesCollectionModel.fromSupabase(Map<String, dynamic> data) {
    return UserSpeciesCollectionModel(
      collectionId: data['id'] as String,
      userId: data['user_id'] as String,
      speciesId: data['species_id'] as String,
      totalSightings: data['total_sightings'] as int? ?? 1,
      firstSeenAt: data['first_seen_at'] != null ? DateTime.parse(data['first_seen_at'] as String) : DateTime.now(),
      lastSeenAt: data['last_seen_at'] != null ? DateTime.parse(data['last_seen_at'] as String) : DateTime.now(),
      bestPhotoUrl: data['best_photo_url'] as String?,
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'user_id': userId,
      'species_id': speciesId,
      'total_sightings': totalSightings,
      'first_seen_at': firstSeenAt.toIso8601String(),
      'last_seen_at': lastSeenAt.toIso8601String(),
      'best_photo_url': bestPhotoUrl,
    };
  }
}
