import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:the_cookbook/models/cookbook.dart';
import 'package:the_cookbook/models/recipe.dart';
import 'package:the_cookbook/pages/cookbook/recipe/create_recipe_page.dart';
import 'package:the_cookbook/pages/cookbook/recipe/recipe_detail_page.dart';
import 'package:the_cookbook/pages/cookbook/recipe/recipe_presenter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class RecipeList extends StatefulWidget {

  final Cookbook cookbook;

  RecipeList({this.cookbook});

  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> implements RecipeContract {

  RecipePresenter recipePresenter;

  @override
  void initState() {
    recipePresenter = new RecipePresenter(this);
    getRecipes();
    super.initState();
  }

  void getRecipes(){
    recipePresenter.getRecipes(widget.cookbook.cookbookId).then((recipeList){
      widget.cookbook.recipes = recipeList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _renderAppBar(context),
      body: ListView.builder(
        itemCount: this.widget.cookbook.recipes == null ? 0 : this.widget.cookbook.recipes.length,
        itemBuilder: (context, index) {
          return _renderRecipeCard(context, this.widget.cookbook.recipes[index]);
        }
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.create),
          tooltip: "Create recipe",
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateRecipe(widget.cookbook.cookbookId, getRecipes)),
            );
          }
      ),
    );
  }

  Widget _renderAppBar(BuildContext context){
    final String title = widget.cookbook.name;
    final double barHeight = 60.0;
    final double statusbarHeight = MediaQuery
        .of(context)
        .padding
        .top;
    return PreferredSize(
      preferredSize: new Size(
          MediaQuery.of(context).size.width,
          150.0
      ),
      child: Container(
        padding: new EdgeInsets.only(top: statusbarHeight),
        height: statusbarHeight + barHeight,
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16.0), bottomRight: Radius.circular(16.0)),
            gradient: new LinearGradient(
                colors: [Color.fromRGBO(179,229,252, 1), Colors.blueAccent],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(0.5, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.black,
                  blurRadius: 10.0
              )
            ]
        ),
        child: Row(
          children: <Widget>[
             Material(
               type: MaterialType.transparency,
               child: Container(
                 height: 80,
                 width: 80,
                 child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      color: Colors.blueAccent,
                      onPressed: () {
                        Navigator.of(context).pop(this);
                      }
                  ),
               ),
             ),
             Text(
               title,
               style: new TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Muli'),
             ),
          ],
        ),
      ),
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
                  MaterialPageRoute(builder: (context) => CreateRecipe(widget.cookbook.cookbookId, getRecipes, recipe: recipe)),
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
          fontFamily: 'Muli'
      ),
    );
  }

  Widget _renderRecipeDifficulty(Recipe recipe){
    return Row(
        children: <Widget>[
          Text(
            "Difficulty: ",
            style: TextStyle(
                fontSize: 12.0,
                fontFamily: 'Muli'
            ),
          ),
          Text(
            recipe.level,
            style: TextStyle(
                fontSize: 12.0,
                fontFamily: 'Muli'
            ),
          ),
        ]
    );
  }

  Widget _renderRecipeTime(Recipe recipe){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Icon(Icons.av_timer),
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            "Min: " + recipe.durationInMinutes.toString(),
            style: TextStyle(
                fontSize: 12.0,
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
      MaterialPageRoute(builder: (context) => RecipeDetail(recipe: recipe, bytesImage: _bytesImage,)),
    );
  }

  @override
  void screenUpdate() {
    setState(() {});
  }

  _deleteRecipe(Recipe recipe) {
    widget.cookbook.recipes.remove(recipe);
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

}

