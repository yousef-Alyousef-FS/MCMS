import 'package:medical_center/core/errors/dio_exceptions.dart';
import 'package:medical_center/core/errors/exceptions.dart';
import 'package:medical_center/core/errors/failure_model.dart';
import 'package:medical_center/core/errors/network_exceptions.dart';
import 'package:dio/dio.dart';

abstract final class ErrorMapper {
  static Failure fromException(
    Object error,
    StackTrace stackTrace, {
    required String message,
  }) {
    final exception = switch (error) {
      DioException() => DioExceptionMapper.toException(error),
      AppException() => error,
      FormatException() => ParsingException(
        cause: error,
        stackTrace: stackTrace,
      ),
      _ => UnexpectedException(cause: error, stackTrace: stackTrace),
    };

    return switch (exception) {
      NetworkException() => NetworkFailure(message),
      ServerException(:final statusCode) => ServerFailure(
        message,
        statusCode: statusCode,
      ),
      RequestCancelledException() => RequestCancelledFailure(message),
      ParsingException() => ParsingFailure(message),
      _ => UnexpectedFailure(
        message,
        cause: error,
        stackTrace: stackTrace,
      ),
    };
  }
}
