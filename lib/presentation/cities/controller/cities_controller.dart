import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import '../../../core/common/app_exceptions.dart';
import '../../../core/utils/fetch_current_hour.dart';
import '../../../data/model/aqi_model.dart';
import '../../../data/model/city_model.dart';
import '../../home/controller/home_controller.dart';
import '../../../core/local_storage/local_storage.dart';
import '../../../domain/use_cases/get_current_weather.dart';

class CitiesController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final LocalStorage localStorage = LocalStorage();
  final rawForecastData = <String, dynamic>{}.obs;
  final cityWeatherData = <String, Map<String, String>>{}.obs;
  final cityAirQualityData = <String, String>{}.obs;
  var hasSearchError = false.obs;
  var searchErrorMessage = ''.obs;
  var filteredCities = <CityModel>[].obs;
  var isSearching = false.obs;

  HomeController get homeController => Get.find<HomeController>();

  @override
  Future<void> onInit() async {
    super.onInit();
    filteredCities.value = homeController.allCities;

    // Initialize rawForecastData from HomeController
    _initializeRawForecastData();

    searchController.addListener(() {
      searchCities(searchController.text);
    });
  }

  void _initializeRawForecastData() {
    // Get current raw forecast data from HomeController
    rawForecastData.value = Map<String, dynamic>.from(
      homeController.rawForecastData,
    );

    // Listen to changes in HomeController's rawForecastData
    ever(homeController.rawForecastData, (Map<String, dynamic> newData) {
      rawForecastData.value = Map<String, dynamic>.from(newData);
    });
  }

  void searchCities(String query) {
    if (query.isEmpty) {
      filteredCities.value = homeController.allCities;
      hasSearchError.value = false;
      return;
    }

    isSearching.value = true;
    hasSearchError.value = false;

    try {
      final results = homeController.allCities
          .where(
            (city) =>
                city.city.toLowerCase().contains(query.toLowerCase()) ||
                city.cityAscii.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();

      if (results.isEmpty) {
        hasSearchError.value = true;
        searchErrorMessage.value = 'No cities found matching "$query"';
        filteredCities.clear();
      } else {
        filteredCities.value = results;
        hasSearchError.value = false;
      }
    } catch (e) {
      hasSearchError.value = true;
      searchErrorMessage.value = 'Search failed. Please try again.';
      filteredCities.clear();
    } finally {
      isSearching.value = false;
    }
  }

  Future<void> addCurrentLocationToSelected(BuildContext context) async {
    final currentCity = homeController.currentLocationCity;
    if (currentCity != null) {
      await selectCity(currentCity);
    }
  }

  Future<void> selectCity(CityModel city) async {
    try {
      final selectedCities = <CityModel>[city];
      homeController.selectedCities.value = selectedCities;

      final citiesJson = json.encode(
        selectedCities.map((c) => c.toJson()).toList(),
      );
      await localStorage.setString('selected_cities', citiesJson);

      await homeController.changeSelectedCity(city);
    } catch (e) {
      debugPrint('${AppExceptions().failToSelect}: $e');
    }
  }

  Map<String, dynamic>? get currentHourData =>
      fetchCurrentHour(rawForecastData);

  String getAqiText(AirQualityModel? airQuality) {
    if (airQuality == null) return 'Air quality unavailable';
    final aqi = airQuality.calculatedAqi;
    final category = airQuality.getAirQualityCategory(aqi);
    return 'AQI $aqi – $category';
  }

  Future<void> loadWeatherDataForCity(CityModel city) async {
    try {
      final GetWeatherAndForecast getCurrentWeather = Get.find();
      final (weather, forecast) = await getCurrentWeather(
        lat: city.latitude,
        lon: city.longitude,
      );

      final currentHourData = this.currentHourData;
      final temperature = currentHourData != null
          ? currentHourData['temp_c'].round().toString()
          : weather.temperature.round().toString();

      cityWeatherData[city.city] = {
        'temp': temperature,
        'condition': weather.condition,
      };

      cityAirQualityData[city.city] =
          'AQI ${weather.airQuality?.calculatedAqi ?? 'N/A'}';
    } catch (e) {
      debugPrint('Error loading weather for ${city.city}: $e');
      cityWeatherData[city.city] = {'temp': '--', 'condition': 'Unavailable'};
      cityAirQualityData[city.city] = 'No data';
    }
  }

  String getTemperatureForCity(CityModel city) {
    final data = cityWeatherData[city.city];
    if (data == null) {
      loadWeatherDataForCity(city);
      return '--';
    }
    return data['temp'] ?? '--';
  }

  String getConditionForCity(CityModel city) {
    final data = cityWeatherData[city.city];
    if (data == null) {
      loadWeatherDataForCity(city);
      return 'Loading...';
    }
    return data['condition'] ?? 'Loading...';
  }

  String getAirQualityForCity(CityModel city) {
    final data = cityAirQualityData[city.city];
    if (data == null) {
      loadWeatherDataForCity(city);
      return 'Loading...';
    }
    return data;
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
