// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import 'core/constants/app_constants.dart';
import 'core/di/service_locator.dart';
import 'core/navigation/app_navigation.dart';
import 'core/theme/app_theme.dart';
import 'core/local_storage/offline_sync_manager.dart';
import 'core/local_storage/local_database.dart';
import 'core/network/network_info.dart';

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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      routerConfig: AppNavigation.buildRouter(),
      debugShowCheckedModeBanner: false,
    );
  }
}