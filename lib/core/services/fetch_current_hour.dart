import 'date_time_service.dart';

Map<String, dynamic>? fetchCurrentHour(Map<String, dynamic> rawForecastData) {
  final now = DateTime.now();
  final today = DateTimeService.getTodayDateKey();
  final forecastDays = rawForecastData['forecast']?['forecastday'];
  if (forecastDays == null) return null;
  Map<String, dynamic>? todayData;
  for (var day in forecastDays) {
    if (day['date'] == today) {
      todayData = day;
      break;
    }
  }
  if (todayData == null) return null;
  final hourlyList = todayData['hour'] as List?;
  if (hourlyList == null) return null;

  for (var hour in hourlyList) {
    final hourTime = DateTimeService.parseLocal(hour['time']);
    if (hourTime.hour == now.hour) {
      return hour;
    }
  }

  return null;
}
