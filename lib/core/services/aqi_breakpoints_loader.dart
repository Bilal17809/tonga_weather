import 'dart:convert';

import 'package:flutter/services.dart';

class AqiBreakpointsLoader {
  static Future<Map<String, List<List<double>>>> loadBreakpoints() async {
    final String jsonString = await rootBundle.loadString(
      'assets/aqi_breakpoints.json',
    );
    final Map<String, dynamic> data = json.decode(jsonString);
    return data.map(
      (key, value) => MapEntry(
        key,
        (value as List)
            .map<List<double>>(
              (e) => List<double>.from(e.map((v) => v.toDouble())),
            )
            .toList(),
      ),
    );
  }
}
