/// Dive Log Model
/// Based on PRD LOG-01 and TRD Schema
class DiveLogModel {
  final String diveId;
  final String userId;
  final DateTime timestamp;
  final String siteName;
  final Map<String, double>? geoPoint;
  final int bottomTime; // minutes
  final double maxDepth; // meters
  final double? avgDepth;
  final int? visibility; // meters
  final List<GasModel> gases;
  final String? telemetryDataUrl;
  final bool verified;
  final String? buddyId;
  final String? notes;
  final List<String> photos;
  final DiveConditions? conditions;
  final TankInfo? tankInfo;
  final DateTime createdAt;
  final DateTime updatedAt;

  DiveLogModel({
    required this.diveId,
    required this.userId,
    required this.timestamp,
    required this.siteName,
    this.geoPoint,
    required this.bottomTime,
    required this.maxDepth,
    this.avgDepth,
    this.visibility,
    this.gases = const [],
    this.telemetryDataUrl,
    this.verified = false,
    this.buddyId,
    this.notes,
    this.photos = const [],
    this.conditions,
    this.tankInfo,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory DiveLogModel.fromSupabase(Map<String, dynamic> data) {
    return DiveLogModel(
      diveId: data['id'] as String,
      userId: data['user_id'] as String,
      timestamp: DateTime.parse(data['timestamp'] as String),
      siteName: data['site_name'] as String,
      geoPoint: data['geo_point'] != null
          ? Map<String, double>.from(data['geo_point'] as Map)
          : null,
      bottomTime: data['bottom_time'] as int,
      maxDepth: (data['max_depth'] as num).toDouble(),
      avgDepth: (data['avg_depth'] as num?)?.toDouble(),
      visibility: data['visibility'] as int?,
      gases: (data['gases'] as List<dynamic>?)
              ?.map((g) => GasModel.fromMap(g as Map<String, dynamic>))
              .toList() ??
          [],
      telemetryDataUrl: data['telemetry_data_url'] as String?,
      verified: data['verified'] as bool? ?? false,
      buddyId: data['buddy_id'] as String?,
      notes: data['notes'] as String?,
      photos: List<String>.from(data['photos'] ?? []),
      conditions: data['conditions'] != null
          ? DiveConditions.fromMap(data['conditions'] as Map<String, dynamic>)
          : null,
      tankInfo: data['tank_info'] != null
          ? TankInfo.fromMap(data['tank_info'] as Map<String, dynamic>)
          : null,
      createdAt: data['created_at'] != null ? DateTime.parse(data['created_at'] as String) : DateTime.now(),
      updatedAt: data['updated_at'] != null ? DateTime.parse(data['updated_at'] as String) : DateTime.now(),
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'user_id': userId,
      'timestamp': timestamp.toIso8601String(),
      'site_name': siteName,
      'geo_point': geoPoint,
      'bottom_time': bottomTime,
      'max_depth': maxDepth,
      'avg_depth': avgDepth,
      'visibility': visibility,
      'gases': gases.map((g) => g.toMap()).toList(),
      'telemetry_data_url': telemetryDataUrl,
      'verified': verified,
      'buddy_id': buddyId,
      'notes': notes,
      'photos': photos,
      'conditions': conditions?.toMap(),
      'tank_info': tankInfo?.toMap(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  DiveLogModel copyWith({
    String? diveId,
    String? userId,
    DateTime? timestamp,
    String? siteName,
    Map<String, double>? geoPoint,
    int? bottomTime,
    double? maxDepth,
    double? avgDepth,
    int? visibility,
    List<GasModel>? gases,
    String? telemetryDataUrl,
    bool? verified,
    String? buddyId,
    String? notes,
    List<String>? photos,
    DiveConditions? conditions,
    TankInfo? tankInfo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DiveLogModel(
      diveId: diveId ?? this.diveId,
      userId: userId ?? this.userId,
      timestamp: timestamp ?? this.timestamp,
      siteName: siteName ?? this.siteName,
      geoPoint: geoPoint ?? this.geoPoint,
      bottomTime: bottomTime ?? this.bottomTime,
      maxDepth: maxDepth ?? this.maxDepth,
      avgDepth: avgDepth ?? this.avgDepth,
      visibility: visibility ?? this.visibility,
      gases: gases ?? this.gases,
      telemetryDataUrl: telemetryDataUrl ?? this.telemetryDataUrl,
      verified: verified ?? this.verified,
      buddyId: buddyId ?? this.buddyId,
      notes: notes ?? this.notes,
      photos: photos ?? this.photos,
      conditions: conditions ?? this.conditions,
      tankInfo: tankInfo ?? this.tankInfo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Gas Mix Model (Air, Nitrox, etc.)
class GasModel {
  final String name;
  final int oxygenPercentage;
  final int? heliumPercentage;

  GasModel({
    required this.name,
    required this.oxygenPercentage,
    this.heliumPercentage,
  });

  factory GasModel.fromMap(Map<String, dynamic> map) {
    return GasModel(
      name: map['name'] as String,
      oxygenPercentage: map['oxygen_percentage'] as int,
      heliumPercentage: map['helium_percentage'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'oxygen_percentage': oxygenPercentage,
      'helium_percentage': heliumPercentage,
    };
  }

  static GasModel air() => GasModel(name: 'Air', oxygenPercentage: 21);
  static GasModel ean32() => GasModel(name: 'EAN32', oxygenPercentage: 32);
  static GasModel ean36() => GasModel(name: 'EAN36', oxygenPercentage: 36);
}

/// Dive Conditions
class DiveConditions {
  final String? weather;
  final String? wind;
  final String? current;
  final String? tide;
  final double? surfaceTemp;
  final double? bottomTemp;
  final String? waterType;
  final String? entryType;

  DiveConditions({
    this.weather,
    this.wind,
    this.current,
    this.tide,
    this.surfaceTemp,
    this.bottomTemp,
    this.waterType,
    this.entryType,
  });

  factory DiveConditions.fromMap(Map<String, dynamic> map) {
    return DiveConditions(
      weather: map['weather'] as String?,
      wind: map['wind'] as String?,
      current: map['current'] as String?,
      tide: map['tide'] as String?,
      surfaceTemp: (map['surface_temp'] as num?)?.toDouble(),
      bottomTemp: (map['bottom_temp'] as num?)?.toDouble(),
      waterType: map['water_type'] as String?,
      entryType: map['entry_type'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'weather': weather,
      'wind': wind,
      'current': current,
      'tide': tide,
      'surface_temp': surfaceTemp,
      'bottom_temp': bottomTemp,
      'water_type': waterType,
      'entry_type': entryType,
    };
  }
}

/// Tank Information
class TankInfo {
  final int startPressure; // bar
  final int endPressure; // bar
  final int? tankSize; // liters
  final String? tankMaterial; // steel, aluminum

  TankInfo({
    required this.startPressure,
    required this.endPressure,
    this.tankSize,
    this.tankMaterial,
  });

  factory TankInfo.fromMap(Map<String, dynamic> map) {
    return TankInfo(
      startPressure: map['start_pressure'] as int,
      endPressure: map['end_pressure'] as int,
      tankSize: map['tank_size'] as int?,
      tankMaterial: map['tank_material'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'start_pressure': startPressure,
      'end_pressure': endPressure,
      'tank_size': tankSize,
      'tank_material': tankMaterial,
    };
  }

  /// Calculate SAC Rate (Surface Air Consumption)
  double? calculateSacRate(int bottomTime, double avgDepth) {
    if (tankSize == null || bottomTime == 0) return null;
    final airUsed = startPressure - endPressure;
    final avgPressure = (avgDepth / 10) + 1; // ATM
    return (airUsed * tankSize!) / (bottomTime * avgPressure);
  }
}
