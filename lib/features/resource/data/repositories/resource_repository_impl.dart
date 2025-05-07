
import 'package:domochat/features/resource/data/datasources/resource_remote_data_source.dart';
import 'package:domochat/features/resource/domain/entities/resource_entity.dart';
import 'package:domochat/features/resource/domain/repositories/resource_repository.dart';

class ResourceRepositoryImpl implements ResourceRepository {
  final ResourceRemoteDataSource resourceRemoteDataSource;

  ResourceRepositoryImpl({required this.resourceRemoteDataSource});

  @override
  Future<List<ResourceEntity>> fetchResources(String communityId) async {
    return await resourceRemoteDataSource.fetchResources(communityId);
  }

  @override
  Future<ResourceEntity> createResource(String communityId, String title, String description, String contactInfo, String category) async {
    return await resourceRemoteDataSource.createResource(
      communityId: communityId,
      title: title,
      description: description,
      contactInfo: contactInfo,
      category: category,
    );
  }

}