import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/load_status.dart';
import '../data/post_repository.dart';
import 'posts_event.dart';
import 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostRepository repository;
  static const int _limit = 10;

  PostsBloc(this.repository) : super(const PostsState.initial()) {
    on<PostsStarted>(_onStarted);
    on<PostsRefreshed>(_onRefreshed);
    on<PostsNextPageRequested>(_onNextPageRequested);
    on<PostsSearchChanged>(_onSearchChanged);
  }

  Future<void> _onStarted(PostsStarted event, Emitter<PostsState> emit) async {
    await _loadFirstPage(emit);
  }

  Future<void> _onRefreshed(PostsRefreshed event, Emitter<PostsState> emit) async {
    await _loadFirstPage(emit);
  }

  Future<void> _onNextPageRequested(PostsNextPageRequested event, Emitter<PostsState> emit) async {
    if (!state.hasMore || state.status == LoadStatus.loading || state.isLoadingMore) return;

    emit(state.copyWith(status: LoadStatus.loading, isLoadingMore: true, message: null));
    try {
      final nextPage = state.page + 1;
      final nextItems = await repository.fetchPosts(page: nextPage, limit: _limit);
      emit(state.copyWith(
        items: [...state.items, ...nextItems],
        page: nextPage,
        hasMore: nextItems.length == _limit,
        isLoadingMore: false,
        status: LoadStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, isLoadingMore: false, message: e.toString()));
    }
  }

  void _onSearchChanged(PostsSearchChanged event, Emitter<PostsState> emit) {
    emit(state.copyWith(searchQuery: event.query));
  }

  Future<void> _loadFirstPage(Emitter<PostsState> emit) async {
    emit(state.copyWith(status: LoadStatus.loading, message: null, page: 1, hasMore: true, isLoadingMore: false, items: []));
    try {
      final items = await repository.fetchPosts(page: 1, limit: _limit);
      emit(state.copyWith(
        items: items,
        status: LoadStatus.success,
        hasMore: items.length == _limit,
        isLoadingMore: false,
      ));
    } catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, isLoadingMore: false, message: e.toString()));
    }
  }
}
