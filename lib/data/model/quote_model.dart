import 'dart:convert';

import 'package:quote_vault/data/model/category_model.dart';

class QuoteModel {
  final int id;
  final String content;
  final String author;
  final int? categoryId;
  final CategoryModel? category;
  final int likesCount;
  final DateTime? createdAt;
  final bool? isFavorite;

  const QuoteModel({
    required this.id,
    required this.content,
    required this.author,
    this.categoryId,
    this.category,
    this.likesCount = 0,
    this.createdAt,
    this.isFavorite,
  });

  QuoteModel copyWith({
    int? id,
    String? content,
    String? author,
    int? categoryId,
    CategoryModel? category,
    int? likesCount,
    DateTime? createdAt,
    bool? isFavorite,
  }) {
    return QuoteModel(
      id: id ?? this.id,
      content: content ?? this.content,
      author: author ?? this.author,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
      likesCount: likesCount ?? this.likesCount,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'author': author,
      'category_id': categoryId,
      'likes_count': likesCount,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory QuoteModel.fromMap(Map<String, dynamic> map) {
    return QuoteModel(
      id: map['id']?.toInt() ?? 0,
      content: map['content'] ?? '',
      author: map['author'] ?? '',
      categoryId: map['category_id']?.toInt(),
      category: map['categories'] != null ? CategoryModel.fromMap(map['categories']) : null,
      likesCount: map['likes_count']?.toInt() ?? 0,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      isFavorite: map['is_favorite'],
    );
  }

  String toJson() => json.encode(toMap());

  factory QuoteModel.fromJson(String source) => QuoteModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'QuoteModel(id: $id, content: $content, author: $author, categoryId: $categoryId, likesCount: $likesCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuoteModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
