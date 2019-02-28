import 'package:the_cookbook/models/recipe.dart';

class Cookbook {
  int id;
  String name;
  String coverUrl;
  List<Recipe> recipes;

  Cookbook({this.id, this.name, this.coverUrl, this.recipes});
}