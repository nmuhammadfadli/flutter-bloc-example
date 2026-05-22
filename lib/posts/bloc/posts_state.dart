import 'package:equatable/equatable.dart';

import '../../../core/models/load_status.dart';
import '../data/post_model.dart';

class PostsState extends Equatable {
  final List<PostModel> items;
  final String searchQuery;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;
  final LoadStatus status;
  final String? message;

  const PostsState({
    required this.items,
    required this.searchQuery,
    required this.page,
    required this.hasMore,
    required this.isLoadingMore,
    required this.status,
    this.message,
  });

  const PostsState.initial()
      : items = const [],
        searchQuery = '',
        page = 1,
        hasMore = true,
        isLoadingMore = false,
        status = LoadStatus.initial,
        message = null;

  List<PostModel> get visibleItems {
    if (searchQuery.trim().isEmpty) return items;
    final q = searchQuery.toLowerCase();
    return items.where((e) => e.title.toLowerCase().contains(q) || e.body.toLowerCase().contains(q)).toList();
  }

  PostsState copyWith({
    List<PostModel>? items,
    String? searchQuery,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
    LoadStatus? status,
    String? message,
  }) {
    return PostsState(
      items: items ?? this.items,
      searchQuery: searchQuery ?? this.searchQuery,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      status: status ?? this.status,
      message: message,
    );
  }

  @override
  List<Object?> get props => [items, searchQuery, page, hasMore, isLoadingMore, status, message];
}
