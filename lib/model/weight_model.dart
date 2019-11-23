import 'package:intl/intl.dart';

class WeightModel{
  String id;
  int date;
  double weight;
  int day;
  int week;
  int month;
  int year;

  WeightModel({this.id,this.date,this.weight,this.day,this.week,this.month,this.year});

  String getDate(){
    return DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(date));
  }

  factory WeightModel.fromMap(Map<dynamic,dynamic> map){
    return new WeightModel(
        id: map["id"],
        weight: map["weight"],
        date: map["date"],
        day: map["day"],
        week: map["week"],
        month: map["month"],
        year: map["year"]
    );
   }

   Map<String,dynamic> toMap(){
    return {
      "id" : this.id,
      "weight" : this.weight,
      "date"   : this.date,
      "day"    : this.day,
      "week"   : this.week,
      "month"  : this.month,
      "year"   : this.year
    };
   }


   String getDayName(){
    String name = "";
    DateTime date = DateTime.fromMillisecondsSinceEpoch(this.date);


    switch(date.weekday){
      case 1: name = "Mon"; break;
      case 2: name = "Tue"; break;
      case 3: name = "Wed"; break;
      case 4: name = "Thu"; break;
      case 5: name = "Fri"; break;
      case 6: name = "Sat"; break;
      case 7: name = "Sun"; break;
    }

    return name;
   }



   String getMonthName(){
    String month = "";

    DateTime date = DateTime.fromMillisecondsSinceEpoch(this.date);

    switch(date.month){
      case 1: month = "January"; break;
      case 2: month = "February"; break;
      case 3: month = "March"; break;
      case 4: month= "April"; break;
      case 5: month = "May"; break;
      case 6: month = "June"; break;
      case 7: month = "July"; break;
      case 8: month= "August"; break;
      case 9: month = "September"; break;
      case 10: month = "October"; break;
      case 11: month = "November"; break;
      case 12: month = "December"; break;
    }

    return month;
   }

   int getDayNumber(){
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(this.date);
    return dateTime.day;
   }


   int getYear(){

    DateTime date = DateTime.fromMillisecondsSinceEpoch(this.date);

    return date.year;
   }


   int getWeekDay(){
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(this.date);

    return dateTime.weekday;
   }


}