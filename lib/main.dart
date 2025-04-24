
import 'package:domochat/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:domochat/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:domochat/features/auth/domain/usecases/login_use_case.dart';
import 'package:domochat/features/auth/domain/usecases/register_use_case.dart';
import 'package:domochat/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:domochat/features/auth/presentation/pages/login_page.dart';
import 'package:domochat/features/auth/presentation/pages/register_page.dart';
import 'package:domochat/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  final authRepository = AuthRepositoryImpl(authRemoteDataSource: AuthRemoteDataSource());
  runApp(MyApp(
    authRepositoryImpl: authRepository,
  ));
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImpl authRepositoryImpl;

  const MyApp({super.key, required this.authRepositoryImpl});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) => AuthBloc(
                  registerUseCase: RegisterUseCase(repository: authRepositoryImpl),
                  loginUseCase: LoginUseCase(repository: authRepositoryImpl)
              )
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          home: LoginPage(),
          routes: {
            '/login': (_) => LoginPage(),
            '/register': (_) => RegisterPage(),
            '/homePage' : (_) => HomePage(),
          },
        ),
    );
  }
}