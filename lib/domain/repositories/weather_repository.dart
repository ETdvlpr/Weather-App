import 'package:weather_app/domain/entities/weather.dart';

abstract class WeatherRepository {
  Future<Weather> getWeather(double lat, double lon);
}
