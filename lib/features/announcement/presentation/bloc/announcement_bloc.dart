
import 'package:domochat/features/announcement/domain/usecases/fetch_announcements_use_case.dart';
import 'package:domochat/features/announcement/presentation/bloc/announcement_event.dart';
import 'package:domochat/features/announcement/presentation/bloc/announcement_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnnouncementBloc extends Bloc<AnnouncementEvent, AnnouncementState> {
  final FetchAnnouncementsUseCase fetchAnnouncementsUseCase;

  AnnouncementBloc({required this.fetchAnnouncementsUseCase}) : super (AnnouncementInitialState()) {
    on<FetchAnnouncements>(_onFetchAnnouncements);
  }

  Future<void> _onFetchAnnouncements (FetchAnnouncements event, Emitter<AnnouncementState> emit) async {
    emit(AnnouncementLoadingState());
    try {
      final announcements = await fetchAnnouncementsUseCase(event.communityId);
      emit(AnnouncementLoadedState(announcements));
    } catch (err) {
      print(err);
      emit(AnnouncementErrorState("Failed to load announcements"));
    }
  }
}