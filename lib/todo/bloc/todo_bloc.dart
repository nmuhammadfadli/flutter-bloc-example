import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/load_status.dart';
import '../data/todo_repository.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository repository;

  TodoBloc(this.repository) : super(const TodoState.initial()) {
    on<TodoStarted>(_onStarted);
    on<TodoTitleChanged>(_onTitleChanged);
    on<TodoSubmitted>(_onSubmitted);
    on<TodoToggled>(_onToggled);
    on<TodoDeleted>(_onDeleted);
    on<TodoSearchChanged>(_onSearchChanged);
  }

  Future<void> _onStarted(TodoStarted event, Emitter<TodoState> emit) async {
    emit(state.copyWith(status: LoadStatus.loading, message: null));
    try {
      final items = await repository.getTodos();
      emit(state.copyWith(items: items, status: LoadStatus.success, message: items.isEmpty ? 'Belum ada todo.' : 'Data dimuat dari SQLite.'));
    } catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, message: e.toString()));
    }
  }

  void _onTitleChanged(TodoTitleChanged event, Emitter<TodoState> emit) {
    emit(state.copyWith(draftTitle: event.title, status: LoadStatus.initial, message: null));
  }

  Future<void> _onSubmitted(TodoSubmitted event, Emitter<TodoState> emit) async {
    final title = state.draftTitle.trim();
    if (title.isEmpty) {
      emit(state.copyWith(status: LoadStatus.failure, message: 'Judul todo tidak boleh kosong.'));
      return;
    }

    emit(state.copyWith(status: LoadStatus.loading, message: null));
    try {
      final items = await repository.addTodo(title);
      emit(state.copyWith(items: items, draftTitle: '', status: LoadStatus.success, message: 'Todo ditambahkan dan disimpan di SQLite.'));
    } catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, message: e.toString()));
    }
  }

  Future<void> _onToggled(TodoToggled event, Emitter<TodoState> emit) async {
    try {
      final items = await repository.toggleTodo(event.id);
      emit(state.copyWith(items: items, status: LoadStatus.success, message: 'Status todo diperbarui.'));
    } catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, message: e.toString()));
    }
  }

  Future<void> _onDeleted(TodoDeleted event, Emitter<TodoState> emit) async {
    try {
      final items = await repository.deleteTodo(event.id);
      emit(state.copyWith(items: items, status: LoadStatus.success, message: 'Todo dihapus.'));
    } catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, message: e.toString()));
    }
  }

  void _onSearchChanged(TodoSearchChanged event, Emitter<TodoState> emit) {
    emit(state.copyWith(searchQuery: event.query));
  }
}
