
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Example provider
final exampleProvider = Provider<String>((ref) => "Hello, Riverpod!");

class TaskScreen extends ConsumerWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = ref.watch(exampleProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: Center(
        child: Text(message),
      ),
    );
  }
}
