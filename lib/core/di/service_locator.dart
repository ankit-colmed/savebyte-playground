import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../../data/datasources/auth_local_data_source.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_logged_in_user_usecase.dart';
import '../../domain/usecases/is_logged_in_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/bloc/home/home_bloc.dart';
import '../../presentation/bloc/profile/profile_bloc.dart';
import '../../presentation/bloc/search/search_bloc.dart';
import '../network/dio_client.dart';
import '../local_storage/local_database.dart';
import '../local_storage/shared_preference_helper.dart';
import '../network/network_info.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Local Storage
  final localDatabase = LocalDatabase();
  await localDatabase.init();
  getIt.registerSingleton<LocalDatabase>(localDatabase);

  getIt.registerSingleton<SharedPreferenceHelper>(
    SharedPreferenceHelper(getIt<SharedPreferences>()),
  );

  // BLoCs
  getIt.registerSingleton<HomeBloc>(
    HomeBloc(),
  );

  getIt.registerSingleton<ProfileBloc>(
    ProfileBloc(),
  );

  getIt.registerSingleton<SearchBloc>(
    SearchBloc(),
  );

  // Network
  getIt.registerSingleton<Dio>(
    DioClient.createDio(),
  );

  getIt.registerSingleton<NetworkInfo>(
    NetworkInfoImpl(),
  );

  // Data Sources
  getIt.registerSingleton<AuthRemoteDataSource>(
    AuthRemoteDataSourceImpl(dio: getIt<Dio>()),
  );

  getIt.registerSingleton<AuthLocalDataSource>(
    AuthLocalDataSourceImpl(
      localDatabase: getIt<LocalDatabase>(),
      preferences: getIt<SharedPreferenceHelper>(),
    ),
  );

  // Repository
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<AuthLocalDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  // Use Cases
  getIt.registerSingleton<LoginUseCase>(
    LoginUseCase(repository: getIt<AuthRepository>()),
  );

  getIt.registerSingleton<RegisterUseCase>(
    RegisterUseCase(repository: getIt<AuthRepository>()),
  );

  getIt.registerSingleton<LogoutUseCase>(
    LogoutUseCase(repository: getIt<AuthRepository>()),
  );

  getIt.registerSingleton<GetLoggedInUserUseCase>(
    GetLoggedInUserUseCase(repository: getIt<AuthRepository>()),
  );

  getIt.registerSingleton<IsLoggedInUseCase>(
    IsLoggedInUseCase(repository: getIt<AuthRepository>()),
  );

  // BLoCs
  getIt.registerSingleton<AuthBloc>(
    AuthBloc(
      loginUseCase: getIt<LoginUseCase>(),
      registerUseCase: getIt<RegisterUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      getLoggedInUserUseCase: getIt<GetLoggedInUserUseCase>(),
      isLoggedInUseCase: getIt<IsLoggedInUseCase>(),
    ),
  );
}