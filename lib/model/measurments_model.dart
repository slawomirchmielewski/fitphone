
class Measurements{

  String id;
  int date;
  double waist;
  double arms;
  double hips;
  double chest;
  int day;
  int week;
  int month;
  int year;


  Measurements({
    this.id,
    this.date,
    this.waist,
    this.arms,
    this.hips,
    this.chest,
    this.day,
    this.week,
    this.month,
    this.year
  });


  factory Measurements.fromMap(Map<String,dynamic> map){
    return Measurements(
      id : map["id"],
      date : map["date"],
      waist: map["waist"],
      arms: map["arms"],
      hips: map["hips"],
      chest: map["chest"],
      day: map["day"],
      week: map["week"],
      month: map["month"],
      year: map["year"]
    );
  }

  Map<String,dynamic> toMap(){
    return {
      "id" : this.id,
      "date" : this.date,
      "waist" : this.waist,
      "arms" : this.arms,
      "hips" : this.hips,
      "chest" : this.chest,
      "day" : this.day,
      "week" : this.week,
      "month" : this.month,
      "year" : this.year
    };
  }



}