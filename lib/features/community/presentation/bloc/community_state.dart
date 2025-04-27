import 'package:domochat/features/community/data/models/community_model.dart';

abstract class CreateCommunityState {}

class CreateCommunityInitial extends CreateCommunityState {}
class CreateCommunitySuccess extends CreateCommunityState {
  final String message;
  final CommunityModel communityModel;

  CreateCommunitySuccess({required this.message, required this.communityModel});
}

class CreateCommunityFailure extends CreateCommunityState {
  final String error;

  CreateCommunityFailure({required this.error});
}

class CreateCommunityLoading extends CreateCommunityState {}