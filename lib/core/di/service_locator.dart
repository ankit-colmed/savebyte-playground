import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../network/dio_client.dart';
import '../local_storage/local_database.dart';
import '../local_storage/shared_preference_helper.dart';

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

  // Network
  getIt.registerSingleton<Dio>(
    DioClient.createDio(),
  );

  // Repositories (example)
  // getIt.registerSingleton<AuthRepository>(
  //   AuthRepositoryImpl(
  //     remoteDataSource: getIt<AuthRemoteDataSource>(),
  //     localDataSource: getIt<AuthLocalDataSource>(),
  //   ),
  // );

  // Use Cases
  // getIt.registerSingleton<LoginUseCase>(
  //   LoginUseCase(getIt<AuthRepository>()),
  // );

  // BLoCs
  // getIt.registerSingleton<AuthBloc>(
  //   AuthBloc(getIt<LoginUseCase>()),
  // );
}