// lib/app/config/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zenciti/features/activity/activity_type.dart';
import 'package:zenciti/features/home/domain/entities/activity.dart';
import 'package:zenciti/features/home/presentation/screens/home_page.dart';
import 'package:zenciti/features/auth/presentation/screens/login_screen.dart';
import 'package:zenciti/features/home/presentation/screens/home_screen.dart';
// import 'package:zenciti/features/home/presentation/screens/home_screen.dart';
// Import all your pages here

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) {
          // final id = state.params['id']!;
          return HomePage();
        },
      ),
      GoRoute(
          path: '/home/type/:activityTypeId',
          builder: (context, state) {
            final activity = state.extra as TypeActivity;

            return ActivityType(activityType: activity);
          }),
    ],
  );
}
