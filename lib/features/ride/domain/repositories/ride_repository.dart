
import 'package:domochat/features/ride/domain/entities/ride_entity.dart';

abstract class RideRepository {
  Future<List<RideEntity>> fetchRides(String communityId);
  Future<RideEntity> createRide(
      String communityId,
      String departureCity,
      String departureStreet,
      String departureHouse,
      String arrivalCity,
      String arrivalStreet,
      String arrivalHouse,
      String description,
      String departureTime,
      );
}