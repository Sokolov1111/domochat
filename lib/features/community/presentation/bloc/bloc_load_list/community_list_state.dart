
import 'package:domochat/features/community/domain/entities/community_entity.dart';

abstract class CommunityListState {}

class CommunityListInitial extends CommunityListState {}
class CommunityListLoading extends CommunityListState {}
class CommunityListLoaded extends CommunityListState {
  final List<CommunityEntity> communityList;

  CommunityListLoaded(this.communityList);
}
class CommunityListError extends CommunityListState {
  final String message;

  CommunityListError(this.message);
}