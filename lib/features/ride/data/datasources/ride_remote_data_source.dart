import 'dart:convert';

import 'package:domochat/features/ride/data/models/ride_model.dart';
import 'package:http/http.dart' as http;
import 'package:domochat/core/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RideRemoteDataSource {
  final String baseUrl = ConstantsLinks.baseUrl;
  final _storage = FlutterSecureStorage();

  Future<List<RideModel>> fetchRides(String communityId) async {
    String token = await _storage.read(key: 'token') ?? '';
    final response = await http.get(
      Uri.parse('$baseUrl/rides/$communityId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((json) => RideModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch shared rides');
    }
  }

  Future<RideModel> createRide({
    required String communityId,
    required String departureCity,
    required String departureStreet,
    required String departureHouse,
    required String arrivalCity,
    required String arrivalStreet,
    required String arrivalHouse,
    required String description,
    required String departureTime,
  }) async {
    String token = await _storage.read(key: 'token') ?? '';
    final response = await http.post(
      Uri.parse('$baseUrl/rides/create'),
      body: jsonEncode({
        "community_id": communityId,
        "departure_city": departureCity,
        "departure_street": departureStreet,
        "departure_house": departureHouse,
        "arrival_city": arrivalCity,
        "arrival_street": arrivalStreet,
        "arrival_house": arrivalHouse,
        "description": description,
        "departure_time": departureTime,
      }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }
    );
    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      print('Запрос на поездку добавлен!');
      print(responseData);
      return RideModel.fromJson(responseData);
    } else {
      throw Exception('Failed to create shared ride - ${response.statusCode}');
    }
  }
}