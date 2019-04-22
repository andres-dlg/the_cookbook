import 'dart:async';

import 'package:the_cookbook/database/database_helper.dart';
import 'package:the_cookbook/models/Ingredient.dart';
import 'package:the_cookbook/models/recipe.dart';

abstract class RecipeContract {
  void screenUpdate();
}

class RecipePresenter {

  RecipeContract _view;

  var db = new DatabaseHelper();

  RecipePresenter(this._view);

  Future<int> delete(Recipe recipe) {
    var db = new DatabaseHelper();
    Future<int> res = db.deleteRecipe(recipe);
    updateScreen();
    return res;
  }

  Future<List<Recipe>> getRecipes(int cookbookId) {
    return db.getRecipes(cookbookId).whenComplete((){
      updateScreen();
    });
  }

  Future<List<Recipe>> getFavouriteRecipes() {
    return db.getFavouriteRecipes().whenComplete((){
      updateScreen();
    });
  }

  Future<bool> updateRecipe(Recipe recipe){
    return db.updateRecipe(recipe).whenComplete((){
      updateScreen();
    });
  }

  updateScreen() {
    _view.screenUpdate();
  }

  Future<List<Ingredient>> getIngredients(int cookbookId, int recipeId) {
    return db.getIngredients(cookbookId,recipeId).whenComplete((){
      updateScreen();
    });
  }

}