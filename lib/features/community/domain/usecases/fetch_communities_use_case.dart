import 'package:domochat/features/community/domain/entities/community_entity.dart';
import 'package:domochat/features/community/domain/repositories/community_repository.dart';

class FetchCommunitiesUseCase {
  final CommunityRepository repository;

  FetchCommunitiesUseCase(this.repository);

  Future<List<CommunityEntity>> call () async {
    return repository.fetchCommunities();
  }
}