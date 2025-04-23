part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

// Event for fetching weather data
class FetchWeather extends WeatherEvent {
  final double lat;
  final double lon;

  const FetchWeather({required this.lat, required this.lon});

  @override
  List<Object> get props => [lat, lon];
}

// weather in celsius or fahrenheit
class ChangeTemperatureUnit extends WeatherEvent {
  final String unit;

  const ChangeTemperatureUnit(this.unit);

  @override
  List<Object> get props => [unit];
}
