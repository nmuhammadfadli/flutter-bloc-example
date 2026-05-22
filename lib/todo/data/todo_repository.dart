import 'todo_model.dart';

class TodoRepository {
  final List<TodoItem> _seed = const [
    TodoItem(id: '1', title: 'Belajar Bloc dasar', isDone: false),
    TodoItem(id: '2', title: 'Latihan fetch API', isDone: true),
  ];

  List<TodoItem> initialTodos() => List<TodoItem>.from(_seed);
}
