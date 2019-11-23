import 'package:fitphone/utils/navigation_icon_icons.dart';
import 'package:fitphone/view/pages/home_page.dart';
import 'package:fitphone/view/pages/programs_page.dart';
import 'package:fitphone/view/pages/progress_page.dart';
import 'package:fitphone/view/workout_selection_view.dart';
import 'package:fitphone/view_model/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';


class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor
      ));
    }
  }

  @override
  Widget build(BuildContext context) {

    var uiHelper = Provider.of<UIHelper>(context);

    Widget getView(int index){
      switch(index){
        case 0:
          return HomePage();
          break;
        case 1:
          return ProgramsPage();
          break;
        case 2:
          return ProgressPage();
          break;
        default:
          return HomePage();
      }
    }

    return Scaffold(
      body: getView(uiHelper.bottomNavigationIndex),
      floatingActionButton: FloatingActionButton(
        heroTag: "PlayButton",
        elevation: 1,
        backgroundColor: Theme.of(context).primaryColor,
        child: Center(
          child: Icon(Ionicons.ios_fitness,color: Colors.white)
        ),
        onPressed: (){
          showCupertinoModalPopup(context: context, builder: (context) => WorkoutSelectionView());
        }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
       // selectedItemColor: Theme.of(context).primaryColor,
       // unselectedItemColor: Colors.grey[600],
        unselectedFontSize: 12,
        selectedFontSize: 12,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        onTap: uiHelper.setBottomNavigationIndex,
        currentIndex: uiHelper.bottomNavigationIndex,
        items: [
          BottomNavigationBarItem(
            title: Text("Home"),
            icon: Icon(NavigationIcon.home_variant_outline__1_)
          ),
          BottomNavigationBarItem(
              title: Text("Programs"),
              icon: Icon(NavigationIcon.format_list_bulleted)
          ),
          BottomNavigationBarItem(
              title: Text("Progress"),
              icon:  Icon(NavigationIcon.chart_timeline_variant)
          ),
        ],
      ));
    }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


}
