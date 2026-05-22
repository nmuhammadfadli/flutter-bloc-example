import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/load_status.dart';
import '../../../core/widgets/section_scaffold.dart';
import '../../../core/widgets/status_view.dart';
import '../../../core/widgets/loading_list_view.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionScaffold(
      title: 'Todo CRUD Lokal',
      subtitle: 'Tambah, tandai selesai, hapus, search, dan simpan data di SQLite.',
      child: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          final isSearching = state.searchQuery.trim().isNotEmpty;
          final isEmptyResult = state.visibleItems.isEmpty && state.status == LoadStatus.success;

          return Column(
            children: [
              TextField(
                onChanged: (value) => context.read<TodoBloc>().add(TodoSearchChanged(value)),
                decoration: const InputDecoration(
                  labelText: 'Search todo',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) => context.read<TodoBloc>().add(TodoTitleChanged(value)),
                      decoration: InputDecoration(
                        labelText: 'Todo baru',
                        helperText: 'Disimpan ke SQLite saat tombol tambah ditekan.',
                        errorText: state.status == LoadStatus.failure && (state.message?.contains('kosong') ?? false) ? state.message : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: state.status == LoadStatus.loading ? null : () => context.read<TodoBloc>().add(const TodoSubmitted()),
                    child: state.status == LoadStatus.loading
                        ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Tambah'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (state.status == LoadStatus.loading && state.items.isEmpty)
                const Expanded(child: LoadingListView(itemCount: 4))
              else if (state.status == LoadStatus.failure && state.items.isEmpty)
                Expanded(
                  child: StatusView(
                    title: 'Gagal memuat data',
                    text: state.message ?? 'Terjadi error.',
                    icon: Icons.cloud_off_outlined,
                    onRetry: () => context.read<TodoBloc>().add(const TodoStarted()),
                  ),
                )
              else if (isEmptyResult)
                Expanded(
                  child: StatusView(
                    title: isSearching ? 'Tidak ada hasil' : 'Belum ada data',
                    text: isSearching ? 'Coba kata kunci lain.' : 'Todo yang kamu buat akan muncul di sini.',
                    icon: isSearching ? Icons.search_off_outlined : Icons.inbox_outlined,
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: state.visibleItems.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = state.visibleItems[index];
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        child: Card(
                          child: ListTile(
                            leading: Checkbox(
                              value: item.isDone,
                              onChanged: (_) => context.read<TodoBloc>().add(TodoToggled(item.id)),
                            ),
                            title: Text(
                              item.title,
                              style: TextStyle(decoration: item.isDone ? TextDecoration.lineThrough : null),
                            ),
                            subtitle: Text(item.isDone ? 'Selesai' : 'Belum selesai'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => context.read<TodoBloc>().add(TodoDeleted(item.id)),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              if (state.message != null && state.status != LoadStatus.failure)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: StatusView(
                    title: state.status == LoadStatus.success ? 'Berhasil' : 'Info',
                    text: state.message!,
                    icon: state.status == LoadStatus.success ? Icons.verified_outlined : Icons.info_outline,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
