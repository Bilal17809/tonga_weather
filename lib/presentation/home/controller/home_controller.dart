import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tonga_weather/ads_manager/interstitial_ads.dart';
import '/core/mixins/connectivity_mixin.dart';
import '/core/services/services.dart';
import 'package:tonga_weather/data/model/city_model.dart';
import '/ads_manager/banner_ads.dart';
import '/core/constants/constant.dart';
import '/presentation/splash/controller/splash_controller.dart';
import '/domain/use_cases/use_case.dart';

class HomeController extends GetxController with ConnectivityMixin {
  final GetWeatherAndForecast getCurrentWeather;
  final CityStorageService cityStorageService;
  final LoadWeatherService loadWeatherService;

  HomeController(this.getCurrentWeather)
    : cityStorageService = Get.find<CityStorageService>(),
      loadWeatherService = Get.find<LoadWeatherService>();

  final splashController = Get.find<SplashController>();
  final conditionController = Get.find<ConditionService>();
  var isDrawerOpen = false.obs;
  final isLoading = false.obs;
  final selectedCities = <CityModel>[].obs;
  final selectedCity = Rx<CityModel?>(null);
  final scrollController = ScrollController();
  final isWeatherDataLoaded = false.obs;
  Timer? _autoUpdateTimer;

  @override
  void onInit() async {
    super.onInit();
    Get.find<InterstitialAdManager>().checkAndDisplayAd();
    Get.find<BannerAdManager>().loadBannerAd('ad1');
    while (!splashController.isAppReady) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    final allCities = splashController.allCities;
    final fallbackCity = splashController.currentCity;
    final selectedCityFromStorage = await cityStorageService.loadSelectedCity(
      allCities: allCities,
      currentLocationCity: fallbackCity,
    );
    selectedCities.value = [selectedCityFromStorage];
    await _initializeSelectedCity(selectedCityFromStorage);
    _startAutoUpdate();
    _setupAutoScroll();
    ever(splashController.selectedCity, (CityModel? newCity) async {
      if (newCity != null &&
          LocationUtilsService.fromCityModel(selectedCity.value!) !=
              LocationUtilsService.fromCityModel(newCity)) {
        selectedCities.value = [newCity];
        await _initializeSelectedCity(newCity);
        _performAutoScroll();
      }
    });
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
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (!scrollController.hasClients) return;
      timer.cancel();
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
    while (!splashController.isAppReady) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    selectedCity.value = city;
  }

  List<CityModel> get allCities => splashController.allCities;
  CityModel? get currentLocationCity => splashController.currentCity;
  String get selectedCityName =>
      selectedCity.value?.city ?? splashController.selectedCityName;
  bool get isAppReady => splashController.isAppReady;
}
