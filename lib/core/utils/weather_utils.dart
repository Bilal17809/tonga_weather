import 'package:get/get.dart';
import 'package:tonga_weather/core/services/weather_codes_loader.dart';

class WeatherUtils {
  static final Map<String, dynamic> _weatherIcon = {
    'clear': 'images/clear.png',
    'cloudy': 'images/cloudy.png',
    'rain': 'images/rain.png',
    'snow': 'images/snow.png',
    'thunderstorm': 'images/thunderstorm.png',
    'sleet': 'images/sleet.png',
  };

  static final Map<String, String> _weatherBg = {
    'clear': 'images/clear-day.jpg',
    'cloudy': 'images/cloudy-day.jpg',
    'rain': 'images/rain-day.jpg',
    'snow': 'images/snow-day.jpg',
    'thunderstorm': 'images/thunderstorm-day.jpg',
    'sleet': 'images/sleet-day.jpg',
  };

  static String getWeatherIcon(int code) {
    final weatherType = Get.find<WeatherCodesLoader>().getWeatherType(code);
    return weatherType;
  }

  static String getWeatherIconPath(String weatherType) {
    return _weatherIcon[weatherType.toLowerCase()] ?? _weatherIcon['clear']!;
  }

  static String getWeatherBgPath(String weatherType) {
    return _weatherBg[weatherType.toLowerCase()] ?? _weatherBg['clear']!;
  }
}
