import 'package:dio/dio.dart';

class ApiClient {
  static Dio getDio() {
    final dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    return dio;
  }
}