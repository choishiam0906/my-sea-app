/// BlueNexus App Constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'BlueNexus';
  static const String appVersion = '1.0.0';

  // Crew Tier Thresholds
  static const int bronzeCrewMinMembers = 5;
  static const int silverCrewMinMembers = 20;
  static const int goldCrewMinMembers = 50;

  // Eco Points (Leaf Points)
  static const int plasticBottlePoints = 10;
  static const int canPoints = 10;
  static const int fishingNetPoints = 50;
  static const int generalTrashPoints = 5;

  // AI Confidence Threshold
  static const double aiConfidenceThreshold = 0.80;

  // Buddy Search Radius (km)
  static const double buddySearchRadius = 50.0;

  // Dive Computer Manufacturers
  static const List<String> supportedDiveComputers = [
    'Shearwater',
    'Suunto',
    'Garmin',
    'Mares',
    'Oceanic',
    'Aqualung',
  ];

  // Certification Agencies
  static const List<String> certificationAgencies = [
    'PADI',
    'SSI',
    'NAUI',
    'SDI/TDI',
    'CMAS',
    'BSAC',
  ];

  // Certification Levels
  static const List<String> certificationLevels = [
    'Open Water Diver',
    'Advanced Open Water',
    'Rescue Diver',
    'Divemaster',
    'Instructor',
    'Master Scuba Diver',
  ];

  // Dive Types
  static const List<String> diveTypes = [
    'Recreational',
    'Night Dive',
    'Drift Dive',
    'Wreck Dive',
    'Cave Dive',
    'Deep Dive',
    'Photography',
    'Training',
  ];

  // Weather Conditions
  static const List<String> weatherConditions = [
    'Sunny',
    'Cloudy',
    'Partly Cloudy',
    'Rainy',
    'Windy',
    'Stormy',
  ];

  // Water Types
  static const List<String> waterTypes = [
    'Salt',
    'Fresh',
    'Brackish',
  ];

  // Entry Types
  static const List<String> entryTypes = [
    'Boat',
    'Shore',
    'Pier',
    'Jetty',
  ];

  // Marine Species Categories
  static const List<String> marineCategories = [
    'Fish',
    'Mollusk',
    'Crustacean',
    'Mammal',
    'Reptile',
    'Coral',
    'Other',
  ];

  // Trash Types (for AI detection)
  static const List<String> trashTypes = [
    'plastic_bottle',
    'plastic_bag',
    'fishing_net',
    'can',
    'glass_bottle',
    'rope',
    'tire',
    'general_debris',
  ];
}
