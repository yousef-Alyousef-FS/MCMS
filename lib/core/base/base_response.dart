import 'package:equatable/equatable.dart';

class BaseResponse<T> extends Equatable {
  const BaseResponse({
    required this.data,
    this.message,
    this.statusCode,
  });

  final T data;
  final String? message;
  final int? statusCode;

  @override
  List<Object?> get props => [data, message, statusCode];
}
