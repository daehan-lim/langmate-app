import 'package:intl/intl.dart';

class DateTimeUtil {
  static String formatString(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) {
      return '방금 전';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}분 전';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}시간 전';
    } else if (diff.inDays == 1) {
      return '어제';
    } else if (diff.inDays < 30) {
      return '${diff.inDays}일 전';
    } else if (diff.inDays < 60) {
      return '${(diff.inDays / 30).floor()}개월 전'; // 1개월 전
    } else if (now.year == dateTime.year) {
      return DateFormat('M월 d일').format(dateTime); // this year -> 5월 2일
    } else {
      return DateFormat('yyyy년 M월 d일').format(dateTime); // older year -> 2023년 5월 2일
    }
  }
}
