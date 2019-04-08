import 'package:the_cookbook/enums/level.dart';
import 'package:the_cookbook/models/Ingredient.dart';
import 'package:the_cookbook/models/step.dart';

class Recipe {
  int id;
  String name;
  String summary;
  List<Ingredient> ingredients;
  List<Step> steps;
  String coverBase64Encoded;
  Level level;
  int durationInMinutes;
  int diners;

  Recipe({
    this.id,
    this.name,
    this.summary,
    this.ingredients,
    this.steps,
    this.coverBase64Encoded,
    this.level,
    this.durationInMinutes,
    this.diners
  });
}