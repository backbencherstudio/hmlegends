import 'package:dio/dio.dart';
import 'package:hmlegends/core/constant/api_endpoint.dart';
import 'package:hmlegends/core/network/error_response.dart';
import 'package:hmlegends/core/network/response_handle.dart';
import 'package:hmlegends/core/services/token_storage.dart';

import '../network/network_service.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  final _tokenStorage = TokenStorage();

  /// --------------------- Function to get data (GET request) -----------------
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final token = await _tokenStorage.getToken();
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      logger.d(token);
      return ResponseHandle.handleResponse(response);
    } catch (e) {
      if (e is DioException) {
        return {
          'success': false,
          'message': ErrorHandle.handleDioError(e),
          'statusCode': e.response?.statusCode ?? 0,
        };
      } else {
        return {
          'success': false,
          'message': 'An unexpected error occurred : $e',
          'statusCode': 0,
        };
      }
    }
  }

  /// -------------------- Function to post data (POST request) ----------------
  Future<dynamic> postHttp(
    String path, {
    Map<String, dynamic>? data,
    FormData? formData,
  }) async {
    try {
      final token = await _tokenStorage.getToken();
      // If formData is provided, use it for the POST request
      // if (formData != null) {
      //   return await _dio.post(path, data: formData, options: Options(
      //     headers: {
      //       'Content-Type' : 'application/json',
      //       'Authorization' : 'Bearer $token'
      //     }
      //   ));
      // }
      // If regular data is provided, send it with options (headers)
      final response = await _dio.post(
        path,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return ResponseHandle.handleResponse(response);
    } catch (e) {
      if (e is DioException) {
        return {
          'success': false,
          'message': ErrorHandle.handleDioError(e),
          'statusCode': e.response?.statusCode ?? 0,
        };
      } else {
        return {
          'success': false,
          'message': 'An unexpected error occurred : $e',
          'statusCode': 0,
        };
      }
    }
  }

  /// ----------------- Function to put data (PUT request) ---------------------
  Future<dynamic> put(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return ResponseHandle.handleResponse(response);
    } catch (e) {
      if (e is DioException) {
        return {
          'success': false,
          'message': ErrorHandle.handleDioError(e),
          'statusCode': e.response?.statusCode ?? 0,
        };
      } else {
        return {
          'success': false,
          'message': 'An unexpected error occurred : $e',
          'statusCode': 0,
        };
      }
    }
  }

  /// ------------------ Function to delete data (DELETE request) --------------
  Future<dynamic> delete(String path, {Map<String, dynamic>? data}) async {
    try {
      return await _dio.delete(path, data: data);
    } catch (e) {
      rethrow;
    }
  }

  /// ------------------ Function to patch data (PATCH request) ----------------
  Future<dynamic> patch(
    String path, {
    Map<String, dynamic>? data,
    FormData? formData,
  }) async {
    try {
      final token = await _tokenStorage.getToken();
      final response = await _dio.patch(
        path,
        data: data ?? formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return ResponseHandle.handleResponse(response);
    } catch (e) {
      if (e is DioException) {
        return {
          'success': false,
          'message': ErrorHandle.handleDioError(e),
          'statusCode': e.response?.statusCode ?? 0,
        };
      } else {
        return {
          'success': false,
          'message': 'An unexpected error occurred : $e',
          'statusCode': 0,
        };
      }
    }
  }
}
