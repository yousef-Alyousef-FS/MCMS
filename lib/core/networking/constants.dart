abstract final class NetworkConstants {
  static const String baseUrl = 'https://selector-repossess-hurdle.ngrok-free.dev/api';

  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);
  static const Duration sendTimeout = Duration(seconds: 20);

  static const Map<String, String> defaultHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };
}

abstract final class EndPoints {
  static const String getPersons = '/persons/GetAllPersons';
  static const String getPersonById = '/persons/';
  static const String addPerson = '/persons/';
  static const String updatePerson = '/persons/';
  
}
