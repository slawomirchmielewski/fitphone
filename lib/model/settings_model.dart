class Settings {

  String theme;
  String units;


  Settings({this.units,this.theme});

  factory Settings.fromMap(Map<String,dynamic> map){
    return Settings(
      theme: map["theme"],
      units: map["units"]
    );
  }


  factory Settings.init(){
    return Settings(
      theme: "System",
      units: ""
    );
  }


  Map<String,dynamic>toMap(){
    return{
      "theme" : this.theme,
      "units" : this.units
    };

  }
}