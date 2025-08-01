import 'package:get/get.dart';
import 'package:tonga_weather/core/platform_channel/android_widget_channel.dart';
import '../../data/model/weather_model.dart';
import '../../data/model/forecast_model.dart';
import 'date_time_service.dart';

class ConditionService extends GetxController {
  final mainCityWeather = Rx<WeatherModel?>(null);
  final selectedCitiesWeather = <WeatherModel>[].obs;
  final allCitiesWeather = <String, WeatherModel>{}.obs;
  final weeklyForecast = <Map<String, dynamic>>[].obs;
  final mainCityName = ''.obs;

  void updateWeatherData(
    List<WeatherModel> weatherList,
    int mainIndex,
    String cityName,
  ) {
    mainCityName.value = cityName;
    mainCityWeather.value = (mainIndex < weatherList.length)
        ? weatherList[mainIndex]
        : null;
    if (mainCityWeather.value != null) {
      WidgetUpdateManager.updateWeatherWidget();
    }
  }

  void updateWeeklyForecast(List<ForecastModel> forecastList) {
    weeklyForecast.value = forecastList.map((f) {
      return {
        'day': _getDayLabel(f.date),
        'date': DateTime.parse(f.date),
        'dateString': f.date,
        'temp': f.maxTemp,
        'minTemp': f.minTemp,
        'iconUrl': f.iconUrl,
        'condition': f.condition,
        'humidity': f.humidity,
        'windSpeed': f.windSpeed,
        'chanceOfRain': f.chanceOfRain,
      };
    }).toList();
    if (mainCityWeather.value != null && mainCityName.value.isNotEmpty) {
      WidgetUpdateManager.updateWeatherWidget();
    }
  }

  String _formatTemp(num? temp) => temp != null ? '${temp.round()}' : '--';

  String _getTodayForecastValue(String key) {
    if (weeklyForecast.isEmpty) return '--';
    final today = weeklyForecast.firstWhere(
      (d) => d['day'] == 'Today',
      orElse: () => weeklyForecast.first,
    );
    return _formatTemp(today[key] as num?);
  }

  String _getDayLabel(String dateStr) {
    final date = DateTime.parse(dateStr);
    return DateTimeService.isToday(date)
        ? 'Today'
        : DateTimeService.getWeekday(date);
  }

  String get minTemp => _getTodayForecastValue('minTemp');
  String get maxTemp => _getTodayForecastValue('temp');
  String get chanceOfRain => '${mainCityWeather.value?.chanceOfRain ?? '--'}%';
  String get humidity => '${mainCityWeather.value?.humidity ?? '--'}%';
  String get windSpeed =>
      '${mainCityWeather.value?.windSpeed.toStringAsFixed(1) ?? '--'}km/h';
}
