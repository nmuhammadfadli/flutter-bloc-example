import 'package:equatable/equatable.dart';

import '../../../core/models/load_status.dart';
import '../data/cart_item_model.dart';

class CartState extends Equatable{
  final List<CartItem> item;
  final LoadStatus status;
  final String? message;

  const CartState({
    required this.item,
    required this.status,
    this.message,
  });

  const CartState.initial()
      : item = const [],
        status = LoadStatus.initial,
        message = null;

  double get subtotal => 
      item.fold(0, (sum, item) => sum + item.lineTotal);

  double get discount =>
      subtotal > 200 ? subtotal * 0.10 : 0;
  double get total => subtotal - discount;

  int get totalItem =>
      item.fold(0, (sum, item) => sum + item.quantity);

  CartState copyWith({
    List<CartItem>? item,
    LoadStatus? status,
    String? message,
  }
  )
  {
    return CartState(item: item ?? this.item,
    status: status ?? this.status,
    message: message);
  }

  @override
  List<Object?> get props => [item, status, message];


}