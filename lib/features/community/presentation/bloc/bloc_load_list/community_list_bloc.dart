
import 'package:domochat/features/community/domain/usecases/fetch_communities_use_case.dart';
import 'package:domochat/features/community/presentation/bloc/bloc_load_list/community_list_event.dart';
import 'package:domochat/features/community/presentation/bloc/bloc_load_list/community_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommunityListBloc extends Bloc<CommunityListEvent, CommunityListState> {
  final FetchCommunitiesUseCase fetchCommunitiesUseCase;

  CommunityListBloc({required this.fetchCommunitiesUseCase}) : super(
    CommunityListInitial()
  ) {
    on<FetchCommunities>(_onFetchCommunities);
  }

  Future<void> _onFetchCommunities (FetchCommunities event, Emitter<CommunityListState> emit) async {
    emit(CommunityListLoading());
    try {
      final communities = await fetchCommunitiesUseCase();
      emit(CommunityListLoaded(communities));
    } catch (error) {
      emit(CommunityListError('Failed to load comms'));
    }
  }
}