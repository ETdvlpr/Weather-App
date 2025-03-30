import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:weather_app/data/datasources/weather_remote_data_source.dart';
import 'package:weather_app/data/repositories/weather_repository_impl.dart';
import 'package:weather_app/domain/repositories/weather_repository.dart';
import 'package:weather_app/util/constants.dart';

final getIt = GetIt.instance;

/// Sets up dependency injection for the app using GetIt.
void setupDependencies(String apiKey) {
  // Dio client setup for network requests
  getIt.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    ),
  );

  // Remote data source for fetching weather data
  getIt.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSource(dio: getIt<Dio>(), apiKey: apiKey),
  );

  // Repository implementation wrapping the remote data source
  getIt.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(
      remoteDataSource: getIt<WeatherRemoteDataSource>(),
    ),
  );
}
