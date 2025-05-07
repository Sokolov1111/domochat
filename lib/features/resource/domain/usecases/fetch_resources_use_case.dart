
import 'package:domochat/features/resource/domain/entities/resource_entity.dart';
import 'package:domochat/features/resource/domain/repositories/resource_repository.dart';

class FetchResourcesUseCase {
  final ResourceRepository repository;

  FetchResourcesUseCase(this.repository);

  Future<List<ResourceEntity>> call (String communityId) async {
    return repository.fetchResources(communityId);
  }
}