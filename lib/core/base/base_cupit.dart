import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_center/core/base/base_state.dart';
import 'package:medical_center/core/errors/failure_model.dart';

abstract class BaseCubit<T> extends Cubit<BaseState<T>> {
  BaseCubit() : super(const BaseState.initial());

  void emitLoading() {
    emit(BaseState<T>.loading(data: state.data));
  }

  void emitSuccess(T data) {
    emit(BaseState<T>.success(data));
  }

  void emitFailure(Failure failure) {
    emit(BaseState<T>.failure(failure, data: state.data));
  }
}
