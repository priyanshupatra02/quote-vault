import 'dart:convert';

class ProfileModel {
  final String id;
  final String? name;
  final String? avatarUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  // Notification preferences
  // Notification preferences
  final bool notificationEnabled;
  final int notificationHour;
  final int notificationMinute;
  // Settings
  final double fontSize;
  // Stats
  final int loginStreak;
  final String? lastLoginDate;
  final int shareCount;

  const ProfileModel({
    required this.id,
    this.name,
    this.avatarUrl,
    this.createdAt,
    this.updatedAt,
    this.notificationEnabled = false,
    this.notificationHour = 9,
    this.notificationMinute = 0,
    this.fontSize = 50.0,
    this.loginStreak = 0,
    this.lastLoginDate,
    this.shareCount = 0,
  });

  ProfileModel copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? notificationEnabled,
    int? notificationHour,
    int? notificationMinute,
    double? fontSize,
    int? loginStreak,
    String? lastLoginDate,
    int? shareCount,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      notificationHour: notificationHour ?? this.notificationHour,
      notificationMinute: notificationMinute ?? this.notificationMinute,
      fontSize: fontSize ?? this.fontSize,
      loginStreak: loginStreak ?? this.loginStreak,
      lastLoginDate: lastLoginDate ?? this.lastLoginDate,
      shareCount: shareCount ?? this.shareCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'avatar_url': avatarUrl,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'notification_enabled': notificationEnabled,
      'notification_hour': notificationHour,
      'notification_minute': notificationMinute,
      'font_size': fontSize,
      'login_streak': loginStreak,
      'last_login_date': lastLoginDate,
      'share_count': shareCount,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] ?? '',
      name: map['name'],
      avatarUrl: map['avatar_url'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
      notificationEnabled: map['notification_enabled'] ?? false,
      notificationHour: map['notification_hour'] ?? 9,
      notificationMinute: map['notification_minute'] ?? 0,
      fontSize: (map['font_size'] as num?)?.toDouble() ?? 50.0,
      loginStreak: map['login_streak'] ?? 0,
      lastLoginDate: map['last_login_date'],
      shareCount: map['share_count'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileModel.fromJson(String source) => ProfileModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProfileModel(id: $id, name: $name, avatarUrl: $avatarUrl, notificationEnabled: $notificationEnabled, notificationHour: $notificationHour)';
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
  int get hashCode => id.hashCode ^ name.hashCode ^ avatarUrl.hashCode ^ fontSize.hashCode;
}
