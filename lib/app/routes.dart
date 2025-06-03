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
import 'package:zenciti/features/auth/data/repositories/auth_repositorie.dart';
import 'package:zenciti/features/auth/data/repositories/notification_repositorie.dart';
import 'package:zenciti/features/auth/domain/usecase/friend_request_use_case.dart';
import 'package:zenciti/features/auth/domain/usecase/register_use_case.dart';
import 'package:zenciti/features/auth/presentation/blocs/notification_bloc.dart';
import 'package:zenciti/features/auth/presentation/blocs/profile_information_bloc.dart';
import 'package:zenciti/features/auth/presentation/blocs/sign_up_event.dart';
import 'package:zenciti/features/auth/presentation/screens/login_screen.dart';
import 'package:zenciti/features/auth/presentation/screens/notification_page.dart';
import 'package:zenciti/features/auth/presentation/screens/profile_page.dart';
import 'package:zenciti/features/auth/presentation/screens/profile_page_username.dart';
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
import 'package:zenciti/features/restaurant/presentation/screens/orderPage.dart';
import 'package:zenciti/features/restaurant/presentation/screens/reservation_test.dart';
import 'package:zenciti/features/restaurant/presentation/screens/reservation_QrCode.dart';
import 'package:zenciti/features/restaurant/presentation/screens/restaurant_details.dart';
import 'package:zenciti/features/restaurant/presentation/screens/restaurant_details_test.dart';
import 'package:zenciti/features/restaurant/presentation/screens/restaurants.dart';
import 'package:zenciti/features/restaurant/presentation/screens/schema_restaurant.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../features/restaurant/domain/entities/tables.dart';

final FlutterSecureStorage storage = FlutterSecureStorage();

