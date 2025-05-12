
class RideEntity {
  final String id;
  final String departureCity;
  final String departureStreet;
  final String departureHouse;
  final String arrivalCity;
  final String arrivalStreet;
  final String arrivalHouse;
  final String description;
  final String departureTime;
  final String authorId;
  final String authorName;
  final String createdAt;

  RideEntity({
    required this.id,
    required this.departureCity,
    required this.departureStreet,
    required this.departureHouse,
    required this.arrivalCity,
    required this.arrivalStreet,
    required this.arrivalHouse,
    required this.description,
    required this.departureTime,
    required this.authorId,
    required this.authorName,
    required this.createdAt
  });

}