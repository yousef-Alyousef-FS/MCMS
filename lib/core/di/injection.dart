import 'package:medical_center/core/networking/api_client.dart';
import 'package:medical_center/core/networking/dio_factory.dart';
import 'package:medical_center/core/storage/secure_storage/secure_storage_service.dart';
import 'package:medical_center/core/storage/secure_storage/token_manger.dart';
import 'package:medical_center/core/storage/shared_preferences/shared_preferences_service.dart';
import 'package:medical_center/core/theming/theme_manager.dart';
import 'package:medical_center/features/persons/data/datasource/person_remote_data_source.dart';
import 'package:medical_center/features/persons/data/repositories/person_repo.dart';
import 'package:medical_center/features/persons/domain/repository/person_repo_interface.dart';
import 'package:medical_center/features/persons/domain/usecases/add_person.dart';
import 'package:medical_center/features/persons/domain/usecases/get_person_by_id.dart';
import 'package:medical_center/features/persons/domain/usecases/get_persons_info.dart';
import 'package:medical_center/features/persons/domain/usecases/update_person.dart';
import 'package:medical_center/features/persons/presentaion/state_management/cubits/add_update_cubit.dart';
import 'package:medical_center/features/persons/presentaion/state_management/cubits/get_person_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

Future<void> init() async {
  // ════════════════════════════════════════════════════════════════════════════
  // SECTION: DEPENDENCY INJECTION
  // ════════════════════════════════════════════════════════════════════════════

  // INFO:
  // Here we can register our dependencies.
  //
  // The main purpose of this function is to register all the dependencies
  // that we need in our app.

  // ════════════════════════════════════════════════════════════════════════════
  // SECTION: REGISTRATION TYPES
  // ════════════════════════════════════════════════════════════════════════════

  // INFO:
  // Example of registering a dependency:
  //
  // getIt.registerSingleton(SomeClass());
  // → Creates one instance immediately when the application starts.
  //
  // Used for dependencies that should be initialized immediately
  // and shared throughout the application.
  //
  //
  // getIt.registerLazySingleton(() => SomeClass());
  // → Creates one instance only when it is needed for the first time.
  //
  // Used when we want a single shared instance but don't need to create it
  // immediately.
  //
  //
  // getIt.registerFactory(() => SomeClass());
  // → Creates a new instance every time it is requested.
  //
  // Commonly used for short-lived objects such as Cubits / Blocs.

  // ════════════════════════════════════════════════════════════════════════════
  // SECTION: STORAGE
  // ════════════════════════════════════════════════════════════════════════════

  // NOTE:
  // Storage dependencies include:
  // • SharedPreferences
  // • SecureStorage
  // • Cache
  // • TokenManager

  final sharedPreferences = await SharedPreferences.getInstance();
  const secureStorage = FlutterSecureStorage();
  // INFO:
  // SharedPreferences is initialized asynchronously,
  // so we create its instance before registering it.
  //
  // Singleton:
  // The same SharedPreferences instance will be used throughout the app.
  getIt
    ..registerSingleton<SharedPreferences>(sharedPreferences)
    ..registerSingleton<FlutterSecureStorage>(secureStorage);
  // INFO:
  // The service itself is registered as a LazySingleton.
  //
  // It will be created only when SharedPreferencesService is requested
  // for the first time, and the same instance will be reused afterwards.
  getIt.registerLazySingleton<SharedPreferencesService>(
    () => SharedPreferencesService(getIt<SharedPreferences>()),
  );
  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(getIt<FlutterSecureStorage>()),
  );
  getIt.registerLazySingleton<TokenManager>(() => TokenManager(getIt<SecureStorageService>()));

  // ════════════════════════════════════════════════════════════════════════════
  // SECTION: SERVICES
  // ════════════════════════════════════════════════════════════════════════════

  // NOTE:
  // App-level services will be registered here.
  //
  // Example:
  // • LocaleManager
  // • ThemeManager
  // • Connectivity
  // • TokenManager

  // ════════════════════════════════════════════════════════════════════════════
  // SECTION: NETWORKING
  // ════════════════════════════════════════════════════════════════════════════

  // NOTE:
  // Networking dependencies are shared so every API client uses
  // the same base URL, timeouts, and interceptors.
  //
  // Example:
  // • Dio
  // • ApiClient
  // • NetworkInfo
  getIt.registerLazySingleton<DioFactory>(DioFactory.new);
  getIt.registerLazySingleton<Dio>(() => getIt<DioFactory>().create());
  getIt.registerLazySingleton<ApiClient>(() => ApiClient(getIt<Dio>()));

  // ════════════════════════════════════════════════════════════════════════════
  // SECTION: DATA SOURCES
  // ════════════════════════════════════════════════════════════════════════════

  // NOTE:
  // Remote and local data sources will be registered here.
  getIt.registerLazySingleton<PersonRemoteDataSource>(
    () => PersonRemoteDataSourceImpl(getIt<ApiClient>()),
  );

  // ════════════════════════════════════════════════════════════════════════════
  // SECTION: REPOSITORIES
  // ════════════════════════════════════════════════════════════════════════════

  // NOTE:
  // Repository implementations will be registered here.
  getIt.registerLazySingleton<IPersonRepository>(
    () => PersonRepository(getIt<PersonRemoteDataSource>()),
  );

  // ════════════════════════════════════════════════════════════════════════════
  // SECTION: USE CASES
  // ════════════════════════════════════════════════════════════════════════════

  // NOTE:
  // UseCases will be registered here.
  getIt.registerFactory<GetpersonsInfoUseCase>(
    () => GetpersonsInfoUseCase(getIt<IPersonRepository>()),
  );
  getIt.registerFactory<GetPersonByIdUseCase>(
    () => GetPersonByIdUseCase(getIt<IPersonRepository>()),
  );
  getIt.registerFactory<AddPersonUseCase>(() => AddPersonUseCase(getIt<IPersonRepository>()));
  getIt.registerFactory<UpdatePersonUseCase>(() => UpdatePersonUseCase(getIt<IPersonRepository>()));

  // ════════════════════════════════════════════════════════════════════════════
  // SECTION: STATE MANAGEMENT
  // ════════════════════════════════════════════════════════════════════════════

  // NOTE:
  // Cubits / Blocs will be registered here.
  //
  // Usually registered as Factory because each request should create
  // a new instance.
  getIt.registerFactory<GetPersonCubit>(
    () => GetPersonCubit(
      getPersonsInfoUseCase: getIt<GetpersonsInfoUseCase>(),
      personByIdUseCase: getIt<GetPersonByIdUseCase>(),
    ),
  );
  getIt.registerFactory<AddUpdateCubit>(
    () => AddUpdateCubit(
      addPersonUseCase: getIt<AddPersonUseCase>(),
      updatePersonUseCase: getIt<UpdatePersonUseCase>(),
    ),
  );
  getIt.registerFactory<ThemeManager>(() => ThemeManager(getIt<SharedPreferencesService>()));
}
