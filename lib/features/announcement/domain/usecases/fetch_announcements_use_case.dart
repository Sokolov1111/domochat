
import 'package:domochat/features/announcement/domain/entities/announcement_entity.dart';
import 'package:domochat/features/announcement/domain/repositories/announcement_repository.dart';

class FetchAnnouncementsUseCase {
  final AnnouncementRepository repository;

  FetchAnnouncementsUseCase(this.repository);

  Future<List<AnnouncementEntity>> call (String communityId) async {
    return repository.fetchAnnouncements(communityId);
  }
}