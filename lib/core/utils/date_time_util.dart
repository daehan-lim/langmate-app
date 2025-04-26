import 'package:intl/intl.dart';

class DateTimeUtil {
  // DateTimeUtils().format
  // DateTimeUtils.formatString
  static String formatString(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 60) {
      // 1시간 이내
      return '${diff.inMinutes} 분 전';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} 시간 전';
    } else {
      return DateFormat('M월 d일').format(dateTime);
    }
  }
}
