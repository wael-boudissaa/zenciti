import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenciti/core/utils/api_client.dart';
import 'package:zenciti/features/activity/data/repositories/activite_type_repo.dart';
import 'package:zenciti/features/activity/domain/usecase/activity_popularity.dart';
import 'package:zenciti/features/activity/domain/usecase/ativity_type_use_case.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_populaire_dart.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_type_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      MultiBlocProvider(
        providers: [
          BlocProvider<ActivityTypeBloc>(
            create: (context) => ActivityTypeBloc(
              ActivityTypeUseCase(
                ActiviteTypeRepoImp(
                  apiClient: ApiClient(baseUrl: "http://192.168.1.191:8080"),
                ),
              ),
            ),
          ),
          BlocProvider<RestaurantBloc>(
            create: (context) => RestaurantBloc(
              RestaurantUseCase(
                RestaurantRepoImpl(
                    apiClient: ApiClient(baseUrl: "http://192.168.1.191:8080")),
              ),
            ),
          ),
        ],
        child: Home_Page(),
      ),
      const Center(child: Text('Browse')),
      const Center(child: Text('Radio')),
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
