

import 'package:flutter/material.dart';

class Folder{

  String id;
  String name;
  String coverUrl;
  int color;

  Folder({
    this.name,
    this.id,
    this.coverUrl,
    this.color
  });


  factory Folder.fromMap(Map<String,dynamic> map){
    return Folder(
      name: map["name"],
      color: int.parse(map["color"]),
    );
  }


  Map<String,dynamic> toMap(){

    Map<String,dynamic> folder ={
      "name" : name
    };

    return folder;
  }

  Color getColor(){
    return Color(color);
  }



}