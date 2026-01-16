import 'dart:convert';

class CollectionModel {
  final int id;
  final String userId;
  final String name;
  final String? iconName;
  final int quotesCount;
  final DateTime? createdAt;

  const CollectionModel({
    required this.id,
    required this.userId,
    required this.name,
    this.iconName,
    this.quotesCount = 0,
    this.createdAt,
  });

  CollectionModel copyWith({
    int? id,
    String? userId,
    String? name,
    String? iconName,
    int? quotesCount,
    DateTime? createdAt,
  }) {
    return CollectionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      quotesCount: quotesCount ?? this.quotesCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'icon_name': iconName,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  /// Map for creating new collection (without id)
  Map<String, dynamic> toCreateMap() {
    return {
      'user_id': userId,
      'name': name,
      'icon_name': iconName,
    };
  }

  factory CollectionModel.fromMap(Map<String, dynamic> map) {
    return CollectionModel(
      id: map['id']?.toInt() ?? 0,
      userId: map['user_id'] ?? '',
      name: map['name'] ?? '',
      iconName: map['icon_name'],
      quotesCount: map['quotes_count']?.toInt() ?? 0,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CollectionModel.fromJson(String source) => CollectionModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CollectionModel(id: $id, name: $name, quotesCount: $quotesCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CollectionModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
