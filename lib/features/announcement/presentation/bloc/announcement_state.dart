
import 'package:domochat/features/announcement/domain/entities/announcement_entity.dart';

abstract class AnnouncementState {}

class AnnouncementInitialState extends AnnouncementState {}
class AnnouncementLoadingState extends AnnouncementState {}

class AnnouncementLoadedState extends AnnouncementState {
  final List<AnnouncementEntity> announcements;
  AnnouncementLoadedState(this.announcements);
}

class AnnouncementErrorState extends AnnouncementState {
  final String message;
  AnnouncementErrorState(this.message);
}