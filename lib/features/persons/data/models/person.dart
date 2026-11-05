
import '../../domain/entities/person.dart';
import '../../domain/enums/gender.dart';

class PersonModel extends Person {
  PersonModel({
    required super.personID,
    required super.nationalID,
    required super.firstName,
    required super.middleName,
    required super.lastName,
    required super.dateOfBirth,
    required super.gender,
    required super.phoneNumber,
    super.emergencyContact,
    super.address,
    super.jobTitle,
  });

  factory PersonModel.fromEntity(Person person) {
    return PersonModel(
      personID: person.personID,
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
  }

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      personID: json['personID'] as int,
      nationalID: json['nationalID'] as String,
      firstName: json['firstName'] as String,
      middleName: json['middleName'] as String,
      lastName: json['lastName'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      gender: switch (json['gender'] as int) {
        0 => Gender.male,
        1 => Gender.female,
        final value => throw FormatException('Unsupported gender value: $value'),
      },
      phoneNumber: json['phoneNumber'] as String,
      emergencyContact: json['emergencyContact'] as String?,
      address: json['address'] as String?,
      jobTitle: json['jobTitle'] as String?,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'personID': personID,
      'nationalID': nationalID,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender.value,
      'phoneNumber': phoneNumber,
      'emergencyContact': emergencyContact,
      'address': address,
      'jobTitle': jobTitle,
    };
  }
}
