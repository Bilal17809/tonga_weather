import 'dart:convert';
import 'package:flutter/services.dart';

class WeatherCodesLoader {
  final Map<int, String> _codeToType = {};

  Future<void> loadWeatherCodes() async {
    final String jsonString = await rootBundle.loadString(
      'assets/weather_conditions.json',
    );
    final Map<String, dynamic> data = json.decode(jsonString);

    _codeToType.clear();
    data.forEach((key, value) {
      for (var code in value) {
        _codeToType[code] = key;
      }
    });
  }

  String getWeatherType(int code) {
    return _codeToType[code] ?? 'clear';
  }
}
