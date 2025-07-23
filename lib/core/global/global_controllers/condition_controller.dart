import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/model/weather_model.dart';
import '../../../data/model/forecast_model.dart';
import '../../utils/weather_utils.dart';

class ConditionController extends GetxController {
  final mainCityWeather = Rx<WeatherModel?>(null);
  final selectedCitiesWeather = <WeatherModel>[].obs;
  final weeklyForecast = <Map<String, dynamic>>[].obs;
  final mainCityIndex = 0.obs;
  final mainCityName = ''.obs;

  String get temperature {
    return mainCityWeather.value != null
        ? '${mainCityWeather.value!.temperature.round()}'
        : '--';
  }

  String get condition {
    return mainCityWeather.value?.condition ?? 'Loading...';
  }

  String get chanceOfRain {
    return mainCityWeather.value != null
        ? '${mainCityWeather.value!.chanceOfRain}%'
        : '--%';
  }

  String get humidity {
    return mainCityWeather.value != null
        ? '${mainCityWeather.value!.humidity}%'
        : '--%';
  }

  String get windSpeed {
    return mainCityWeather.value != null
        ? '${mainCityWeather.value!.windSpeed.toStringAsFixed(1)}km/h'
        : '--km/h';
  }

  String get minTemp {
    if (weeklyForecast.isNotEmpty) {
      final todayForecast = weeklyForecast.firstWhere(
        (forecast) => forecast['day'] == 'Today',
        orElse: () => weeklyForecast.first,
      );
      return '${todayForecast['minTemp']?.round() ?? '--'}';
    }
    return '--';
  }

  String get maxTemp {
    if (weeklyForecast.isNotEmpty) {
      final todayForecast = weeklyForecast.firstWhere(
        (forecast) => forecast['day'] == 'Today',
        orElse: () => weeklyForecast.first,
      );
      return '${todayForecast['temp']?.round() ?? '--'}';
    }
    return '--';
  }

  String get weatherIconPath {
    if (mainCityWeather.value != null) {
      String weatherType = WeatherUtils.getWeatherIcon(
        mainCityWeather.value!.code,
      );
      return WeatherUtils.getWeatherIconPath(weatherType);
    }
    return WeatherUtils.getWeatherIconPath('clear');
  }

  List<WeatherModel> get otherCitiesWeather {
    if (selectedCitiesWeather.length <= 1) return [];
    String currentMainCityName = mainCityWeather.value?.cityName ?? '';
    return selectedCitiesWeather
        .where((weather) => weather.cityName != currentMainCityName)
        .toList();
  }

  List<Map<String, dynamic>> getHourlyDataForDate({
    required String targetDate,
    required Map<String, dynamic> rawForecastData,
  }) {
    final forecastDays = rawForecastData['forecast']?['forecastday'] as List?;
    if (forecastDays == null) return [];

    final targetDay = forecastDays.firstWhere(
      (day) => day['date'] == targetDate,
      orElse: () => null,
    );

    if (targetDay != null) {
      final hourly = targetDay['hour'] as List;
      return hourly.map((hour) {
        return {
          'time': hour['time'],
          'temp_c': (hour['temp_c'] as num).toDouble(),
          'condition': hour['condition']['text'],
          'iconUrl': 'https:${hour['condition']['icon']}',
          'humidity': hour['humidity'],
          'wind_kph': (hour['wind_kph'] as num).toDouble(),
          'chance_of_rain': hour['chance_of_rain'],
          'precip_mm': (hour['precip_mm'] as num).toDouble(),
          'feels_like_c': (hour['feelslike_c'] as num).toDouble(),
          'uv': (hour['uv'] as num).toDouble(),
          'pressure_mb': (hour['pressure_mb'] as num).toDouble(),
          'vis_km': (hour['vis_km'] as num).toDouble(),
          'gust_kph': (hour['gust_kph'] as num).toDouble(),
        };
      }).toList();
    }

    return [];
  }

  void updateWeatherData(
    List<WeatherModel> weatherList,
    int mainIndex,
    String cityName,
  ) {
    selectedCitiesWeather.value = weatherList;
    mainCityIndex.value = mainIndex;
    mainCityName.value = cityName;
    if (weatherList.isNotEmpty && mainIndex < weatherList.length) {
      mainCityWeather.value = weatherList[mainIndex];
    }
  }

  void updateWeeklyForecast(List<ForecastModel> forecastList) {
    weeklyForecast.value = forecastList.map((forecast) {
      return {
        'day': getDayName(forecast.date),
        'date': DateTime.parse(forecast.date),
        'dateString': forecast.date,
        'temp': forecast.maxTemp,
        'minTemp': forecast.minTemp,
        'iconUrl': forecast.iconUrl,
        'condition': forecast.condition,
        'humidity': forecast.humidity,
        'windSpeed': forecast.windSpeed,
        'chanceOfRain': forecast.chanceOfRain,
      };
    }).toList();
  }

  String getDayName(String dateString) {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);
    final difference = targetDate.difference(today).inDays;
    if (difference == 0) {
      return 'Today';
    } else {
      return DateFormat('EEE').format(date);
    }
  }

  Map<String, dynamic>? getForecastForDay(int index) {
    if (index >= 0 && index < weeklyForecast.length) {
      return weeklyForecast[index];
    }
    return null;
  }

  void clearWeatherData() {
    mainCityWeather.value = null;
    selectedCitiesWeather.clear();
    weeklyForecast.clear();
    mainCityName.value = '';
  }
}
