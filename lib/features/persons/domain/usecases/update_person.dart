import 'package:medical_center/core/base/base_usecase.dart';
import 'package:medical_center/core/errors/failure_model.dart';
import 'package:medical_center/features/persons/domain/entities/person.dart';
import 'package:medical_center/features/persons/domain/repository/person_repo_interface.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class UpdatePersonUseCase implements BaseUseCase<Person, UpdatePersonParams> {
  UpdatePersonUseCase(this._personRepository);
  final IPersonRepository _personRepository;

  @override
  Future<Either<Failure, Person>> call(UpdatePersonParams params) async {
    return await _personRepository.updatePerson(params.person);
  }
}

class UpdatePersonParams extends Equatable {
  const UpdatePersonParams({required this.person});
  final Person person;

  @override
  List<Object?> get props => [person];

}
