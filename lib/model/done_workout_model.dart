
import 'package:intl/intl.dart';

class DoneWorkout{

  String name;
  int date;
  String time;
  double maxLift;
  String comment;
  int week;
  int month;
  int year;

  DoneWorkout({
    this.name,
    this.date,
    this.maxLift,
    this.time,
    this.comment,
    this.week,
    this.month,
    this.year
  });

  factory DoneWorkout.fromMap(Map<String,dynamic> map){
    return DoneWorkout(
      name: map["name"],
      date: map["date"],
      time: map["time"],
      maxLift: map["maxLift"],
      comment: map["comment"],
      week: map["week"],
      month: map["month"],
      year: map["year"]
    );
  }

  Map<String,dynamic> toMap(){
    return{
      "name" : this.name,
      "date" : this.date,
      "time" : this.time,
      "maxLift" : this.maxLift,
      "comment" : this.comment,
      "week" : this.week,
      "month" : this.month,
      "year" : this.year
    };
  }


  String getDate(){
    return DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(this.date));
  }


}