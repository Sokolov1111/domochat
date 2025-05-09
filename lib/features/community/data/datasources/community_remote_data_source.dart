import 'dart:convert';

import 'package:domochat/core/constants.dart';
import 'package:domochat/features/community/data/models/member_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:domochat/features/community/data/models/community_model.dart';

class CommunityRemoteDataSource {
  final String baseUrl = ConstantsLinks.baseUrl;
  final _storage = FlutterSecureStorage();

  Future<CommunityModel> createCommunity ({
    required String adressCity,
    required String adressStreet,
    required String adressHouse,
    required String creatorId,
    required String fullName,
    required String apartment,
    required String residentStatus,
  }) async {
    String token = await _storage.read(key: 'token') ?? '';
    final response = await http.post(
      Uri.parse('$baseUrl/communities/create'),
      body: jsonEncode({
        'adress_city': adressCity,
        'adress_street': adressStreet,
        'adress_house': adressHouse,
        'full_name': fullName,
        'apartment': apartment,
        'resident_status': residentStatus,
      }),
        headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      }
    );
    print(jsonDecode(response.body));
    if(response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      if (responseData['community'] != null) {
        return CommunityModel.fromJson(responseData);
      }
      return CommunityModel.fromJson(responseData);
    } else {
      throw Exception("Failed to create ${response.statusCode}");
    }
  }

  Future<List<CommunityModel>> fetchCommunities() async {
    String token = await _storage.read(key: 'token') ?? '';
    final response = await http.get(
      Uri.parse('$baseUrl/communities'),
      headers: {
        'Authorization': 'Bearer $token',
      }
    );
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      print(response.body);
      return data.map((json) => CommunityModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch community');
    }
  }

  Future<List<MemberModel>> fetchCommunityMembers(String communityId) async {
    String token = await _storage.read(key: 'token') ?? '';
    final response = await http.get(
      Uri.parse('$baseUrl/communities/members/$communityId'),
      headers: {'Authorization': 'Bearer $token'}
    );
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      print(data);
      return data.map((json) => MemberModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch members');
    }
  }
}