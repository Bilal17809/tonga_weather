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
  static final Map<String, Map<String, dynamic>> _rawDataStorage = {};
  var showButton = false.obs;

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(milliseconds: 500), () {
      initWithConnectivityCheck(
        context: Get.context!,
        onConnected: () async {
          await _initializeApp();
          // final savedCityJson = await localStorage.getString('selected_city');
          // final hasCurrentLocation =
          //     await localStorage.getBool('has_current_location') ?? false;
          // isFirstLaunch.value = savedCityJson == null || !hasCurrentLocation;
          // if(savedCityJson!.isEmpty){
          //   await loadWeatherService.loadWeatherForAllCities(allCities);
          //   // await loadWeatherService.loadWeatherData(savedCityJson.value);
          // }else
          //
          // print(
          //   '#################################### ${conditionController.allCitiesWeather}',
          // );
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
      );

      isDataLoaded.value = true;
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
        (city) => city.city.toLowerCase() == 'nukualofa',
        orElse: () => allCities.first,
      );
      selectedCity.value = nukualofa;
    }

    await cityStorageService.saveSelectedCity(selectedCity.value);
    await localStorage.setBool('has_current_location', currentCity != null);
  }

  String get selectedCityName => selectedCity.value?.city ?? 'Loading...';
  bool get isAppReady => isDataLoaded.value;
  CityModel? get currentCity => currentLocationCity.value;
  CityModel? get chosenCity => selectedCity.value;
  bool get isFirstTime => isFirstLaunch.value;
  Map<String, dynamic> get rawWeatherData =>
      _rawDataStorage[selectedCityName] ?? {};
}
