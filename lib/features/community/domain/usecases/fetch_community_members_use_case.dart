
import 'package:domochat/features/community/domain/entities/member_entity.dart';
import 'package:domochat/features/community/domain/repositories/community_repository.dart';

class FetchCommunityMembersUseCase {
  final CommunityRepository repository;

  FetchCommunityMembersUseCase(this.repository);

  Future<List<MemberEntity>> call (String communityId) async {
    return repository.fetchCommunityMembers(communityId);
  }
}