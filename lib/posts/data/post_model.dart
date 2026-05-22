import 'package:equatable/equatable.dart';

class PostModel extends Equatable {
  final int id;
  final String title;
  final String body;

  const PostModel({required this.id, required this.title, required this.body});

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(id: json['id'] as int, title: json['title'] as String, body: json['body'] as String);
  }

  @override
  List<Object?> get props => [id, title, body];
}
