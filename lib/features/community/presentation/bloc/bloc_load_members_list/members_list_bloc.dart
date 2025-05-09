
import 'package:domochat/features/community/domain/usecases/fetch_community_members_use_case.dart';
import 'package:domochat/features/community/presentation/bloc/bloc_load_members_list/members_list_event.dart';
import 'package:domochat/features/community/presentation/bloc/bloc_load_members_list/members_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MembersListBloc extends Bloc<MembersListEvent, MembersListState> {
  final FetchCommunityMembersUseCase fetchCommunityMembersUseCase;

  MembersListBloc({required this.fetchCommunityMembersUseCase}) : super(MembersListInitial()) {
    on<FetchMembers>(_onFetchMembers);
  }

  Future<void> _onFetchMembers (FetchMembers event, Emitter<MembersListState> emit) async {
    emit(MembersListLoading());
    try {
      final members = await fetchCommunityMembersUseCase(event.communityId);
      emit(MembersListLoaded(members));
    } catch (err) {
      print("Failed to load members - $err");
      emit(MembersListError("Failed to load members"));
    }
  }
}