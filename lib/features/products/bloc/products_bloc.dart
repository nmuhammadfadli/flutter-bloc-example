import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/load_status.dart';
import '../data/product_repository.dart';
import '../data/product_sort_order.dart';
import 'products_event.dart';
import 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductRepository repository;

  ProductsBloc(this.repository) : super(const ProductsState.initial()) {
    on<ProductsStarted>(_onStarted);
    on<ProductsRefreshed>(_onRefreshed);
    on<ProductsSearchChanged>(_onSearchChanged);
    on<ProductsCategoryChanged>(_onCategoryChanged);
    on<ProductsSortChanged>(_onSortChanged);
  }

  Future<void> _onStarted(ProductsStarted event, Emitter<ProductsState> emit) async {
    await _loadProducts(emit, keepCurrentItems: false);
  }

  Future<void> _onRefreshed(ProductsRefreshed event, Emitter<ProductsState> emit) async {
    await _loadProducts(emit, keepCurrentItems: true);
  }

  void _onSearchChanged(ProductsSearchChanged event, Emitter<ProductsState> emit) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onCategoryChanged(ProductsCategoryChanged event, Emitter<ProductsState> emit) {
    emit(state.copyWith(selectedCategory: event.category));
  }

  void _onSortChanged(ProductsSortChanged event, Emitter<ProductsState> emit) {
    emit(state.copyWith(sortOrder: event.sortOrder));
  }

  Future<void> _loadProducts(
    Emitter<ProductsState> emit, {
    required bool keepCurrentItems,
  }) async {
    emit(state.copyWith(
      items: keepCurrentItems ? state.items : const [],
      searchQuery: '',
      selectedCategory: 'All',
      sortOrder: ProductSortOrder.none,
      status: LoadStatus.loading,
      message: null,
    ));

    try {
      final items = await repository.fetchProducts();
      emit(state.copyWith(
        items: items,
        searchQuery: '',
        selectedCategory: 'All',
        sortOrder: ProductSortOrder.none,
        status: LoadStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LoadStatus.failure,
        message: e.toString(),
      ));
    }
  }
}
