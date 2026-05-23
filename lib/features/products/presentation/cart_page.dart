import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/load_status.dart';
import '../../../core/widgets/loading_list_view.dart';
import '../../../core/widgets/section_scaffold.dart';
import '../../../core/widgets/status_view.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
import '../data/cart_item_model.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  String _currency(double value) => '\$${value.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listenWhen: (previous, current) =>
          previous.message != current.message &&
          current.message != null &&
          current.status != LoadStatus.loading,
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context);
        messenger.clearSnackBars();
        messenger.showSnackBar(
          SnackBar(
            content: Text(state.message!),
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.read<CartBloc>().add(const CartMessageCleared());
      },
      child: SectionScaffold(
        title: 'Cart',
        subtitle: 'Data cart disimpan di SQLite',
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state.status == LoadStatus.loading && state.item.isEmpty) {
              return const LoadingListView(itemCount: 4);
            }

            if (state.status == LoadStatus.failure && state.item.isEmpty) {
              return StatusView(
                title: 'Cart gagal dimuat',
                text: state.message ?? 'Terjadi error ketika memuat cart.',
                icon: Icons.shopping_cart_outlined,
                onRetry: () => context.read<CartBloc>().add(const CartStarted()),
                actionLabel: 'Muat ulang',
              );
            }

            if (state.item.isEmpty) {
              return StatusView(
                title: 'Cart masih kosong',
                text: 'Tambahkan produk dari halaman Product List.',
                icon: Icons.shopping_cart_outlined,
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: state.item.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = state.item[index];
                      return _CartItemTile(item: item);
                    },
                  ),
                ),
                const SizedBox(height: 12),
                _SummaryCard(
                  subtotal: state.subtotal,
                  discount: state.discount,
                  total: state.total,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;

  const _CartItemTile({required this.item});

  String _currency(double value) => '\$${value.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 72,
                height: 72,
                color: Colors.black12,
                child: item.image.isEmpty
                    ? const Icon(Icons.image_not_supported_outlined)
                    : Image.network(
                        item.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported_outlined),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(item.category),
                  const SizedBox(height: 6),
                  Text(
                    _currency(item.lineTotal),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      IconButton(
                        tooltip: 'Kurangi',
                        onPressed: () => context.read<CartBloc>().add(CartQuantityDecremented(item.productId)),
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text('${item.quantity}'),
                      IconButton(
                        tooltip: 'Tambah',
                        onPressed: () => context.read<CartBloc>().add(CartQuantityIncremented(item.productId)),
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: 'Hapus',
                        onPressed: () => context.read<CartBloc>().add(CartItemRemoved(item.productId)),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final double subtotal;
  final double discount;
  final double total;

  const _SummaryCard({
    required this.subtotal,
    required this.discount,
    required this.total,
  });

  String _currency(double value) => '\$${value.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ringkasan',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 12),
            _RowLabelValue(label: 'Subtotal', value: _currency(subtotal)),
            const SizedBox(height: 6),
            _RowLabelValue(label: 'Discount', value: '- ${_currency(discount)}'),
            const SizedBox(height: 6),
            const Divider(),
            const SizedBox(height: 6),
            _RowLabelValue(
              label: 'Total',
              value: _currency(total),
              isBold: true,
            ),
            if (discount > 0) ...[
              const SizedBox(height: 8),
              Text(
                'Diskon 10% aktif karena subtotal > 200',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black54),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RowLabelValue extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _RowLabelValue({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
        );
    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        Text(value, style: style),
      ],
    );
  }
}
