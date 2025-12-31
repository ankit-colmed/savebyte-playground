import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import 'core/constants/app_constants.dart';
import 'core/di/service_locator.dart';
import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/local_storage/offline_sync_manager.dart';
import 'core/local_storage/local_database.dart';
import 'core/network/network_info.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/home/home_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup service locator
  await setupServiceLocator();

  // Initialize offline sync manager
  final syncManager = OfflineSyncManager(
    localDatabase: getIt<LocalDatabase>(),
    networkInfo: NetworkInfoImpl(),
    dio: getIt<Dio>(),
  );

  // Sync pending requests on app start
  await syncManager.syncPendingRequests();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => HomeBloc(),
        ),
        // Add other BLoCs here as needed
        // BlocProvider(
        //   create: (context) => ProfileBloc(),
        // ),
        // BlocProvider(
        //   create: (context) => SearchBloc(),
        // ),
      ],
      child: MaterialApp.router(
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}