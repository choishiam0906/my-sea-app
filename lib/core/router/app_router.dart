import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/logbook/presentation/pages/home_page.dart';
import '../../features/logbook/presentation/pages/dive_log_page.dart';
import '../../features/logbook/presentation/pages/dive_detail_page.dart';
import '../../features/logbook/presentation/pages/add_dive_page.dart';
import '../../features/eco/presentation/pages/eco_page.dart';
import '../../features/eco/presentation/pages/eco_submit_page.dart';
import '../../features/crew/presentation/pages/crew_page.dart';
import '../../features/crew/presentation/pages/crew_detail_page.dart';
import '../../features/crew/presentation/pages/buddy_finder_page.dart';
import '../../features/certification/presentation/pages/cert_wallet_page.dart';
import '../../features/certification/presentation/pages/add_cert_page.dart';
import '../../features/ai/presentation/pages/fish_id_page.dart';
import '../../features/ai/presentation/pages/encyclopedia_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/settings_page.dart';
import '../../shared/widgets/main_scaffold.dart';
import '../../providers/auth_provider.dart';

/// App Route Paths
class AppRoutes {
  AppRoutes._();

  // Auth
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';

  // Main Tabs
  static const String home = '/home';
  static const String dives = '/dives';
  static const String eco = '/eco';
  static const String crew = '/crew';
  static const String profile = '/profile';

  // Sub Routes
  static const String diveDetail = '/dives/:id';
  static const String addDive = '/dives/add';
  static const String ecoSubmit = '/eco/submit';
  static const String crewDetail = '/crew/:id';
  static const String buddyFinder = '/buddy';
  static const String certWallet = '/certifications';
  static const String addCert = '/certifications/add';
  static const String fishId = '/fish-id';
  static const String encyclopedia = '/encyclopedia';
  static const String settings = '/settings';
}

/// Shell Route Keys for Bottom Navigation
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// App Router Provider
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final user = ref.watch(supabaseUserProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = user != null;
      final isAuthRoute = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register ||
          state.matchedLocation == AppRoutes.splash;

      // If not logged in and not on auth route, redirect to login
      if (!isLoggedIn && !isAuthRoute) {
        return AppRoutes.login;
      }

      // If logged in and on auth route (except splash), redirect to home
      if (isLoggedIn && (state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register)) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      // Splash Screen
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),

      // Auth Routes
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),

      // Main Shell Route with Bottom Navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          // Home Tab
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomePage(),
            ),
          ),

          // Dives Tab
          GoRoute(
            path: AppRoutes.dives,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DiveLogPage(),
            ),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const AddDivePage(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) => DiveDetailPage(
                  diveId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),

          // Eco Tab
          GoRoute(
            path: AppRoutes.eco,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: EcoPage(),
            ),
            routes: [
              GoRoute(
                path: 'submit',
                builder: (context, state) => const EcoSubmitPage(),
              ),
            ],
          ),

          // Crew Tab
          GoRoute(
            path: AppRoutes.crew,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: CrewPage(),
            ),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => CrewDetailPage(
                  crewId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),

          // Profile Tab
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfilePage(),
            ),
          ),
        ],
      ),

      // Non-Tab Routes
      GoRoute(
        path: AppRoutes.buddyFinder,
        builder: (context, state) => const BuddyFinderPage(),
      ),
      GoRoute(
        path: AppRoutes.certWallet,
        builder: (context, state) => const CertWalletPage(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) => const AddCertPage(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.fishId,
        builder: (context, state) => const FishIdPage(),
      ),
      GoRoute(
        path: AppRoutes.encyclopedia,
        builder: (context, state) => const EncyclopediaPage(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri.path}'),
      ),
    ),
  );
});
