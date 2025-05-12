
import 'package:domochat/features/ride/domain/entities/ride_entity.dart';

class RideModel extends RideEntity {
  RideModel({
    required super.id,
    required super.departureCity,
    required super.departureStreet,
    required super.departureHouse,
    required super.arrivalCity,
    required super.arrivalStreet,
    required super.arrivalHouse,
    required super.description,
    required super.departureTime,
    required super.authorId,
    required super.authorName,
    required super.createdAt
  });

  factory RideModel.fromJson(Map<String, dynamic> json) {
    return RideModel(
        id: json['id'],
        departureCity: json['departure_city'],
        departureStreet: json['departure_street'],
        departureHouse: json['departure_house'],
        arrivalCity: json['arrival_city'],
        arrivalStreet: json['arrival_street'],
        arrivalHouse: json['arrival_house'],
        description: json['description'],
        departureTime: json['departure_time'],
        authorId: json['author_id'],
        authorName: json['author_name'] ?? '',
        createdAt: json['created_at']
    );
  }

}