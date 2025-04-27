
import 'package:domochat/features/auth/data/models/user_model.dart';
import 'package:domochat/features/auth/domain/usecases/login_use_case.dart';
import 'package:domochat/features/auth/domain/usecases/register_use_case.dart';
import 'package:domochat/features/auth/domain/usecases/update_username_use_case.dart';
import 'package:domochat/features/auth/presentation/bloc/auth_event.dart';
import 'package:domochat/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;
  final UpdateUsernameUseCase updateUsernameUseCase;
  final _storage = FlutterSecureStorage();

  AuthBloc({required this.registerUseCase, required this.loginUseCase, required this.updateUsernameUseCase})
    : super(AuthInitial()) {
      on<RegisterEvent>(_onRegister);
      on<LoginEvent>(_onLogin);
      on<UpdateUsernameEvent>(_onUpdateUsername);
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await registerUseCase(event.username, event.email, event.password);
      emit(AuthSuccess(message: "Registration successful", user: user as UserModel));
    } catch (e) {
      emit(AuthFailure(error: "Registration failed"));
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await loginUseCase(event.email, event.password);
      await _storage.write(key: 'token', value: user.token);
      await _storage.write(key: 'userId', value: user.id);
      await _storage.write(key: 'userName', value: user.username);
      print('token ${user.token}');
      emit(AuthSuccess(message: "Login successful", user: user as UserModel));
    } catch (e) {
      emit(AuthFailure(error: "Login failed"));
    }
  }

  Future<void> _onUpdateUsername(UpdateUsernameEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      final updatedUser = await updateUsernameUseCase(event.newUsername) as UserModel;
      await _storage.write(key: 'userName', value: updatedUser.username);
      emit(AuthSuccess(message: "Имя обновлено", user: updatedUser));
    } catch (e) {
      if(state is AuthSuccess) {
        emit(state);
      }
      emit(AuthFailure(error: 'Failed to update username'));
    }
  }

}