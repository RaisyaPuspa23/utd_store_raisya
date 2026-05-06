import 'package:dio/dio.dart';

class DioClient {
  final dio = Dio();

  DioClient() {
    dio.interceptors.add(
      LogInterceptor(responseBody: true),
    );
  }
}