import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_cookbook/models/Ingredient.dart';
import 'package:the_cookbook/models/recipe.dart';
import 'package:the_cookbook/pages/cookbook/recipe/recipe_presenter.dart';
import 'package:the_cookbook/pages/cookbook/recipe/step/recipe_steps_page.dart';
import 'package:the_cookbook/utils/separator.dart';

// ignore: must_be_immutable
class RecipeDetail extends StatefulWidget {

  static double height = 300.0;

  Recipe recipe;
  Uint8List bytesImage;

  RecipeDetail({this.recipe, this.bytesImage});

  @override
  _RecipeDetailState createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> implements RecipeContract{

  RecipePresenter recipePresenter;

  @override
  void initState() {
    recipePresenter = new RecipePresenter(this);
    recipePresenter.getIngredients(widget.recipe.cookbookId, widget.recipe.recipeId).then((ingredients){
      widget.recipe.ingredients = ingredients;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            _renderAppBar(context)
          ];
        },
        body: _renderBody(context),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow),
        onPressed: () {
          _navigateToRecipeSteps(context, widget.recipe);
        },
      ),
    );
  }

  SliverAppBar _renderAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 248.0,
      floating: false,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.3),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: _renderBackgroundImage(context)
        /*Image.network(
          recipe.coverBase64Encoded,
          fit: BoxFit.cover,
        )*/
      ),
    );
  }

  Widget _renderBackgroundImage(BuildContext context) {
    var thumb;
    if(widget.recipe.coverBase64Encoded == "DEFAULT"){
      thumb = Container(
          width: MediaQuery.of(context).size.width,
          child: Hero(
            tag: "default",
            child: Image.asset(
              "assets/images/food_pattern.png",
              fit: BoxFit.cover,
            ),
          )
      );
    }else{
      thumb = Container(
          width: MediaQuery.of(context).size.width,
          child: Hero(
            tag: "photo",
            child: Image.memory(
              widget.bytesImage,
              fit: BoxFit.cover,
            ),
          )
      );
    }
    return thumb;

    /*return Container(
        width: MediaQuery.of(context).size.width,
        child: _image == null ?
        Image.asset(
          "assets/images/food_pattern.png",
          fit: BoxFit.cover,
        ) :
        Image.file(
          _image,
          fit: BoxFit.cover,
          gaplessPlayback: false,
        )
    );*/
  }

  Widget _renderBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _renderRecipeTitle(),
            _renderRecipeMinutes(),
            _renderRecipeDifficulty(),
            new Separator(width: MediaQuery.of(context).size.width, heigth: 1.0, color: Colors.grey),
            _renderRecipeSummary(context),
            Container(height: 16,),
            _renderRecipeIngredients(context),
          ],
        ),
      ),
    );
  }

  Widget _renderRecipeTitle() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, left: 8.0),
      child: Text(
          widget.recipe.name,
          style: TextStyle(
            color: Colors.black,
            fontSize: 24.0,
            fontFamily: 'Muli',
          )
      ),
    );
  }

  Widget _renderRecipeMinutes() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, left: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.av_timer),
          Text(
            " Minutes: " + widget.recipe.durationInMinutes.toString(),
            style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Muli'
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderRecipeDifficulty() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        "Level: " + widget.recipe.level,
        style: TextStyle(
            fontSize: 20.0,
            fontFamily: 'Muli'
        ),
      ),
    );
  }

  Widget _renderRecipeSummary(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  "Summary",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Muli'
                  )
                ),
              ),
              Center(child: new Separator(width: 64.0, heigth: 1.0, color: Colors.cyan,)),
              Text(
                  widget.recipe.summary,
                  style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Muli'
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderRecipeIngredients(BuildContext context) {
    return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text(
                      "Ingredients",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Muli'
                      )
                  ),
                ),
                Center(child: new Separator(width: 64.0, heigth: 1.0, color: Colors.cyan,)),
                _getIngredients(widget.recipe.ingredients)
              ],
            ),
          ),
        )
    );
  }

  Widget _getIngredients(List<Ingredient> ingredients){
    if(ingredients!=null && ingredients.length>0){
      List<Row> ingredientsRows = new List<Row>();

      for(Ingredient ingredient in ingredients){
        ingredientsRows.add(new Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.check_box),
            ),
            Text(
              ingredient.description,
              style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'Muli'
              ),
            )
          ],
        )
        );
      }

      return Column(children: ingredientsRows);
    }else{
      return Center(
        child: Text("No ingredients"),
      );
    }


  }

  _navigateToRecipeSteps(BuildContext context, Recipe recipe) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecipeStepsPage(recipe: recipe)),
    );
  }

  @override
  void screenUpdate() {
    setState(() {});
  }
}
