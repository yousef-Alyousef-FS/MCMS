import 'package:medical_center/core/base/base_usecase.dart';
import 'package:medical_center/core/errors/failure_model.dart';
import 'package:medical_center/features/persons/domain/entities/person.dart';
import 'package:medical_center/features/persons/domain/repository/person_repo_interface.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetPersonByIdUseCase implements BaseUseCase<Person, GetPersonByIdParams> {
  GetPersonByIdUseCase(this._personRepository);
  final IPersonRepository _personRepository;

  @override
  Future<Either<Failure, Person>> call(GetPersonByIdParams params) async {
    return await _personRepository.getPersonById(params.id);
  }
}

class GetPersonByIdParams extends Equatable {
  const GetPersonByIdParams({required this.id});
  final int id;

  @override
  List<Object?> get props => [id];
}
