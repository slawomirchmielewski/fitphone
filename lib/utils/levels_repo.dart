import 'package:fitphone/model/level_model.dart';

class LevelsRepo{
  static List<LevelModel> _levels = [
    LevelModel(name: "Beginner",points: 2000),
    LevelModel(name: "Seasoned",points: 4000),
    LevelModel(name: "Lower Intermediate",points: 8000),
    LevelModel(name: "Intermediate",points: 10000),
    LevelModel(name: "Higher Intermediate",points: 15000),
    LevelModel(name: "Experienced",points: 18000),
    LevelModel(name: "Highly Experienced",points: 20000),
    LevelModel(name: "Advanced",points: 22000),
    LevelModel(name: "Highly Advanced",points: 25000),
    LevelModel(name: "Proficient",points: 28000),
    LevelModel(name: "Senior",points: 30000),
    LevelModel(name: "Expert",points: 40000),
    LevelModel(name: "Master",points: 70000),
  ];

  List<LevelModel> get level =>_levels;

}



LevelsRepo levelsRepository = LevelsRepo();