import 'package:medical_center/core/base/base_usecase.dart';
import 'package:medical_center/core/errors/failure_model.dart';
import 'package:medical_center/features/persons/domain/entities/person.dart';
import 'package:medical_center/features/persons/domain/repository/person_repo_interface.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class AddPersonUseCase implements BaseUseCase<Person, AddPersonParams> {
  AddPersonUseCase(this._personRepository);
  final IPersonRepository _personRepository;

  @override
  Future<Either<Failure, Person>> call(AddPersonParams params) async {
    return await _personRepository.addPerson(params.person);
  }
}

class AddPersonParams extends Equatable {
  const AddPersonParams({required this.person});
  final Person person;

  @override
  List<Object?> get props => [person];
}
