
import 'package:medical_center/features/persons/data/datasource/person_remote_data_source.dart';

import '../../domain/enums/gender.dart';
import '../models/person.dart';

class PersonMockDataSource implements PersonRemoteDataSource {
  PersonMockDataSource()
    : _persons = [
        PersonModel(
          personID: 1,
          nationalID: '1000000001',
          firstName: 'Ahmed',
          middleName: 'Ali',
          lastName: 'Hassan',
          dateOfBirth: DateTime(1990, 5, 12),
          gender: Gender.male,
          phoneNumber: '0500000001',
          emergencyContact: '0500000002',
          address: 'Riyadh',
          jobTitle: 'Software Engineer',
        ),
        PersonModel(
          personID: 2,
          nationalID: '1000000002',
          firstName: 'Sara',
          middleName: 'Mohamed',
          lastName: 'Omar',
          dateOfBirth: DateTime(1994, 8, 20),
          gender: Gender.female,
          phoneNumber: '0500000003',
          address: 'Jeddah',
          jobTitle: 'Designer',
        ),
      ];

  final List<PersonModel> _persons;

  int get _nextId {
    if (_persons.isEmpty) return 1;

    return _persons
            .map((person) => person.personID)
            .reduce((first, second) => first > second ? first : second) +
        1;
  }

  @override
  Future<List<PersonModel>> getAllPersons() async {
    return List<PersonModel>.unmodifiable(_persons);
  }

  @override
  Future<PersonModel> getPersonById(int id) async {
    return _findById(id);
  }

  @override
  Future<PersonModel> addPerson(PersonModel person) async {
    final alreadyExists = _persons.any((item) => item.nationalID == person.nationalID);

    if (alreadyExists) {
      throw StateError('A person with national ID ${person.nationalID} already exists');
    }

    final createdPerson = PersonModel(
      personID: _nextId,
      nationalID: person.nationalID,
      firstName: person.firstName,
      middleName: person.middleName,
      lastName: person.lastName,
      dateOfBirth: person.dateOfBirth,
      gender: person.gender,
      phoneNumber: person.phoneNumber,
      emergencyContact: person.emergencyContact,
      address: person.address,
      jobTitle: person.jobTitle,
    );

    _persons.add(createdPerson);
    return createdPerson;
  }

  @override
  Future<PersonModel> updatePerson(PersonModel person) async {
    final index = _persons.indexWhere((item) => item.personID == person.personID);

    if (index == -1) {
      throw StateError('Person with id ${person.personID} was not found');
    }

    final duplicateNationalId = _persons.any(
      (item) => item.personID != person.personID && item.nationalID == person.nationalID,
    );

    if (duplicateNationalId) {
      throw StateError('A person with national ID ${person.nationalID} already exists');
    }

    _persons[index] = person;
    return person;
  }

  PersonModel _findById(int id) {
    for (final person in _persons) {
      if (person.personID == id) {
        return person;
      }
    }

    throw StateError('Person with id $id was not found');
  }
}
