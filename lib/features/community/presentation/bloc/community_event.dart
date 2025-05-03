
abstract class CreateCommunityEvent {}

class CreateCommunitySubmitted extends CreateCommunityEvent {
  final String city;
  final String street;
  final String house;
  final String creatorId;
  final String fullName;
  final String apartment;
  final String residentStatus;

  CreateCommunitySubmitted({required this.city, required this.street, required this.house, required this.creatorId, required this.fullName,  required this.apartment, required this.residentStatus});
}