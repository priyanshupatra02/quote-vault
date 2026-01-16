import 'dart:convert';

class ProfileModel {
  final String id;
  final String? name;
  final String? avatarUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProfileModel({
    required this.id,
    this.name,
    this.avatarUrl,
    this.createdAt,
    this.updatedAt,
  });

  ProfileModel copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'avatar_url': avatarUrl,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] ?? '',
      name: map['name'],
      avatarUrl: map['avatar_url'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileModel.fromJson(String source) => ProfileModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProfileModel(id: $id, name: $name, avatarUrl: $avatarUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfileModel &&
        other.id == id &&
        other.name == name &&
        other.avatarUrl == avatarUrl;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ avatarUrl.hashCode;
}
