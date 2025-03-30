import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:weather_app/data/datasources/weather_remote_data_source.dart';
import 'package:weather_app/domain/repositories/weather_repository.dart';

@GenerateMocks([Dio, WeatherRepository, WeatherRemoteDataSource])
void main() {}
