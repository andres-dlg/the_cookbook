import 'package:the_cookbook/mocks/mock_recipe.dart';
import 'package:the_cookbook/models/cookbook.dart';

class MockCookbook extends Cookbook {

  static final List<Cookbook> cookbooks = [
    Cookbook(
      name: "Meat",
      coverUrl: "https://stmed.net/sites/default/files/meat-wallpapers-28272-3297793.jpg",
      recipes: MockRecipe.FetchAllMeatRecipes()
    ),
    Cookbook(
        name: "Pasta",
        coverUrl: "https://images8.alphacoders.com/826/thumb-1920-826205.jpg"
    ),
    Cookbook(
        name: "Salad",
        coverUrl: "https://www.wallpaperup.com/uploads/wallpapers/2016/01/29/884139/f0bfdcc0457f290e35a1cc5c95c4e6f8-700.jpg"
    ),
    Cookbook(
        name: "Bread",
        coverUrl: "https://images5.alphacoders.com/322/thumb-1920-322557.jpg"
    ),
    Cookbook(
        name: "Pizza",
        coverUrl: "https://images.unsplash.com/photo-1506354666786-959d6d497f1a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1500&q=80"
    ),
    Cookbook(
        name: "Soup",
        coverUrl: "https://www.ecestaticos.com/imagestatic/clipping/60f/90d/60f90d9298d04d7b8f24231f22f0cf4e/por-que-tomar-sopa-durante-las-comidas-logra-que-adelgaces.jpg?mtime=1481893825"
    )
  ];

  static Cookbook FetchAny(){
    return cookbooks[0];
  }

  static List<Cookbook> FetchAll(){
    return cookbooks;
  }

}