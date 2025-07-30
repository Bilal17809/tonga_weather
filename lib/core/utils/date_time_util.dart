import 'package:intl/intl.dart';

class DateTimeUtils {
  static String getFormattedCurrentDate() {
    return DateFormat('EEE MMMM d').format(DateTime.now());
  }

  static String getTodayDateKey() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  static DateTime parseLocal(String time) {
    return DateTime.parse(time);
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  static String getWeekday(DateTime date) {
    return DateFormat('EEE').format(date);
  }
}
