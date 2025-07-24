import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/city_model.dart';
import '../../../domain/use_cases/get_current_weather.dart';
import '../../utils/fetch_current_hour.dart';

class WeatherService extends GetxService {
  final GetWeatherAndForecast _getCurrentWeather = Get.find();

  static final Map<String, Map<String, dynamic>> _weatherDataCache = {};
  static final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheValidDuration = Duration(minutes: 10);

  Future<Map<String, String>> getWeatherData(CityModel city) async {
    try {
      final cacheKey = '${city.city}_${city.latitude}_${city.longitude}';
      final now = DateTime.now();

      // Check if we have valid cached data
      if (_weatherDataCache.containsKey(cacheKey) &&
          _cacheTimestamps.containsKey(cacheKey)) {
        final cacheTime = _cacheTimestamps[cacheKey]!;
        if (now.difference(cacheTime) < _cacheValidDuration) {
          final cachedData = _weatherDataCache[cacheKey]!;
          return _extractWeatherInfo(cachedData, city.city);
        }
      }

      // Fetch fresh data
      final (weather, forecast) = await _getCurrentWeather(
        lat: city.latitude,
        lon: city.longitude,
      );

      // Cache the raw data (this will be set by OnlineDataSource)
      _cacheTimestamps[cacheKey] = now;

      return {
        'temp': weather.temperature.round().toString(),
        'condition': weather.condition,
      };
    } catch (e) {
      debugPrint('Error loading weather for ${city.city}: $e');
      return {'temp': '--', 'condition': 'Unavailable'};
    }
  }

  /// Get current hour temperature for a city
  String getCurrentHourTemperature(
    String cityName,
    Map<String, dynamic>? rawData,
  ) {
    if (rawData == null || rawData.isEmpty) return '--';

    final currentHourData = fetchCurrentHour(rawData);
    if (currentHourData == null) return '--';

    final temp = currentHourData['temp_c'];
    return temp?.round().toString() ?? '--';
  }

  /// Get air quality information
  Future<String> getAirQuality(CityModel city) async {
    try {
      final (weather, _) = await _getCurrentWeather(
        lat: city.latitude,
        lon: city.longitude,
      );

      final aqi = weather.airQuality?.calculatedAqi;
      return aqi != null ? 'AQI $aqi' : 'AQI N/A';
    } catch (e) {
      debugPrint('Error loading air quality for ${city.city}: $e');
      return 'No data';
    }
  }

  /// Extract weather info from cached raw data
  Map<String, String> _extractWeatherInfo(
    Map<String, dynamic> rawData,
    String cityName,
  ) {
    try {
      final currentHourData = fetchCurrentHour(rawData);
      if (currentHourData != null) {
        final temp = currentHourData['temp_c']?.round().toString() ?? '--';
        final condition =
            rawData['current']?['condition']?['text'] ?? 'Unknown';
        return {'temp': temp, 'condition': condition};
      }

      // Fallback to current weather data
      final current = rawData['current'];
      if (current != null) {
        final temp = current['temp_c']?.round().toString() ?? '--';
        final condition = current['condition']?['text'] ?? 'Unknown';
        return {'temp': temp, 'condition': condition};
      }

      return {'temp': '--', 'condition': 'Unavailable'};
    } catch (e) {
      debugPrint('Error extracting weather info for $cityName: $e');
      return {'temp': '--', 'condition': 'Unavailable'};
    }
  }

  /// Cache raw weather data
  static void cacheWeatherData(String cityKey, Map<String, dynamic> data) {
    _weatherDataCache[cityKey] = data;
    _cacheTimestamps[cityKey] = DateTime.now();
  }

  /// Get cached weather data
  static Map<String, dynamic>? getCachedWeatherData(String cityKey) {
    final now = DateTime.now();
    if (_weatherDataCache.containsKey(cityKey) &&
        _cacheTimestamps.containsKey(cityKey)) {
      final cacheTime = _cacheTimestamps[cityKey]!;
      if (now.difference(cacheTime) < _cacheValidDuration) {
        return _weatherDataCache[cityKey];
      }
    }
    return null;
  }

  /// Clear cache for a specific city
  static void clearCacheForCity(String cityKey) {
    _weatherDataCache.remove(cityKey);
    _cacheTimestamps.remove(cityKey);
  }

  /// Clear all cache
  static void clearAllCache() {
    _weatherDataCache.clear();
    _cacheTimestamps.clear();
  }
}
