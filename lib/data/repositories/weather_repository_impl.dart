import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:weather_app/data/datasources/weather_remote_data_source.dart';
import 'package:weather_app/domain/entities/api_error.dart';
import 'package:weather_app/domain/entities/weather.dart';
import 'package:weather_app/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  WeatherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Weather> getWeather(double lat, double lon) async {
    try {
      final data = await remoteDataSource.getWeather(lat, lon);
      log('Weather data: $data');

      // Extract and validate essential fields from the response
      final locationName = data['name'] as String;
      final mainData = data['main'] as Map<String, dynamic>;
      final temperature = mainData['temp'] as num;
      final weatherList = data['weather'] as List<dynamic>;

      // Retrieve weather icon if available
      final weatherIcon =
          weatherList.isNotEmpty
              ? (weatherList.first as Map<String, dynamic>)['icon'] as String?
              : null;

      return Weather(
        locationName: locationName,
        temperature: temperature.toDouble(),
        weatherIcon: weatherIcon,
      );
    } on DioException catch (e) {
      log('Network error: ${e.message}');
      // Handle network-related errors with simplified error message
      throw const AppError(
        type: ErrorType.network,
        message: 'Failed to connect to weather service',
      );
    } catch (e) {
      log('Unexpected error: $e');
      // Handle unexpected API response format
      throw const AppError(
        type: ErrorType.api,
        message: 'Invalid weather data format',
      );
    }
  }
}
