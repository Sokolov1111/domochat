
import 'package:domochat/features/resource/domain/usecases/fetch_resources_use_case.dart';
import 'package:domochat/features/resource/presentation/bloc/resource_event.dart';
import 'package:domochat/features/resource/presentation/bloc/resource_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResourceBloc extends Bloc<ResourceEvent, ResourceState> {
  final FetchResourcesUseCase fetchResourcesUseCase;

  ResourceBloc({required this.fetchResourcesUseCase}) : super(ResourceInitialState()) {
    on<FetchResources>(_onFetchResources);
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
}