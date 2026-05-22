import 'package:equatable/equatable.dart';

sealed class TodoEvent extends Equatable {
  const TodoEvent();
  @override
  List<Object?> get props => [];
}

final class TodoStarted extends TodoEvent {
  const TodoStarted();
}

final class TodoTitleChanged extends TodoEvent {
  final String title;
  const TodoTitleChanged(this.title);
  @override
  List<Object?> get props => [title];
}

final class TodoSubmitted extends TodoEvent {
  const TodoSubmitted();
}

final class TodoToggled extends TodoEvent {
  final String id;
  const TodoToggled(this.id);
  @override
  List<Object?> get props => [id];
}

final class TodoDeleted extends TodoEvent {
  final String id;
  const TodoDeleted(this.id);
  @override
  List<Object?> get props => [id];
}

final class TodoSearchChanged extends TodoEvent {
  final String query;
  const TodoSearchChanged(this.query);
  @override
  List<Object?> get props => [query];
}
