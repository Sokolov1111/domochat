
import 'package:domochat/features/resource/domain/entities/resource_entity.dart';
import 'package:domochat/features/resource/domain/repositories/resource_repository.dart';

class CreateResourceUseCase {
  final ResourceRepository repository;

  CreateResourceUseCase({required this.repository});

  Future<ResourceEntity> call (
     String communityId,
     String title,
     String description,
     String contactInfo,
     String category,
      ) {
    return repository.createResource(communityId, title, description, contactInfo, contactInfo);
  }
}