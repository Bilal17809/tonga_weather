class CityModel {
  final String city;
  final String cityAscii;
  final double latitude;
  final double longitude;
  final String? region;

  CityModel({
    required this.city,
    required this.cityAscii,
    required this.latitude,
    required this.longitude,
    this.region,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      city: json['city'],
      cityAscii: json['cityAscii'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      region: json['region'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'cityAscii': cityAscii,
      'latitude': latitude,
      'longitude': longitude,
      'region': region,
    };
  }
}
