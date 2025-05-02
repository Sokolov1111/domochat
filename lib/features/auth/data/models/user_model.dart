
import 'package:domochat/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required String id,
    required String username,
    required String email,
    required String password,
    String? token,
  }) : super(id: id, username: username, email: email, password: password, token: token);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        password: json['password'] ?? '',
        token: json.containsKey('token') ? json['token']?.toString() : null,
    );
  }
}