import 'package:dartz/dartz.dart';

import '../../../../core/base/base_repository.dart';
import '../../../../core/errors/failure_model.dart';
import '../../domain/entities/person.dart';
import '../../domain/repository/person_repo_interface.dart';
import '../datasource/person_remote_data_source.dart';
import '../models/person.dart';

class PersonRepository extends BaseRepository implements IPersonRepository {
  PersonRepository(this._personRemoteDataSource);
  final PersonRemoteDataSource _personRemoteDataSource;
  @override
  Future<Either<Failure, List<Person>>> getAllPersons() {
    return execute(_personRemoteDataSource.getAllPersons, errorMessage: 'Failed to load persons');
  }

  @override
  Future<Either<Failure, Person>> getPersonById(int id) {
    return execute(
      () => _personRemoteDataSource.getPersonById(id),
      errorMessage: 'Failed to fetch',
    );
  }

  @override
  Future<Either<Failure, Person>> addPerson(Person person) {
    final model = PersonModel.fromEntity(person);
    return execute(
      () => _personRemoteDataSource.addPerson(model),
      errorMessage: 'Failed to add this person',
    );
  }

  @override
  Future<Either<Failure, Person>> updatePerson(Person person) {
    final model = PersonModel.fromEntity(person);
    return execute(
      () => _personRemoteDataSource.updatePerson(model),
      errorMessage: 'Failed to update this person',
    );
  }
}