Future<String?> getToken() async => await storage.read(key: 'token');
Future<String?> getIdClient() async => await storage.read(key: 'idClient');

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      // For GoRouter v6+, use state.uri.toString() or state.fullPath
      final String location = state.fullPath ?? state.uri.toString();
      final token = await getToken();

      // If on login page and already authenticated, redirect to home
      if (location == '/' && token != null && token.isNotEmpty) {
        return '/home';
      }
      // If not authenticated and trying to access a protected route, redirect to login
      if (location != '/' && (token == null || token.isEmpty)) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/profile/:username',
        builder: (context, state) {
          final username = state.pathParameters['username']!;
          return MultiBlocProvider(
            providers: [
              BlocProvider<ProfileInformationBloc>(
                create: (context) => ProfileInformationBloc(
                  RegisterUseCase(
                    AuthRepositoryImpl(
                      apiClient: ApiClient(baseUrl: "http://192.168.1.41:8080"),
                    ),
                  ),
                )..add(GetUsernameData(username)),
              ),
              BlocProvider<NotificationBloc>(
                create: (context) => NotificationBloc(
                  FriendRequestUseCase(
                    NotificationRepoImpl(
                      apiClient: ApiClient(baseUrl: "http://192.168.1.41:8080"),
                    ),
                  ),
                ),
              ),
            ],
            child: ProfilePageUsername(username: username),
          );
        },
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => HomePage(),
      ),
      GoRoute(
        path: '/reservation/qr',
        builder: (context, state) {
          final String idReservation = state.extra as String;
          return ReservationQrCode(idReservation: idReservation);
        },
      ),
      GoRoute(
          path: '/notification',
          builder: (context, state) {
            // if (extra is! Map<String, dynamic>) {
            //   return Text('Invalid arguments passed to the Order page');
            // }
            //
            // final String idRestaurant = extra['idRestaurant'] as String;
            // final String idReservation = extra['reservationId'] as String;
            //
            // if (idRestaurant == null || idReservation == null) {
            //   return Text('Invalid arguments passed to the Order page');
            // }

            return FutureBuilder<String?>(
              future: getIdClient(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text('No client ID found'));
                }

                final idClient = snapshot.data!;

                return BlocProvider(
                  create: (context) => NotificationBloc(
                    FriendRequestUseCase(
                      NotificationRepoImpl(
                        apiClient:
                            ApiClient(baseUrl: "http://192.168.1.41:8080"),
                      ),
                    ),
                  )..add(NotificationGet(idClient)),
                  child: NotificationPage(idClient: idClient),
                );
              },
            );
          }),
      GoRoute(
        path: '/order',
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! Map<String, dynamic>) {
            return Text('Invalid arguments passed to the Order page');
          }

          final String idRestaurant = extra['idRestaurant'] as String;
          final String idReservation = extra['reservationId'] as String;

          if (idRestaurant == null || idReservation == null) {
            return Text('Invalid arguments passed to the Order page');
          }

          return BlocProvider(
            create: (context) => RestaurantBloc(
              RestaurantUseCase(
                RestaurantRepoImpl(
                  apiClient: ApiClient(baseUrl: "http://192.168.1.41:8080"),
                ),
              ),
            )..add(MenuGetFood(idRestaurant: idRestaurant)),
            child: OrderPage(idReservation: idReservation),
          );
        },
      ),
      GoRoute(
        path: '/restaurant',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => RestaurantBloc(
              RestaurantUseCase(
                RestaurantRepoImpl(
                  apiClient: ApiClient(baseUrl: "http://192.168.1.41:8080"),
                ),
              ),
            ),
            child: Restaurants(),
          );
        },
      ),
      GoRoute(
        path: '/reservation',
        builder: (context, state) {
          final Restaurant restaurant = state.extra as Restaurant;
          // Use FutureBuilder to get idClient from secure storage
          return FutureBuilder<String?>(
            future: getIdClient(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final idClient = snapshot.data!;
              return BlocProvider(
                create: (context) => RestaurantBloc(
                  RestaurantUseCase(
                    RestaurantRepoImpl(
                      apiClient: ApiClient(baseUrl: "http://192.168.1.41:8080"),
                    ),
                  ),
                ),
                child: ReservationPage(
                  restaurant: restaurant,
                  idClient: idClient,
                ),
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/restaurant/menu',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => RestaurantBloc(
              RestaurantUseCase(
                RestaurantRepoImpl(
                  apiClient: ApiClient(baseUrl: "http://192.168.1.41:8080"),
                ),
              ),
            )..add(MenuGetFood(idRestaurant: state.extra as String)),
            child: MenuPage(),
          );
        },
      ),
      GoRoute(
        path: '/home/restaurant/s/:restaurantId',
        builder: (context, state) {
          return BlocProvider(
            create: (context) => RestaurantBloc(
              RestaurantUseCase(
                RestaurantRepoImpl(
                  apiClient: ApiClient(baseUrl: "http://192.168.1.41:8080"),
                ),
              ),
            )..add(RestaurantGetById(id: state.extra as String)),
            child: RestaurantDetailsPage(),
          );
        },
      ),
      GoRoute(
        path: '/restaurant/tables',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          final String idRestaurant = args['idRestaurant'];
          final DateTime timeSlot = DateTime.parse(args['timeSlot']);

          return BlocProvider<RestaurantTableBloc>(
            create: (context) => RestaurantTableBloc(
              RestaurantTablesUseCase(
                RestaurantRepoImpl(
                  apiClient: ApiClient(baseUrl: "http://192.168.1.41:8080"),
                ),
              ),
            )..add(RestaurantTableGetAll(
                idRestaurant: idRestaurant, timeSlot: timeSlot)),
            child: RestaurantLayoutScreen(),
          );
        },
      ),
      GoRoute(
        path: '/home/type/:activityTypeId',
        builder: (context, state) {
          final activity = state.extra as TypeActivity;
          return BlocProvider<ActivityBloc>(
            create: (context) => ActivityBloc(
              ActivityUseCase(
                ActiviteTypeRepoImp(
                  apiClient: ApiClient(baseUrl: "http://192.168.1.41:8080"),
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
                  apiClient: ApiClient(baseUrl: "http://192.168.1.41:8080"),
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
