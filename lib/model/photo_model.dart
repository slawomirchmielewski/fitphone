class PhotoModel{
  String url;
  DateTime date;


  PhotoModel({this.url,this.date});

  factory PhotoModel.fromMap(Map<String,dynamic> map){
    return PhotoModel(
      url: map['url'],
      date: DateStamp.fromDataTime(map["date"]).date
    );
  }

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = {
      "url" : url,
      "date" : DateTime.now()
    };

    return map;
  }


  String getDate(){
    return "${this.date.day} ${_getMonthName(this.date.month)} ${this.date.year}";
  }

  static String _getMonthName(int month){
    int n  = month;
    String name;

    switch(n){
      case 1:
        name = "Jan";
        break;
      case 2:
        name = "Feb";
        break;
      case 3:
        name = "Mar";
        break;
      case 4:
        name = "Apr";
        break;
      case 5:
        name = "May";
        break;
      case 6:
        name = "Jun";
        break;
      case 7:
        name = "Jul";
        break;
      case 8:
        name = "Aug";
        break;
      case 9:
        name = "Sep";
        break;
      case 10:
        name = "Oct";
        break;
      case 11:
        name = "Nov";
        break;
      case 12:
        name = "Dec";
        break;
    }


    return name;


  }


}

class DateStamp{
  DateTime date;

  DateStamp({this.date});

  factory DateStamp.fromDataTime(DateTime dataTime){
    return DateStamp(
        date: dataTime
    );
  }
}