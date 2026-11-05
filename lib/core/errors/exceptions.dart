abstract class AppException implements Exception {
  const AppException({this.cause, this.stackTrace});

  final Object? cause;
  final StackTrace? stackTrace;
}

final class ParsingException extends AppException {
  const ParsingException({super.cause, super.stackTrace});
}

final class UnexpectedException extends AppException {
  const UnexpectedException({super.cause, super.stackTrace});
}
