abstract class MembersListEvent {}

class FetchMembers extends MembersListEvent {
  final String communityId;

  FetchMembers({required this.communityId});
}