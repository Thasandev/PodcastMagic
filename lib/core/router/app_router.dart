import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/home/presentation/screens/main_shell.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/discovery/presentation/screens/discovery_screen.dart';
import '../../features/library/presentation/screens/library_screen.dart';
import '../../features/dangal/presentation/screens/dangal_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/player/presentation/screens/player_screen.dart';
import '../../features/reflections/presentation/screens/reflections_screen.dart';
import '../../features/reflections/presentation/screens/record_reflection_screen.dart';
import '../../features/coins/presentation/screens/coins_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/community/presentation/screens/community_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  routes: [
    // Auth
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),

    // Onboarding
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),

    // Main app shell with bottom nav
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/discover',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DiscoveryScreen(),
          ),
        ),
        GoRoute(
          path: '/library',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: LibraryScreen(),
          ),
        ),
        GoRoute(
          path: '/dangal',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DangalScreen(),
          ),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProfileScreen(),
          ),
        ),
      ],
    ),

    // Full screen routes
    GoRoute(
      path: '/player',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const PlayerScreen(),
    ),
    GoRoute(
      path: '/reflections',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ReflectionsScreen(),
    ),
    GoRoute(
      path: '/record-reflection',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const RecordReflectionScreen(),
    ),
    GoRoute(
      path: '/coins',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CoinsScreen(),
    ),
    GoRoute(
      path: '/settings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/community',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CommunityScreen(),
    ),
  ],
);
