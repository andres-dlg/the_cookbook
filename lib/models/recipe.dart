import 'package:the_cookbook/enums/level.dart';
import 'package:the_cookbook/models/Ingredient.dart';
import 'package:the_cookbook/models/step.dart';

class Recipe {
  int id;
  int _cookbookId;
  String _name;
  String _summary;
  List<Ingredient> _ingredients;
  List<Step> _steps;
  String _coverBase64Encoded;
  String _level;
  int _durationInMinutes;
  //int _diners;

  Recipe(
    this._cookbookId,
    this._name,
    this._summary,
    this._coverBase64Encoded,
    this._level,
    this._durationInMinutes,
    //this._diners
  );

  int get cookbookId => _cookbookId;
  String get name => _name;
  String get coverBase64Encoded => _coverBase64Encoded;
  String get summary => _summary;
  List<Ingredient> get ingredients => _ingredients;
  List<Step> get steps => _steps;
  String get level => _level;
  int get durationInMinutes => _durationInMinutes;

  Recipe.map(dynamic obj){
    this._cookbookId = obj["cookbookId"];
    this._name = obj["name"];
    this._coverBase64Encoded = obj["coverBase64Encoded"];
    this._summary = obj["summary"];
    this._level = obj["level"];
    this._durationInMinutes = obj["durationInMinutes"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["cookbookId"] = _cookbookId;
    map["name"] = _name;
    map["coverBase64Encoded"] = _coverBase64Encoded;
    map["summary"] = _summary;
    map["level"] = _level;
    map["durationInMinutes"] = _durationInMinutes;
    return map;
  }

  void setRecipeId(int id) {
    this.id = id;
  }

}