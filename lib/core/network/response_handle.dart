import 'package:dio/dio.dart';
import 'package:hmlegends/core/network/network_service.dart';

class ResponseHandle {
  static dynamic handleResponse(Response response) {
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i("Response Url : ${response.realUri}");
        logger.i("Response body : ${response.data}");
        return response.data;
      } else {
        logger.e("Error Response : ${response.statusCode} - ${response.data}");
        throw Exception("Error : ${response.statusCode}, ${response.data}");
      }
    } catch (e) {
      throw Exception("Failed to parse response : $e");
    }
  }
}
