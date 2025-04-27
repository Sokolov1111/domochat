
import 'package:domochat/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:domochat/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:domochat/features/auth/domain/usecases/login_use_case.dart';
import 'package:domochat/features/auth/domain/usecases/register_use_case.dart';
import 'package:domochat/features/auth/domain/usecases/update_username_use_case.dart';
import 'package:domochat/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:domochat/features/auth/presentation/pages/login_page.dart';
import 'package:domochat/features/auth/presentation/pages/profile_page.dart';
import 'package:domochat/features/auth/presentation/pages/register_page.dart';
import 'package:domochat/features/community/data/datasources/community_remote_data_source.dart';
import 'package:domochat/features/community/data/repositories/community_repository_impl.dart';
import 'package:domochat/features/community/domain/usecases/create_community_use_case.dart';
import 'package:domochat/features/community/domain/usecases/fetch_communities_use_case.dart';
import 'package:domochat/features/community/presentation/bloc/bloc_load_list/community_list_bloc.dart';
import 'package:domochat/features/community/presentation/bloc/community_bloc.dart';
import 'package:domochat/features/community/presentation/pages/create_community_page.dart';
import 'package:domochat/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  final authRepository = AuthRepositoryImpl(authRemoteDataSource: AuthRemoteDataSource());
  final communityRepository = CommunityRepositoryImpl(communityRemoteDataSource: CommunityRemoteDataSource());
  runApp(MyApp(
    authRepositoryImpl: authRepository,
    communityRepositoryImpl: communityRepository,
  ));
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImpl authRepositoryImpl;
  final CommunityRepositoryImpl communityRepositoryImpl;

  const MyApp({super.key, required this.authRepositoryImpl, required this.communityRepositoryImpl});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) => AuthBloc(
                  registerUseCase: RegisterUseCase(repository: authRepositoryImpl),
                  loginUseCase: LoginUseCase(repository: authRepositoryImpl),
                  updateUsernameUseCase: UpdateUsernameUseCase(repository: authRepositoryImpl)
              ),
          ),
          BlocProvider(
            create: (_) => CreateCommunityBloc(
                createCommunityUseCase: CreateCommunityUseCase(repository: communityRepositoryImpl)
            ),
          ),
            BlocProvider(
            create: (_) => CommunityListBloc(
                fetchCommunitiesUseCase: FetchCommunitiesUseCase(communityRepositoryImpl)
          ),),
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
            '/profilePage': (_) => ProfilePage(),
            '/createCommunityPage': (_) => CreateCommunityPage(),
          },
        ),
    );
  }
}