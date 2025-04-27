
import 'package:domochat/features/community/data/models/community_model.dart';
import 'package:domochat/features/community/domain/usecases/create_community_use_case.dart';
import 'package:domochat/features/community/presentation/bloc/community_event.dart';
import 'package:domochat/features/community/presentation/bloc/community_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateCommunityBloc extends Bloc<CreateCommunityEvent, CreateCommunityState> {
  final CreateCommunityUseCase createCommunityUseCase;

  CreateCommunityBloc({required this.createCommunityUseCase})
      : super(CreateCommunityInitial()) {
      on<CreateCommunitySubmitted>(_onCreateCommunity);
  }

  Future<void> _onCreateCommunity (CreateCommunitySubmitted event, Emitter<CreateCommunityState> emit) async {
    emit(CreateCommunityLoading());
    try {
      final communityModel = await createCommunityUseCase(
          event.city,
          event.street,
          event.house,
          event.creatorId,
          event.fullName,
          event.apartment,
          event.residentStatus,
      );
      emit(CreateCommunitySuccess(message: "Vse good", communityModel: communityModel as CommunityModel));
    } catch (e) {
      print(e);
      emit(CreateCommunityFailure(error: "Create comm-ty failed"));
    }
  }
}