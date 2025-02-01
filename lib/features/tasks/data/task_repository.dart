class TaskRepository {
  final List<String> _tasks = ['Task 1', 'Task 2', 'Task 3'];

  List<String> getTasks() {
    return _tasks;
  }

  void addTask(String task) {
    _tasks.add(task);
  }
}
