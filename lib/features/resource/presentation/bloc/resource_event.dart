abstract class ResourceEvent {}

class FetchResources extends ResourceEvent {
  final String communityId;

  FetchResources({required this.communityId});
}