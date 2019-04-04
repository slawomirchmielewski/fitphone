import 'dart:async';
import 'package:fitphone/bloc/bloc_provider.dart';
import 'package:fitphone/repository/firebase_api.dart';
import 'package:fitphone/utils/preferences_controller.dart';
import 'package:rxdart/rxdart.dart';
import 'package:fitphone/utils/enums.dart';

class ApplicationBloc implements BlocBase{

  bool _isDark;
  int _setUpPageIndex;

  final _themeController = BehaviorSubject<bool>();
  Stream<bool> get darkThemeEnabled => _themeController.stream;
  Function(bool) get changeTheme => _themeController.sink.add;

  final _setUpPageIndexController = BehaviorSubject<int>();
  Stream <int> get getPageIndex=> _setUpPageIndexController.stream;
  Function(int) get setPageIndex => _setUpPageIndexController.sink.add;

  final _bottomBarIndexController = BehaviorSubject.seeded(0);
  Stream<int> get getBottomBarIndex => _bottomBarIndexController.stream;
  Function(int) get setBottomBarIndex => _bottomBarIndexController.sink.add;

  final _loaderStateController = BehaviorSubject.seeded(LoadersState.Hidden);
  Stream<LoadersState> get loaderState => _loaderStateController.stream;
  Function(LoadersState) get setLoaderState =>_loaderStateController.sink.add;


  final _weightUnitController = BehaviorSubject.seeded(WeightUnit.Kilogram);
  Stream<WeightUnit> get weightUnit => _weightUnitController.stream;
  Function(WeightUnit) get setWeightUnit => _weightUnitController.sink.add;

  final _weightUnitTextController = BehaviorSubject.seeded("Kilograms");
  Stream<String> get getUnitText => _weightUnitTextController.stream;
  Function(String) get setUnitText => _weightUnitTextController.sink.add;


  WeightUnit get unit => _weightUnitController.stream.value;

  ApplicationBloc() {
    getTheme();
    getWeightUnit();

     initializeSetUpPageIndex();


    _weightUnitController.listen((data) {

      print("Data $data");

      if(data != null){
        _setWeightUnitText(data);
      }

    });

    _themeController.listen((data) => PreferencesController().saveTheme(data));

  }

  initializeSetUpPageIndex(){
    _setUpPageIndex = 0;
    _setUpPageIndexController.sink.add(_setUpPageIndex);
  }

  getTheme() async {
    _isDark = await preferencesController.getTheme();
    if(_isDark != null)
    _themeController.sink.add(_isDark);
    else
      _themeController.sink.add(false);
  }


  getWeightUnit() async{
    var unit = await FirebaseUserAPI().getWeightUnit();
    if(unit == "Kilograms"){
      _weightUnitController.sink.add(WeightUnit.Kilogram);
    }
    else if(unit == "Pounds"){
      _weightUnitController.sink.add(WeightUnit.Pound);
    }
  }

  setLoaderIndicatorState(LoadersState loaderState){
    _loaderStateController.sink.add(loaderState);
  }

  _setWeightUnitText(WeightUnit unit){
    if(unit == WeightUnit.Kilogram){
      _weightUnitTextController.sink.add("kg");
    }else{
      _weightUnitTextController.sink.add("lbs");
    }

  }

  cleanUserData(){
    _setUpPageIndexController.sink.add(null);
    _loaderStateController.sink.add(null);
    _weightUnitController.sink.add(WeightUnit.Kilogram);
    _weightUnitTextController.add(null);
    _bottomBarIndexController.sink.add(0);
  }

  @override
  void dispose() {
    _setUpPageIndexController.close();
    _themeController.close();
    _loaderStateController.close();
    _weightUnitController.close();
    _weightUnitTextController.close();
    _bottomBarIndexController.close();

  }
}

