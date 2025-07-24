import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/global/global_controllers/condition_controller.dart';
import '../../../core/global/global_services/connectivity_service.dart';
import '../../../core/local_storage/local_storage.dart';
import '../../../domain/use_cases/get_current_weather.dart';
import '../../../data/model/city_model.dart';
import '../../../gen/assets.gen.dart';

class SplashController extends GetxController with ConnectivityMixin {
  final GetWeatherAndForecast getCurrentWeather;
  final LocalStorage localStorage = LocalStorage();

  SplashController(this.getCurrentWeather);

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
          _initializeApp();
        },
      );
    });
  }

  Future<void> _initializeApp() async {
    try {
      isLoading.value = true;
      isDataLoaded.value = false;

      await _loadAllCities();
      await _checkFirstLaunch();
      await _getCurrentLocation();

      if (isFirstLaunch.value) {
        await _setupFirstLaunch();
      } else {
        await _loadSelectedCityFromStorage();
      }

      await _loadWeatherData();
      isDataLoaded.value = true;
    } catch (e) {
      debugPrint('Error during app initialization: $e');
      isDataLoaded.value = true;
    } finally {
      isLoading.value = false;
      showButton.value = true;
    }
  }

  Future<void> _loadAllCities() async {
    final String response = await rootBundle.loadString(Assets.cities);
    final List<dynamic> data = json.decode(response);
    allCities.value = data.map((city) => CityModel.fromJson(city)).toList();
  }

  Future<void> _checkFirstLaunch() async {
    try {
      final savedCityJson = await localStorage.getString('selected_city');
      final hasCurrentLocation =
          await localStorage.getBool('has_current_location') ?? false;
      isFirstLaunch.value = savedCityJson == null || !hasCurrentLocation;
    } catch (e) {
      debugPrint('First launch check error: $e');
      isFirstLaunch.value = true;
    }
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

    await saveSelectedCityToStorage();
    await localStorage.setBool('has_current_location', currentCity != null);
  }

  Future<void> _loadSelectedCityFromStorage() async {
    try {
      final savedCityJson = await localStorage.getString('selected_city');

      if (savedCityJson != null) {
        final cityData = json.decode(savedCityJson);
        selectedCity.value = CityModel.fromJson(cityData);
      } else {
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
        await saveSelectedCityToStorage();
      }
    } catch (e) {
      debugPrint("Failed to load selected city from storage: $e");
      if (allCities.isNotEmpty) {
        selectedCity.value = allCities.first;
        await saveSelectedCityToStorage();
      }
    }
  }

  Future<void> saveSelectedCityToStorage() async {
    try {
      if (selectedCity.value != null) {
        final cityJson = json.encode(selectedCity.value!.toJson());
        await localStorage.setString('selected_city', cityJson);
      }
    } catch (e) {
      debugPrint("Failed to save selected city to storage: $e");
    }
  }

  Future<void> _loadWeatherData() async {
    try {
      if (selectedCity.value == null) return;

      final city = selectedCity.value!;
      final (weather, forecast) = await getCurrentWeather(
        lat: city.latitude,
        lon: city.longitude,
      );

      conditionController.updateWeatherData([weather], 0, city.city);
      conditionController.updateWeeklyForecast(forecast);
    } catch (e) {
      debugPrint('Failed to load weather data: $e');
      conditionController.clearWeatherData();
    }
  }

  static void storeRawDataForCity(String cityName, Map<String, dynamic> data) {
    _rawDataStorage[cityName] = data;
  }

  String get selectedCityName => selectedCity.value?.city ?? 'Loading...';
  bool get isAppReady => isDataLoaded.value;
  CityModel? get currentCity => currentLocationCity.value;
  CityModel? get chosenCity => selectedCity.value;
  bool get isFirstTime => isFirstLaunch.value;
  Map<String, dynamic> get rawWeatherData =>
      _rawDataStorage[selectedCityName] ?? {};
}
