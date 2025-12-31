import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

class DioClient {
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(
          milliseconds: AppConstants.connectTimeout,
        ),
        receiveTimeout: const Duration(
          milliseconds: AppConstants.receiveTimeout,
        ),
        contentType: 'application/json',
      ),
    );

    // Add interceptors
    dio.interceptors.add(_LoggingInterceptor());
    dio.interceptors.add(_ErrorInterceptor());

    return dio;
  }
}

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('📤 REQUEST[${options.method}] => PATH: ${options.path}');
    print('Headers: ${options.headers}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('📥 RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    super.onError(err, handler);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle global errors here
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        print('Connection timeout');
        break;
      case DioExceptionType.receiveTimeout:
        print('Receive timeout');
        break;
      case DioExceptionType.badResponse:
        print('Bad response: ${err.response?.statusCode}');
        break;
      case DioExceptionType.unknown:
        print('Unknown error');
        break;
      default:
        print('Error: ${err.message}');
    }
    super.onError(err, handler);
  }
}