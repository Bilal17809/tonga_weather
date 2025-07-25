import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tonga_weather/core/global/global_controllers/condition_controller.dart';
import 'package:tonga_weather/core/global/global_services/city_storage_service.dart';
import 'package:tonga_weather/core/global/global_services/connectivity_service.dart';
import 'package:tonga_weather/core/utils/fetch_current_hour.dart';
import 'package:tonga_weather/data/model/city_model.dart';
import '../../../core/common/app_exceptions.dart';
import '../../../core/constants/constant.dart';
import '../../../core/global/global_services/load_weather_service.dart';
import '../../splash/controller/splash_controller.dart';
import '../../../domain/use_cases/get_current_weather.dart';

class HomeController extends GetxController with ConnectivityMixin {
  final GetWeatherAndForecast getCurrentWeather;
  final CityStorageService cityStorageService;
  final LoadWeatherService loadWeatherService;

  HomeController(this.getCurrentWeather)
    : cityStorageService = Get.find<CityStorageService>(),
      loadWeatherService = Get.find<LoadWeatherService>();

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

  @override
  void onInit() async {
    super.onInit();
    _refreshWeatherData();
    final fallbackCity = splashController.currentCity;
    final cities = await cityStorageService.loadSelectedCities(fallbackCity);
    selectedCities.value = cities;
    await _initializeSelectedCity(cities.first);
    _startAutoUpdate();
    _setupAutoScroll();
  }

  @override
  void onClose() {
    _autoUpdateTimer?.cancel();
    super.onClose();
  }

  void _setupAutoScroll() {
    ever(isWeatherDataLoaded, (bool loaded) {
      if (loaded) {
        _performAutoScroll();
      }
    });
    if (isWeatherDataLoaded.value) {
      _performAutoScroll();
    }
  }

  void _performAutoScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;
      final context = scrollController.position.context.storageContext;
      final double itemWidth = mobileWidth(context) * 0.22;
      final int currentHour = DateTime.now().hour;
      final double targetScrollOffset = currentHour * itemWidth;

      scrollController.animateTo(
        targetScrollOffset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void _startAutoUpdate() {
    _autoUpdateTimer = Timer.periodic(const Duration(minutes: 15), (timer) {
      _refreshWeatherData();
    });
  }

  // Future<void> _initializeSelectedCity() async {
  //   await Future.delayed(const Duration(milliseconds: 100));
  //   selectedCity.value = splashController.chosenCity;
  // }
  Future<void> _initializeSelectedCity(CityModel city) async {
    while (!splashController.isAppReady) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    selectedCity.value = splashController.chosenCity;
    rawForecastData.value = Map<String, dynamic>.from(
      _rawDataStorage[city.city]!,
    );
    // if (selectedCity.value != null) {
    //   final cityWeather =
    //   conditionController.allCitiesWeather[selectedCity.value!.city];
    //   if (cityWeather != null) {
    //     try {
    //       final (_, forecast) = await getCurrentWeather(
    //         lat: selectedCity.value!.latitude,
    //         lon: selectedCity.value!.longitude,
    //       );
    //       conditionController.updateWeeklyForecast(forecast);
    //     } catch (e) {
    //       debugPrint('${AppExceptions().failToLoadWeather}: $e');
    //     }
    //   }
    // }
  }

  Future<void> changeSelectedCity(CityModel city) async {
    try {
      isLoading.value = true;
      selectedCity.value = city;
      splashController.selectedCity.value = city;
      await splashController.cityStorageService.saveSelectedCity(city);
      conditionController.clearWeatherData();
      rawForecastData.clear();
      isWeatherDataLoaded.value = false;
      if (_rawDataStorage.containsKey(city.city)) {
        rawForecastData.value = Map<String, dynamic>.from(
          _rawDataStorage[city.city]!,
        );
        await _updateConditionControllerFromCache(city);
        isWeatherDataLoaded.value = true;
      } else {
        await _loadWeatherDataForCity(city);
      }
    } catch (e) {
      debugPrint('Error changing selected city: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _updateConditionControllerFromCache(CityModel city) async {
    try {
      final (weather, forecast) = await getCurrentWeather(
        lat: city.latitude,
        lon: city.longitude,
      );
      conditionController.updateWeatherData([weather], 0, city.city);
      conditionController.updateWeeklyForecast(forecast);
      final rawData = getCityRawData(city.city);
      if (rawData != null) {
        rawForecastData.value = Map<String, dynamic>.from(rawData);
        _rawDataStorage[city.city] = Map<String, dynamic>.from(rawData);
      }
    } catch (e) {
      debugPrint('Error updating condition controller from cache: $e');
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

      final rawData = getCityRawData(city.city);
      if (rawData != null) {
        rawForecastData.value = Map<String, dynamic>.from(rawData);
        _rawDataStorage[city.city] = Map<String, dynamic>.from(rawData);
      }
      isWeatherDataLoaded.value = true;
    } catch (e) {
      debugPrint('Failed to load weather data for ${city.city}: $e');
      isWeatherDataLoaded.value = false;
    }
  }

  Future<void> _refreshWeatherData() async {
    final currentCity = selectedCity.value;
    if (currentCity == null) return;

    try {
      final (weather, forecast) = await getCurrentWeather(
        lat: currentCity.latitude,
        lon: currentCity.longitude,
      );
      conditionController.updateWeatherData([weather], 0, currentCity.city);
      conditionController.updateWeeklyForecast(forecast);

      final rawData = getCityRawData(currentCity.city);
      if (rawData != null) {
        rawForecastData.value = Map<String, dynamic>.from(rawData);
        _rawDataStorage[currentCity.city] = Map<String, dynamic>.from(rawData);
      }
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
