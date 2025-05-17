// lib/app/config/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zenciti/core/utils/api_client.dart';
import 'package:zenciti/features/activity/data/repositories/activite_type_repo.dart';
import 'package:zenciti/features/activity/domain/entities/activity.dart';
import 'package:zenciti/features/activity/domain/usecase/activity_single_use_case.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_bloc.dart';
import 'package:zenciti/features/activity/domain/usecase/ativity_use_case.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_event.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_single.dart';
import 'package:zenciti/features/activity/presentation/screens/activity_details.dart';
import 'package:zenciti/features/activity/presentation/screens/activity_type.dart';
import 'package:zenciti/features/auth/presentation/screens/login_screen.dart';
import 'package:zenciti/features/home/presentation/screens/home_screen.dart';
import 'package:zenciti/features/restaurant/data/repositories/restaurant_repo.dart';
import 'package:zenciti/features/restaurant/domain/repositories/restaurant_repo.dart';
import 'package:zenciti/features/restaurant/domain/usecase/restaurant_table_use_case.dart';
import 'package:zenciti/features/restaurant/domain/usecase/restaurant_use_case.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_bloc.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_event.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_table_bloc.dart';
import 'package:zenciti/features/restaurant/presentation/screens/menu.dart';
import 'package:zenciti/features/restaurant/presentation/screens/order.dart';
import 'package:zenciti/features/restaurant/presentation/screens/reservation.dart';
import 'package:zenciti/features/restaurant/presentation/screens/restaurant_details.dart';
import 'package:zenciti/features/restaurant/presentation/screens/restaurants.dart';
import 'package:zenciti/features/restaurant/presentation/screens/schema_restaurant.dart';

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
          path: '/order',
          builder: (context, state) {
            return BlocProvider(
              create: (context) => RestaurantBloc(
                RestaurantUseCase(
                  RestaurantRepoImpl(apiClient: ApiClient(baseUrl: "http://192.168.1.191:8080")),
                ),
              )..add(MenuGetFood(idRestaurant: state.extra as String)),
              child: FoodOrderPage(),
            );
          }),
      GoRoute(
          path: '/restaurant',
          builder: (context, state) {
            return BlocProvider(
              create: (context) => RestaurantBloc(
                RestaurantUseCase(
                  RestaurantRepoImpl(
                      apiClient:
                          ApiClient(baseUrl: "http://192.168.1.191:8080")),
                ),
              ),
              child: Restaurants(),
            );
          }),
      GoRoute(
        path: '/reservation',
        builder: (context, state) => ReservationPage(),
      ),
      GoRoute(
          path: '/restaurant/menu',
          builder: (context, state) {
            return BlocProvider(
              create: (context) => RestaurantBloc(
                RestaurantUseCase(
                  RestaurantRepoImpl(apiClient: ApiClient(baseUrl: "http://192.168.1.191:8080")),
                ),
              )..add(MenuGetFood(idRestaurant: state.extra as String)),
              child: FoodMenu(),
            );
          }),
      GoRoute(
          path: '/home/restaurant/s/:restaurantId',
          builder: (context, state) {
            return BlocProvider(
              create: (context) => RestaurantBloc(
                RestaurantUseCase(
                  RestaurantRepoImpl(
                      apiClient:
                          ApiClient(baseUrl: "http://192.168.1.191:8080")),
                ),
              )..add(RestaurantGetById(id: state.extra as String)),
              child: RestaurantDetails(),
            );
          }),
      GoRoute(
          path: '/restaurant/tables',
          builder: (context, state) {
            print("EXTRA: ${state.extra}");
            // final restaurantId = state.extra as String;
            return BlocProvider<RestaurantTableBloc>(
              create: (context) => RestaurantTableBloc(
                RestaurantTablesUseCase(
                  RestaurantRepoImpl(
                    apiClient: ApiClient(baseUrl: "http://192.168.1.191:8080"),
                  ),
                ),
              ),
              child: RestaurantLayoutScreen(),
            );
          }),
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
