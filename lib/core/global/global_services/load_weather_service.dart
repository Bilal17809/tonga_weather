import 'package:flutter/foundation.dart';
import 'package:tonga_weather/core/common/app_exceptions.dart';

import '../../../data/model/city_model.dart';
import '../../../domain/use_cases/get_current_weather.dart';
import '../global_controllers/condition_controller.dart';

class LoadWeatherService {
  final GetWeatherAndForecast getCurrentWeather;
  final ConditionController conditionController;

  LoadWeatherService({
    required this.getCurrentWeather,
    required this.conditionController,
  });

  Future<void> loadWeatherData(CityModel? selectedCity) async {
    try {
      if (selectedCity == null) return;

      final (weather, forecast) = await getCurrentWeather(
        lat: selectedCity.latitude,
        lon: selectedCity.longitude,
      );
      conditionController.updateWeatherData([weather], 0, selectedCity.city);
      conditionController.updateWeeklyForecast(forecast);
    } catch (e) {
      debugPrint('${AppExceptions().failToLoadWeather}: $e');
      conditionController.clearWeatherData();
    }
  }
}

// Future<void> loadWeatherData(double lat,double lon) async {
//   try {
//     conditionController.updateWeeklyForecast(lat,long);
//   }
//
// }catch (e) {
// }
