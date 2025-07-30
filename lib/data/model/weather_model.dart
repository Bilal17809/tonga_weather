import '../../core/utils/date_time_util.dart';
import 'aqi_model.dart';

class WeatherModel {
  final String cityName;
  final double temperature;
  final String condition;
  final int humidity;
  final double windSpeed;
  final int chanceOfRain;
  final String iconUrl;
  final int code;
  final AirQualityModel? airQuality;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.chanceOfRain,
    required this.iconUrl,
    required this.code,
    this.airQuality,
  });

  factory WeatherModel.fromForecastJson(Map<String, dynamic> json) {
    final currentTime = DateTime.now();
    final hourlyData =
        json['forecast']['forecastday'][0]['hour'] as List<dynamic>;

    int currentChanceOfRain = 0;
    for (var hour in hourlyData) {
      final hourTime = DateTimeUtils.parseLocal(hour['time']);

      if (hourTime.hour == currentTime.hour &&
          hourTime.day == currentTime.day &&
          hourTime.month == currentTime.month &&
          hourTime.year == currentTime.year) {
        currentChanceOfRain = hour['chance_of_rain'] ?? 0;
        break;
      }
    }

    final windSpeedKmh =
        (json['current']?['wind_kph'] as num?)?.toDouble() ?? 0.0;

    final iconUrl = json['current']?['condition']?['icon'] != null
        ? 'https:${json['current']['condition']['icon']}'
        : '';

    AirQualityModel? airQuality;
    if (json['current']?['air_quality'] != null) {
      airQuality = AirQualityModel.fromJson(json['current']['air_quality']);
    }

    return WeatherModel(
      cityName: json['location']['name'],
      temperature: (json['current']['temp_c'] as num).toDouble(),
      condition: json['current']['condition']['text'],
      humidity: json['current']['humidity'],
      windSpeed: windSpeedKmh,
      chanceOfRain: currentChanceOfRain,
      iconUrl: iconUrl,
      code: json['current']['condition']['code'],
      airQuality: airQuality,
    );
  }
}
