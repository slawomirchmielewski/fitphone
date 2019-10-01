import 'package:intl/intl.dart';


class User {

  final String id;
  final String name;
  final double weight;
  final int xp;
  final int maxXp;
  final bool isActive;
  final int level;
  final String photoUrl;
  final int registrationDate;


  const User({
    this.id,
    this.name,
    this.weight,
    this.xp,
    this.maxXp,
    this.isActive,
    this.level,
    this.photoUrl,
    this.registrationDate,
  });


  factory User.init(String id, String name, int registrationDate){
    return User(
      id:id,
      name:name,
      weight: 0.0,
      xp: 0,
      maxXp: 50,
      isActive: true,
      level: 1,
      photoUrl: "",
      registrationDate: registrationDate,
    );
  }


  factory User.fromMap(Map<String,dynamic> map){
    return User(
      id: map["id"],
      name: map["name"],
      weight: map["weight"],
      xp: map["xp"],
      maxXp: map["maxXp"],
      isActive: map["isActive"],
      level: map["level"],
      photoUrl: map["photoUrl"],
      registrationDate: map["registrationDate"],
    );
  }

  Map<String,dynamic> toMap(){
    return {
      "id" : this.id,
      "name" : this.name,
      "weight" : this.weight,
      "xp" :  this.xp,
      "maxXp" : this.maxXp,
      "isActive" : this.isActive,
      "level" : this.level,
      "photoUrl" : this.photoUrl,
      "registrationDate" : this.registrationDate,
    };
  }


  double get levelPercent => getLevelPercent();

  DateTime get firstRegistrationDate => DateTime.fromMillisecondsSinceEpoch(registrationDate);

  int get remainingPoints  => maxXp - xp;


  double getLevelPercent(){
    if(xp > maxXp){
      return 1;
    }

    return xp / maxXp;
  }

  String getFirstName(){
    List<String> list = name.split(" ");
    return list[0];
  }

  String getReadableDate(){

    DateFormat dateFormat = DateFormat.yMMMd();
    return dateFormat.format(DateTime.fromMillisecondsSinceEpoch(registrationDate));
  }



}