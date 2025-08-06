import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tonga_weather/core/common/app_exceptions.dart';
import 'package:tonga_weather/core/theme/app_colors.dart';
import '/core/mixins/connectivity_mixin.dart';
import '/core/services/services.dart';
import '/core/local_storage/local_storage.dart';
import '/domain/use_cases/use_case.dart';
import '/data/model/city_model.dart';
import '/presentation/home/controller/home_controller.dart';

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

  final conditionController = Get.find<ConditionService>();
  final isLoading = true.obs;
  final isDataLoaded = false.obs;
  final allCities = <CityModel>[].obs;
  final currentLocationCity = Rx<CityModel?>(null);
  final selectedCity = Rx<CityModel?>(null);
  final isFirstLaunch = true.obs;
  final RxMap<String, dynamic> _rawDataStorage =
      <String, Map<String, dynamic>>{}.obs;
  final rawForecastData = <String, dynamic>{}.obs;
  var visibleLetters = 0.obs;
  var title = kOrange.obs;
  final String _targetText = 'Real Time Tonga Forecast Updates';
  bool _colorUpdate = true;
  var showButton = false.obs;
  Timer? _flickerTimer;
  Timer? _letterTimer;
  final Color _color1 = kWhite;
  final Color _color2 = kOrange;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startSloganAnimation();
      _animateTitle();
    });
  }

  void _animateTitle() {
    _letterTimer?.cancel();
    _letterTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
      if (visibleLetters.value < _targetText.length) {
        visibleLetters.value++;
      } else {
        timer.cancel();
      }
    });
  }

  void _startSloganAnimation() {
    title.value = _color1;
    _flickerTimer?.cancel();

    _flickerTimer = Timer.periodic(const Duration(milliseconds: 800), (_) {
      title.value = _colorUpdate ? _color2 : _color1;
      _colorUpdate = !_colorUpdate;
    });
  }

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
    final key = LocationUtilsService.fromCityModel(selectedCity.value!);
    return _rawDataStorage[key] ?? {};
  }

  void cacheCityData(String key, Map<String, dynamic> data) {
    _rawDataStorage[key] = data;
  }

  void _updateRawForecastDataForCurrentCity() {
    final key = LocationUtilsService.fromCityModel(selectedCity.value!);
    if (_rawDataStorage.containsKey(key)) {
      rawForecastData.value = Map<String, dynamic>.from(_rawDataStorage[key]!);
    }
  }

  @override
  void onClose() {
    _flickerTimer?.cancel();
    _letterTimer?.cancel();
    super.onClose();
  }
}
