import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/tasks/presentation/screens/task_screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const TaskScreen(),
    ),
  ],
);
