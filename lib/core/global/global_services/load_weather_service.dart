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

  Future<void> loadWeatherForAllCities(
    List<CityModel> cities, {
    CityModel? selectedCity,
  }) async {
    try {
      String? selectedCityName = selectedCity?.city;

      for (var city in cities) {
        final (weather, forecast) = await getCurrentWeather(
          lat: city.latitude,
          lon: city.longitude,
        );

        if (selectedCityName != null && city.city == selectedCityName) {
          conditionController.updateWeatherData([weather], 0, city.city);
          conditionController.updateWeeklyForecast(forecast);
        }
        conditionController.allCitiesWeather[city.city] = weather;
      }
    } catch (e) {
      debugPrint('${AppExceptions().failToLoadWeather}: $e');
      conditionController.allCitiesWeather.clear();
    }
  }
}
