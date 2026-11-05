
import '../enums/gender.dart';

class Person {

  Person({
    required this.personID ,
    required this.nationalID,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    required this.phoneNumber,
    this.emergencyContact,
    this.address,
    this.jobTitle,
  });

  int personID;
  String nationalID;
  String firstName;
  String middleName;
  String lastName;
  DateTime dateOfBirth;
  Gender gender ;
  String phoneNumber;
  String? emergencyContact;
  String? address;
  String? jobTitle;
  
}
  
