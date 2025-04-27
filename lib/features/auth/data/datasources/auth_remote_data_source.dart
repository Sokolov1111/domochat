
import 'dart:convert';

import 'package:domochat/features/auth/data/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthRemoteDataSource {
  final String baseUrl = 'http://10.0.2.2:6001/auth';
  final String baseUrl1 = 'http://10.0.2.2:6001';
  final _storage = FlutterSecureStorage();

  Future<UserModel> register({required String username, required String email, required String password}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: jsonEncode({'username': username, 'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'}
    );
    print(response.statusCode);
    print(response.body);
    if(response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      if (responseData['user'] != null) {
        return UserModel.fromJson(responseData['user']);
      }
      return UserModel.fromJson(responseData);
    } else {
      throw Exception("Failed to register ${response.statusCode}");
    }

  }

  Future<UserModel> login({required String email, required String password}) async {
    final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'}
    );

    print(response.body);
    return UserModel.fromJson(jsonDecode(response.body)['user']);
  }

  Future<UserModel> updateUsername({required String username}) async {
    String token = await _storage.read(key: 'token') ?? '';
    final response = await http.put(
      Uri.parse("$baseUrl1/profile"),
      body: jsonEncode({'newUsername': username}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      }
    );
    print(response.body);
    return UserModel.fromJson(jsonDecode(response.body)['user']);
  }

}
