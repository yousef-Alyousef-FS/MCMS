import 'package:medical_center/core/services/app_logger.dart';
import 'package:dio/dio.dart';

class AppInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.debug('[REQUEST] ${options.method} ${options.path}');

    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    AppLogger.debug(
      '[RESPONSE] ${response.statusCode} '
      '${response.requestOptions.path}',
    );

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      '[ERROR] ${err.type} '
      '${err.requestOptions.path}'
      'Stack trace: ${err.stackTrace}',
    );

    handler.next(err);
  }
}
