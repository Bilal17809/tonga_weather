import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import '../../../core/common/app_exceptions.dart';
import '../../../core/global/global_controllers/condition_controller.dart';
import '../../../data/model/city_model.dart';
import '../../splash/controller/splash_controller.dart';
import '../../../core/local_storage/local_storage.dart';

class CitiesController extends GetxController {
  // final LoadWeatherService loadWeatherService = Get.find();
  final TextEditingController searchController = TextEditingController();
  final LocalStorage localStorage = LocalStorage();

  final rawForecastData = <String, dynamic>{}.obs;
  final cityWeatherData = <String, Map<String, String>>{}.obs;
  final cityAirQualityData = <String, String>{}.obs;
  var hasSearchError = false.obs;
  var searchErrorMessage = ''.obs;
  var filteredCities = <CityModel>[].obs;
  var isSearching = false.obs;
  SplashController get splashController => Get.find<SplashController>();
  ConditionController get conditionController =>
      Get.find<ConditionController>();

  @override
  Future<void> onInit() async {
    super.onInit();
    while (!splashController.isAppReady) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    filteredCities.value = splashController.allCities;
    _initializeRawForecastData();

    searchController.addListener(() {
      searchCities(searchController.text);
    });
  }

  void _initializeRawForecastData() {
    rawForecastData.value = Map<String, dynamic>.from(
      splashController.rawWeatherData,
    );
  }

  void searchCities(String query) {
    if (query.isEmpty) {
      filteredCities.value = splashController.allCities;
      hasSearchError.value = false;
      return;
    }
    isSearching.value = true;
    hasSearchError.value = false;
    try {
      final results = splashController.allCities
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
    final currentCity = splashController.currentCity;
    if (currentCity != null) {
      await selectCity(currentCity);
    }
  }

  Future<void> selectCity(CityModel city) async {
    try {
      final selectedCities = <CityModel>[city];
      splashController.selectedCity.value = city;
      final citiesJson = json.encode(
        selectedCities.map((c) => c.toJson()).toList(),
      );
      await localStorage.setString('selected_cities', citiesJson);

      await splashController.cityStorageService.saveSelectedCity(city);
    } catch (e) {
      debugPrint('${AppExceptions().failToSelect}: $e');
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
