import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/load_status.dart';
import '../data/cart_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repository;

  CartBloc(this.repository) : super(const CartState.initial()) {
    on<CartStarted>(_onStarted);
    on<CartProductAdded>(_onProductAdded);
    on<CartQuantityIncremented>(_onIncremented);
    on<CartQuantityDecremented>(_onDecremented);
    on<CartItemRemoved>(_onRemoved);
    on<CartCleared>(_onCleared);
    on<CartMessageCleared>(_onMessageCleared);
  }

  Future<void> _onStarted(CartStarted event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: LoadStatus.loading, message: null));
    try {
      final items = await repository.loadCartItems();
      emit(state.copyWith(item: items, status: LoadStatus.success));
    } catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, message: e.toString()));
    }
  }

  Future<void> _onProductAdded(CartProductAdded event, Emitter<CartState> emit) async {
    try {
      final items = await repository.addOrIncrement(event.product);
      emit(state.copyWith(
        item: items,
        status: LoadStatus.success,
        message: '${event.product.title} ditambahkan ke cart.',
      ));
    } catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, message: e.toString()));
    }
  }

  Future<void> _onIncremented(CartQuantityIncremented event, Emitter<CartState> emit) async {
    try {
      final items = await repository.incrementQuantity(event.productId);
      emit(state.copyWith(item: items, status: LoadStatus.success));
    } catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, message: e.toString()));
    }
  }

  Future<void> _onDecremented(CartQuantityDecremented event, Emitter<CartState> emit) async {
    try {
      final items = await repository.decrementQuantity(event.productId);
      emit(state.copyWith(item: items, status: LoadStatus.success));
    } catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, message: e.toString()));
    }
  }

  Future<void> _onRemoved(CartItemRemoved event, Emitter<CartState> emit) async {
    try {
      final items = await repository.removeItem(event.productId);
      emit(state.copyWith(item: items, status: LoadStatus.success, message: 'Item dihapus dari cart.'));
    } catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, message: e.toString()));
    }
  }

  Future<void> _onCleared(CartCleared event, Emitter<CartState> emit) async {
    try {
      final items = await repository.clearCart();
      emit(state.copyWith(item: items, status: LoadStatus.success, message: 'Cart berhasil dikosongkan.'));
    } catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, message: e.toString()));
    }
  }

  void _onMessageCleared(CartMessageCleared event, Emitter<CartState> emit) {
    if (state.message != null) {
      emit(state.copyWith(message: null));
    }
  }
}
