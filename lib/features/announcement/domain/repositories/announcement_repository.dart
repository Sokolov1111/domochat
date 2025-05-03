
import 'package:domochat/features/announcement/domain/entities/announcement_entity.dart';

abstract class AnnouncementRepository {
  Future<List<AnnouncementEntity>> fetchAnnouncements (String communityId);
}