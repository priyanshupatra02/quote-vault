import 'dart:convert';

class CategoryModel {
  final int id;
  final String name;
  final String? iconName;
  final DateTime? createdAt;

  const CategoryModel({
    required this.id,
    required this.name,
    this.iconName,
    this.createdAt,
  });

  CategoryModel copyWith({
    int? id,
    String? name,
    String? iconName,
    DateTime? createdAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon_name': iconName,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      iconName: map['icon_name'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) => CategoryModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, iconName: $iconName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryModel && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
