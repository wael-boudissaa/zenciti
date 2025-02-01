import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/task_repository.dart';

// TaskListNotifier
class TaskListNotifier extends StateNotifier<List<String>> {
  final TaskRepository taskRepository;

  TaskListNotifier(this.taskRepository) : super(taskRepository.getTasks());

  void addTask(String task) {
    taskRepository.addTask(task);
    state = [...taskRepository.getTasks()];
  }
}

// Providers
final taskRepositoryProvider = Provider((ref) => TaskRepository());
final taskListProvider = StateNotifierProvider<TaskListNotifier, List<String>>(
  (ref) => TaskListNotifier(ref.read(taskRepositoryProvider)),
);
