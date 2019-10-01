import 'package:fitphone/view/pages/home_page.dart';
import 'package:fitphone/view/pages/photos_page.dart';
import 'package:fitphone/view/pages/programs_page.dart';
import 'package:fitphone/view/pages/progress_page.dart';
import 'package:fitphone/view/workout_selection_view.dart';
import 'package:fitphone/view_model/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';


class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {


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
        case 3:
          return PhotosPage();
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
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        unselectedFontSize: 12,
        selectedFontSize: 12,
        onTap: uiHelper.setBottomNavigationIndex,
        currentIndex: uiHelper.bottomNavigationIndex,
        items: [
          BottomNavigationBarItem(
            title: Text("Home"),
            icon: Icon(Ionicons.ios_home)
          ),
          BottomNavigationBarItem(
              title: Text("Programs"),
              icon: Icon(Ionicons.ios_paper)
          ),
          BottomNavigationBarItem(
              title: Text("Progress"),
              icon: Icon(Ionicons.ios_stats)
          ),
          BottomNavigationBarItem(
              title: Text("Gallery"),
              icon: Icon(Ionicons.ios_albums)
          )
        ],
      ));
    }
}
