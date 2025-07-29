import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tonga_weather/core/common/app_exceptions.dart';
import 'package:tonga_weather/core/global/global_services/city_storage_service.dart';
import 'package:tonga_weather/core/global/global_services/current_location_service.dart';
import 'package:tonga_weather/core/global/global_services/load_cities_service.dart';
import 'package:tonga_weather/core/global/global_services/load_weather_service.dart';
import '../../../core/global/global_controllers/condition_controller.dart';
import '../../../core/global/global_services/connectivity_service.dart';
import '../../../core/local_storage/local_storage.dart';
import '../../../domain/use_cases/get_current_weather.dart';
import '../../../data/model/city_model.dart';
import '../../home/controller/home_controller.dart';

class SplashController extends GetxController with ConnectivityMixin {
  final GetWeatherAndForecast getCurrentWeather;
  final LocalStorage localStorage;
  final CurrentLocationService currentLocationService;
  final LoadCitiesService cityService;
  final CityStorageService cityStorageService;
  final LoadWeatherService loadWeatherService;

  SplashController({
    required this.getCurrentWeather,
    required this.localStorage,
    required this.currentLocationService,
    required this.cityService,
    required this.cityStorageService,
    required this.loadWeatherService,
  });

  ConditionController get conditionController =>
      Get.find<ConditionController>();

  final isLoading = true.obs;
  final isDataLoaded = false.obs;
  final allCities = <CityModel>[].obs;
  final currentLocationCity = Rx<CityModel?>(null);
  final selectedCity = Rx<CityModel?>(null);
  final isFirstLaunch = true.obs;
  final RxMap<String, dynamic> _rawDataStorage =
      <String, Map<String, dynamic>>{}.obs;
  final rawForecastData = <String, dynamic>{}.obs;
  var showButton = false.obs;

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(milliseconds: 500), () {
      initWithConnectivityCheck(
        context: Get.context!,
        onConnected: () async {
          await _initializeApp();
        },
      );
    });
  }

  Future<void> _initializeApp() async {
    try {
      isLoading.value = true;
      isDataLoaded.value = false;
      allCities.value = await cityService.loadAllCities();
      await _checkFirstLaunch();
      currentLocationCity.value = await currentLocationService
          .getCurrentLocationCity(allCities);
      if (isFirstLaunch.value) {
        await _setupFirstLaunch();
      } else {
        selectedCity.value = await cityStorageService.loadSelectedCity(
          allCities: allCities,
          currentLocationCity: currentLocationCity.value,
        );
        await cityStorageService.saveSelectedCity(selectedCity.value);
      }
      await loadWeatherService.loadWeatherForAllCities(
        allCities,
        selectedCity: selectedCity.value,
        currentLocationCity: currentLocationCity.value,
      );
      _updateRawForecastDataForCurrentCity();
      isDataLoaded.value = true;
      Get.find<HomeController>().isWeatherDataLoaded.value = true;
    } catch (e) {
      debugPrint('${AppExceptions().errorAppInit}: $e');
      isDataLoaded.value = true;
    } finally {
      isLoading.value = false;
      showButton.value = true;
    }
  }

  Future<void> _checkFirstLaunch() async {
    try {
      final savedCityJson = await localStorage.getString('selected_city');
      final hasCurrentLocation =
          await localStorage.getBool('has_current_location') ?? false;
      isFirstLaunch.value = savedCityJson == null || !hasCurrentLocation;
    } catch (e) {
      debugPrint('${AppExceptions().firstLaunch}: $e');
      isFirstLaunch.value = true;
    }
  }

  Future<void> _setupFirstLaunch() async {
    final currentCity = currentLocationCity.value;

    if (currentCity != null) {
      selectedCity.value = currentCity;
    } else {
      final nukualofa = allCities.firstWhere(
        (city) => city.cityAscii.toLowerCase() == 'nukualofa',
        orElse: () => allCities.first,
      );
      selectedCity.value = nukualofa;
    }
    await cityStorageService.saveSelectedCity(selectedCity.value);
    await localStorage.setBool('has_current_location', currentCity != null);
  }

  String get selectedCityName => selectedCity.value?.cityAscii ?? 'Loading...';
  bool get isAppReady => isDataLoaded.value;
  CityModel? get currentCity => currentLocationCity.value;
  CityModel? get chosenCity => selectedCity.value;
  bool get isFirstTime => isFirstLaunch.value;
  Map<String, dynamic> get rawWeatherData {
    final key = selectedCity.value?.latLonKey ?? selectedCityName;
    return _rawDataStorage[key] ?? {};
  }

  void cacheCityData(String key, Map<String, dynamic> data) {
    _rawDataStorage[key] = data;
  }

  void _updateRawForecastDataForCurrentCity() {
    final key = selectedCity.value?.latLonKey ?? selectedCityName;
    if (_rawDataStorage.containsKey(key)) {
      rawForecastData.value = Map<String, dynamic>.from(_rawDataStorage[key]!);
    }
  }
}
