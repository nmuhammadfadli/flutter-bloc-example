import 'package:equatable/equatable.dart';

import '../data/product_model.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

final class CartStarted extends CartEvent {
  const CartStarted();
}

final class CartProductAdded extends CartEvent {
  final ProductModel product;

  const CartProductAdded(this.product);

  @override
  List<Object?> get props => [product];
}

final class CartQuantityIncremented extends CartEvent {
  final int productId;

  const CartQuantityIncremented(this.productId);

  @override
  List<Object?> get props => [productId];
}

final class CartQuantityDecremented extends CartEvent {
  final int productId;

  const CartQuantityDecremented(this.productId);

  @override
  List<Object?> get props => [productId];
}

final class CartItemRemoved extends CartEvent {
  final int productId;

  const CartItemRemoved(this.productId);

  @override
  List<Object?> get props => [productId];
}

final class CartCleared extends CartEvent {
  const CartCleared();
}

final class CartMessageCleared extends CartEvent {
  const CartMessageCleared();
}
