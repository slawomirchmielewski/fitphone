import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';


class Program{

  String id;
  String referenceId;
  String name;
  Timestamp date;

  Program({this.id,this.referenceId,this.name,this.date});

  factory Program.fromMap(Map<String,dynamic> map){
    return Program(
      id: map["id"] ?? "",
      referenceId: map["referenceId"] ?? "",
      name: map["name"] ?? "",
      date: map["date"] ?? "date",
    );
  }


  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = {
      "id" : this.id,
      "name" : this.name,
      "date" : this.date,
      "referenceId" : this.referenceId
    };

    return map;
  }



  String getDate(){
    return DateFormat.yMMMd().format(date.toDate());
  }

}



