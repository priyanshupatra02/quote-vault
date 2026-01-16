import 'dart:convert';

class UserFavoriteModel {
  final int id;
  final String userId;
  final int quoteId;
  final DateTime? createdAt;

  const UserFavoriteModel({
    required this.id,
    required this.userId,
    required this.quoteId,
    this.createdAt,
  });

  UserFavoriteModel copyWith({
    int? id,
    String? userId,
    int? quoteId,
    DateTime? createdAt,
  }) {
    return UserFavoriteModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      quoteId: quoteId ?? this.quoteId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'quote_id': quoteId,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  /// Map for creating new favorite (without id)
  Map<String, dynamic> toCreateMap() {
    return {
      'user_id': userId,
      'quote_id': quoteId,
    };
  }

  factory UserFavoriteModel.fromMap(Map<String, dynamic> map) {
    return UserFavoriteModel(
      id: map['id']?.toInt() ?? 0,
      userId: map['user_id'] ?? '',
      quoteId: map['quote_id']?.toInt() ?? 0,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserFavoriteModel.fromJson(String source) =>
      UserFavoriteModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserFavoriteModel(id: $id, userId: $userId, quoteId: $quoteId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserFavoriteModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
