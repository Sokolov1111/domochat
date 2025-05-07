abstract class ResourceEvent {}

class FetchResources extends ResourceEvent {
  final String communityId;

  FetchResources({required this.communityId});
}

class CreateResourceSubmitted extends ResourceEvent {
  final String communityId;
  final String title;
  final String description;
  final String contactInfo;
  final String category;

  CreateResourceSubmitted({
    required this.communityId,
    required this.title,
    required this.description,
    required this.contactInfo,
    required this.category,
  });
}