import 'package:medical_center/features/persons/domain/entities/person.dart';
import 'package:equatable/equatable.dart';

enum AddUpdateStatus { initial, submitting, success, failure }

class AddUpdateState extends Equatable {
  const AddUpdateState({
    this.status = AddUpdateStatus.initial,
    this.errorMessage,
    this.successMessage,
    this.person,
  });

  final AddUpdateStatus status;
  final String? errorMessage;
  final String? successMessage;
  final Person? person;

  @override
  List<Object?> get props => [status, errorMessage, successMessage, person];
}
