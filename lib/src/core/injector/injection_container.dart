import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sos_app/src/core/network/api_client.dart';
import 'package:sos_app/src/core/preferences/local_preferences.dart';
import 'package:sos_app/src/core/utils/location_util.dart';
import 'package:sos_app/src/features/auth/repository/auth_repository.dart';
import 'package:sos_app/src/features/sos_details/repository/sos_details_repository.dart';
import 'package:sos_app/src/features/start_sos/repository/sos_repository.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  // repository
  sl.registerLazySingleton<SOSRepository>(
      () => SOSRepositoryImpl(apiClient: sl(), prefs: sl()));
  sl.registerLazySingleton<SOSDetailsRepository>(
      () => SOSDetailsRepositoryImpl(apiClient: sl(), prefs: sl()));

  sl.registerLazySingleton<LocationUtil>(() => LocationUtilImpl());
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(apiClient: sl(), prefs: sl()));

  // core
  sl.registerLazySingleton<ApiClient>(() => ApiClientImpl(dio: sl()));

  final prefs = LocalPreferences();
  await prefs.init();
  sl.registerLazySingleton(() => prefs);
  sl.registerLazySingleton(() => Dio());
}
