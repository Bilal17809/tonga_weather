import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:tonga_weather/presentation/splash/controller/splash_controller.dart';
import '../../core/common/app_exceptions.dart';
import '../../core/config/enviroment.dart';
import '../model/weather_model.dart';
import '../model/forecast_model.dart';

class OnlineDataSource {
  static const baseUrl = EnvironmentConfig;
  final String apiKey;
  OnlineDataSource(this.apiKey);
  Future<(WeatherModel, List<ForecastModel>)> getWeatherAndForecast({
    required double lat,
    required double lon,
    int days = 7,
  }) async {
    final uri = Uri.parse(
      '$baseUrl?key=$apiKey&q=$lat,$lon&days=$days&aqi=yes&alerts=no',
    );
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final splashController = Get.find<SplashController>();
      final latLonKey = '${lat.toStringAsFixed(4)},${lon.toStringAsFixed(4)}';
      splashController.cacheCityData(latLonKey, data);
      splashController.rawForecastData.value = data;
      final current = WeatherModel.fromJson(data);
      final forecastDays = data['forecast']['forecastday'] as List;
      final forecast = forecastDays
          .map((e) => ForecastModel.fromJson(e))
          .toList();
      return (current, forecast);
    } else {
      throw Exception(
        '${AppExceptions().failedApiCall}: ${response.statusCode}',
      );
    }
  }

  /// For Current Location
  Future<String> getCity(double lat, double lon) async {
    final uri = Uri.parse('$baseUrl?key=$apiKey&q=$lat,$lon');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final cityName = data['location']['name'] as String?;

      if (cityName != null) {
        return cityName;
      } else {
        throw Exception(AppExceptions().noCityInApi);
      }
    } else {
      throw Exception(
        '${AppExceptions().failedApiCall}: ${response.statusCode}',
      );
    }
  }
}
