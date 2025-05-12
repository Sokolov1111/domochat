
import 'package:domochat/features/ride/domain/usecases/create_ride_use_case.dart';
import 'package:domochat/features/ride/domain/usecases/fetch_ride_use_case.dart';
import 'package:domochat/features/ride/presentation/bloc/ride_event.dart';
import 'package:domochat/features/ride/presentation/bloc/ride_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RideBloc extends Bloc<RideEvent, RideState> {
  final FetchRideUseCase fetchRideUseCase;
  final CreateRideUseCase createRideUseCase;

  RideBloc({required this.fetchRideUseCase, required this.createRideUseCase})
      : super(RideInitialState()) {
        on<FetchRides>(_onFetchRides);
        on<CreateRideSubmitted>(_onCreateRide);
  }

  Future<void> _onFetchRides (FetchRides event, Emitter<RideState> emit) async {
    emit(RideLoadingState());
    try {
      final rides = await fetchRideUseCase(event.communityId);
      emit(RideLoadedState(rides));
    } catch (err) {
      print(err);
      emit(RideErrorState('Failed to fetch shared rides'));
    }
  }

  Future<void> _onCreateRide(CreateRideSubmitted event, Emitter<RideState> emit) async {
    emit(RideLoadingState());
    try {
      final rideModel = await createRideUseCase(
        event.communityId,
        event.departureCity,
        event.departureStreet,
        event.departureHouse,
        event.arrivalCity,
        event.arrivalStreet,
        event.arrivalHouse,
        event.description,
        event.departureTime,
      );
      emit(CreateRideSuccess(message: "Ok", rideEntity: rideModel));
    } catch (err) {
      print('Failed to create shared ride - $err');
      emit(RideErrorState('Failed to create shared ride - $err'));
    }
  }
}