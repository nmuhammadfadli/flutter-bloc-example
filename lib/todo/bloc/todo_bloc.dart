import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/load_status.dart';
import '../data/todo_model.dart';
import '../data/todo_repository.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository repository;

  TodoBloc(this.repository) : super(const TodoState.initial()) {
    on<TodoStarted>((event, emit) {
      emit(state.copyWith(status: LoadStatus.loading));
      emit(state.copyWith(items: repository.initialTodos(), status: LoadStatus.success));
    });

    on<TodoTitleChanged>((event, emit) => emit(state.copyWith(draftTitle: event.title, message: null)));

    on<TodoSubmitted>((event, emit) {
      final title = state.draftTitle.trim();
      if (title.isEmpty) {
        emit(state.copyWith(status: LoadStatus.failure, message: 'Judul todo tidak boleh kosong.'));
        return;
      }
      final item = TodoItem(id: DateTime.now().millisecondsSinceEpoch.toString(), title: title, isDone: false);
      emit(state.copyWith(items: [item, ...state.items], draftTitle: '', status: LoadStatus.success, message: 'Todo ditambahkan.'));
    });

    on<TodoToggled>((event, emit) {
      final next = state.items.map((e) => e.id == event.id ? e.copyWith(isDone: !e.isDone) : e).toList();
      emit(state.copyWith(items: next, status: LoadStatus.success, message: null));
    });

    on<TodoDeleted>((event, emit) {
      emit(state.copyWith(items: state.items.where((e) => e.id != event.id).toList(), status: LoadStatus.success, message: 'Todo dihapus.'));
    });

    on<TodoSearchChanged>((event, emit) => emit(state.copyWith(searchQuery: event.query)));
  }
}
