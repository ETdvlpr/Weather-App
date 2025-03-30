import 'package:dio/dio.dart';

class WeatherRemoteDataSource {
  final Dio dio;
  final String apiKey;

  WeatherRemoteDataSource({required this.dio, required this.apiKey});

  Future<Map<String, dynamic>> getWeather(double lat, double lon) async {
    final response = await dio.get(
      '',
      queryParameters: {'lat': lat, 'lon': lon, 'appid': apiKey},
    );

    return response.data;
  }
}
