import '/domain/repositories/weather_repo.dart';
import '../data_source/online_data_sr.dart';
import '../model/weather_model.dart';
import '../model/forecast_model.dart';

class WeatherApiImpl implements WeatherRepo {
  final OnlineDataSource onlineDataSource;

  WeatherApiImpl(this.onlineDataSource);

  @override
  Future<(WeatherModel, List<ForecastModel>)> getWeatherAndForecast(
    double lat,
    double lon,
  ) async {
    return await onlineDataSource.getWeatherAndForecast(lat: lat, lon: lon);
  }

  /// For Current Location
  @override
  Future<String> getCity(double lat, double lon) async {
    return await onlineDataSource.getCity(lat, lon);
  }
}
