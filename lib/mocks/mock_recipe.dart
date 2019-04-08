import 'package:the_cookbook/enums/level.dart';
import 'package:the_cookbook/mocks/mock_ingredient.dart';
import 'package:the_cookbook/mocks/mock_step.dart';
import 'package:the_cookbook/models/recipe.dart';

class MockRecipe extends Recipe {

  static final List<Recipe> meatRecipes = [
    Recipe(
      id: 0,
      name: "Conejo al horno con patatas",
      coverBase64Encoded: "https://t2.rg.ltmcdn.com/es/images/9/8/1/img_conejo_al_horno_con_patatas_56189_600.jpg",
      level: Level.MEDIUM,
      steps: MockStep.FetchAll(),
      ingredients: MockIngredient.FetchAll(),
      summary: "Es una de las carnes magras mejor valoradas por su bajo índice de grasa, lo que convierte a este plato en un candidato ideal tanto para comer como para cenar. Como entrante, te proponemos que prepares una ensalada fácil y rápida como la caprese.",
      durationInMinutes: 150,
      diners: 4
    )
  ];

  static List<Recipe> FetchAllMeatRecipes(){
    return meatRecipes;
  }

}