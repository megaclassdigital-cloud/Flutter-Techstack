class UserProfile {
  final String id;
  final String fullName;
  final String role;
  final String? avatarUrl;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.fullName,
    required this.role,
    this.avatarUrl,
    required this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'],
    fullName: json['full_name'],
    role: json['role'],
    avatarUrl: json['avatar_url'],
    createdAt: DateTime.parse(json['created_at']),
  );
}
