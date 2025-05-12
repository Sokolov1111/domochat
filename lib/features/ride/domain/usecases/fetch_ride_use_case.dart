
import 'package:domochat/features/ride/domain/entities/ride_entity.dart';
import 'package:domochat/features/ride/domain/repositories/ride_repository.dart';

class FetchRideUseCase {
  final RideRepository repository;

  FetchRideUseCase(this.repository);

  Future<List<RideEntity>> call (String communityId) async {
    return repository.fetchRides(communityId);
  }
}