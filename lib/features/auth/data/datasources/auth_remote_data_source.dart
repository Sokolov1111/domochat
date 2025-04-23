
import 'dart:convert';

import 'package:domochat/features/auth/data/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteDataSource {
  final String baseUrl = 'http://10.0.2.2:6000/auth';

  Future<UserModel> register({required String username, required String email, required String password}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: jsonEncode({'username': username, 'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'}
    );

    print(response.body);

    return UserModel.fromJson(jsonDecode(response.body)['user']);
  }

  Future<UserModel> login({required String email, required String password}) async {
    final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'}
    );

    return UserModel.fromJson(jsonDecode(response.body)['user']);
  }

}