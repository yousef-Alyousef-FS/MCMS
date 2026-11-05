import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.statusCode});

  final int? statusCode;

  @override
  List<Object?> get props => [...super.props, statusCode];
}

class ParsingFailure extends Failure {
  const ParsingFailure(super.message);
}

class RequestCancelledFailure extends Failure {
  const RequestCancelledFailure(super.message);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message, {required this.cause, required this.stackTrace});

  final Object cause;
  final StackTrace stackTrace;

  @override
  List<Object?> get props => [...super.props, cause, stackTrace];
}
