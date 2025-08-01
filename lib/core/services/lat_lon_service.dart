import '/data/model/city_model.dart';

class LocationUtilsService {
  static String generateLatLonKey(double latitude, double longitude) {
    return '${latitude.toStringAsFixed(4)},${longitude.toStringAsFixed(4)}';
  }

  static String fromCityModel(CityModel city) {
    return generateLatLonKey(city.latitude, city.longitude);
  }
}
