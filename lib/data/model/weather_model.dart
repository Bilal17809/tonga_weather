import '/core/services/services.dart';
import 'aqi_model.dart';

class WeatherModel {
  final String cityName;
  final double temperature;
  final String region;
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
    required this.region,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final current = json['current'];
    final condition = current['condition'];
    final forecastHours =
        json['forecast']['forecastday'][0]['hour'] as List<dynamic>;
    final currentTime = DateTime.now();
    return WeatherModel(
      cityName: json['location']['name'],
      region: json['location']['region'],
      temperature: (current['temp_c'] as num).toDouble(),
      condition: condition['text'],
      humidity: current['humidity'],
      windSpeed: WeatherParsingService.parseWindSpeed(current),
      chanceOfRain: WeatherParsingService.extractCurrentChanceOfRain(
        forecastHours,
        currentTime,
      ),
      iconUrl: WeatherParsingService.parseIconUrl(condition),
      code: condition['code'],
      airQuality: WeatherParsingService.parseAirQuality(current['air_quality']),
    );
  }
}
