import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure_model.dart';
import '../entities/person.dart';

abstract class IPersonRepository {
  Future<Either<Failure, List<Person>>> getAllPersons();
  Future<Either<Failure,Person>> getPersonById(int id);
  Future<Either<Failure,Person>> addPerson(Person person);
  Future<Either<Failure,Person>> updatePerson(Person person);
  // Future<void> deletePerson(int id);
}
