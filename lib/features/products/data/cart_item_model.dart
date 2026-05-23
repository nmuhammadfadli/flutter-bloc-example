import 'package:equatable/equatable.dart';
import 'product_model.dart';

class CartItem extends Equatable {
  final int productId;
  final String title;
  final String image;
  final String category;
  final double price;
  final int quantity;

  const CartItem({
    required this.productId,
    required this.title,
    required this.image,
    required this.category,
    required this.price,
    required this.quantity,
  });

  factory CartItem.fromProduct(ProductModel product, {int quantity = 1}) {
    return CartItem(
      productId: product.id ?? 0,
      title: product.title ?? '',
      image: product.image ?? '',
      category: product.category ?? '',
      price: product.price ?? 0,
      quantity: quantity,
    );
  }

  double get lineTotal => price * quantity;

  CartItem copyWith({
    int? productId,
    String? title,
    String? image,
    String? category,
    double? price,
    int? quantity,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      title: title ?? this.title,
      image: image ?? this.image,
      category: category ?? this.category,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [productId, title, image, category, price, quantity];
}
