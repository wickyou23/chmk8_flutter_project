import 'package:intl/intl.dart' as intl;

extension DateTimeExt on DateTime {
  String csToString(String formatString) {
    var format = intl.DateFormat(formatString);
    return format.format(this);
  }

  DateTime startOfDate() {
    return DateTime(this.year, this.month, this.day);
  }

  DateTime endOfDate() {
    return DateTime(this.year, this.month, this.day, 23, 59, 59);
  }

  bool isToday() {
    DateTime now = DateTime.now();
    return now.year == this.year &&
        now.month == this.month &&
        now.day == this.day;
  }

  bool isTomorrow() {
    DateTime tomorrow = DateTime.now().add(Duration(days: 1));
    return tomorrow.year == this.year &&
        tomorrow.month == this.month &&
        tomorrow.day == this.day;
  }

  bool isYesterday() {
    DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
    return yesterday.year == this.year &&
        yesterday.month == this.month &&
        yesterday.day == this.day;
  }

  //Start at Monday
  static List<DateTime> dateInWeekByDate(DateTime date) {
    final now = DateTime.now().startOfDate();
    final weekDay = date.weekday;
    final result = <DateTime>[];
    for (var i = 1; i <= 7; i++) {
      final calculate = now.add(Duration(days: i - weekDay));
      result.add(calculate);
    }

    return result;
  }
}