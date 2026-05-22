import 'dart:convert';

import 'package:http/http.dart' as http;

import 'post_model.dart';

class PostRepository {
  Future<List<PostModel>> fetchPosts({required int page, int limit = 10}) async {
    final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts?_page=$page&_limit=$limit');
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Gagal memuat data');
    }
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((e) => PostModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
