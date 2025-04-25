import 'package:domochat/features/auth/data/models/user_model.dart';
import 'package:domochat/features/auth/domain/entities/user_entity.dart';

abstract class AuthState{}

class AuthInitial extends AuthState{}

class AuthLoading extends AuthState{}

class AuthSuccess extends AuthState {
  final String message;
  final UserModel user;

  AuthSuccess({required this.message, required this.user});
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure({required this.error});
}

class UsernameUpdatedState extends AuthState {
  final UserModel user;

  UsernameUpdatedState({required this.user});
}