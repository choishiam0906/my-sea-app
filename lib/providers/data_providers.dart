import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/models.dart';
import 'repository_providers.dart';
import 'auth_provider.dart';

/// User's Dive Logs Provider
final userDiveLogsProvider = FutureProvider<List<DiveLogModel>>((ref) async {
  final user = ref.watch(supabaseUserProvider);
  if (user == null) return [];

  final repository = ref.watch(diveLogRepositoryProvider);
  return repository.getUserDiveLogs(user.id);
});

/// Recent Dive Logs Provider (last 5)
final recentDiveLogsProvider = FutureProvider<List<DiveLogModel>>((ref) async {
  final user = ref.watch(supabaseUserProvider);
  if (user == null) return [];

  final repository = ref.watch(diveLogRepositoryProvider);
  return repository.getRecentDiveLogs(user.id, count: 5);
});

/// Dive Statistics Provider
final diveStatisticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final user = ref.watch(supabaseUserProvider);
  if (user == null) return {};

  final repository = ref.watch(diveLogRepositoryProvider);
  return repository.getDiveStatistics(user.id);
});

/// Single Dive Log Provider (by ID)
final diveLogProvider = FutureProvider.family<DiveLogModel?, String>((ref, diveId) async {
  final repository = ref.watch(diveLogRepositoryProvider);
  return repository.getDiveLogById(diveId);
});

/// User's Eco Logs Provider
final userEcoLogsProvider = FutureProvider<List<EcoLogModel>>((ref) async {
  final user = ref.watch(supabaseUserProvider);
  if (user == null) return [];

  final repository = ref.watch(ecoLogRepositoryProvider);
  return repository.getUserEcoLogs(user.id);
});

/// Eco Statistics Provider
final ecoStatisticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final user = ref.watch(supabaseUserProvider);
  if (user == null) return {};

  final repository = ref.watch(ecoLogRepositoryProvider);
  return repository.getEcoStatistics(user.id);
});

/// User's Total Eco Points Provider
final userEcoPointsProvider = FutureProvider<int>((ref) async {
  final user = ref.watch(supabaseUserProvider);
  if (user == null) return 0;

  final repository = ref.watch(ecoLogRepositoryProvider);
  return repository.getUserTotalEcoPoints(user.id);
});

/// User's Point Transactions Provider
final pointTransactionsProvider = FutureProvider<List<PointTransactionModel>>((ref) async {
  final user = ref.watch(supabaseUserProvider);
  if (user == null) return [];

  final repository = ref.watch(ecoLogRepositoryProvider);
  return repository.getUserPointTransactions(user.id);
});

/// Public Crews Provider
final publicCrewsProvider = FutureProvider<List<CrewModel>>((ref) async {
  final repository = ref.watch(crewRepositoryProvider);
  return repository.getPublicCrews();
});

/// Top Crews by Eco Score Provider
final topCrewsProvider = FutureProvider<List<CrewModel>>((ref) async {
  final repository = ref.watch(crewRepositoryProvider);
  return repository.getTopCrewsByEcoScore(limit: 10);
});

/// User's Crew Provider
final userCrewProvider = FutureProvider<CrewModel?>((ref) async {
  final user = ref.watch(supabaseUserProvider);
  if (user == null) return null;

  final repository = ref.watch(crewRepositoryProvider);
  return repository.getUserCrew(user.id);
});

/// Single Crew Provider (by ID)
final crewProvider = FutureProvider.family<CrewModel?, String>((ref, crewId) async {
  final repository = ref.watch(crewRepositoryProvider);
  return repository.getCrewById(crewId);
});

/// Crew Members Provider
final crewMembersProvider = FutureProvider.family<List<CrewMemberModel>, String>((ref, crewId) async {
  final repository = ref.watch(crewRepositoryProvider);
  return repository.getCrewMembers(crewId);
});

/// User's Certifications Provider
final userCertificationsProvider = FutureProvider<List<CertificationModel>>((ref) async {
  final user = ref.watch(supabaseUserProvider);
  if (user == null) return [];

  final repository = ref.watch(certificationRepositoryProvider);
  return repository.getUserCertifications(user.id);
});

/// User's Highest Certification Provider
final highestCertificationProvider = FutureProvider<CertificationModel?>((ref) async {
  final user = ref.watch(supabaseUserProvider);
  if (user == null) return null;

  final repository = ref.watch(certificationRepositoryProvider);
  return repository.getUserHighestCertification(user.id);
});

/// All Marine Species Provider
final marineSpeciesProvider = FutureProvider<List<MarineSpeciesModel>>((ref) async {
  final repository = ref.watch(marineSpeciesRepositoryProvider);
  return repository.getAllSpecies();
});

/// Species by Category Provider
final speciesByCategoryProvider = FutureProvider.family<List<MarineSpeciesModel>, MarineCategory>((ref, category) async {
  final repository = ref.watch(marineSpeciesRepositoryProvider);
  return repository.getSpeciesByCategory(category);
});

/// Rare Species Provider
final rareSpeciesProvider = FutureProvider<List<MarineSpeciesModel>>((ref) async {
  final repository = ref.watch(marineSpeciesRepositoryProvider);
  return repository.getRareSpecies();
});

/// User's Species Collection Provider
final userSpeciesCollectionProvider = FutureProvider<List<UserSpeciesCollectionModel>>((ref) async {
  final user = ref.watch(supabaseUserProvider);
  if (user == null) return [];

  final repository = ref.watch(marineSpeciesRepositoryProvider);
  return repository.getUserCollection(user.id);
});

/// Collection Statistics Provider
final collectionStatisticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final user = ref.watch(supabaseUserProvider);
  if (user == null) return {};

  final repository = ref.watch(marineSpeciesRepositoryProvider);
  return repository.getCollectionStatistics(user.id);
});

/// User's Sightings Provider
final userSightingsProvider = FutureProvider<List<MarineSightingModel>>((ref) async {
  final user = ref.watch(supabaseUserProvider);
  if (user == null) return [];

  final repository = ref.watch(marineSpeciesRepositoryProvider);
  return repository.getUserSightings(user.id);
});

/// Dive Sightings Provider (by dive ID)
final diveSightingsProvider = FutureProvider.family<List<MarineSightingModel>, String>((ref, diveId) async {
  final repository = ref.watch(marineSpeciesRepositoryProvider);
  return repository.getDiveSightings(diveId);
});

/// Single Species Provider (by ID)
final speciesProvider = FutureProvider.family<MarineSpeciesModel?, String>((ref, speciesId) async {
  final repository = ref.watch(marineSpeciesRepositoryProvider);
  return repository.getSpeciesById(speciesId);
});

/// Species Search Provider
final speciesSearchProvider = FutureProvider.family<List<MarineSpeciesModel>, String>((ref, query) async {
  if (query.isEmpty) return [];
  final repository = ref.watch(marineSpeciesRepositoryProvider);
  return repository.searchSpecies(query);
});

/// Crew Search Provider
final crewSearchProvider = FutureProvider.family<List<CrewModel>, String>((ref, query) async {
  if (query.isEmpty) return [];
  final repository = ref.watch(crewRepositoryProvider);
  return repository.searchCrews(query);
});
