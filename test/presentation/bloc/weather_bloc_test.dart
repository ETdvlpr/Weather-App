import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/domain/entities/api_error.dart';
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

  blocTest<WeatherBloc, WeatherState>(
    'emits [Loading, Error] when data fetch fails',
    build: () => weatherBloc,
    setUp:
        () => when(
          mockRepository.getWeather(any, any), // Mock API call
        ).thenThrow(
          const AppError(type: ErrorType.network, message: 'Network error'),
        ),
    act: (bloc) => bloc.add(const FetchWeather(lat: 51.51, lon: -0.12)),
    expect:
        () => [
          WeatherLoading(), // First state: loading
          const WeatherError(
            AppError(type: ErrorType.network, message: 'Network error'),
          ), // Final state: error
        ],
  );

  blocTest<WeatherBloc, WeatherState>(
    'changes temperature unit to Fahrenheit',
    build: () => weatherBloc,
    setUp:
        () => when(
          mockRepository.getWeather(any, any), // Mock API call
        ).thenAnswer((_) async => testWeather),
    act: (bloc) {
      bloc.add(const FetchWeather(lat: 51.51, lon: -0.12));
      bloc.add(const ChangeTemperatureUnit('F'));
    },
    expect:
        () => [
          WeatherLoading(), // First state: loading
          const WeatherLoaded(
            weather: testWeather,
            isCelsius: true,
          ), // Intermediate state: loaded with data
          const WeatherLoaded(
            weather: testWeather,
            isCelsius: false,
          ), // Final state: loaded with Fahrenheit
        ],
  );
}
