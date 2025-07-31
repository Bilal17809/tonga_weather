import 'package:tonga_weather/core/utils/date_time_util.dart';
import '/data/model/aqi_model.dart';

class WeatherParsingService {
  static int extractCurrentChanceOfRain(
    List<dynamic> hourlyData,
    DateTime currentTime,
  ) {
    for (var hour in hourlyData) {
      final hourTime = DateTimeUtils.parseLocal(hour['time']);
      if (hourTime.hour == currentTime.hour &&
          hourTime.day == currentTime.day &&
          hourTime.month == currentTime.month &&
          hourTime.year == currentTime.year) {
        return hour['chance_of_rain'] ?? 0;
      }
    }
    return 0;
  }

  static double parseWindSpeed(dynamic current) {
    return (current?['wind_kph'] as num?)?.toDouble() ?? 0.0;
  }

  static String parseIconUrl(dynamic condition) {
    final icon = condition?['icon'];
    return icon != null ? 'https:$icon' : '';
  }

  static AirQualityModel? parseAirQuality(dynamic airQualityJson) {
    if (airQualityJson != null) {
      return AirQualityModel.fromJson(airQualityJson);
    }
    return null;
  }
}
