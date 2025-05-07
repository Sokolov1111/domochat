
import 'package:domochat/features/resource/domain/usecases/create_resource_use_case.dart';
import 'package:domochat/features/resource/domain/usecases/fetch_resources_use_case.dart';
import 'package:domochat/features/resource/presentation/bloc/resource_event.dart';
import 'package:domochat/features/resource/presentation/bloc/resource_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResourceBloc extends Bloc<ResourceEvent, ResourceState> {
  final FetchResourcesUseCase fetchResourcesUseCase;
  final CreateResourceUseCase createResourceUseCase;

  ResourceBloc({required this.fetchResourcesUseCase, required this.createResourceUseCase})
      : super(ResourceInitialState()) {
        on<FetchResources>(_onFetchResources);
        on<CreateResourceSubmitted>(_onCreateResource);
  }

  Future<void> _onFetchResources (FetchResources event, Emitter<ResourceState> emit) async {
    emit(ResourceLoadingState());
    try {
      final resources = await fetchResourcesUseCase(event.communityId);
      emit(ResourceLoadedState(resources));
    } catch (err) {
      print(err);
      emit(ResourceErrorState('Failed to load resources'));
    }
  }

  Future<void> _onCreateResource (CreateResourceSubmitted event, Emitter<ResourceState> emit) async {
    emit(ResourceLoadingState());
    try {
      final resourceModel = await createResourceUseCase(
        event.communityId,
        event.title,
        event.description,
        event.contactInfo,
        event.category,
      );
      emit(CreateResourceSuccess(message: "OK", resourceEntity: resourceModel));
    } catch (e) {
      print("Failed to create res - $e");
      emit(ResourceErrorState("Failed to create res - $e"));
    }
  }
}