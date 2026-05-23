import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_example/features/products/bloc/products_bloc.dart';
import 'package:flutter_bloc_example/features/products/bloc/products_event.dart';
import 'package:flutter_bloc_example/features/products/presentation/product_detail_page.dart';

import '../../../core/models/load_status.dart';
import '../../../core/widgets/loading_list_view.dart';
import '../../../core/widgets/section_scaffold.dart';
import '../../../core/widgets/status_view.dart';

import '../bloc/products_state.dart';
import '../data/product_model.dart';
import '../data/product_sort_order.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _openDetail(BuildContext context, ProductModel product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductDetailPage(product: product),
      ),
    );
  }

  String _sortLabel(ProductSortOrder value) {
    switch (value) {
      case ProductSortOrder.none:
        return 'Default';
      case ProductSortOrder.priceLowToHigh:
        return 'Price Low → High';
      case ProductSortOrder.priceHighToLow:
        return 'Price High → Low';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SectionScaffold(
      title: 'Product List',
      subtitle: 'Search, filter category, sort price, dan buka halaman detail produk.',
      child: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          final isInitialLoading = state.status == LoadStatus.loading && state.items.isEmpty;
          final isInitialError = state.status == LoadStatus.failure && state.items.isEmpty;
          final isEmptySearchResult = state.visibleItems.isEmpty && state.status == LoadStatus.success;

          if (isInitialLoading) {
            return const LoadingListView(itemCount: 5);
          }

          if (isInitialError) {
            return StatusView(
              title: 'Gagal memuat produk',
              text: state.message ?? 'Terjadi error ketika mengambil data produk.',
              icon: Icons.shopping_bag_outlined,
              onRetry: () => context.read<ProductsBloc>().add(const ProductsRefreshed()),
              actionLabel: 'Muat ulang',
            );
          }

          return Column(
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: 360,
                    child: TextField(
                      onChanged: (value) {
                        _debounce?.cancel();
                        _debounce = Timer(const Duration(milliseconds: 250), () {
                          if (!mounted) return;
                          context.read<ProductsBloc>().add(ProductsSearchChanged(value));
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Search product',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 220,
                    child: DropdownButtonFormField<String>(
                      value: state.selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                      ),
                      items: state.availableCategories
                          .map(
                            (category) => DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        context.read<ProductsBloc>().add(ProductsCategoryChanged(value));
                      },
                    ),
                  ),
                  SizedBox(
                    width: 220,
                    child: DropdownButtonFormField<ProductSortOrder>(
                      value: state.sortOrder,
                      decoration: const InputDecoration(
                        labelText: 'Sort Price',
                      ),
                      items: ProductSortOrder.values
                          .map(
                            (sortOrder) => DropdownMenuItem<ProductSortOrder>(
                              value: sortOrder,
                              child: Text(_sortLabel(sortOrder)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        context.read<ProductsBloc>().add(ProductsSortChanged(value));
                      },
                    ),
                  ),
                ],
              ),
              if (state.status == LoadStatus.loading && state.items.isNotEmpty) ...[
                const SizedBox(height: 12),
                const LinearProgressIndicator(minHeight: 2),
              ],
              const SizedBox(height: 12),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<ProductsBloc>().add(const ProductsRefreshed());
                    await Future<void>.delayed(const Duration(milliseconds: 250));
                  },
                  child: isEmptySearchResult
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            const SizedBox(height: 80),
                            StatusView(
                              title: 'Tidak ada hasil',
                              text: 'Coba kata kunci, kategori, atau sorting lain.',
                              icon: Icons.search_off_outlined,
                              onRetry: () => context.read<ProductsBloc>().add(const ProductsRefreshed()),
                              actionLabel: 'Refresh',
                            ),
                          ],
                        )
                      : ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: state.visibleItems.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final product = state.visibleItems[index];
                            return Card(
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: () => _openDetail(context, product),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Hero(
                                        tag: 'product_${product.id}',
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Container(
                                            width: 72,
                                            height: 72,
                                            color: Colors.black12,
                                            child: product.image.isEmpty
                                                ? const Icon(Icons.image_not_supported_outlined)
                                                : Image.network(
                                                    product.image,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported_outlined),
                                                  ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(product.category),
                                            const SizedBox(height: 6),
                                            Text(
                                              '\$${product.price.toStringAsFixed(2)}',
                                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(Icons.chevron_right),
                                    ],
                                  ),
                                ),
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
