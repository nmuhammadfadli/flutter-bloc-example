import 'package:equatable/equatable.dart';

class TodoItem extends Equatable {
  final String id;
  final String title;
  final bool isDone;

  const TodoItem({required this.id, required this.title, required this.isDone});

  TodoItem copyWith({String? id, String? title, bool? isDone}) {
    return TodoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }

  @override
  List<Object?> get props => [id, title, isDone];
}
