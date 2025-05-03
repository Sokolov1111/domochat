
import 'dart:convert';

import 'package:domochat/core/constants.dart';
import 'package:domochat/features/auth/data/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthRemoteDataSource {
  // final String baseUrl = 'http://10.0.2.2:6102/auth';
  // final String baseUrl1 = 'http://10.0.2.2:6102';
  final String baseUrl = ConstantsLinks.baseUrl;
  final _storage = FlutterSecureStorage();

  Future<UserModel> register({required String username, required String email, required String password}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
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
        Uri.parse('$baseUrl/auth/login'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'}
    );

    print(response.body);
    return UserModel.fromJson(jsonDecode(response.body)['user']);
  }

  Future<UserModel> updateUsername({required String username}) async {
    String token = await _storage.read(key: 'token') ?? '';
    final response = await http.put(
      Uri.parse("$baseUrl/profile"),
      body: jsonEncode({'newUsername': username}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      }
    );
    print(jsonDecode(response.body)['user']);
    return UserModel.fromJson(jsonDecode(response.body)['user']);
  }

}
