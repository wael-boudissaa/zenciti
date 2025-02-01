
import '../../data/repositories/task_repository.dart';
import '../../data/models/task_model.dart';

class ManageTasks {
  final TaskRepository repository;

  ManageTasks(this.repository);

  List<TaskModel> getTasks() => repository.getTasks();

  void addTask(String title) {
    repository.addTask(TaskModel(id: DateTime.now().toString(), title: title));
  }

  void removeTask(String id) {
    repository.removeTask(id);
  }
}
