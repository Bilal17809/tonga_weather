import 'dart:async';
import 'package:geolocator/geolocator.dart';

import '../../core/constants/app_exceptions.dart';
import '../../core/local_storage/local_storage.dart';
import '../../data/model/weather_model.dart';
import '../../data/model/forecast_model.dart';
import '../repositories/weather_repo.dart';

class GetWeatherAndForecast {
  final WeatherRepo weatherRepo;
  final storage = LocalStorage();

  GetWeatherAndForecast(this.weatherRepo);

  Future<(WeatherModel, List<ForecastModel>)> call({
    required double lat,
    required double lon,
  }) {
    return weatherRepo.getWeatherAndForecast(lat, lon);
  }

  /// For Current Location
  Future<String> getCity() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception(deniedPermission);
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception(deniedPermission);
      }
    }

    final position =
        await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
            timeLimit: Duration(seconds: 10),
          ),
        ).timeout(
          const Duration(seconds: 8),
          onTimeout: () => throw Exception(timeoutException),
        );

    await savePosition(position);
    return weatherRepo.getCity(position.latitude, position.longitude);
  }

  Future<void> savePosition(Position position) async {
    await storage.setString('latitude', position.latitude.toString());
    await storage.setString('longitude', position.longitude.toString());
  }
}
