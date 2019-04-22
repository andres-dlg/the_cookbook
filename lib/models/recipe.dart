import 'package:the_cookbook/models/Ingredient.dart';
import 'package:the_cookbook/models/step.dart';

class Recipe {
  int recipeId;
  int _cookbookId;
  String _name;
  String _summary;
  List<Ingredient> _ingredients;
  List<Step> steps;
  String _coverBase64Encoded;
  String _level;
  int _durationInMinutes;
  int _isFavourite;
  //int _diners;

  Recipe(
    this._cookbookId,
    this._name,
    this._summary,
    this._coverBase64Encoded,
    this._level,
    this._durationInMinutes,
    this._isFavourite
    //this._diners
  );

  set ingredients(value) => _ingredients = value;
  set coverBase64Encoded(value) => _coverBase64Encoded = value;
  set name(value) => _name = value;
  set summary(value) => _summary = value;
  set level(value) => _level = value;
  set durationInMinutes(value) => _durationInMinutes = value;
  set isFavourite(value) => _isFavourite = value;

  int get cookbookId => _cookbookId;
  String get name => _name;
  String get coverBase64Encoded => _coverBase64Encoded;
  String get summary => _summary;
  List<Ingredient> get ingredients => _ingredients;
  //List<Step> get steps => _steps;
  String get level => _level;
  int get durationInMinutes => _durationInMinutes;
  int get isFavourite => _isFavourite;

  Recipe.map(dynamic obj){
    this._cookbookId = obj["cookbookId"];
    this._name = obj["name"];
    this._coverBase64Encoded = obj["coverBase64Encoded"];
    //this._steps = obj["steps"];
    this._summary = obj["summary"];
    this._level = obj["level"];
    this._durationInMinutes = obj["durationInMinutes"];
    this._isFavourite = obj["isFavourite"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["cookbookId"] = _cookbookId;
    map["name"] = _name;
    map["coverBase64Encoded"] = _coverBase64Encoded;
    map["summary"] = _summary;
    //map["steps"] = _steps;
    map["level"] = _level;
    map["durationInMinutes"] = _durationInMinutes;
    map["isFavourite"] = _isFavourite;
    return map;
  }

  void setRecipeId(int recipeId) {
    this.recipeId = recipeId;
  }

}