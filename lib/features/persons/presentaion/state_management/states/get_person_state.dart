import 'package:medical_center/features/persons/domain/entities/person.dart';
import 'package:equatable/equatable.dart';

class GetPersonState extends Equatable {
  const GetPersonState({
    required this.isLoading,
    required this.persons,
    required this.person,
    this.errorMessage,
    this.successMessage,
  });

  const GetPersonState.initial()
    : isLoading = false,
      errorMessage = null,
      successMessage = null,
      persons = const [],
      person = null;

  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  final List<Person> persons;
  final Person? person;
  bool get isError => errorMessage != null;
  bool get isSuccess => successMessage != null;

  GetPersonState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    List<Person>? persons,
    Person? person,
    bool clearError = false,
    bool clearSuccess = false,
    bool clearPerson = false,
  }) {
    return GetPersonState(
      isLoading: isLoading ?? this.isLoading,
      persons: persons ?? this.persons,
      person: clearPerson ? null : person ?? this.person,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      successMessage: clearSuccess ? null : successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, successMessage, persons, person];
}
