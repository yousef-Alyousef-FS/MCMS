import 'package:equatable/equatable.dart';
import 'package:medical_center/core/errors/failure_model.dart';

enum BaseStatus { initial, loading, success, failure }

class BaseState<T> extends Equatable {
  const BaseState({
    required this.status,
    this.data,
    this.failure,
  });

  const BaseState.initial()
    : status = BaseStatus.initial,
      data = null,
      failure = null;

  const BaseState.loading({this.data})
    : status = BaseStatus.loading,
      failure = null;

  const BaseState.success(this.data)
    : status = BaseStatus.success,
      failure = null;

  const BaseState.failure(this.failure, {this.data})
    : status = BaseStatus.failure;

  final BaseStatus status;
  final T? data;
  final Failure? failure;

  bool get isInitial => status == BaseStatus.initial;
  bool get isLoading => status == BaseStatus.loading;
  bool get isSuccess => status == BaseStatus.success;
  bool get isFailure => status == BaseStatus.failure;

  BaseState<T> copyWith({
    BaseStatus? status,
    T? data,
    Failure? failure,
    bool clearData = false,
    bool clearFailure = false,
  }) {
    return BaseState<T>(
      status: status ?? this.status,
      data: clearData ? null : data ?? this.data,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, data, failure];
}
