import 'package:medical_center/core/networking/constants.dart';
import 'package:medical_center/core/networking/interceptors.dart';
import 'package:dio/dio.dart';

class DioFactory {
  Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: NetworkConstants.baseUrl,
        connectTimeout: NetworkConstants.connectTimeout,
        receiveTimeout: NetworkConstants.receiveTimeout,
        sendTimeout: NetworkConstants.sendTimeout,
        headers: NetworkConstants.defaultHeaders,
      ),
    );

    dio.interceptors.add(AppInterceptors());

    return dio;
  }
}
