import 'package:tonga_weather/core/services/aqi_breakpoints_loader.dart';

class AqiService {
  static Map<String, List<List<double>>>? _breakpoints;
  static Future<void> initialize() async {
    _breakpoints = await AqiBreakpointsLoader.loadBreakpoints();
  }

  static int calculateAqi(Map<String, double> pollutants) {
    if (_breakpoints == null) {
      initialize();
    }

    final pollutantAqis = <int>[
      _calculateIndividualAqi(pollutants['pm2_5']!, _breakpoints!['pm2_5']!),
      _calculateIndividualAqi(pollutants['pm10']!, _breakpoints!['pm10']!),
      _calculateIndividualAqi(pollutants['o3']!, _breakpoints!['o3']!),
      _calculateIndividualAqi(pollutants['no2']!, _breakpoints!['no2']!),
      _calculateIndividualAqi(pollutants['so2']!, _breakpoints!['so2']!),
      _calculateIndividualAqi(pollutants['co']! * 1000, _breakpoints!['co']!),
    ];

    return pollutantAqis.reduce((a, b) => a > b ? a : b);
  }

  static String getAirQualityCategory(int aqi) {
    if (aqi <= 50) return 'Good';
    if (aqi <= 100) return 'Moderate';
    if (aqi <= 150) return 'Slightly Unhealthy';
    if (aqi <= 200) return 'Unhealthy';
    if (aqi <= 300) return 'Very Unhealthy';
    return 'Hazardous';
  }

  static int _calculateIndividualAqi(
    double concentration,
    List<List<double>> breakpoints,
  ) {
    for (var bp in breakpoints) {
      final cLow = bp[0], cHigh = bp[1], aqiLow = bp[2], aqiHigh = bp[3];
      if (concentration >= cLow && concentration <= cHigh) {
        return ((aqiHigh - aqiLow) / (cHigh - cLow) * (concentration - cLow) +
                aqiLow)
            .round();
      }
    }
    return 0;
  }
}
