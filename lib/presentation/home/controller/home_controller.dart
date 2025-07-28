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
    print('[HomeController] onInit called');
    final fallbackCity = splashController.currentCity;
    final cities = await cityStorageService.loadSelectedCities(fallbackCity);
    print(
      '[HomeController] Loaded cities: ${cities.map((e) => e.city).toList()}',
    );

    if (cities.isEmpty) {
      while (!splashController.isAppReady) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
      final splashSelectedCity = splashController.chosenCity;
      print(
        '[HomeController] Using splash selected city: ${splashSelectedCity?.city}',
      );
      if (splashSelectedCity != null) {
        selectedCities.value = [splashSelectedCity];
        await _initializeSelectedCity(splashSelectedCity);
      }
    } else {
      print(
        '[HomeController] Using stored selected city: ${cities.first.city}',
      );
      selectedCities.value = cities;
      await _initializeSelectedCity(cities.first);
    }

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
      loadWeatherService.loadWeatherForAllCities(
        allCities,
        selectedCity: selectedCity.value,
        currentLocationCity: currentLocationCity,
      );
    });
  }

  Future<void> _initializeSelectedCity(CityModel city) async {
    print(
      '[HomeController] _initializeSelectedCity called for: ${city.cityAscii}',
    );
    while (!splashController.isAppReady) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    selectedCity.value = city;
    final cityData = _rawDataStorage[city.cityAscii];

    if (cityData != null) {
      print(
        '##############################[HomeController] Found cached data for: ${city.cityAscii}',
      );
      rawForecastData.value = Map<String, dynamic>.from(cityData);
    } else {
      print(
        '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@[HomeController] No cached data found for: ${city.cityAscii}',
      );
    }
  }

  List<CityModel> get allCities => splashController.allCities;
  CityModel? get currentLocationCity => splashController.currentCity;
  String get selectedCityName =>
      selectedCity.value?.city ?? splashController.selectedCityName;
  bool get isAppReady => splashController.isAppReady;

  static void cacheCityData(String cityName, Map<String, dynamic> data) {
    _rawDataStorage[cityName] = data;
  }
}
