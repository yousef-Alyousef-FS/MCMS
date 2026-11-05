
import 'package:medical_center/core/errors/exceptions.dart';

final class NetworkException extends AppException {
  const NetworkException({super.cause, super.stackTrace});
}

final class ServerException extends AppException {
  const ServerException({
    this.statusCode,
    super.cause,
    super.stackTrace,
  });

  final int? statusCode;
}

final class RequestCancelledException extends AppException {
  const RequestCancelledException({super.cause, super.stackTrace});
}
