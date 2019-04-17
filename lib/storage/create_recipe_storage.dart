import 'dart:io';
import 'package:the_cookbook/models/step.dart' as RecipeStep;

class CreateRecipeStorage {

  static List<RecipeStep.Step> _steps;

  static Map<int,File> _stepImages;

  static getSteps(){
    if(_steps != null && _steps.length > 0){
      return _steps;
    }else{
      return new List<RecipeStep.Step>();
    }
  }

  static getStepImages(){
    if(_stepImages != null && _stepImages.length > 0){
      return _stepImages;
    }else{
      return new Map<int,File>();
    }
  }

  static void setStepImage(int itemIndex, File croppedFile) {
    _stepImages[itemIndex] = croppedFile;
  }

  static void setStep(RecipeStep.Step newStep) {
    if(_steps == null){
      _steps = new List<RecipeStep.Step>();
    }
    _steps.add(newStep);
  }

  static getStepImage(int itemIndex) {
    if(_stepImages == null){
      _stepImages = new Map<int,File>();
    }
    return _stepImages[itemIndex];
  }

  static RecipeStep.Step getStep(int itemIndex) {
    return _steps[itemIndex];
  }


}