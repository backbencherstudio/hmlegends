import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../constant/api_endpoint.dart';
import '../services/token_storage.dart';
import 'logger.dart';

final logger = Logger();

class Network {
  static final Network _instance = Network._internal();

  factory Network() => _instance;
  late Dio dio;

  Network._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    dio = Dio(options);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenStorage().getToken();
          logger.d('Injected Token: $token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );

    /// --------------------- For debug logging --------------------------------
    // dio.interceptors.add(LoggerInterceptor());
  }
}
