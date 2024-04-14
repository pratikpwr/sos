import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sos_app/src/core/network/api_client.dart';
import 'package:sos_app/src/core/preferences/local_preferences.dart';
import 'package:sos_app/src/core/utils/location_util.dart';
import 'package:sos_app/src/features/start_sos/repository/sos_repository.dart';

final sl = GetIt.instance;

void initDI() {
  // repository
  sl.registerLazySingleton<SOSRepository>(
      () => SOSRepositoryImpl(apiClient: sl(), prefs: sl()));

  sl.registerLazySingleton<LocationUtil>(() => LocationUtilImpl());

  // core
  sl.registerLazySingleton<ApiClient>(() => ApiClientImpl(dio: sl()));

  sl.registerLazySingleton(() => LocalPreferences());
  sl.registerLazySingleton(() => Dio());
}
