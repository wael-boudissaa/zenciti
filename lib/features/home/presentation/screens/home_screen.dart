import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zenciti/core/utils/api_client.dart';
import 'package:zenciti/features/activity/data/repositories/activite_type_repo.dart';
import 'package:zenciti/features/activity/domain/repositories/activity_repo.dart';
import 'package:zenciti/features/activity/domain/usecase/activity_popularity.dart';
import 'package:zenciti/features/activity/domain/usecase/ativity_type_use_case.dart';
import 'package:zenciti/features/activity/domain/usecase/ativity_use_case.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_bloc.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_event.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_populaire_dart.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_type_bloc.dart';
import 'package:zenciti/features/auth/data/repositories/auth_repositorie.dart';
import 'package:zenciti/features/auth/domain/usecase/register_use_case.dart';
import 'package:zenciti/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:zenciti/features/auth/presentation/blocs/profile_information_bloc.dart';
import 'package:zenciti/features/auth/presentation/blocs/sign_up_event.dart';
import 'package:zenciti/features/auth/presentation/screens/profile_page.dart';
import 'package:zenciti/features/home/presentation/screens/home_page.dart';
import 'package:zenciti/features/home/presentation/screens/qr_code_scanner.dart';
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
  static final String? apiUrl = dotenv.env['API_URL'];
  bool? isAdmin; // null at first

  @override
  void initState() {
    super.initState();
    fetchIsAdmin();
  }

  Future<void> fetchIsAdmin() async {
    final value = await storage.read(key: 'isAdmin');
    setState(() {
      isAdmin = value == 'true' || value == '1';
    });
  }

  Future<String?> getIdClient() async => await storage.read(key: 'idClient');

  static ApiClient buildApiClient() {
    return ApiClient(baseUrl: apiUrl ?? "");
  }

  @override
  Widget build(BuildContext context) {
    // Wait until isAdmin is loaded
    if (isAdmin == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Build navigation and pages based on isAdmin
    final List<Widget> pages = [
      MultiBlocProvider(
        providers: [
          BlocProvider<ActivityTypeBloc>(
            create: (context) => ActivityTypeBloc(
              ActivityTypeUseCase(
                ActiviteTypeRepoImp(apiClient: buildApiClient()),
              ),
            ),
          ),
          BlocProvider<RestaurantBloc>(
            create: (context) => RestaurantBloc(
              RestaurantUseCase(
                RestaurantRepoImpl(apiClient: buildApiClient()),
              ),
            ),
          )
        ],
        child: Home_Page(),
      ),
      const Center(
        child: Text(
          'Statistics',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      const Center(
        child: Text(
          'Analytics',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      if (isAdmin!)
        BlocProvider<ActivityBloc>(
          create: (context) => ActivityBloc(
            ActivityUseCase(
              ActiviteTypeRepoImp(apiClient: buildApiClient()),
            ),
          ),
          child: QrScannerScreen(),
        ),
      FutureBuilder<String?>(
        future: getIdClient(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final idClient = snapshot.data!;
          return MultiBlocProvider(
            providers: [
              BlocProvider<ProfileInformationBloc>(
                create: (context) => ProfileInformationBloc(
                  RegisterUseCase(
                    AuthRepositoryImpl(apiClient: buildApiClient()),
                  ),
                )..add(GetProfileData(idClient)),
              ),
              BlocProvider<ActivityBloc>(
                create: (context) => ActivityBloc(
                  ActivityUseCase(
                    ActiviteTypeRepoImp(apiClient: buildApiClient()),
                  ),
                )..add(ActivityRecentGet(idClient)),
              ),
            ],
            child: ProfilePage(idClient: idClient),
          );
        },
      ),
    ];

    // For NavigationBarW: index and onChange must be mapped since the number of items changes
    int pagesCount = pages.length;
    int actualIndex = _currentIndex;
    if (!isAdmin! && _currentIndex == 1) {
      actualIndex =
          pagesCount - 1; // fallback to Profile if admin nav was removed
    }

    return Scaffold(
      appBar: AppBarHome(),
      body: pages[actualIndex],
      bottomNavigationBar: NavigationBarW(
        index: actualIndex,
        isAdmin: isAdmin!,
        onChange: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
