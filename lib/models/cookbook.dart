import 'package:the_cookbook/models/recipe.dart';

class Cookbook {
  int id;
  String _name;
  String _coverBase64Encoded;
  List<Recipe> recipes;

  Cookbook(
    this._name,
    this._coverBase64Encoded,
  );

  Cookbook.map(dynamic obj){
    this._name = obj["name"];
    this._coverBase64Encoded = obj["coverBase64Encoded"];
  }

  String get name => _name;

  String get coverBase64Encoded => _coverBase64Encoded;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = _name;
    map["coverBase64Encoded"] = _coverBase64Encoded;
    return map;
  }
  void setCookbookId(int id) {
    this.id = id;
  }
}