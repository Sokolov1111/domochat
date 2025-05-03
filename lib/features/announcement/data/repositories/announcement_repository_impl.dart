
import 'package:domochat/features/announcement/data/datasources/announcement_remote_datasource.dart';
import 'package:domochat/features/announcement/domain/entities/announcement_entity.dart';
import 'package:domochat/features/announcement/domain/repositories/announcement_repository.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  final AnnouncementRemoteDatasource announcementRemoteDataSource;

  AnnouncementRepositoryImpl({required this.announcementRemoteDataSource});

  @override
  Future<List<AnnouncementEntity>> fetchAnnouncements (String communityId) async {
    return await announcementRemoteDataSource.fetchAnnouncements(communityId);
  }


}