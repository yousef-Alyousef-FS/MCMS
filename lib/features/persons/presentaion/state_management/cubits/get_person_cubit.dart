import 'package:medical_center/core/base/base_usecase.dart';
import 'package:medical_center/core/errors/failure_model.dart';
import 'package:medical_center/features/persons/domain/usecases/get_person_by_id.dart';
import 'package:medical_center/features/persons/domain/usecases/get_persons_info.dart';
import 'package:medical_center/features/persons/presentaion/state_management/states/get_person_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetPersonCubit extends Cubit<GetPersonState> {
  GetPersonCubit({
    required GetpersonsInfoUseCase getPersonsInfoUseCase,
    required GetPersonByIdUseCase personByIdUseCase,
  }) : _getpersonsInfoUseCase = getPersonsInfoUseCase,
       _getPersonByIdUseCase = personByIdUseCase,
       super(const GetPersonState.initial());

  final GetpersonsInfoUseCase _getpersonsInfoUseCase;
  final GetPersonByIdUseCase _getPersonByIdUseCase;

  Future<void> loadPersons() async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));
    final result = await _getpersonsInfoUseCase(const NoParams());
    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
      (persons) => emit(
        state.copyWith(
          isLoading: false,
          persons: persons,
          successMessage: 'تم تحميل بيانات المرضى بنجاح',
        ),
      ),
    );
  }

  Future<void> findPersonById(int id) async {
    emit(
      state.copyWith(
        isLoading: true,
        clearError: true,
        clearSuccess: true,
        clearPerson: true,
      ),
    );

    final result = await _getPersonByIdUseCase(GetPersonByIdParams(id: id));
    result.fold(
      (failure) {
        final message = failure is ServerFailure && failure.statusCode == 404
            ? 'no person found with id'
            : failure.message;
        emit(state.copyWith(isLoading: false, errorMessage: message));
      },
      (person) => emit(
        state.copyWith(
          isLoading: false,
          person: person,
          successMessage: 'found successfully',
        ),
      ),
    );
  }

  // Future<void> addPerson(Person person) async {
  //   emit(state.copyWith(isLoading: true, clearError: true, clearSucces: true));
  //   final result = await _addPersonUseCase(AddPersonParams(person: person));
  //   result.fold(
  //     (failure) {
  //       final message = failure is ServerFailure && failure.statusCode == 409
  //           ? 'the person with national id ${person.nationalID} already exist , check your personal info'
  //           : failure.message;
  //       emit(state.copyWith(isLoading: false, errorMessage: message));
  //     },
  //     (person) => emit(
  //       state.copyWith(isLoading: false, person: person, successMessage: 'Added successfully'),
  //     ),
  //   );
  // }

  void clearMessages() {
    emit(state.copyWith(clearError: true, clearSuccess: true));
  }
}
