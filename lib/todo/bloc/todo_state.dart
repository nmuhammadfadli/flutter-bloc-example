import 'package:equatable/equatable.dart';

import '../../../core/models/load_status.dart';
import '../data/todo_model.dart';

class TodoState extends Equatable {
  final List<TodoItem> items;
  final String draftTitle;
  final String searchQuery;
  final LoadStatus status;
  final String? message;

  const TodoState({
    required this.items,
    required this.draftTitle,
    required this.searchQuery,
    required this.status,
    this.message,
  });

  const TodoState.initial()
      : items = const [],
        draftTitle = '',
        searchQuery = '',
        status = LoadStatus.initial,
        message = null;

  List<TodoItem> get visibleItems {
    if (searchQuery.trim().isEmpty) return items;
    final q = searchQuery.toLowerCase();
    return items.where((e) => e.title.toLowerCase().contains(q)).toList();
  }

  TodoState copyWith({
    List<TodoItem>? items,
    String? draftTitle,
    String? searchQuery,
    LoadStatus? status,
    String? message,
  }) {
    return TodoState(
      items: items ?? this.items,
      draftTitle: draftTitle ?? this.draftTitle,
      searchQuery: searchQuery ?? this.searchQuery,
      status: status ?? this.status,
      message: message,
    );
  }

  @override
  List<Object?> get props => [items, draftTitle, searchQuery, status, message];
}
