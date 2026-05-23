import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/load_status.dart';
import '../../../core/widgets/loading_list_view.dart';
import '../../../core/widgets/section_scaffold.dart';
import '../../../core/widgets/status_view.dart';
import '../bloc/posts_bloc.dart';
import '../bloc/posts_event.dart';
import '../bloc/posts_state.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 240) {
      context.read<PostsBloc>().add(const PostsNextPageRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SectionScaffold(
      title: 'Fetch API + Lazy Loading',
      subtitle:
          'Ambil data dari API, cari, refresh, dan auto-load page berikutnya saat scroll.',
      child: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          final isEmptySearchResult =
              state.visibleItems.isEmpty && state.status == LoadStatus.success;
          final isInitialLoading =
              state.status == LoadStatus.loading && state.items.isEmpty;
          final isInitialError =
              state.status == LoadStatus.failure && state.items.isEmpty;

          if (isInitialLoading) {
            return const LoadingListView(itemCount: 5);
          }

          if (isInitialError) {
            return StatusView(
              title: 'Gagal memuat posts',
              text: state.message ?? 'Terjadi error ketika mengambil data.',
              icon: Icons.cloud_off_outlined,
              onRetry:
                  () => context.read<PostsBloc>().add(const PostsRefreshed()),
              actionLabel: 'Muat ulang',
            );
          }

          return Column(
            children: [
              TextField(
                onChanged: (value) {
                  _debounce?.cancel();
                  _debounce = Timer(const Duration(milliseconds: 200), () {
                    if (!mounted) return;
                    context.read<PostsBloc>().add(PostsSearchChanged(value));
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Search posts',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: RefreshIndicator(
                  onRefresh:
                      () async =>
                          context.read<PostsBloc>().add(const PostsRefreshed()),
                  child:
                      isEmptySearchResult
                          ? ListView(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              const SizedBox(height: 60),
                              StatusView(
                                title: 'Tidak ada hasil',
                                text: 'Coba kata kunci lain atau refresh data.',
                                icon: Icons.search_off_outlined,
                                onRetry:
                                    () => context.read<PostsBloc>().add(
                                      const PostsRefreshed(),
                                    ),
                                actionLabel: 'Refresh',
                              ),
                            ],
                          )
                          : ListView.separated(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: state.visibleItems.length + 1,
                            separatorBuilder:
                                (_, __) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              if (index == state.visibleItems.length) {
                                if (state.hasMore) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    child: Center(
                                      child:
                                          state.isLoadingMore
                                              ? const SizedBox(
                                                width: 22,
                                                height: 22,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                              )
                                              : OutlinedButton.icon(
                                                onPressed:
                                                    () => context
                                                        .read<PostsBloc>()
                                                        .add(
                                                          const PostsNextPageRequested(),
                                                        ),
                                                icon: const Icon(
                                                  Icons.expand_more,
                                                ),
                                                label: const Text('Load more'),
                                              ),
                                    ),
                                  );
                                }
                                return const SizedBox(height: 24);
                              }

                              final post = state.visibleItems[index];
                              return Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: Text('${post.id}'),
                                  ),
                                  title: Text(post.title),
                                  subtitle: Text(
                                    post.body,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              );
                            },
                          ),
                ),
              ),
              if (state.status == LoadStatus.failure && state.items.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: StatusView(
                    title: 'Ada masalah jaringan',
                    text: state.message ?? 'Data lama tetap ditampilkan.',
                    icon: Icons.wifi_off_outlined,
                    onRetry:
                        () => context.read<PostsBloc>().add(
                          const PostsRefreshed(),
                        ),
                    actionLabel: 'Coba refresh',
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
