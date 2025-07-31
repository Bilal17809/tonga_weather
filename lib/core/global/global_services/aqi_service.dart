class AqiService {
  static int calculateAqi(Map<String, double> pollutants) {
    final pollutantAqis = <int>[
      _calculateAqi(pollutants['pm2_5']!, _pm25Breakpoints),
      _calculateAqi(pollutants['pm10']!, _pm10Breakpoints),
      _calculateAqi(pollutants['o3']!, _o3Breakpoints),
      _calculateAqi(pollutants['no2']!, _no2Breakpoints),
      _calculateAqi(pollutants['so2']!, _so2Breakpoints),
      _calculateAqi(pollutants['co']! * 1000, _coBreakpoints),
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

  static int _calculateAqi(
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

  static final List<List<double>> _pm25Breakpoints = [
    [0.0, 12.0, 0, 50],
    [12.1, 35.4, 51, 100],
    [35.5, 55.4, 101, 150],
    [55.5, 150.4, 151, 200],
    [150.5, 250.4, 201, 300],
    [250.5, 350.4, 301, 400],
    [350.5, 500.4, 401, 500],
  ];

  static final List<List<double>> _pm10Breakpoints = [
    [0, 54, 0, 50],
    [55, 154, 51, 100],
    [155, 254, 101, 150],
    [255, 354, 151, 200],
    [355, 424, 201, 300],
    [425, 504, 301, 400],
    [505, 604, 401, 500],
  ];

  static final List<List<double>> _o3Breakpoints = [
    [0.0, 54.0, 0, 50],
    [55.0, 70.0, 51, 100],
    [71.0, 85.0, 101, 150],
    [86.0, 105.0, 151, 200],
    [106.0, 200.0, 201, 300],
  ];

  static final List<List<double>> _no2Breakpoints = [
    [0, 53, 0, 50],
    [54, 100, 51, 100],
    [101, 360, 101, 150],
    [361, 649, 151, 200],
    [650, 1249, 201, 300],
  ];

  static final List<List<double>> _so2Breakpoints = [
    [0, 35, 0, 50],
    [36, 75, 51, 100],
    [76, 185, 101, 150],
    [186, 304, 151, 200],
    [305, 604, 201, 300],
  ];

  static final List<List<double>> _coBreakpoints = [
    [0.0, 4.4, 0, 50],
    [4.5, 9.4, 51, 100],
    [9.5, 12.4, 101, 150],
    [12.5, 15.4, 151, 200],
    [15.5, 30.4, 201, 300],
  ];
}
