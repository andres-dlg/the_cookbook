import 'dart:async';

import 'package:the_cookbook/database/database_helper.dart';
import 'package:the_cookbook/models/cookbook.dart';

abstract class CookbookContract {
  void screenUpdate();
}

class CookbookPresenter {

  CookbookContract _view;

  var db = new DatabaseHelper();

  CookbookPresenter(this._view);

  Future<int> delete(Cookbook cookbook) {
    var db = new DatabaseHelper();
    Future<int> res = db.deleteCookbook(cookbook);
    updateScreen();
    return res;
  }

  Future<List<Cookbook>> getCookbooks() {
    return db.getCookbooks();
  }

  updateScreen() {
    _view.screenUpdate();
  }

}