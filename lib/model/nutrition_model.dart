class Nutritions{

  int fat;
  int protein;
  int carbs;
  int calories;

  Nutritions({this.fat,this.calories,this.protein,this.carbs});

  factory Nutritions.fromMap(Map<String,dynamic> map){
    return Nutritions(
      fat : map["fat"],
      calories : map["calories"],
      protein : map["protein"],
      carbs: map["carbs"]
    );
  }

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = {
      "fat" : this.fat,
      "calories" : this.calories,
      "carbs" : this.carbs,
      "protein" : this.protein
    };
    return map;
  }


  setCalories(int value){
    calories = value;
  }

  setProtein(int value){
    protein = value;
  }

  setCarbs(int value){
    carbs = value;
  }

  setFat(int value){
    fat = value;
  }

}