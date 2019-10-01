import 'package:fitphone/view_model/feedback_view_model.dart';
import 'package:fitphone/widget/fit_button.dart';
import 'package:fitphone/widget/fit_feedback_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';


class AddFeedbackScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        brightness: Theme.of(context).brightness,
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text("Feedback",style: Theme.of(context).textTheme.title),
        iconTheme: Theme.of(context).iconTheme,
        elevation: 0,
      ),
      body: ChangeNotifierProvider<FeedbackViewModel>(
          builder: (context) => FeedbackViewModel(),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(right: 16,left: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 36),
                  Text("How do you like FitPhone ?",style: Theme.of(context).textTheme.title),
                  SizedBox(height: 72),
                  Consumer(
                    builder: (context,FeedbackViewModel feedbackViewModel,_) =>
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        FitFeedbackButton(imageUri: "assets/happy.png",name: "It's great !",value: 1,groupValue: feedbackViewModel.feedbackPoints,
                        onChange:(value) => feedbackViewModel.setFeedbacPoints(value)),
                        FitFeedbackButton(imageUri: "assets/neutral.png",name: "Do the job.",value: 2,groupValue: feedbackViewModel.feedbackPoints,
                            onChange:(value) => feedbackViewModel.setFeedbacPoints(value)),
                        FitFeedbackButton(imageUri: "assets/sad.png",name: "I'm disappointed.",value: 3,groupValue: feedbackViewModel.feedbackPoints,
                            onChange:(value) => feedbackViewModel.setFeedbacPoints(value)),
                      ],
                    ),
                  ),
                  SizedBox(height: 72),
                  Center(child: Text("Do you have any additional feedback for us ?",style: Theme.of(context).textTheme.subtitle,)),
                  SizedBox(height: 36),
                  Consumer(
                    builder: (context,FeedbackViewModel feedbackViewModel,_) =>
                    TextField(
                      controller: new TextEditingController.fromValue(new TextEditingValue(text: feedbackViewModel.feedbackText,selection: new TextSelection.collapsed(offset: feedbackViewModel.feedbackText.length))),
                      maxLines: 10,
                      decoration: InputDecoration(
                        hintMaxLines: 1,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1,color: Theme.of(context).primaryColor),
                          gapPadding: 10
                        ),
                        hintText: feedbackViewModel.getHintText()
                      ),
                      onChanged:(value) => feedbackViewModel.setFeedbackText(value) ,
                    ),
                  ),
                  SizedBox(height: 36),
                  Consumer(
                    builder: (context,FeedbackViewModel feedbackViewModel,_) =>
                      FitButton(buttonText: "Add feedback",onTap: (){
                        feedbackViewModel.addFeedback().then((_){
                          feedbackViewModel.setFeedbacPoints(1);
                          Toast.show("Feedback added", context,gravity: 0,duration: 2);
                        }).catchError((error){
                          Toast.show("Some error occurred... please try later", context,gravity: 0,);
                        });
                      },)),
                  SizedBox(height: 32)
                ],
              ),
            ),
          ),
      ),
    );
  }
}
