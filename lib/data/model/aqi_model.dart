class AirQualityModel {
  final double co;
  final double no2;
  final double o3;
  final double so2;
  final double pm2_5;
  final double pm10;
  final int usEpaIndex;
  final int gbDefraIndex;

  AirQualityModel({
    required this.co,
    required this.no2,
    required this.o3,
    required this.so2,
    required this.pm2_5,
    required this.pm10,
    required this.usEpaIndex,
    required this.gbDefraIndex,
  });

  factory AirQualityModel.fromJson(Map<String, dynamic> json) {
    return AirQualityModel(
      co: (json['co'] as num).toDouble(),
      no2: (json['no2'] as num).toDouble(),
      o3: (json['o3'] as num).toDouble(),
      so2: (json['so2'] as num).toDouble(),
      pm2_5: (json['pm2_5'] as num).toDouble(),
      pm10: (json['pm10'] as num).toDouble(),
      usEpaIndex: json['us-epa-index'] as int,
      gbDefraIndex: json['gb-defra-index'] as int,
    );
  }

  // int get calculatedAqi {
  //   final pollutantAqis = <int>[
  //     _calculateAqi(pm2_5, _pm25Breakpoints),
  //     _calculateAqi(pm10, _pm10Breakpoints),
  //     _calculateAqi(o3, _o3Breakpoints),
  //     _calculateAqi(no2, _no2Breakpoints),
  //     _calculateAqi(so2, _so2Breakpoints),
  //     _calculateAqi(co * 1000, _coBreakpoints),
  //   ];
  //   return pollutantAqis.reduce((a, b) => a > b ? a : b);
  // }

  // String getAirQualityCategory(int aqi) {
  //   if (aqi <= 50) return 'Good';
  //   if (aqi <= 100) return 'Moderate';
  //   if (aqi <= 150) return 'Slightly Unhealthy';
  //   if (aqi <= 200) return 'Unhealthy';
  //   if (aqi <= 300) return 'Very Unhealthy';
  //   return 'Hazardous';
  // }
  //
  // int _calculateAqi(double concentration, List<List<double>> breakpoints) {
  //   for (var bp in breakpoints) {
  //     final cLow = bp[0], cHigh = bp[1], aqiLow = bp[2], aqiHigh = bp[3];
  //     if (concentration >= cLow && concentration <= cHigh) {
  //       return ((aqiHigh - aqiLow) / (cHigh - cLow) * (concentration - cLow) +
  //               aqiLow)
  //           .round();
  //     }
  //   }
  //   return 0;
  // }

  // final List<List<double>> _pm25Breakpoints = [
  //   [0.0, 12.0, 0, 50],
  //   [12.1, 35.4, 51, 100],
  //   [35.5, 55.4, 101, 150],
  //   [55.5, 150.4, 151, 200],
  //   [150.5, 250.4, 201, 300],
  //   [250.5, 350.4, 301, 400],
  //   [350.5, 500.4, 401, 500],
  // ];
  //
  // final List<List<double>> _pm10Breakpoints = [
  //   [0, 54, 0, 50],
  //   [55, 154, 51, 100],
  //   [155, 254, 101, 150],
  //   [255, 354, 151, 200],
  //   [355, 424, 201, 300],
  //   [425, 504, 301, 400],
  //   [505, 604, 401, 500],
  // ];
  //
  // final List<List<double>> _o3Breakpoints = [
  //   [0.0, 54.0, 0, 50],
  //   [55.0, 70.0, 51, 100],
  //   [71.0, 85.0, 101, 150],
  //   [86.0, 105.0, 151, 200],
  //   [106.0, 200.0, 201, 300],
  // ];
  //
  // final List<List<double>> _no2Breakpoints = [
  //   [0, 53, 0, 50],
  //   [54, 100, 51, 100],
  //   [101, 360, 101, 150],
  //   [361, 649, 151, 200],
  //   [650, 1249, 201, 300],
  // ];
  //
  // final List<List<double>> _so2Breakpoints = [
  //   [0, 35, 0, 50],
  //   [36, 75, 51, 100],
  //   [76, 185, 101, 150],
  //   [186, 304, 151, 200],
  //   [305, 604, 201, 300],
  // ];
  //
  // final List<List<double>> _coBreakpoints = [
  //   [0.0, 4.4, 0, 50],
  //   [4.5, 9.4, 51, 100],
  //   [9.5, 12.4, 101, 150],
  //   [12.5, 15.4, 151, 200],
  //   [15.5, 30.4, 201, 300],
  // ];
}
