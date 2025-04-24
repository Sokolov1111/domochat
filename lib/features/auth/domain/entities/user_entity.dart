class UserEntity {
  final String id;
  final String email;
  final String username;
  final String password;
  final String? token;

  UserEntity({required this.id, required this.email, required this.username, required this.password, this.token});
}