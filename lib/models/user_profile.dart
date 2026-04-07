class UserProfile {
  final String name;
  final String email;
  final String role;
  final String? joinDate;
  final UserStats? stats;

  UserProfile({
    required this.name,
    required this.email,
    required this.role,
    this.joinDate,
    this.stats,
  });

  factory UserProfile.fromMap(Map<String, dynamic> data) {
    final statsData = data['stats'] as Map<String, dynamic>?;
    return UserProfile(
      name: data['fullName'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'parent',
      joinDate: data['createdAt']?.toString(),
      stats: statsData != null ? UserStats.fromMap(statsData) : null,
    );
  }
}

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

  factory UserStats.fromMap(Map<String, dynamic> data) {
    return UserStats(
      analyzedPrompts: data['analyzedPrompts'] ?? 0,
      blockedThreats: data['blockedThreats'] ?? 0,
      allowedPrompts: data['allowedPrompts'] ?? 0,
      hesitateCases: data['hesitateCases'] ?? 0,
    );
  }
}
