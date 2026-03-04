import 'package:dio/dio.dart';

import 'network_service.dart';

class ErrorHandle {

  static String handleDioError(DioException e) {

    switch (e.type) {
      case DioExceptionType.badCertificate:
        logger.e("error: ${e.message}");
        return "Bad certificate. Please try again.";
      case DioExceptionType.badResponse:
        logger.e("badResponse: ${e.message}");
        if (e.response != null) {
          logger.e("Status Code: ${e.response?.statusCode}");
          logger.e("Response Data: ${e.response?.data}");
          // return e.response?.data;
        }
        logger.e("error: ${e.message}");
        if (e.response != null && e.response?.data != null) {
          // Attempt to extract a message from server
          final data = e.response?.data;
          if (data is Map<String, dynamic> && data['message'] != null) {
            return data['message'].toString();
          }
          return "Server error: ${e.response?.statusCode}";
        }
        return "Server error: ${e.message}";
      case DioExceptionType.cancel:
        logger.e("error: ${e.message}");
        return "Request was cancelled.";
      case DioExceptionType.connectionError:
        logger.e("error: ${e.message}");
        return "Connection error. Please check your internet.";
      case DioExceptionType.connectionTimeout:
        logger.e("error: ${e.message}");
        return "Connection timeout. Please try again.";
      case DioExceptionType.receiveTimeout:
        logger.e("error: ${e.message}");
        return "Receive timeout. Please try again.";
      case DioExceptionType.sendTimeout:
        logger.e("error: ${e.message}");
        return "Send timeout. Please try again.";
      case DioExceptionType.unknown:
        logger.e("error: ${e.message}");
        return "Unknown error occurred. Please try again.";
    }
  }
}