import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final String locationName;
  final double temperature;
  final String? weatherIcon;

  const Weather({
    required this.locationName,
    required this.temperature,
    this.weatherIcon,
  });

  @override
  List<Object> get props => [locationName, temperature, weatherIcon ?? ''];
}
