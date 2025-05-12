
import 'package:domochat/features/ride/domain/entities/ride_entity.dart';
import 'package:domochat/features/ride/domain/repositories/ride_repository.dart';

class CreateRideUseCase {
  final RideRepository repository;

  CreateRideUseCase({required this.repository});

  Future<RideEntity> call (
      String communityId,
      String departureCity,
      String departureStreet,
      String departureHouse,
      String arrivalCity,
      String arrivalStreet,
      String arrivalHouse,
      String description,
      String departureTime,
      ) {
    return repository.createRide(
      communityId,
      departureCity,
      departureStreet,
      departureHouse,
      arrivalCity,
      arrivalStreet,
      arrivalHouse,
      description,
      departureTime
    );
  }
}