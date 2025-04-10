
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// @immutable
//
// abstract class NavigationEvent {}
//
// class NavigateToHome extends NavigationEvent {}
// class NavigateToProfile extends NavigationEvent {}
// class NavigateToSettings extends NavigationEvent {}
//
// class NavigationBloc extends Bloc<NavigationEvent, RouteSettings> {
//   final Router router;
//  //!WARNING : CHECK KIMI AI 
//
//   NavigationBloc(this.router) : super(const RouteSettings(name: '/')) {
//     on<NavigateToHome>((event, emit) => emit(const RouteSettings(name: '/home')));
//     on<NavigateToProfile>((event, emit) => emit(const RouteSettings(name: '/profile')));
//     on<NavigateToSettings>((event, emit) => emit(const RouteSettings(name: '/settings')));
//   }
//
//   static final router = Router(
//     routes: <String, Page Function(RouteSettings settings)>{
//       '/': (_) => const MaterialPage(child: HomePage()),
//       '/home': (_) => const MaterialPage(child: HomePage()),
//       '/profile': (_) => const MaterialPage(child: ProfilePage()),
//       '/settings': (_) => const MaterialPage(child: SettingsPage()),
//     },
//   );
// }
