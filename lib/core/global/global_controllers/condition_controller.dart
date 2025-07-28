import 'package:get/get.dart';
import '../../../data/model/weather_model.dart';
import '../../../data/model/forecast_model.dart';
import '../../utils/date_time_util.dart';

class ConditionController extends GetxController {
  final mainCityWeather = Rx<WeatherModel?>(null);
  final selectedCitiesWeather = <WeatherModel>[].obs;
  final allCitiesWeather = <String, WeatherModel>{}.obs;
  final weeklyForecast = <Map<String, dynamic>>[].obs;
  final mainCityName = ''.obs;
  final rawForecastData = <String, dynamic>{}.obs;
  String get minTemp => _getTodayForecastValue('minTemp');
  String get maxTemp => _getTodayForecastValue('temp');
  String get chanceOfRain => '${mainCityWeather.value?.chanceOfRain ?? '--'}%';
  String get humidity => '${mainCityWeather.value?.humidity ?? '--'}%';
  String get windSpeed =>
      '${mainCityWeather.value?.windSpeed.toStringAsFixed(1) ?? '--'}km/h';

  void updateWeatherData(
    List<WeatherModel> weatherList,
    int mainIndex,
    String cityName,
  ) {
    mainCityName.value = cityName;
    mainCityWeather.value = (mainIndex < weatherList.length)
        ? weatherList[mainIndex]
        : null;
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
  }

  void clearWeatherData() {
    mainCityWeather.value = null;
    selectedCitiesWeather.clear();
    weeklyForecast.clear();
    mainCityName.value = '';
    rawForecastData.clear();
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
    return DateTimeUtils.isToday(date)
        ? 'Today'
        : DateTimeUtils.getWeekday(date);
  }
}
