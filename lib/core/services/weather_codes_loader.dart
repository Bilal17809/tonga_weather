import 'dart:convert';
import 'package:flutter/services.dart';

class WeatherCodesLoader {
  static final Map<int, String> _codeToType = {};

  static Future<void> loadWeatherCodes() async {
    final String jsonString = await rootBundle.loadString(
      'assets/weather_conditions.json',
    );
    final Map<String, dynamic> data = json.decode(jsonString);

    _codeToType.clear();
    data.forEach((key, value) {
      value.forEach((code) {
        _codeToType[code] = key;
      });
    });
  }

  static String getWeatherType(int code) {
    return _codeToType[code] ?? 'clear';
  }
}
