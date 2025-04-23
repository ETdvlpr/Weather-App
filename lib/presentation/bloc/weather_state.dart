part of 'weather_bloc.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

// Initial state before any data is loaded
class WeatherInitial extends WeatherState {}

// State while fetching weather data
class WeatherLoading extends WeatherState {}

// State when weather data is successfully loaded
class WeatherLoaded extends WeatherState {
  final Weather weather;
  final bool isCelsius;

  const WeatherLoaded({required this.weather, this.isCelsius = true});

  @override
  List<Object> get props => [weather, isCelsius];
}

// State when an error occurs
class WeatherError extends WeatherState {
  final AppError error;

  const WeatherError(this.error);

  @override
  List<Object> get props => [error];
}
