enum Gender {
   male,
   female
}

extension GenderExtension on Gender {
  String get name {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
    }
  }

  int get value {
    switch (this) {
      case Gender.male:
        return 0;
      case Gender.female:
        return 1;
    }
  }
}
