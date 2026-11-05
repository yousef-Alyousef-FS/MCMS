import 'package:medical_center/core/base/base_usecase.dart';
import 'package:medical_center/core/errors/failure_model.dart';
import 'package:medical_center/features/persons/domain/entities/person.dart';
import 'package:medical_center/features/persons/domain/repository/person_repo_interface.dart';
import 'package:dartz/dartz.dart';

class GetpersonsInfoUseCase extends BaseUseCase<List<Person>, NoParams> {
  GetpersonsInfoUseCase(this._personRepository);
  final IPersonRepository _personRepository;

  @override
  Future<Either<Failure, List<Person>>> call(NoParams params) {
    return _personRepository.getAllPersons();
  }
}
