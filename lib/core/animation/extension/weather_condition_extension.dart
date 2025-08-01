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
    if ([1087, 1273, 1276, 1279, 1282].contains(this)) {
      return WeatherCondition.thunderstorm;
    }
    if ([1000].contains(this)) {
      return WeatherCondition.clear;
    }
    if ([1003, 1006, 1009, 1030, 1135, 1147].contains(this)) {
      return WeatherCondition.cloudy;
    }
    if ([
      1063,
      1150,
      1153,
      1180,
      1183,
      1186,
      1189,
      1192,
      1195,
      1240,
      1243,
      1246,
    ].contains(this)) {
      return WeatherCondition.rain;
    }
    if ([
      1066,
      1210,
      1213,
      1216,
      1219,
      1222,
      1225,
      1255,
      1258,
      1114,
      1117,
    ].contains(this)) {
      return WeatherCondition.snow;
    }
    if ([
      1069,
      1072,
      1168,
      1171,
      1198,
      1201,
      1204,
      1207,
      1249,
      1252,
      1237,
      1261,
      1264,
    ].contains(this)) {
      return WeatherCondition.sleet;
    }
    return WeatherCondition.clear;
  }
}
