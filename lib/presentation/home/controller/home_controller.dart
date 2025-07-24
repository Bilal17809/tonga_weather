import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tonga_weather/core/global/global_controllers/condition_controller.dart';
import 'package:tonga_weather/core/global/global_services/connectivity_service.dart';
import 'package:tonga_weather/core/utils/fetch_current_hour.dart';
import 'package:tonga_weather/data/model/city_model.dart';
import '../../splash/controller/splash_controller.dart';
import '../../../core/local_storage/local_storage.dart';
import '../../../domain/use_cases/get_current_weather.dart';

class HomeController extends GetxController with ConnectivityMixin {
  final GetWeatherAndForecast getCurrentWeather;
  final LocalStorage localStorage = LocalStorage();

  HomeController(this.getCurrentWeather);

  SplashController get splashController => Get.find<SplashController>();
  final conditionController = Get.find<ConditionController>();

  var isDrawerOpen = false.obs;
  final isLoading = false.obs;
  final selectedCities = <CityModel>[].obs;
  final selectedCity = Rx<CityModel?>(null);
  final scrollController = ScrollController();
  static final Map<String, Map<String, dynamic>> _rawDataStorage = {};
  final rawForecastData = <String, dynamic>{}.obs;
  final isWeatherDataLoaded = false.obs;

  Timer? _autoUpdateTimer;
  static const Duration _updateInterval = Duration(minutes: 15);

  @override
  void onInit() {
    super.onInit();
    refreshWeatherData();
    _startAutoUpdate();
    _loadSelectedCities();
    _initializeSelectedCity();
  }

  @override
  void onReady() {
    super.onReady();
    _autoScrollToCurrentHour();
  }

  @override
  void onClose() {
    _autoUpdateTimer?.cancel();
    super.onClose();
  }

  void _autoScrollToCurrentHour() {
    ever(isWeatherDataLoaded, (bool loaded) {
      if (loaded) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final int currentHour = DateTime.now().hour;
          const double itemWidth = 80.0;

          if (scrollController.hasClients) {
            scrollController.animateTo(
              currentHour * itemWidth,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    });
  }

  void _startAutoUpdate() {
    _autoUpdateTimer = Timer.periodic(_updateInterval, (timer) {
      refreshWeatherData();
    });
  }

  Future<void> _initializeSelectedCity() async {
    await Future.delayed(const Duration(milliseconds: 100));
    selectedCity.value = splashController.chosenCity;
  }

  Future<void> _loadSelectedCities() async {
    try {
      final selectedCitiesJson = await localStorage.getString(
        'selected_cities',
      );
      if (selectedCitiesJson != null) {
        final List<dynamic> citiesData = json.decode(selectedCitiesJson);
        selectedCities.value = citiesData
            .map((data) => CityModel.fromJson(data))
            .toList();
      } else {
        final currentCity = splashController.currentCity;
        if (currentCity != null) {
          selectedCities.value = [currentCity];
          await _saveSelectedCities();
        }
      }
    } catch (e) {
      debugPrint('Error loading selected cities: $e');
    }
  }

  Future<void> _saveSelectedCities() async {
    try {
      final citiesJson = json.encode(
        selectedCities.map((c) => c.toJson()).toList(),
      );
      await localStorage.setString('selected_cities', citiesJson);
    } catch (e) {
      debugPrint('Error saving selected cities: $e');
    }
  }

  Future<void> changeSelectedCity(CityModel city) async {
    try {
      isLoading.value = true;
      selectedCity.value = city;
      splashController.selectedCity.value = city;
      await splashController.saveSelectedCityToStorage();
      conditionController.clearWeatherData();
      rawForecastData.clear();
      _loadWeatherDataForCity(city);
      _rawDataStorage[city.city] = Map<String, dynamic>.from(rawForecastData);
    } catch (e) {
      debugPrint('Error changing selected city: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadWeatherDataForCity(CityModel city) async {
    try {
      final (weather, forecast) = await getCurrentWeather(
        lat: city.latitude,
        lon: city.longitude,
      );
      conditionController.updateWeatherData([weather], 0, city.city);
      conditionController.updateWeeklyForecast(forecast);
      rawForecastData.value = splashController.rawWeatherData;
      isWeatherDataLoaded.value = true;
    } catch (e) {
      debugPrint('Failed to load weather data for ${city.city}: $e');
      isWeatherDataLoaded.value = false;
    }
  }

  Future<void> refreshWeatherData() async {
    final currentCity = selectedCity.value;
    if (currentCity == null) return;
    try {
      final (weather, forecast) = await getCurrentWeather(
        lat: currentCity.latitude,
        lon: currentCity.longitude,
      );
      conditionController.updateWeatherData([weather], 0, currentCity.city);
      conditionController.updateWeeklyForecast(forecast);
      rawForecastData.value = splashController.rawWeatherData;
      _rawDataStorage[currentCity.city] = Map<String, dynamic>.from(
        rawForecastData,
      );
    } catch (e) {
      debugPrint('Auto-update failed: $e');
    }
  }

  List<CityModel> get allCities => splashController.allCities;
  CityModel? get currentLocationCity => splashController.currentCity;
  String get selectedCityName =>
      selectedCity.value?.city ?? splashController.selectedCityName;
  bool get isAppReady => splashController.isAppReady;

  Map<String, dynamic>? get currentHourData =>
      fetchCurrentHour(rawForecastData);
  Map<String, dynamic>? getCityRawData(String cityName) {
    return _rawDataStorage[cityName];
  }

  static void cacheCityData(String cityName, Map<String, dynamic> data) {
    _rawDataStorage[cityName] = data;
  }
}
