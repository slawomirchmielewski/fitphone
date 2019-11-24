import 'dart:async';

import 'package:fitphone/model/measurments_model.dart';
import 'package:fitphone/repository/firebase_api.dart';
import 'package:fitphone/utils/date_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MeasurementsViewModel extends ChangeNotifier with WidgetsBindingObserver{


  List<Measurements> _currentMeasurements = List();
  List<Measurements> _weekMeasurements = List();
  List<Measurements> _monthMeasurements = List();
  List<Measurements> _yearMeasurements = List();

  List<Measurements> get weekMeasurements => _weekMeasurements;
  List<Measurements> get monthMeasurements => _monthMeasurements;
  List<Measurements> get yearMeasurements => _yearMeasurements;

  StreamSubscription _userStream;
  StreamSubscription _lastMeasurementStream;
  StreamSubscription _weekMeasurementStream;
  StreamSubscription _monthMeasurementStream;
  StreamSubscription _yearMeasurementStream;
  String _userId;


  int _week = DateHelper.getWeekNumber(DateTime.now());
  int _month = DateTime.now().month;
  int _year = DateTime.now().year;


  MeasurementsViewModel(){
    WidgetsBinding.instance.addObserver(this);
  }


  getUserStream() async{
    _userStream =  FirebaseAPI().checkLoginUser().listen((firebaseUser){
      if(firebaseUser != null){
        _userId = firebaseUser.uid;
        _getCurrentMeasurements();
        _getMeasurementsFromWeek();
        _getMeasurementsFromMonth();
        _getMeasurementsFromYear();
      }
    });
  }

  _getCurrentMeasurements(){
    _lastMeasurementStream = FirebaseAPI().getCurrentMeasurements(_userId).listen((snapshot){
      if(snapshot.documents != null){
        for(var m in snapshot.documents){
          Measurements measurements = Measurements.fromMap(m.data);
          _currentMeasurements.add(measurements);
        }
        notifyListeners();
      }
    });
  }


  _getMeasurementsFromWeek(){
    _weekMeasurementStream = FirebaseAPI().getMeasurementsFromWeek(_userId,_week , _year).listen((snapshot){
        if(snapshot.documents != null){
          for(var m in snapshot.documents){
            Measurements measurements = Measurements.fromMap(m.data);
            _weekMeasurements.add(measurements);
          }
          notifyListeners();
        }
    });
  }

  _getMeasurementsFromMonth(){
    _monthMeasurementStream = FirebaseAPI().getMeasurementsFromMonth(_userId, _month, _year).listen((snapshot){
      if(snapshot.documents != null){
        for(var m in snapshot.documents){
          Measurements measurements = Measurements.fromMap(m.data);
          measurements.id = m.documentID;
          _monthMeasurements.add(measurements);
        }

         var m = _calculateMonthlyAvgMeasurement(_monthMeasurements);
        _addAvgMeasurement(m);
         notifyListeners();
      }
    });
  }

  _getMeasurementsFromYear(){
    _yearMeasurementStream = FirebaseAPI().getMeasurementsFromYear(_userId, _year).listen((snapshot){
      if(snapshot.documents != null){
        for(var m in snapshot.documents){
          Measurements measurements = Measurements.fromMap(m.data);
          _yearMeasurements.add(measurements);
        }
        notifyListeners();
      }
    });
  }

   Measurements _calculateMonthlyAvgMeasurement(List<Measurements> measurementsList){

    double waistSum = 0;
    double armsSum = 0;
    double hipsSum = 0;
    double chestSum = 0;

    double waistAvg = 0;
    double armsAvg = 0;
    double hipsAvg = 0;
    double chestAvg = 0;

    Measurements measurements;

    if(measurementsList.length > 0){
      for(var m in measurementsList){
        waistSum += m.waist;
        armsSum += m.chest;
        hipsSum += m.hips;
        chestSum += m.chest;
      }

      waistAvg = waistSum / measurementsList.length;
      armsAvg = armsSum / measurementsList.length;
      hipsAvg =  hipsSum / measurementsList.length;
      chestAvg = chestSum / measurementsList.length;

      measurements = Measurements(
        id: "",
        date: DateTime.now().millisecondsSinceEpoch,
        waist: waistAvg,
        arms: armsAvg,
        hips: hipsAvg,
        chest: chestAvg,
        day: 0,
        month: _month,
        year: _year,
        week: _week
      );
    }
   return measurements;
  }


  _addAvgMeasurement(Measurements measurements){
    if(_yearMeasurements.length > 0){
      var lastMeasure  =  _yearMeasurements.last;

      if(DateTime.now().month == lastMeasure.month){
        FirebaseAPI().updateMonthlyAvgMeasurements(_userId, lastMeasure.id, measurements.toMap());
      }else {
        FirebaseAPI().addMonthlyAvgMeasurements(_userId, measurements.toMap());
      }
    }
    else {
      FirebaseAPI().addMonthlyAvgMeasurements(_userId, measurements.toMap());
    }
  }

  addMeasurements(Measurements measurements){

    FirebaseAPI().addMeasurements(_userId, measurements.toMap());
  }



  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.paused){

      _userStream?.pause();
      _lastMeasurementStream?.pause();
      _weekMeasurementStream?.pause();
      _monthMeasurementStream?.pause();
      _yearMeasurementStream?.pause();


    }else if(state == AppLifecycleState.resumed){

      _userStream?.resume();
      _lastMeasurementStream?.resume();
      _weekMeasurementStream?.resume();
      _monthMeasurementStream?.resume();
      _yearMeasurementStream?.resume();

    }
  }

  @override
  void dispose() {
    _userStream.cancel();
    _lastMeasurementStream?.cancel();
    _weekMeasurementStream?.cancel();
    _monthMeasurementStream?.cancel();
    _yearMeasurementStream?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


}