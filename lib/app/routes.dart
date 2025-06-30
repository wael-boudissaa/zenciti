import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
import 'package:zenciti/features/activity/presentation/screens/activity_history.dart';
import 'package:zenciti/features/activity/presentation/screens/activity_res.dart';
import 'package:zenciti/features/activity/presentation/screens/activity_reservation.dart';
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
import 'package:zenciti/features/auth/presentation/screens/profile_page_username.dart';
import 'package:zenciti/features/home/presentation/screens/home_screen.dart';
import 'package:zenciti/features/restaurant/data/repositories/restaurant_repo.dart';
import 'package:zenciti/features/restaurant/domain/usecase/restaurant_table_use_case.dart';
import 'package:zenciti/features/restaurant/domain/usecase/restaurant_use_case.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_bloc.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_event.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_table_bloc.dart';
import 'package:zenciti/features/restaurant/presentation/screens/menu.dart';
import 'package:zenciti/features/restaurant/presentation/screens/orderPage.dart';
import 'package:zenciti/features/restaurant/presentation/screens/reservation_information.dart';
import 'package:zenciti/features/restaurant/presentation/screens/reservation_test.dart';
import 'package:zenciti/features/restaurant/presentation/screens/reservation_QrCode.dart';
import 'package:zenciti/features/restaurant/presentation/screens/restaurant_details_test.dart';
import 'package:zenciti/features/restaurant/presentation/screens/restaurants.dart';
import 'package:zenciti/features/restaurant/presentation/screens/schema_restaurant.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../features/restaurant/domain/entities/tables.dart';

// Secure storage helpers
final FlutterSecureStorage storage = FlutterSecureStorage();

Future<String?> getToken() async => await storage.read(key: 'token');
Future<String?> getIdClient() async => await storage.read(key: 'idClient');

class AppRouter {
  static final String? apiUrl = dotenv.env['API_URL'];

  static ApiClient buildApiClient() {
    return ApiClient(baseUrl: apiUrl ?? "");
  }

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (ontext, state) async {
      final String location = state.fullPath ?? state.uri.toString();
      final token = await getToken();

      if (location == '/' && token != null && token.isNotEmpty) {
        return '/home';
      }
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
                      apiClient: buildApiClient(),
                    ),
                  ),
                )..add(GetUsernameData(username)),
              ),
              BlocProvider<NotificationBloc>(
                create: (context) => NotificationBloc(
                  FriendRequestUseCase(
                    NotificationRepoImpl(
                      apiClient: buildApiClient(),
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
      // GoRoute(
      //   path: '/reservaiton-information',
      //   builder: (context, state) => ReservationInformationPage(),
      // ),
      GoRoute(
        path: '/activity-history',
        builder: (context, state) {
          return FutureBuilder<String?>(
            future: getIdClient(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final idClient = snapshot.data!;
              final apiClient =
                  buildApiClient(); // avoid calling it multiple times

              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                      create: (context) => RestaurantBloc(
                            RestaurantUseCase(
                              RestaurantRepoImpl(apiClient: apiClient),
                            ),
                          )),
                  BlocProvider(
                    create: (context) => ActivityBloc(
                      ActivityUseCase(
                        ActiviteTypeRepoImp(apiClient: apiClient),
                      ),
                    ),
                  ),
                ],
                child: ActivityHistoryPage(idClient: idClient),
              );
            },
          );
        },
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
                        apiClient: buildApiClient(),
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
                  apiClient: buildApiClient(),
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
                  apiClient: buildApiClient(),
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
                      apiClient: buildApiClient(),
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
                  apiClient: buildApiClient(),
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
          final String restaurantId = state.extra as String;

          return FutureBuilder<String?>(
            future: getIdClient(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final idClient = snapshot.data!;
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => RestaurantBloc(
                      RestaurantUseCase(
                        RestaurantRepoImpl(
                          apiClient: buildApiClient(),
                        ),
                      ),
                    )..add(RestaurantGetById(id: restaurantId)),
                  ),
                  BlocProvider(
                    create: (context) {
                      final bloc = ReviewsBloc(
                        RestaurantUseCase(
                          RestaurantRepoImpl(
                            apiClient: buildApiClient(),
                          ),
                        ),
                      );
                      bloc.add(GetFriendsReviews(
                        idRestaurant: restaurantId,
                        idClient: idClient,
                      ));
                      return bloc;
                    },
                  ),
                ],
                child: RestaurantDetailsPage(),
              );
            },
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
                  apiClient: buildApiClient(),
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
                  apiClient: buildApiClient(),
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
          final String activityId = state.pathParameters['activityId']!;
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

              return BlocProvider<ActivitySingleBloc>(
                create: (context) => ActivitySingleBloc(
                  ActivitySingleUseCase(
                    ActiviteTypeRepoImp(
                      apiClient: buildApiClient(),
                    ),
                  ),
                )..add(GetActivityById(activityId)),
                child: ActivityDetailsPage(),
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/activity/reservation',
        builder: (context, state) {
          final result = state.extra as Map<String, dynamic>;
          final String activityId = result['activityId'] as String;
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

              return BlocProvider<ActivityBloc>(
                create: (context) => ActivityBloc(
                  ActivityUseCase(
                    ActiviteTypeRepoImp(
                      apiClient: buildApiClient(),
                    ),
                  ),
                ),
                child: CourtReservationPage(
                  activityId: activityId,
                  clientId: idClient,
                ),
              );
            },
          );
        },
      ),
    ],
  );
}
