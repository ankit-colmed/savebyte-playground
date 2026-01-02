import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../models/login_request_model.dart';
import '../../core/error/exception.dart';
import '../../core/constants/app_constants.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(LoginRequestModel loginRequest);
  Future<UserModel> register(String name, String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<UserModel> login(LoginRequestModel loginRequest) async {
    try {
      final response = await _dio.post(
        '${AppConstants.baseUrl}/auth/login',
        data: loginRequest.toJson(),
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['data'] ?? response.data);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Login failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<UserModel> register(
      String name, String email, String password) async {
    try {
      final response = await _dio.post(
        '${AppConstants.baseUrl}/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromJson(response.data['data'] ?? response.data);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Registration failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    }
  }
}