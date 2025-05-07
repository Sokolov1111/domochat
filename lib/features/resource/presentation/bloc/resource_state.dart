
import 'package:domochat/features/resource/domain/entities/resource_entity.dart';

abstract class ResourceState {}

class ResourceInitialState extends ResourceState {}
class ResourceLoadingState extends ResourceState {}

class ResourceLoadedState extends ResourceState {
  final List<ResourceEntity> resources;
  ResourceLoadedState(this.resources);
}

class ResourceErrorState extends ResourceState {
  final String message;
  ResourceErrorState(this.message);
}