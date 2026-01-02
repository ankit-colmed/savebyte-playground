import 'package:dio/dio.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/error/exception.dart';
import '../../core/error/failure.dart';
import '../../core/network/network_info.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/login_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo;

  @override
  Future<User?> login(String email, String password) async {
    try {
      final isConnected = await _networkInfo.isConnected;

      if (!isConnected) {
        // Try to get cached user
        final cachedUser = await _localDataSource.getUser();
        return cachedUser?.toEntity();
      }

      final loginRequest = LoginRequestModel(
        email: email,
        password: password,
      );

      final userModel = await _remoteDataSource.login(loginRequest);
      await _localDataSource.saveUser(userModel);

      return userModel.toEntity();
    } on ServerException catch (e) {
      rethrow;
    } on CacheException catch (e) {
      rethrow;
    } on DioException catch (e) {
      throw NetworkException(message: e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<User?> register(String name, String email, String password) async {
    try {
      final isConnected = await _networkInfo.isConnected;

      if (!isConnected) {
        throw NetworkException(message: 'No internet connection');
      }

      final userModel =
      await _remoteDataSource.register(name, email, password);
      await _localDataSource.saveUser(userModel);

      return userModel.toEntity();
    } on ServerException catch (e) {
      rethrow;
    } on CacheException catch (e) {
      rethrow;
    } on DioException catch (e) {
      throw NetworkException(message: e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<User?> getLoggedInUser() async {
    try {
      final userModel = await _localDataSource.getUser();
      return userModel?.toEntity();
    } on CacheException catch (e) {
      rethrow;
    } catch (e) {
      throw CacheException(message: 'Failed to get logged in user: $e');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return await _localDataSource.isUserLoggedIn();
    } on CacheException catch (e) {
      rethrow;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _localDataSource.deleteUser();
    } on CacheException catch (e) {
      rethrow;
    } catch (e) {
      throw CacheException(message: 'Failed to logout: $e');
    }
  }
}