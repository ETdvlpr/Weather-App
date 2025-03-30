import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/core/injection_container.dart';
import 'package:weather_app/domain/repositories/weather_repository.dart';
import 'package:weather_app/presentation/bloc/weather_bloc.dart';
import 'package:weather_app/presentation/screens/weather_screen.dart';
import 'package:weather_app/util/constants.dart';

void main() async {
  // Load environment variables from the .env file
  await dotenv.load(fileName: ".env");

  final apiKey = dotenv.env['API_KEY'] ?? '';
  if (apiKey.isEmpty) {
    throw Exception('API_KEY not found in .env file');
  }

  setupDependencies(apiKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        // Provide the WeatherBloc with the weather repository
        create:
            (context) =>
                WeatherBloc(weatherRepository: getIt<WeatherRepository>())..add(
                  // Trigger initial weather fetch for default location
                  FetchWeather(
                    lat: AppConstants.defaultLocation.lat,
                    lon: AppConstants.defaultLocation.lon,
                  ),
                ),
        child: const WeatherScreen(),
      ),
    );
  }
}
