import 'package:firebase_database/firebase_database.dart';

class WeightModel{
  String date;
  double weight;

  WeightModel({this.date,this.weight});

  factory WeightModel.fromSnapshot(DataSnapshot snapshot){
    return new WeightModel(
      weight: double.tryParse(snapshot.value["weight"].toString()),
      date: snapshot.value["date"]);
    }

  factory WeightModel.fromMap(Map<dynamic,dynamic> map){
    return new WeightModel(
        weight: double.tryParse(map["weight"].toString()),
        date: map["date"]);
   }

   String getDateForChart(){
    List<String> list = date.split(",");
    return "${list[0]}\n${list[1]}";
   }
}