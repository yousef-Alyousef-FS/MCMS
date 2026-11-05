import 'package:medical_center/core/errors/failure_model.dart';
import 'package:medical_center/features/persons/domain/entities/person.dart';
import 'package:medical_center/features/persons/domain/usecases/add_person.dart';
import 'package:medical_center/features/persons/domain/usecases/update_person.dart';
import 'package:medical_center/features/persons/presentaion/state_management/states/add_update_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddUpdateCubit extends Cubit<AddUpdateState> {
  AddUpdateCubit({required this._addPersonUseCase, required this._updatePersonUseCase}) : super(const AddUpdateState());

  final AddPersonUseCase _addPersonUseCase;
  final UpdatePersonUseCase _updatePersonUseCase;

  Future<void> addPerson(Person person) async {
    emit(const AddUpdateState(status: AddUpdateStatus.submitting));

    final result = await _addPersonUseCase(AddPersonParams(person: person));
    result.fold(
      (failure) {
        final message = failure is ServerFailure && failure.statusCode == 409
            ? 'A person with national ID ${person.nationalID} already exists'
            : failure.message;
        emit(AddUpdateState(status: AddUpdateStatus.failure, errorMessage: message));
      },
      (savedPerson) => emit(
        AddUpdateState(
          status: AddUpdateStatus.success,
          person: savedPerson,
          successMessage: 'Added successfully',
        ),
      ),
    );
  }

  Future<void> updatePerson(Person person) async {
    emit(const AddUpdateState(status: AddUpdateStatus.submitting));
    final result = await _updatePersonUseCase(UpdatePersonParams(person: person));
    result.fold(
      (failure) {
        final message = failure is ServerFailure && failure.statusCode == 409
            ? 'A person with national ID ${person.nationalID} already exists'
            : failure.message;
        emit(AddUpdateState(status: AddUpdateStatus.failure, errorMessage: message));
      },
      (updatedPerson) => emit(
        AddUpdateState(
          status: AddUpdateStatus.success,
          person: updatedPerson,
          successMessage: 'Updated successfully',
        ),
      ),
    );
  }

  void resetState() {
    emit(const AddUpdateState());
  }
}
