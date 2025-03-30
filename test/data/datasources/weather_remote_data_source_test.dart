import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/data/datasources/weather_remote_data_source.dart';

import '../../mocks/mock_builders.mocks.dart';

void main() {
  late MockDio mockDio;
  late WeatherRemoteDataSource dataSource;
  const apiKey = 'test_key';

  setUp(() {
    mockDio = MockDio();
    dataSource = WeatherRemoteDataSource(dio: mockDio, apiKey: apiKey);
  });

  test('makes correct API call with parameters', () async {
    // Mock successful API response
    when(
      mockDio.get(any, queryParameters: anyNamed('queryParameters')),
    ).thenAnswer(
      (_) async => Response(
        data: <String, dynamic>{}, // Empty response data for this test
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      ),
    );

    // Execute API call
    await dataSource.getWeather(51.51, -0.12);

    // Verify that the request was made with the correct endpoint and parameters
    verify(
      mockDio.get(
        'weather',
        queryParameters: {'lat': 51.51, 'lon': -0.12, 'appid': apiKey},
      ),
    );
  });
}
