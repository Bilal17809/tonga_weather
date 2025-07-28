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
    CityModel? currentLocationCity,
  }) async {
    try {
      String? selectedCityName = selectedCity?.cityAscii;
      for (var city in cities) {
        final (weather, forecast) = await getCurrentWeather(
          lat: city.latitude,
          lon: city.longitude,
        );
        if (selectedCityName != null && city.cityAscii == selectedCityName) {
          conditionController.updateWeatherData([weather], 0, city.cityAscii);
          conditionController.updateWeeklyForecast(forecast);
        }
        conditionController.allCitiesWeather[city.cityAscii] = weather;
      }
      if (currentLocationCity != null) {
        final isCurrentLocationInCities = cities.any(
          (city) => city.cityAscii == currentLocationCity.cityAscii,
        );
        if (!isCurrentLocationInCities) {
          final (weather, forecast) = await getCurrentWeather(
            lat: currentLocationCity.latitude,
            lon: currentLocationCity.longitude,
          );
          if (selectedCityName != null &&
              currentLocationCity.cityAscii == selectedCityName) {
            conditionController.updateWeatherData(
              [weather],
              0,
              currentLocationCity.cityAscii,
            );
            conditionController.updateWeeklyForecast(forecast);
          }
          conditionController.allCitiesWeather[currentLocationCity.cityAscii] =
              weather;
        }
      }
    } catch (e) {
      debugPrint('${AppExceptions().failToLoadWeather}: $e');
      conditionController.allCitiesWeather.clear();
    }
  }
}
