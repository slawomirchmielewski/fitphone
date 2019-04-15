import 'package:fitphone/bloc/application_bloc.dart';
import 'package:fitphone/bloc/bloc_provider.dart';
import 'package:fitphone/utils/colors.dart';
import 'package:fitphone/view/setup_view/diet_style_view.dart';
import 'package:fitphone/view/setup_view/goal_view.dart';
import 'package:fitphone/view/setup_view/summary_view.dart';
import 'package:fitphone/view/setup_view/weight_view.dart';
import 'package:fitphone/view/setup_view/welcome_view.dart';
import 'package:fitphone/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:fitphone/view/main_hub_screen.dart';
import 'package:fitphone/widget/page_base.dart';
import 'package:fitphone/view/setup_view/activity_level_view.dart';

class SetupScreen extends StatefulWidget{

  @override
  _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final List<PageBase> views = [
    WelcomeView(title: ""),
    WeightView(title: "Weight"),
    GoalView(title: "Fitness Goal"),
    ActivityLevelView(title: "Activity Level"),
    DietStyleView(title: "Diet Style",),
    SummaryView(title: "Summary")
  ];

  final PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    
    final ApplicationBloc applicationBloc = BlocProvider.of<ApplicationBloc>(context);

    int pagesCount = views.length - 1;

    double margin = 16;

    incrementPage(AsyncSnapshot<int> snap){
      int index  = snap.data;

      if(index < pagesCount){
        index++;
        pageController.animateToPage(index, duration: Duration(seconds: 1), curve: Curves.easeIn);
        applicationBloc.setPageIndex(index);
      }
    }

    decrementPage(AsyncSnapshot<int> snap){
      int index  = snap.data;

      if(index > 0){
        index--;
        pageController.animateToPage(index, duration: Duration(seconds: 1), curve: Curves.easeIn);
        applicationBloc.setPageIndex(index);
      }
    }


    Future<bool> _goBack(AsyncSnapshot<int> snap) {
      decrementPage(snap);
      return Future.value(false);
    }

    return StreamBuilder(
      stream: applicationBloc.getPageIndex,
      initialData: 0,
      builder: (context,snapshot){
      return WillPopScope(
        onWillPop:() => _goBack(snapshot),
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("${views[snapshot.data].title}",style: TextStyle(color: Theme.of(context).textTheme.title.color),),
            backgroundColor: Colors.transparent,
            brightness: Theme.of(context).brightness,
            iconTheme: Theme.of(context).iconTheme,
            elevation: 0.0,
            automaticallyImplyLeading: snapshot.data == 0 ? false : true,
          ),
          body: SafeArea(
            child: Container(
              margin: EdgeInsets.all(margin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Opacity(
                    opacity: snapshot.data == 0 ? 0 : 1,
                    child: LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width - (margin*2),
                        lineHeight: 5.0,
                        percent: (snapshot.data / pagesCount),
                        backgroundColor: CustomColors.colorLightGrey,
                        progressColor: Theme.of(context).accentColor
                        ),
                  ),

                  SizedBox(height: 16.0),
                  Expanded(
                    child: PageView(
                      scrollDirection: Axis.horizontal,
                      controller: pageController,
                      physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                      children: views
                    ),
                  ),
                  SizedBox(height: 16.0),
                  CustomButton(
                      title: snapshot.data != pagesCount ? "Continue" : "Finish",
                      onClick: (){
                           if(snapshot.data != pagesCount){
                             incrementPage(snapshot);
                           }
                           else {
                               Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MainHubScreen()));
                               applicationBloc.setPageIndex(0);
                           }
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      );}
    );
  }


  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

}