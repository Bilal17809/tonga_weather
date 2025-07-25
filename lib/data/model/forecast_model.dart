class ForecastModel {
  final String date;
  final double maxTemp;
  final double minTemp;
  final String condition;
  final String iconUrl;
  final int humidity;
  final double windSpeed;
  final int chanceOfRain;
  final int code;

  ForecastModel({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
    required this.iconUrl,
    required this.humidity,
    required this.windSpeed,
    required this.chanceOfRain,
    required this.code,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    final iconUrl = json['day']?['condition']?['icon'] != null
        ? 'https:${json['day']['condition']['icon']}'
        : '';

    return ForecastModel(
      date: json['date'],
      maxTemp: (json['day']['maxtemp_c'] as num).toDouble(),
      minTemp: (json['day']['mintemp_c'] as num).toDouble(),
      condition: json['day']['condition']['text'],
      iconUrl: iconUrl,
      humidity: json['day']['avghumidity'],
      windSpeed: (json['day']['maxwind_kph'] as num).toDouble(),
      chanceOfRain: json['day']['daily_chance_of_rain'] ?? 0,
      code: json['day']['condition']['code'],
    );
  }
}
