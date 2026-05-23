import 'dart:convert';

import 'package:http/http.dart' as http;

import 'product_model.dart';

class ProductRepository {
  static const _endPoint = 'https://fakestoreapi.com/products';

  Future<List<ProductModel>> fetchProducts() async {
    Object? lastError;

    for (final endpoint in [_endPoint]) {
      try{
        final response = await http.get(Uri.parse(endpoint));

        if (response.statusCode != 200) {
          throw Exception('HTTP ${response.statusCode}');
        }

        final decoded = jsonDecode(response.body);
        if (decoded is! List){
          throw Exception('Data produk tidak valid');

        }
        return decoded
          .whereType<Map<String, dynamic>>()
          .map(ProductModel.fromJson)
          .toList();
      } catch(e) {
        lastError = e;
      }
    }

    throw Exception('Gagal memuat produkk $lastError');
  }
}

