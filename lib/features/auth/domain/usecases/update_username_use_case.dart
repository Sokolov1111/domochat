
import 'package:domochat/features/auth/domain/entities/user_entity.dart';
import 'package:domochat/features/auth/domain/repositoties/auth_repository.dart';

class UpdateUsernameUseCase {
  final AuthRepository repository;

  UpdateUsernameUseCase({required this.repository});

  Future<UserEntity> call(String newUsername) {
    return repository.updateUsername(newUsername);
  }
}