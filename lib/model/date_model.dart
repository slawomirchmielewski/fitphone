

class DateModel{

  int week;
  int month;
  int year;


  DateModel({this.week,this.month,this.year});


  factory DateModel.fromMap(Map<String ,dynamic> map){
    return DateModel(
      week : map["week"],
      month: map["month"],
      year: map["year"]
    );
  }

  Map<String,dynamic> toMap(){
    return {
      "week" : week,
      "month" : month,
      "year" : year
    };
  }


}