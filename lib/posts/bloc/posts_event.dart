import 'package:equatable/equatable.dart';

sealed class PostsEvent extends Equatable {
  const PostsEvent();
  @override
  List<Object?> get props => [];
}

final class PostsStarted extends PostsEvent {
  const PostsStarted();
}

final class PostsRefreshed extends PostsEvent {
  const PostsRefreshed();
}

final class PostsNextPageRequested extends PostsEvent {
  const PostsNextPageRequested();
}

final class PostsSearchChanged extends PostsEvent {
  final String query;
  const PostsSearchChanged(this.query);
  @override
  List<Object?> get props => [query];
}
