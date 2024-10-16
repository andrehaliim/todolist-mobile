class RegisterModel {
  late String name;
  late String username;
  late String password;
  late String confirmation;
  late String email;

  RegisterModel({
    required this.name,
    required this.password,
    required this.confirmation,
    required this.email,
    required this.username,
  });
}