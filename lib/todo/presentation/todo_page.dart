import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/load_status.dart';
import '../../../core/widgets/section_scaffold.dart';
import '../../../core/widgets/status_view.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionScaffold(
      title: 'Todo CRUD Lokal',
      subtitle: 'Tambah, tandai selesai, hapus, dan search data lokal.',
      child: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          return Column(
            children: [
              TextField(
                onChanged: (value) => context.read<TodoBloc>().add(TodoSearchChanged(value)),
                decoration: const InputDecoration(labelText: 'Search todo'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) => context.read<TodoBloc>().add(TodoTitleChanged(value)),
                      decoration: InputDecoration(labelText: 'Todo baru', errorText: state.status == LoadStatus.failure ? state.message : null),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(onPressed: () => context.read<TodoBloc>().add(const TodoSubmitted()), child: const Text('Tambah')),
                ],
              ),
              const SizedBox(height: 12),
              if (state.status == LoadStatus.loading) const LinearProgressIndicator(),
              if (state.visibleItems.isEmpty)
                Expanded(child: StatusView(text: 'Belum ada data untuk ditampilkan.'))
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: state.visibleItems.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = state.visibleItems[index];
                      return Card(
                        child: ListTile(
                          leading: Checkbox(
                            value: item.isDone,
                            onChanged: (_) => context.read<TodoBloc>().add(TodoToggled(item.id)),
                          ),
                          title: Text(
                            item.title,
                            style: TextStyle(decoration: item.isDone ? TextDecoration.lineThrough : null),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => context.read<TodoBloc>().add(TodoDeleted(item.id)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
