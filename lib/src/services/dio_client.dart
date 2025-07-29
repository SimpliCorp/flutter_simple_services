import 'package:dio/dio.dart';
import 'package:flutter_simple_services/src/responses/error_response.dart';
import 'package:logger/logger.dart';

import 'simple_services_manager.dart';

class DioClient {
  static DioClient? _instance;
  late Dio _dio;
  final Logger _logger = Logger();

  DioClient._internal() {
    _dio = Dio();
    _setupInterceptors();
  }

  factory DioClient() {
    _instance ??= DioClient._internal();
    return _instance!;
  }

  Dio get dio => _dio;

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _logger.i('REQUEST[${options.method}] => PATH: ${options.path}');
          _logger.d('Request data: ${options.data}');
          _logger.d('Request headers: ${options.headers}');

          // Add header token
          String token = SimpleServicesManager.instance.accessToken;
          if (token.isNotEmpty) {
            options.headers.addAll({
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            });
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.i(
            'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
          );
          _logger.d('Response data: ${response.data}');
          handler.next(response);
        },
        onError: (error, handler) {
          _logger.e(
            'ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}',
          );
          _logger.e('Error message: ${error.message}');
          _logger.e('Error data: ${error.response?.data}');

          if ((error.response?.statusCode ?? 500) <= 400) {
            // Handle unauthorized error
            ErrorResponse errorModel = errorResponseFromJson(
              error.response?.data ?? '{}',
            );

            if (errorModel.id != null && errorModel.detail != null) {}
          }

          handler.next(error);
        },
      ),
    );

    // Add timeout
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.sendTimeout = const Duration(seconds: 30);

    // Add default headers
    _dio.options.headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
  }

  void setBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  void addHeader(String key, String value) {
    _dio.options.headers[key] = value;
  }

  void removeHeader(String key) {
    _dio.options.headers.remove(key);
  }

  void enableLogging(bool enable) {
    if (enable) {
      if (!_dio.interceptors.any(
        (interceptor) => interceptor is LogInterceptor,
      )) {
        _dio.interceptors.add(
          LogInterceptor(
            request: true,
            requestHeader: true,
            requestBody: true,
            responseHeader: true,
            responseBody: true,
            error: true,
          ),
        );
      }
    } else {
      _dio.interceptors.removeWhere(
        (interceptor) => interceptor is LogInterceptor,
      );
    }
  }
}
