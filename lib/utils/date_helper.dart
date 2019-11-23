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


  static String getMonthName(int month){
    String monthName = "";

    switch(month){
      case 1: monthName = "January"; break;
      case 2: monthName = "February"; break;
      case 3: monthName = "March"; break;
      case 4: monthName= "April"; break;
      case 5: monthName = "May"; break;
      case 6: monthName = "June"; break;
      case 7: monthName = "July"; break;
      case 8: monthName= "August"; break;
      case 9: monthName = "September"; break;
      case 10: monthName = "October"; break;
      case 11: monthName = "November"; break;
      case 12: monthName = "December"; break;
    }

    return monthName;
  }


}