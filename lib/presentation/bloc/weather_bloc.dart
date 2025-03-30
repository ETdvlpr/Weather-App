import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/domain/entities/api_error.dart';
import 'package:weather_app/domain/entities/weather.dart';
import 'package:weather_app/domain/repositories/weather_repository.dart';
import 'package:weather_app/util/constants.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherBloc({required this.weatherRepository}) : super(WeatherInitial()) {
    // Register event handler for fetching weather
    on<FetchWeather>(_onFetchWeather);
  }

  Future<void> _onFetchWeather(
    FetchWeather event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());
    try {
      // Fetch weather data from the repository
      final weather = await weatherRepository.getWeather(
        AppConstants.defaultLocation.lat,
        AppConstants.defaultLocation.lon,
      );
      emit(WeatherLoaded(weather: weather));
    } catch (e) {
      // Handle known and unknown errors
      emit(
        e is AppError
            ? WeatherError(e)
            : const WeatherError(
              AppError(
                type: ErrorType.unknown,
                message: 'An unknown error occurred',
              ),
            ),
      );
    }
  }
}
