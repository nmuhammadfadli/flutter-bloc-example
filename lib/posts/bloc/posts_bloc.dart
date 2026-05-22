import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_example/core/models/load_status.dart';

import '../data/post_repository.dart';
import 'posts_event.dart';
import 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostRepository repository;
  static const int _limit = 10;

  PostsBloc(this.repository) : super(const PostsState.initial()) {
    on<PostsStarted>((event, emit) => _loadFirstPage(emit));
    on<PostsRefreshed>((event, emit) => _loadFirstPage(emit));
    on<PostsNextPageRequested>((event, emit) async {
      if (!state.hasMore || state.status == LoadStatus.loading) return;
      emit(state.copyWith(status: LoadStatus.loading, message: null));
      try {
        final nextPage = state.page + 1;
        final nextItems = await repository.fetchPosts(page: nextPage, limit: _limit);
        emit(state.copyWith(
          items: [...state.items, ...nextItems],
          page: nextPage,
          hasMore: nextItems.length == _limit,
          status: LoadStatus.success,
        ));
      } catch (e) {
        emit(state.copyWith(status: LoadStatus.failure, message: e.toString()));
      }
    });
    on<PostsSearchChanged>((event, emit) => emit(state.copyWith(searchQuery: event.query)));
  }

  Future<void> _loadFirstPage(Emitter<PostsState> emit) async {
    emit(state.copyWith(status: LoadStatus.loading, message: null, page: 1, hasMore: true, items: []));
    try {
      final items = await repository.fetchPosts(page: 1, limit: _limit);
      emit(state.copyWith(items: items, status: LoadStatus.success, hasMore: items.length == _limit));
    } catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, message: e.toString()));
    }
  }
}
