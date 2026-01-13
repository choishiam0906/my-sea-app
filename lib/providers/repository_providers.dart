import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/repositories/repositories.dart';

/// Supabase Client Provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// User Repository Provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return UserRepository(client);
});

/// Dive Log Repository Provider
final diveLogRepositoryProvider = Provider<DiveLogRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return DiveLogRepository(client);
});

/// Eco Log Repository Provider
final ecoLogRepositoryProvider = Provider<EcoLogRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return EcoLogRepository(client);
});

/// Crew Repository Provider
final crewRepositoryProvider = Provider<CrewRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return CrewRepository(client);
});

/// Certification Repository Provider
final certificationRepositoryProvider = Provider<CertificationRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return CertificationRepository(client);
});

/// Marine Species Repository Provider
final marineSpeciesRepositoryProvider = Provider<MarineSpeciesRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return MarineSpeciesRepository(client);
});
