class UserModel {
  int id;
  String name;
  String username;
  String email;
  String role;
  int active;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.role,
    required this.active,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      active: json['is_active'] ?? 0,
    );
  }

  factory UserModel.empty() {
    return UserModel(
      id: 0,
      name: '',
      username: '',
      email: '',
      role: '',
      active: 0,
    );
  }
}