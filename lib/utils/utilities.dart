import 'package:the_cookbook/enums/level.dart';

class Utilities {

  static String getDifficultyLevelString (String level) {
    if(level == Level.VERY_EASY){
      return "VERY EASY";
    }else if(level == Level.EASY){
      return "EASY";
    }else if(level == Level.MEDIUM){
      return "MEDIUM";
    }else if(level == Level.HARD){
      return "HARD";
    }else{
      return "VERY HARD";
    }
  }

}