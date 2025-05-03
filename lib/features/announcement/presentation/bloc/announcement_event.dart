abstract class AnnouncementEvent {}

class FetchAnnouncements extends AnnouncementEvent {
  final String communityId;

  FetchAnnouncements({required this.communityId});
}
