import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tonga_weather/core/global/global_controllers/condition_controller.dart';
import 'package:tonga_weather/data/model/city_model.dart';

import '../../../core/local_storage/local_storage.dart';
import '../../../core/utils/date_time_util.dart';
import '../../../domain/use_cases/get_current_weather.dart';
import '../../../gen/assets.gen.dart';

class HomeController extends GetxController {
  final GetWeatherAndForecast getCurrentWeather;
  final LocalStorage localStorage = LocalStorage();
  HomeController(this.getCurrentWeather);
  final conditionController = Get.find<ConditionController>();
  var isDrawerOpen = false.obs;
  final isLoading = false.obs;
  final allCities = <CityModel>[].obs;
  static final Map<String, Map<String, dynamic>> _rawDataStorage = {};
  final rawForecastData = <String, dynamic>{}.obs;
  final isWeatherDataLoaded = false.obs;
  final currentLocationCity = Rx<CityModel?>(null);

  @override
  void onInit() async {
    super.onInit();
    await _loadAllCities();
    await _getCurrentLocation();
    await _loadWeatherData();
  }

  Future<void> _loadAllCities() async {
    final String response = await rootBundle.loadString(Assets.cities);
    final List<dynamic> data = json.decode(response);
    allCities.value = data.map((city) => CityModel.fromJson(city)).toList();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final city = await getCurrentWeather.getCity();
      final latStr = await localStorage.getString('latitude');
      final lonStr = await localStorage.getString('longitude');

      double? lat;
      double? lon;

      if (latStr != null && lonStr != null) {
        lat = double.tryParse(latStr);
        lon = double.tryParse(lonStr);
      }

      final foundCity = allCities.firstWhere(
        (c) => c.city.toLowerCase() == city.toLowerCase(),
        orElse: () {
          if (lat != null && lon != null) {
            return CityModel(
              city: city,
              cityAscii: city,
              latitude: lat,
              longitude: lon,
            );
          } else {
            return CityModel(
              city: city,
              cityAscii: city,
              latitude: 0.0,
              longitude: 0.0,
            );
          }
        },
      );
      currentLocationCity.value = foundCity;
    } catch (e) {
      debugPrint('Failed to fetch current location: $e');
      currentLocationCity.value = null;
    }
  }

  Future<void> _loadWeatherData() async {
    try {
      final city = currentLocationCity.value;
      if (city == null) {
        debugPrint('Current location city is null');
        isWeatherDataLoaded.value = false;
        return;
      }

      final (weather, forecast) = await getCurrentWeather(
        lat: city.latitude,
        lon: city.longitude,
      );
      final cachedData = _rawDataStorage[city.city];
      if (cachedData != null) {
        rawForecastData.value = cachedData;
        isWeatherDataLoaded.value = true;
      } else {
        debugPrint('No cached raw data found for ${city.city}');
        isWeatherDataLoaded.value = false;
      }
      conditionController.updateWeatherData([weather], 0, city.city);
      conditionController.updateWeeklyForecast(forecast);
    } catch (e) {
      debugPrint('Failed to load weather for current location: $e');
      conditionController.clearWeatherData();
    }
  }

  Map<String, dynamic>? getCurrentHourData() {
    final now = DateTime.now();
    final today = DateTimeUtils.getTodayDateKey();
    final forecastDays = rawForecastData['forecast']?['forecastday'];
    if (forecastDays == null) return null;

    final todayData = (forecastDays as List).firstWhereOrNull(
      (day) => day['date'] == today,
    );

    if (todayData == null) return null;

    final hourlyList = todayData['hour'] as List?;
    if (hourlyList == null) return null;

    final currentHour = hourlyList.firstWhereOrNull((hour) {
      final hourTime = DateTimeUtils.parseLocal(hour['time']);
      return hourTime.hour == now.hour;
    });

    return currentHour;
  }

  static void cacheCityData(String cityName, Map<String, dynamic> data) {
    _rawDataStorage[cityName] = data;
  }
}
