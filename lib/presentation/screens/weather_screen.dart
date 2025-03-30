import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/presentation/bloc/weather_bloc.dart';
import 'package:weather_app/presentation/widgets/error_display.dart';
import 'package:weather_app/presentation/widgets/weather_display.dart';
import 'package:weather_app/util/constants.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Local helper to dispatch the fetch event with default coordinates.
    void fetchWeather() => context.read<WeatherBloc>().add(
      FetchWeather(
        lat: AppConstants.defaultLocation.lat,
        lon: AppConstants.defaultLocation.lon,
      ),
    );

    return Scaffold(
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          return switch (state) {
            WeatherInitial() => Center(
              child: ElevatedButton(
                onPressed: fetchWeather,
                child: const Text('Get Weather'),
              ),
            ),
            WeatherLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            WeatherLoaded() => WeatherDisplay(weather: state.weather),
            WeatherError() => ErrorDisplay(
              message: state.error.message,
              onRetry: fetchWeather,
            ),
            _ => ErrorDisplay(message: 'Unknown state', onRetry: fetchWeather),
          };
        },
      ),
    );
  }
}
