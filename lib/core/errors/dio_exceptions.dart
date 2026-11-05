import 'package:medical_center/core/errors/exceptions.dart';
import 'package:medical_center/core/errors/network_exceptions.dart';
import 'package:dio/dio.dart';

abstract final class DioExceptionMapper {
  static AppException toException(DioException error) {
    final stackTrace = error.stackTrace;

    if (error.error is FormatException) {
      return ParsingException(cause: error.error, stackTrace: stackTrace);
    }

    return switch (error.type) {
      DioExceptionType.badResponse => ServerException(
        statusCode: error.response?.statusCode,
        cause: error,
        stackTrace: stackTrace,
      ),
      DioExceptionType.cancel => RequestCancelledException(cause: error, stackTrace: stackTrace),
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout ||
      DioExceptionType.connectionError ||
      DioExceptionType.badCertificate ||
      DioExceptionType.unknown => NetworkException(cause: error, stackTrace: stackTrace),
    };
  }
}
