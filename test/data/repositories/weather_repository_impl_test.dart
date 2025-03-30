import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/data/repositories/weather_repository_impl.dart';
import 'package:weather_app/domain/entities/weather.dart';

import '../../mocks/mock_builders.mocks.dart';

void main() {
  late MockWeatherRemoteDataSource mockDataSource;
  late WeatherRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockWeatherRemoteDataSource();
    repository = WeatherRepositoryImpl(remoteDataSource: mockDataSource);
  });

  test('converts valid response to Weather entity', () async {
    // Mock API response data
    final testData = {
      'name': 'London',
      'main': {'temp': 285.15},
      'weather': [
        {'icon': '01d'},
      ],
    };

    when(mockDataSource.getWeather(any, any)).thenAnswer((_) async => testData);

    // Fetch weather data for a valid location
    final result = await repository.getWeather(51.51, -0.12);

    // Verify the response is correctly converted into a Weather entity
    expect(result, isA<Weather>());
    expect(result.locationName, 'London');
  });
}
