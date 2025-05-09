
import 'package:domochat/features/community/domain/entities/community_entity.dart';
import 'package:domochat/features/community/domain/entities/member_entity.dart';

abstract class CommunityRepository {
  Future<CommunityEntity> createCommunity(
      String adressCity,
      String adressStreet,
      String adressHouse,
      String creatorId,
      String fullName,
      String apartment,
      String residentStatus,
      );
  Future<List<CommunityEntity>> fetchCommunities();

  Future<List<MemberEntity>> fetchCommunityMembers(String communityId);
}
