import 'package:equatable/equatable.dart';

import '../data/product_sort_order.dart';

sealed class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object?> get props => [];
}

final class ProductsStarted extends ProductsEvent {
  const ProductsStarted();
}

final class ProductsRefreshed extends ProductsEvent {
  const ProductsRefreshed();
}

final class ProductsSearchChanged extends ProductsEvent {
  final String query;

  const ProductsSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

final class ProductsCategoryChanged extends ProductsEvent {
  final String category;

  const ProductsCategoryChanged(this.category);

  @override
  List<Object?> get props => [category];
}

final class ProductsSortChanged extends ProductsEvent {
  final ProductSortOrder sortOrder;

  const ProductsSortChanged(this.sortOrder);

  @override
  List<Object?> get props => [sortOrder];
}
