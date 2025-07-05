import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zenciti/app/routes.dart';
import 'package:zenciti/core/utils/api_client.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart'; // Add this import

// Auth feature
import 'package:zenciti/features/auth/data/repositories/auth_repositorie.dart';
import 'package:zenciti/features/auth/domain/usecase/login_use_case.dart';
import 'package:zenciti/features/auth/domain/usecase/register_use_case.dart';
import 'package:zenciti/features/auth/presentation/blocs/auth_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enable hybrid composition for Google Maps rendering fix
  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }

  try {
    await dotenv.load(fileName: "assets/.env");
  } catch (e) {
    print("Failed to load .env file: $e");


  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String? apiUrl =
      dotenv.env['API_URL'] ?? "https://localhost:8000";

  const MyApp({super.key});

  static ApiClient buildApiClient() {
    return ApiClient(baseUrl: apiUrl ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepositoryImpl>(
          create: (context) => AuthRepositoryImpl(
            apiClient: buildApiClient(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LoginBloc(
              LoginUseCase(
                context.read<AuthRepositoryImpl>(),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => SignUpBloc(
              RegisterUseCase(
                context.read<AuthRepositoryImpl>(),
              ),
            ),
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router, // Here
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
            fontFamily: 'Kadwa',
          ),
          // home: LoginScreen(),
        ),
      ),
    );
  }
}
