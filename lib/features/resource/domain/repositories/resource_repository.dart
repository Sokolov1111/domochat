
import 'package:domochat/features/resource/domain/entities/resource_entity.dart';

abstract class ResourceRepository {
  Future<List<ResourceEntity>> fetchResources (String communityId);
}