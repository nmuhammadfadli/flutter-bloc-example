import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_example/core/models/load_status.dart';
import 'package:flutter_bloc_example/core/widgets/section_scaffold.dart';
import 'package:flutter_bloc_example/core/widgets/status_view.dart';


import '../bloc/posts_bloc.dart';
import '../bloc/posts_event.dart';
import '../bloc/posts_state.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionScaffold(
      title: 'Fetch API + Pagination',
      subtitle: 'Ambil data dari API, cari, dan load page berikutnya.',
      child: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          if (state.status == LoadStatus.loading && state.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == LoadStatus.failure && state.items.isEmpty) {
            return StatusView(text: state.message ?? 'Terjadi error.', onRetry: () => context.read<PostsBloc>().add(const PostsRefreshed()));
          }
          return Column(
            children: [
              TextField(
                onChanged: (value) => context.read<PostsBloc>().add(PostsSearchChanged(value)),
                decoration: const InputDecoration(labelText: 'Search posts'),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => context.read<PostsBloc>().add(const PostsRefreshed()),
                  child: ListView.separated(
                    itemCount: state.visibleItems.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      if (index == state.visibleItems.length) {
                        if (state.hasMore) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                              child: OutlinedButton(
                                onPressed: () => context.read<PostsBloc>().add(const PostsNextPageRequested()),
                                child: state.status == LoadStatus.loading ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Load more'),
                              ),
                            ),
                          );
                        }
                        return const SizedBox(height: 24);
                      }
                      final post = state.visibleItems[index];
                      return Card(
                        child: ListTile(
                          title: Text(post.title),
                          subtitle: Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
