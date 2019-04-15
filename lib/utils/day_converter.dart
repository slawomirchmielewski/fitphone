class DayConverter{

  static String getDay(int index){

    String name = "Monday";

    switch(index){
      case 1:
        name = "Monday";
        break;
      case 2:
        name = "Tuesday";
        break;
      case 3:
        name = "Wednesday";
        break;
      case 4:
        name = "Thursday";
        break;
      case 5:
        name = "Friday";
        break;
      case 6:
        name = "Saturday";
        break;
      case 7:
        name = "Sunday";
        break;
      default:
        name = "";
    }

    return name;
    }

}