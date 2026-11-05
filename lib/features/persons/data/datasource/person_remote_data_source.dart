
import '../../../../core/networking/api_client.dart';
import '../../../../core/networking/constants.dart';
import '../models/person.dart';

abstract class PersonRemoteDataSource {
  Future<List<PersonModel>> getAllPersons();
  Future<PersonModel> getPersonById(int id);
  Future<PersonModel> addPerson(PersonModel person);
  Future<PersonModel> updatePerson(PersonModel person);
  // Future<void> deletePerson(int id);
}

class PersonRemoteDataSourceImpl implements PersonRemoteDataSource {
  PersonRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<List<PersonModel>> getAllPersons() async {
    final response = await _apiClient.get(EndPoints.getPersons);
    final responseData = response.data;

    if (responseData is! Map) {
      throw FormatException(
        'Expected a paginated response object, got ${responseData.runtimeType}',
      );
    }

    final items = responseData['items'];
    if (items is! List) {
      throw FormatException('Expected "items" to be a list, got ${items.runtimeType}');
    }

    return items
        .map((item) {
          if (item is! Map) {
            throw FormatException(
              'Expected each person to be a JSON object, got ${item.runtimeType}',
            );
          }
          return PersonModel.fromJson(Map<String, dynamic>.from(item));
        })
        .toList(growable: false);
  }

  @override
  Future<PersonModel> getPersonById(int id) async {
    final response = await _apiClient.get('${EndPoints.getPersonById}$id');
    final responseData = response.data;

    if (responseData is! Map) {
      throw FormatException(
        'Expected a paginated response object, got ${responseData.runtimeType}',
      );
    }

    return PersonModel.fromJson(Map<String, dynamic>.from(responseData));
  }

  @override
  Future<PersonModel> addPerson(PersonModel person) async {
    final response = await _apiClient.post(EndPoints.addPerson, data: person.toJson());
    final responseData = response.data;

    if (responseData is! Map) {
      throw FormatException(
        'Expected a paginated response object, got ${responseData.runtimeType}',
      );
    }

    return PersonModel.fromJson(Map<String, dynamic>.from(responseData));
  }

  @override
  Future<PersonModel> updatePerson(PersonModel person) async {
    final response = await _apiClient.put('${EndPoints.updatePerson}${person.personID}', data: person.toJson());
    final responseData = response.data;

    if (responseData is! Map) {
      throw FormatException(
        'Expected a paginated response object, got ${responseData.runtimeType}',
      );
    }

    return PersonModel.fromJson(Map<String, dynamic>.from(responseData));
  }
}
/*
  لا تنسى تعدل حقن التبعيات من  
getIt.registerLazySingleton<PersonRemoteDataSource>(
  () => PersonRemoteDataSourceImpl(getIt<ApiClient>()),
);
الى
getIt.registerLazySingleton<PersonRemoteDataSource>(
  PersonMockDataSource.new,
);
 */
