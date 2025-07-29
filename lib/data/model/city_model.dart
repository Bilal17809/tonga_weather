class CityModel {
  final String city;
  final String cityAscii;
  final double latitude;
  final double longitude;

  CityModel({
    required this.city,
    required this.cityAscii,
    required this.latitude,
    required this.longitude,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      city: json['city'],
      cityAscii: json['cityAscii'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
  factory CityModel.fallback(String cityName, {double? lat, double? lon}) {
    return CityModel(
      city: cityName,
      cityAscii: cityName,
      latitude: lat ?? 0.0,
      longitude: lon ?? 0.0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'cityAscii': cityAscii,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  String get latLonKey =>
      '${latitude.toStringAsFixed(4)},${longitude.toStringAsFixed(4)}';
}
