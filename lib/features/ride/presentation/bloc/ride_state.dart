
import 'package:domochat/features/ride/domain/entities/ride_entity.dart';

abstract class RideState {}

class RideInitialState extends RideState {}

class RideLoadingState extends RideState {}

class RideLoadedState extends RideState {
  final List<RideEntity> rides;

  RideLoadedState(this.rides);
}

class RideErrorState extends RideState {
  final String message;

  RideErrorState(this.message);
}

class CreateRideSuccess extends RideState {
  final String message;
  final RideEntity rideEntity;

  CreateRideSuccess({required this.message, required this.rideEntity});

}