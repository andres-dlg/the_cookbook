import 'dart:io';
import 'package:the_cookbook/models/Ingredient.dart';
import 'package:the_cookbook/models/step.dart';
import 'package:the_cookbook/pages/cookbook/recipe/create_recipe_cover_page.dart';

class CreateRecipeStorage {

  static List<Step> _steps;

  static Map<int,File> _stepImages;

  static List<TextFieldAndController> _textFieldAndController;

  static initialize(){
    _steps = new List<Step>();
    _stepImages = new Map<int,File>();
  }

  static List<Step> getSteps(){
    if(_steps != null && _steps.length > 0){
      return _steps;
    }else{
      return new List<Step>();
    }
  }

  static  Map<int,File> getStepImages(){
    if(_stepImages != null && _stepImages.length > 0){
      return _stepImages;
    }else{
      return new Map<int,File>();
    }
  }

  static void setStepImage(int itemIndex, File croppedFile) {
    _stepImages[itemIndex] = croppedFile;
  }

  static void setStepImages(Map<int, File> newStepImages) {
    _stepImages = new Map<int,File>();
    _stepImages.addAll(newStepImages);
  }

  static void setStep(Step newStep) {
    if(_steps == null){
      _steps = new List<Step>();
    }
    bool exists = false;
    for(Step step in _steps){
      if(step.title.trim() == newStep.title.trim()){
        exists = true;
        break;
      }
    }
    if(!exists){
      _steps.add(newStep);
    }

  }

  static getStepImage(int itemIndex) {
    if(_stepImages == null){
      _stepImages = new Map<int,File>();
    }
    return _stepImages[itemIndex];
  }

  static Step getStep(int itemIndex) {
    return _steps[itemIndex];
  }

  static getIngredients(){
    if(_textFieldAndController != null && _textFieldAndController.length > 0){
      return _textFieldAndController;
    }else{
      return new List<TextFieldAndController>();
    }
  }

  static void setIngredient(TextFieldAndController newIngredient) {
    if(_textFieldAndController == null){
      _textFieldAndController = new List<TextFieldAndController>();
    }
    bool exists = false;
    for(TextFieldAndController textFieldAndController in _textFieldAndController){
      if(textFieldAndController.controller.text == newIngredient.controller.text){
        exists = true;
        break;
      }
    }
    if(!exists){
      _textFieldAndController.add(newIngredient);
    }

  }

  static void deleteIngredient(TextFieldAndController tf) {
    _textFieldAndController.remove(tf);
  }



}