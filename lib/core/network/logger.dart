import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'exception_handler/data_source.dart';

final class LoggerInterceptor extends Interceptor {
  final logger = Logger();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.d("= = = = = Dio Request = = = = =");
    logger.i(options.path);
    logger.i("${options.data}");
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.d("= = = Dio Success Response = = =");
    logger.i(response.realUri);
    logger.i("${response.statusCode}");
    logger.i(json.encode(response.data));
    logger.i("${response.statusMessage}");
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      logger.i("= = = Dio Error Response = = =");
      logger.i('Error Response: ${err.response}');
      logger.i('Error Message: ${err.message}');
      logger.i('Error Type: ${err.type}');
      logger.i('Error: ${err.error}');
      logger.i('Error Req option: ${err.requestOptions}');
    }
    ErrorHandler.handle(err).failure;
    return super.onError(err, handler);
  }
}
