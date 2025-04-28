import 'package:intl/intl.dart';

class DateTimeUtil {
  static String formatForChatList(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      // Today: 오전 11:23
      return DateFormat('a h:mm', 'ko').format(dateTime);
    } else if (messageDate == yesterday) {
      // Yesterday
      return '어제';
    } else if (dateTime.year == now.year) {
      // Same year: 2월 23일
      return DateFormat('M월 d일').format(dateTime);
    } else {
      // Different year: 2023.04.24
      return DateFormat('yyyy.MM.dd').format(dateTime);
    }
  }

  /// Format for message time
  static String formatTimeForMessage(DateTime dateTime) {
    final formatter = DateFormat('a h:mm', 'ko');
    return formatter.format(dateTime);
  }

  static String formatDateForMessageGroup(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      return '오늘';
    } else if (messageDate == yesterday) {
      return '어제';
    } else {
      return '${dateTime.year}년 ${dateTime.month}월 ${dateTime.day}일';
    }
  }
}
