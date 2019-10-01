import 'package:flutter/foundation.dart';
import 'package:fitphone/repository/firebase_api.dart';


class FeedbackViewModel  extends ChangeNotifier{

  String _feedbackText = "";
  int _feedbackPoints = 1;


  String get feedbackText => _feedbackText;
  String get hintText => getHintText();
  int get feedbackPoints => _feedbackPoints;


  setFeedbackText(String value){
    _feedbackText = value;
    notifyListeners();
  }


  setFeedbacPoints(int value){
    _feedbackPoints = value;
    notifyListeners();
  }


  String getHintText(){

    String hint;

    switch(feedbackPoints){
      case 1:
        hint = "What do You like the most ?";
        break;
      case 2:
        hint = "How we can improve ? ";
        break;
      case 3:
        hint = "What disappointed you ?";
        break;
    }
    return hint;
  }
  
  
  String _getFeedbackValue(){
    
    var feedback = "";
    
    switch(feedbackPoints){
      case 1: 
        feedback = "Its grate";
        break;
      case 2:
        feedback = "Do the job";
        break;
      case 3:
        feedback = "I'm disappointed";
        break;
    }
    
    return feedback;
  }


  Future<void>addFeedback() async {
    var map = {"text" : _feedbackText, "feedback" : _getFeedbackValue()};

    if(_feedbackPoints != 0)
       FirebaseAPI().addFeedback(map);
  }

}