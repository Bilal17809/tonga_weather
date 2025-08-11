import 'package:flutter/foundation.dart';
import '/data/model/city_model.dart';
import '/domain/use_cases/use_case.dart';
import '../common/app_exceptions.dart';
import '../local_storage/local_storage.dart';

class CurrentLocationService {
  final LocalStorage localStorage;
  final GetWeatherAndForecast getCurrentWeather;

  CurrentLocationService({
    required this.localStorage,
    required this.getCurrentWeather,
  });

  Future<CityModel?> getCurrentLocationCity(List<CityModel> allCities) async {
    try {
      final (city, region) = await getCurrentWeather.getCity();
      final latStr = await localStorage.getString('latitude');
      final lonStr = await localStorage.getString('longitude');

      double? lat = latStr != null ? double.tryParse(latStr) : null;
      double? lon = lonStr != null ? double.tryParse(lonStr) : null;

      final foundCity = allCities.firstWhere(
        (c) => c.city.toLowerCase() == city.toLowerCase(),
        orElse: () => CityModel(
          city: city,
          cityAscii: city,
          region: region,
          latitude: lat ?? 0.0,
          longitude: lon ?? 0.0,
        ),
      );

      return foundCity;
    } catch (e) {
      debugPrint('${AppExceptions().locationFetchError}: $e');
      return null;
    }
  }
}
