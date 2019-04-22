import 'dart:async';

import 'package:the_cookbook/database/database_helper.dart';
import 'package:the_cookbook/models/step.dart';

abstract class StepContract {
  void screenUpdate();
}

class StepPresenter {

  StepContract _view;

  var db = new DatabaseHelper();

  StepPresenter(this._view);

  Future<int> delete(Step step) {
    var db = new DatabaseHelper();
    Future<int> res = db.deleteStep(step);
    updateScreen();
    return res;
  }

  Future<List<Step>> getSteps(int cookbookId, int recipeId) {
    return db.getSteps(cookbookId, recipeId).whenComplete((){
      updateScreen();
    });
  }

  updateScreen() {
    if(_view != null) _view.screenUpdate();
  }

}