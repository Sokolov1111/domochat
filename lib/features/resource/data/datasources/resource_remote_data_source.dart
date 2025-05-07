import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:domochat/core/constants.dart';
import 'package:domochat/features/resource/data/models/resource_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ResourceRemoteDataSource {
  final String baseUrl = ConstantsLinks.baseUrl;
  final _storage = FlutterSecureStorage();

  Future<List<ResourceModel>> fetchResources(String communityId) async {
    String token = await _storage.read(key: 'token') ?? '';
    final response = await http.get(
      Uri.parse('$baseUrl/resources/$communityId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      print(data);
      return data.map((json) => ResourceModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch resources');
    }
  }
}