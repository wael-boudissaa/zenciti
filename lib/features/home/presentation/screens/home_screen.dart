import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenciti/core/utils/api_client.dart';
import 'package:zenciti/features/home/data/repositories/activite_type_repo.dart';
import 'package:zenciti/features/home/domain/repositories/activity_repo.dart';
import 'package:zenciti/features/home/domain/usecase/ativity_use_case.dart'
    show ActivityUseCase;
import 'package:zenciti/features/home/presentation/blocs/activity_bloc.dart';
import 'package:zenciti/features/home/presentation/blocs/activity_event.dart';
import 'package:zenciti/features/home/presentation/screens/home_page.dart';
import 'package:zenciti/features/home/presentation/widgets/navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      BlocProvider<ActivityBloc>(
        create: (context) => ActivityBloc(
          ActivityUseCase(
            ActiviteTypeRepoImp(
              apiClient: ApiClient(baseUrl: "http://192.168.1.191:8080"),
            ),
          ),
        )..add(ActivityGet(id: "1")),
        child: Home_Page(), // your real home scree
      ),
      const Center(child: Text('Browse')),
      const Center(child: Text('Radio')),
      const Center(child: Text('Library')),
      const Center(child: Text('Search')),
    ];

    return Scaffold(
      body: _pages[_currentIndex],
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
