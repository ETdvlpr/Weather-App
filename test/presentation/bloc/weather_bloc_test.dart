import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/domain/entities/weather.dart';
import 'package:weather_app/presentation/bloc/weather_bloc.dart';

import '../../mocks/mock_builders.mocks.dart';

void main() {
  late MockWeatherRepository mockRepository;
  late WeatherBloc weatherBloc;

  // Test weather data
  const testWeather = Weather(
    locationName: 'London',
    temperature: 285.15,
    weatherIcon: '01d',
  );

  setUp(() {
    mockRepository = MockWeatherRepository();
    weatherBloc = WeatherBloc(weatherRepository: mockRepository);
  });

  tearDown(() => weatherBloc.close());

  blocTest<WeatherBloc, WeatherState>(
    'emits [Loading, Loaded] when data is fetched successfully',
    build: () => weatherBloc,
    setUp:
        () => when(
          mockRepository.getWeather(any, any), // Mock API call
        ).thenAnswer((_) async => testWeather),
    act: (bloc) => bloc.add(const FetchWeather(lat: 51.51, lon: -0.12)),
    expect:
        () => [
          WeatherLoading(), // First state: loading
          const WeatherLoaded(
            weather: testWeather,
          ), // Final state: loaded with data
        ],
  );
}
