enum UserRole { admin, parent, child }

class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final UserRole role;
  final String? parentId; // only for child accounts
  final List<String>? childrenIds; // only for parent accounts
  final DateTime createdAt;
  final bool isActive;
  final String? profileImageUrl;

  const UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.role,
    this.parentId,
    this.childrenIds,
    required this.createdAt,
    this.isActive = true,
    this.profileImageUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      role: UserRole.values.firstWhere(
        (r) => r.name == map['role'],
        orElse: () => UserRole.child,
      ),
      parentId: map['parentId'],
      childrenIds: map['childrenIds'] != null
          ? List<String>.from(map['childrenIds'])
          : null,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : DateTime.now(),
      isActive: map['isActive'] ?? true,
      profileImageUrl: map['profileImageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'role': role.name,
      'parentId': parentId,
      'childrenIds': childrenIds,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'isActive': isActive,
      'profileImageUrl': profileImageUrl,
    };
  }

  UserModel copyWith({
    String? fullName,
    String? email,
    UserRole? role,
    String? parentId,
    List<String>? childrenIds,
    bool? isActive,
    String? profileImageUrl,
  }) {
    return UserModel(
      uid: uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      parentId: parentId ?? this.parentId,
      childrenIds: childrenIds ?? this.childrenIds,
      createdAt: createdAt,
      isActive: isActive ?? this.isActive,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
