
import 'package:domochat/features/ride/data/datasources/ride_remote_data_source.dart';
import 'package:domochat/features/ride/domain/entities/ride_entity.dart';
import 'package:domochat/features/ride/domain/repositories/ride_repository.dart';

class RideRepositoryImpl implements RideRepository {
  final RideRemoteDataSource rideRemoteDataSource;

  RideRepositoryImpl({required this.rideRemoteDataSource});

  @override
  Future<RideEntity> createRide(String communityId, String departureCity, String departureStreet, String departureHouse, String arrivalCity, String arrivalStreet, String arrivalHouse, String description, String departureTime) async {
    return await rideRemoteDataSource.createRide(
        communityId: communityId,
        departureCity: departureCity,
        departureStreet: departureStreet,
        departureHouse: departureHouse,
        arrivalCity: arrivalCity,
        arrivalStreet: arrivalStreet,
        arrivalHouse: arrivalHouse,
        description: description,
        departureTime: departureTime);
  }

  @override
  Future<List<RideEntity>> fetchRides(String communityId) async {
    return await rideRemoteDataSource.fetchRides(communityId);
  }

}