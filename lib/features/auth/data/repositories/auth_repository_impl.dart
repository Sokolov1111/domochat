
import 'package:domochat/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:domochat/features/auth/domain/entities/user_entity.dart';
import 'package:domochat/features/auth/domain/repositoties/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl({required this.authRemoteDataSource});

  @override
  Future<UserEntity> login(String email, String password) async {
    return await authRemoteDataSource.login(email: email, password: password);
  }

  @override
  Future<UserEntity> register(String username, String email, String password) async {
    return await authRemoteDataSource.register(username: username, email: email, password: password);
  }


}