// lib/app/config/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zenciti/core/utils/api_client.dart';
import 'package:zenciti/features/activity/data/repositories/activite_type_repo.dart';
import 'package:zenciti/features/activity/domain/entities/activity.dart';
import 'package:zenciti/features/activity/domain/usecase/activity_single_use_case.dart';
import 'package:zenciti/features/activity/domain/usecase/ativity_use_case.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_bloc.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_event.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_single.dart';
import 'package:zenciti/features/activity/presentation/screens/activity_details.dart';
import 'package:zenciti/features/activity/presentation/screens/activity_type.dart';
import 'package:zenciti/features/auth/presentation/screens/login_screen.dart';
import 'package:zenciti/features/home/presentation/screens/home_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => HomePage(),
      ),
      GoRoute(
        path: '/home/type/:activityTypeId',
        builder: (context, state) {
          final activity = state.extra as TypeActivity;
          return BlocProvider<ActivityBloc>(
            create: (context) => ActivityBloc(
              ActivityUseCase(
                ActiviteTypeRepoImp(
                  apiClient: ApiClient(baseUrl: "http://192.168.1.191:8080"),
                ),
              ),
            ),
            child: ActivityType(activityType: activity),
          );
        },
      ),
      GoRoute(
        path: '/activities/:activityId',
        builder: (context, state) {
          final activityId = state.pathParameters['activityId']!;
          return BlocProvider<ActivitySingleBloc>(
            create: (context) => ActivitySingleBloc(
              ActivitySingleUseCase(
                ActiviteTypeRepoImp(
                  apiClient: ApiClient(baseUrl: "http://192.168.1.191:8080"),
                ),
              ),
            )..add(GetActivityById(activityId)),
            child: ActivityDetailsPage(),
          );
        },
      ),
    ],
  );
}
