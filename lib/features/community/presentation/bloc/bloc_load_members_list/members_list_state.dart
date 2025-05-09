
import 'package:domochat/features/community/domain/entities/member_entity.dart';

abstract class MembersListState {}

class MembersListInitial extends MembersListState {}

class MembersListLoading extends MembersListState {}

class MembersListLoaded extends MembersListState {
  final List<MemberEntity> membersList;

  MembersListLoaded(this.membersList);
}

class MembersListError extends MembersListState {
  final String message;

  MembersListError(this.message);
}