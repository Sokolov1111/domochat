abstract class RideEvent {}

class FetchRides extends RideEvent {
  final String communityId;

  FetchRides({required this.communityId});
}

class CreateRideSubmitted extends RideEvent {
  final String communityId;
  final String departureCity;
  final String departureStreet;
  final String departureHouse;
  final String arrivalCity;
  final String arrivalStreet;
  final String arrivalHouse;
  final String description;
  final String departureTime;

  CreateRideSubmitted(
      {required this.communityId,
      required this.departureCity,
      required this.departureStreet,
      required this.departureHouse,
      required this.arrivalCity,
      required this.arrivalStreet,
      required this.arrivalHouse,
      required this.description,
      required this.departureTime});
}
