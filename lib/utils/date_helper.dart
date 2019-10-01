import 'package:intl/intl.dart';

class DateHelper{


  static int getWeekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }


  static List<DateTime> getDatesFromWeek(){
    List<DateTime> dates = [];

    DateTime today = DateTime.now();
    DateTime firstDayOfTheWeek = today.subtract(new Duration(days: today.weekday - 1));
    DateTime lastDayOfTheWeek  = firstDayOfTheWeek.add(new Duration(days: 6));

    dates.add(firstDayOfTheWeek);
    dates.add(lastDayOfTheWeek);

    return dates;
  }


}