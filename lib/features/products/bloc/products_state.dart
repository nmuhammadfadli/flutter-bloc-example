import 'package:equatable/equatable.dart';

import '../../../core/models/load_status.dart';
import '../data/product_model.dart';
import '../data/product_sort_order.dart';

class ProductsState extends Equatable {
  final List<ProductModel> items;
  final String searchQuery;
  final String selectedCategory;
  final ProductSortOrder sortOrder;
  final LoadStatus status;
  final String? message;

  const ProductsState({
    required this.items,
    required this.searchQuery,
    required this.selectedCategory,
    required this.sortOrder,
    required this.status,
    this.message,
  });

  const ProductsState.initial()
      : items = const [],
        searchQuery = '',
        selectedCategory = 'All',
        sortOrder = ProductSortOrder.none,
        status = LoadStatus.initial,
        message = null;

  List<String> get availableCategories {
    final categories = items
        .map((e) => e.category!.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
    return ['All', ...categories];
  }

  List<ProductModel> get visibleItems {
    Iterable<ProductModel> result = items;

    final query = searchQuery.trim().toLowerCase();
    if (query.isNotEmpty) {
      result = result.where((item) =>
          item.title!.toLowerCase().contains(query));
    }

    if (selectedCategory != 'All') {
      result = result.where((item) => item.category == selectedCategory);
    }

    final list = result.toList();
    switch (sortOrder) {
      case ProductSortOrder.priceLowToHigh:
        list.sort((a, b) => a.price!.compareTo(b.price as num));
        break;
      case ProductSortOrder.priceHighToLow:
        list.sort((a, b) => b.price!.compareTo(a.price as num));
        break;
      case ProductSortOrder.none:
        break;
    }

    return list;
  }

  ProductsState copyWith({
    List<ProductModel>? items,
    String? searchQuery,
    String? selectedCategory,
    ProductSortOrder? sortOrder,
    LoadStatus? status,
    String? message,
  }) {
    return ProductsState(
      items: items ?? this.items,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      sortOrder: sortOrder ?? this.sortOrder,
      status: status ?? this.status,
      message: message,
    );
  }

  @override
  List<Object?> get props => [
        items,
        searchQuery,
        selectedCategory,
        sortOrder,
        status,
        message,
      ];
}
