import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:domochat/features/announcement/data/models/announcement_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AnnouncementRemoteDatasource {
  final String baseUrl = 'http://10.0.2.2:6102';
  final _storage = FlutterSecureStorage();

  Future<List<AnnouncementModel>> fetchAnnouncements(String communityId) async {
    String token = await _storage.read(key: 'token') ?? '';
    final response = await http.get(
      Uri.parse('$baseUrl/announcements/$communityId'),
      headers: {'Authorization': 'Bearer $token'}
    );
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      print(data);
      print(data.runtimeType);
      return data.map((json) => AnnouncementModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch announcements');
    }
  }
}