import 'package:get/get.dart';
import '/core/services/weather_codes_loader.dart';

enum WeatherCondition { clear, cloudy, rain, sleet, snow, thunderstorm }

extension WeatherConditionExtension on String {
  WeatherCondition get toWeatherCondition {
    final lower = toLowerCase();
    if (lower.contains('thunder')) return WeatherCondition.thunderstorm;
    if (lower.contains('snow')) return WeatherCondition.snow;
    if (lower.contains('sleet')) return WeatherCondition.sleet;
    if (lower.contains('rain') || lower.contains('drizzle')) {
      return WeatherCondition.rain;
    }
    if (lower.contains('cloud') ||
        lower.contains('overcast') ||
        lower.contains('mist') ||
        lower.contains('fog')) {
      return WeatherCondition.cloudy;
    }
    if (lower.contains('sun') || lower.contains('clear')) {
      return WeatherCondition.clear;
    }
    return WeatherCondition.clear;
  }
}

extension WeatherCodeExtension on int {
  WeatherCondition get toWeatherCondition {
    final loader = Get.find<WeatherCodesLoader>();
    final type = loader.getWeatherType(this);

    switch (type.toLowerCase()) {
      case 'clear':
        return WeatherCondition.clear;
      case 'cloudy':
        return WeatherCondition.cloudy;
      case 'rain':
        return WeatherCondition.rain;
      case 'snow':
        return WeatherCondition.snow;
      case 'sleet':
        return WeatherCondition.sleet;
      case 'thunderstorm':
        return WeatherCondition.thunderstorm;
      default:
        return WeatherCondition.clear;
    }
  }
}
