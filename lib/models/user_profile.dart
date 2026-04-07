class UserStats {
  final int analyzedPrompts;
  final int blockedThreats;
  final int allowedPrompts;
  final int hesitateCases;

  UserStats({
    required this.analyzedPrompts,
    required this.blockedThreats,
    required this.allowedPrompts,
    required this.hesitateCases,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      analyzedPrompts: json['analyzedPrompts'] ?? 0,
      blockedThreats: json['blockedThreats'] ?? 0,
      allowedPrompts: json['allowedPrompts'] ?? 0,
      hesitateCases: json['hesitateCases'] ?? 0,
    );
  }
}

class UserProfile {
  final String id;
  final String email;
  final String name;
  final String role;
  final String? joinDate;
  final UserStats? stats;

  UserProfile({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.joinDate,
    this.stats,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? 'user',
      joinDate: json['joinDate'],
      stats: json['stats'] != null
          ? UserStats.fromJson(json['stats'] as Map<String, dynamic>)
          : null,
    );
  }
}
