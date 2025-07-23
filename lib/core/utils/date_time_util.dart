import 'package:intl/intl.dart';

class DateTimeUtils {
  static String getFormattedCurrentDate() {
    final now = DateTime.now();
    return DateFormat('EEE MMMM d').format(now);
  }

  static String getTodayDateKey() {
    final now = DateTime.now();
    return DateFormat('yyyy-MM-dd').format(now);
  }

  static DateTime parseLocal(String time) {
    return DateTime.parse(time).toLocal();
  }
}
