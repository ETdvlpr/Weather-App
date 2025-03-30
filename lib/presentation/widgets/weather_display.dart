import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/domain/entities/weather.dart';
import 'package:weather_app/presentation/bloc/weather_bloc.dart';
import 'package:weather_app/util/constants.dart';

class WeatherDisplay extends StatefulWidget {
  final Weather weather;

  const WeatherDisplay({super.key, required this.weather});

  @override
  State<WeatherDisplay> createState() => _WeatherDisplayState();
}

class _WeatherDisplayState extends State<WeatherDisplay> {
  bool isCelsius = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CustomScrollView(
        slivers: [
          // Main content
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: AppConstants.backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final aspectRatio =
                        constraints.maxWidth > 300 ? 16 / 9 : 4 / 3;
                    return AspectRatio(
                      aspectRatio: aspectRatio,
                      child: _buildWeatherIcon(
                        widget.weather.weatherIcon ?? '',
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'THIS IS MY WEATHER APP',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                  fontSize: 24,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                'Temperature',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 8),
              Text(
                _getTemperature(widget.weather.temperature),
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 8),
              Text(
                'Location',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 8),
              Text(
                widget.weather.locationName,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Celsius/Fahrenheit',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(width: 16),
                  CupertinoSwitch(
                    value: !isCelsius,
                    activeTrackColor: AppConstants.primaryColor,
                    onChanged:
                        (value) => setState(() => isCelsius = !isCelsius),
                  ),
                ],
              ),
            ]),
          ),
          // Refresh button at the bottom
          SliverFillRemaining(
            hasScrollBody: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 24,
                  ),
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed:
                    () => context.read<WeatherBloc>().add(
                      FetchWeather(
                        lat: AppConstants.defaultLocation.lat,
                        lon: AppConstants.defaultLocation.lon,
                      ),
                    ),
                child: const Text(
                  'Refresh',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Convert Kelvin to Celsius or Fahrenheit
  String _getTemperature(double kelvin) {
    return isCelsius
        ? '${(kelvin - 273.15).toStringAsFixed(1)}°C'
        : '${((kelvin - 273.15) * 9 / 5 + 32).toStringAsFixed(1)}°F';
  }

  // Build weather icon widget from icon code
  Widget _buildWeatherIcon(String? iconCode) {
    if (iconCode == null || iconCode.isEmpty) {
      return const Icon(Icons.error, size: 100, color: Colors.red);
    }

    log('https://openweathermap.org/img/wn/$iconCode@4x.png');
    return CachedNetworkImage(
      imageUrl: 'https://openweathermap.org/img/wn/$iconCode@4x.png',
      placeholder:
          (context, url) => const Center(child: CircularProgressIndicator()),
      errorWidget:
          (context, url, error) =>
              const Icon(Icons.error, size: 100, color: Colors.red),
    );
  }
}
