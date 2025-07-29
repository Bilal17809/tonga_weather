import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tonga_weather/core/global/global_services/connectivity_service.dart';
import '../../../core/global/global_controllers/condition_controller.dart';
import '../../../data/model/city_model.dart';
import '../../splash/controller/splash_controller.dart';

class CitiesController extends GetxController with ConnectivityMixin {
  final TextEditingController searchController = TextEditingController();
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
    searchController.addListener(() {
      searchCities(searchController.text);
    });
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

  Future<void> selectCity(CityModel city) async {
    await initWithConnectivityCheck(
      context: Get.context!,
      onConnected: () async {
        splashController.selectedCity.value = city;
        await splashController.cityStorageService.saveSelectedCity(city);
      },
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
