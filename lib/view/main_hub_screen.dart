import 'package:fitphone/bloc/application_bloc.dart';
import 'package:fitphone/bloc/bloc_provider.dart';
import 'package:fitphone/utils/colors.dart';
import 'package:fitphone/view/workout_screen.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:fitphone/view/home_screen.dart';
import 'package:fitphone/view/programs_screen.dart';
import 'package:fitphone/view/summary_screen.dart';
import 'package:fitphone/view/settings_screen.dart';
import 'package:fitphone/widget/navigation_icons_icons.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class MainHubScreen extends StatelessWidget{


  final HomeScreen _homeScreen = HomeScreen();
  final ProgramsScreen _programsScreen = ProgramsScreen();
  final SummeryScreen _summeryScreen = SummeryScreen();
  final SettingsScreen _settingsScreen = SettingsScreen();


  @override
  Widget build(BuildContext context) {

    ApplicationBloc applicationBloc = BlocProvider.of<ApplicationBloc>(context);


    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<int>(
              stream: applicationBloc.getBottomBarIndex,
              initialData: 0,
              builder: (context,snapshot) {
                 int index = snapshot.data;

                 switch(index){
                   case 0:
                     return _homeScreen;
                     break;
                   case 1:
                     return _programsScreen;
                     break;
                   case 2:
                     return _summeryScreen;
                     break;
                   case 3:
                     return _settingsScreen;
                     break;
                 }


              }),
      ),
      bottomNavigationBar: StreamBuilder<int>(
        stream: applicationBloc.getBottomBarIndex,
        initialData: 0,
        builder: (context, snapshot) {
          return BottomNavigationBar(
            currentIndex: snapshot.data,
            onTap: applicationBloc.setBottomBarIndex,
            type: BottomNavigationBarType.fixed,
            fixedColor: Theme.of(context).textTheme.title.color,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(NavigationIcons.home),
                title: Text("Home"),
              ),
              BottomNavigationBarItem(
                icon: Icon(NavigationIcons.dumbbell),
                title: Text("Programs"),
              ),
              BottomNavigationBarItem(
                icon: Icon(NavigationIcons.line_chart),
                title: Text("Summary"),
              ),
              BottomNavigationBarItem(
                icon: Icon(NavigationIcons.settings),
                title: Text("Settings"),
              )
            ],
          );
        }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: CircularGradientButton(
          elevation: 2,
          gradient: LinearGradient(colors: [CustomColors.colorLightRed,CustomColors.colorViolet],begin: Alignment.topLeft,end: Alignment.bottomRight),
          child: Icon(OMIcons.playArrow,color: Colors.white),
          callback: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> WorkoutScreen()));
          }
      ),
    );
  }
}