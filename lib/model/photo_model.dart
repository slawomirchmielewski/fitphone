import 'package:intl/intl.dart';

class PhotoModel{
  String url;
  String date;


  PhotoModel({this.url,this.date});

  factory PhotoModel.fromMap(Map<dynamic,dynamic> map){
    return PhotoModel(
      url: map['url'],
      date: map["date"]
    );
  }

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = {
      "url" : url,
      "date" : DateFormat.yMMMd().format(new DateTime.now()).toString()
    };

    return map;
  }
}