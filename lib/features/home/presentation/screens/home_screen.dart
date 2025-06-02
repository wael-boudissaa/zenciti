import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zenciti/core/utils/api_client.dart';
import 'package:zenciti/features/activity/data/repositories/activite_type_repo.dart';
import 'package:zenciti/features/activity/domain/usecase/activity_popularity.dart';
import 'package:zenciti/features/activity/domain/usecase/ativity_type_use_case.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_populaire_dart.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_type_bloc.dart';
import 'package:zenciti/features/auth/data/repositories/auth_repositorie.dart';
import 'package:zenciti/features/auth/domain/usecase/register_use_case.dart';
import 'package:zenciti/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:zenciti/features/auth/presentation/blocs/profile_information_bloc.dart';
import 'package:zenciti/features/auth/presentation/blocs/sign_up_event.dart';
import 'package:zenciti/features/auth/presentation/screens/profile_page.dart';
import 'package:zenciti/features/home/presentation/screens/home_page.dart';
import 'package:zenciti/features/home/presentation/widgets/appbar.dart';
import 'package:zenciti/features/home/presentation/widgets/navigation_bar.dart';
import 'package:zenciti/features/restaurant/data/repositories/restaurant_repo.dart';
import 'package:zenciti/features/restaurant/domain/usecase/restaurant_use_case.dart';
import 'package:zenciti/features/restaurant/presentation/blocs/restaurant_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<String?> getIdClient() async => await storage.read(key: 'idClient');

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      MultiBlocProvider(
        providers: [
          BlocProvider<ActivityTypeBloc>(
            create: (context) => ActivityTypeBloc(
              ActivityTypeUseCase(
                ActiviteTypeRepoImp(
                  apiClient: ApiClient(baseUrl: "http://192.168.1.41:8080"),
                ),
              ),
            ),
          ),
          BlocProvider<RestaurantBloc>(
            create: (context) => RestaurantBloc(
              RestaurantUseCase(
                RestaurantRepoImpl(
                    apiClient: ApiClient(baseUrl: "http://192.168.1.41:8080")),
              ),
            ),
          ),
        ],
        child: Home_Page(),
      ),
      const Center(child: Text('Browse')),
      // Use FutureBuilder to fetch idClient for ProfilePage
      FutureBuilder<String?>(
        future: getIdClient(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          // Pass idClient to ProfilePage
          final idClient = snapshot.data!;
          return BlocProvider<ProfileInformationBloc>(
            create: (context) => ProfileInformationBloc(
              RegisterUseCase(
                AuthRepositoryImpl(
                    apiClient: ApiClient(baseUrl: "http://192.168.1.41:8080")),
              ),
            )..add(GetProfileData(idClient)),
            child: ProfilePage(idClient: idClient),
          );
        },
      ),
      const Center(child: Text('Library')),
      const Center(child: Text('Search')),
    ];

    return Scaffold(
      appBar: AppBarHome(),
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBarW(
        index: _currentIndex,
        onChange: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

