
import 'package:domochat/features/community/data/datasources/community_remote_data_source.dart';
import 'package:domochat/features/community/domain/entities/community_entity.dart';
import 'package:domochat/features/community/domain/entities/member_entity.dart';
import 'package:domochat/features/community/domain/repositories/community_repository.dart';

class CommunityRepositoryImpl implements CommunityRepository {
  final CommunityRemoteDataSource communityRemoteDataSource;

  CommunityRepositoryImpl({required this.communityRemoteDataSource});

  @override
  Future<CommunityEntity> createCommunity(String adressCity, String adressStreet, String adressHouse, String creatorId, String fullName, String apartment, String residentStatus) async {
    return await communityRemoteDataSource.createCommunity(adressCity: adressCity, adressStreet: adressStreet, adressHouse: adressHouse, creatorId: creatorId, fullName: fullName, apartment: apartment, residentStatus: residentStatus);
  }

  @override
  Future<List<CommunityEntity>> fetchCommunities() async {
    return await communityRemoteDataSource.fetchCommunities();
  }

  @override
  Future<List<MemberEntity>> fetchCommunityMembers(String communityId) async {
    return await communityRemoteDataSource.fetchCommunityMembers(communityId);
  }
}