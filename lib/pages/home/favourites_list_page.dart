import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:the_cookbook/models/recipe.dart';
import 'package:the_cookbook/pages/cookbook/recipe/create_recipe_page.dart';
import 'package:the_cookbook/pages/cookbook/recipe/recipe_detail_page.dart';
import 'package:the_cookbook/pages/cookbook/recipe/recipe_presenter.dart';

class FavouritesList extends StatefulWidget {

  @override
  _FavouritesListState createState() => _FavouritesListState();

}

class _FavouritesListState extends State<FavouritesList> implements RecipeContract{

  List<Recipe> recipes;
  RecipePresenter recipePresenter;
  bool recipesRetrieved = false;

  @override
  void screenUpdate() {
    setState(() {});
  }

  void callback(){
    setState(() {
      getRecipes();
    });
  }

  @override
  void initState() {
    recipePresenter = new RecipePresenter(this);
    getRecipes();
    super.initState();
  }

  void getRecipes(){
    recipes = new List<Recipe>();
    recipePresenter.getFavouriteRecipes().then((recipesList) => {
      recipesRetrieved = true,
      recipes.addAll(recipesList)
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      recipesRetrieved ?
          _renderFavouriteScreen()
      :   Center(child: CircularProgressIndicator());

  }

  Widget _renderFavouriteScreen() {
    return
      recipes.length == 0 ?
        Center(child: Text(
            "No favourites recipes yet :)",
            style: TextStyle(
            fontFamily: 'Muli',
            fontSize: 20,
            color: Colors.black45
        ),
        )
        ) :
        _renderRecipeList();
  }

  Widget _renderRecipeList() {
    return ListView.builder(
        itemCount: recipes == null ? 0 : recipes.length,
        itemBuilder: (context, index) {
          return _renderRecipeCard(context, recipes[index]);
        }
    );
  }

  Widget _renderRecipeCard(BuildContext context, Recipe recipe) {
    return Slidable(
      delegate: new SlidableDrawerDelegate(),
      actionExtentRatio: 0.20,
      child: Card(
        child: InkWell(
          onTap: () => { _navigateToRecipeDetail(context, recipe) },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _renderRecipeThumbnail(recipe),
              _renderRecipeDetails(context, recipe)
            ],
          ),
        ),
      ),
      secondaryActions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black45,
            ),
            child: new IconSlideAction(
              caption: 'Edit',
              color: Colors.transparent,
              icon: Icons.edit,
              onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateRecipe(recipe.cookbookId, callback, recipe: recipe)),
              )
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.red,
            ),
            child: new IconSlideAction(
              caption: 'Delete',
              color: Colors.transparent,
              icon: Icons.delete,
              onTap: () => {
              _showDialog(recipe)
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _renderRecipeThumbnail(Recipe recipe){
    var thumb;
    if(recipe.coverBase64Encoded == "DEFAULT"){
      thumb = Container(
        width: 128.0,
        height: 128.0,
        child: Hero(
          child: Image.asset(
            "assets/images/food_pattern.png",
            fit: BoxFit.cover,
          ), tag: "default-${recipe.recipeId}",
        ),
      );
    }else{
      Uint8List _bytesImage;
      _bytesImage = Base64Decoder().convert(recipe.coverBase64Encoded);
      thumb = Container(
        width: 128.0,
        height: 128.0,
        child: Hero(
          child: Image.memory(
            _bytesImage,
            fit: BoxFit.cover,
          ), tag: "photo-${recipe.recipeId}",
        ),
      );
    }
    return thumb;
  }

  Widget _renderRecipeDetails(BuildContext context, Recipe recipe){
    return Container(
      height: 128.0,
      //It is 136 because 128 + 8. 8 = (padding/2)
      width: MediaQuery.of(context).size.width - 136,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _renderRecipeTitle(recipe),
          _renderRecipeDifficulty(recipe),
          _renderRecipeTime(recipe),
        ],
      ),
    );
  }

  Widget _renderRecipeTitle(Recipe recipe){
    return Text(
      recipe.name,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'Muli',
        fontSize: 16.0,
      ),
    );
  }

  Widget _renderRecipeDifficulty(Recipe recipe){
    return Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
              "Level: ",
              style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'Muli'
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: recipe.level != "null" ? _renderLevelIcon(recipe.level) : Padding(padding: EdgeInsets.only(top: 12.0), child:Text("N/A")),
          )
        ]
    );
  }

  Widget _renderRecipeTime(Recipe recipe){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          width: 24,
          height: 24,
          child: Image(
            image: AssetImage("assets/images/clock.png"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            recipe.durationInMinutes.toString() != "987654321" ?
            recipe.durationInMinutes.toString()+" Min" :
            "N/A",
            style: TextStyle(
                fontSize: 14.0,
                fontFamily: 'Muli'
            ),
          ),
        )
      ],
    );
  }

  _navigateToRecipeDetail(BuildContext context, Recipe recipe) {

    Uint8List _bytesImage;
    if(recipe.coverBase64Encoded != "DEFAULT"){
      _bytesImage = Base64Decoder().convert(recipe.coverBase64Encoded);
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecipeDetail(recipe: recipe, bytesImage: _bytesImage, callback: callback,)),
    );
  }

  _deleteRecipe(Recipe recipe) {
    recipes.remove(recipe);
    recipePresenter.delete(recipe);
  }

  void _showDialog(Recipe recipe) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Delete confirmation"),
          content: new Text("Are sure do you want to delete this recipe?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                _deleteRecipe(recipe);
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _renderLevelIcon(String level){
    Widget container;
    if(level.toLowerCase()=="easy"){
      container = Container(
        height: 24,
        width: 24,
        child: Image.asset("assets/images/level_easy.png"),
      );
    }else if(level.toLowerCase()=="medium"){
      container = Container(
        height: 24,
        width: 24,
        child: Image.asset("assets/images/level_medium.png"),
      );
    }
    else {
      container = Container(
        height: 24,
        width: 24,
        child: Image.asset("assets/images/level_hard.png"),
      );
    }
    return container;
  }


}