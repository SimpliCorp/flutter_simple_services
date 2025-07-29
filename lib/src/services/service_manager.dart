import 'package:dio/dio.dart';
import 'api_service.dart';
import 'dio_client.dart';

class ServiceManager {
  static ServiceManager? _instance;
  late ApiService _apiService;
  late DioClient _dioClient;

  ServiceManager._internal() {
    _dioClient = DioClient();
    _apiService = ApiService(_dioClient.dio);
  }

  factory ServiceManager() {
    _instance ??= ServiceManager._internal();
    return _instance!;
  }

  ApiService get apiService => _apiService;
  DioClient get dioClient => _dioClient;

  // Error handling
  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return Exception(
            'Connection timeout. Please check your internet connection.',
          );
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          switch (statusCode) {
            case 400:
              return Exception('Bad request. Please check your input.');
            case 401:
              return Exception('Unauthorized. Please login again.');
            case 403:
              return Exception('Forbidden. You don\'t have permission.');
            case 404:
              return Exception('Resource not found.');
            case 500:
              return Exception(
                'Internal server error. Please try again later.',
              );
            default:
              return Exception(
                'Server error: ${error.response?.statusMessage}',
              );
          }
        case DioExceptionType.cancel:
          return Exception('Request cancelled.');
        case DioExceptionType.connectionError:
          return Exception('No internet connection.');
        case DioExceptionType.unknown:
        default:
          return Exception('Something went wrong: ${error.message}');
      }
    }
    return Exception('Unexpected error: $error');
  }

  // Configuration methods
  void setBaseUrl(String baseUrl) {
    _dioClient.setBaseUrl(baseUrl);
  }

  void setAuthToken(String token) {
    _dioClient.setAuthToken(token);
  }

  void removeAuthToken() {
    _dioClient.removeAuthToken();
  }

  void enableLogging(bool enable) {
    _dioClient.enableLogging(enable);
  }
}
