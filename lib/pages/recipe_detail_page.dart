import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_cookbook/models/Ingredient.dart';
import 'package:the_cookbook/models/recipe.dart';
import 'package:the_cookbook/pages/recipe_steps_page.dart';
import 'package:the_cookbook/utils/separator.dart';
import 'package:the_cookbook/utils/utilities.dart';

class RecipeDetail extends StatelessWidget {

  static double height = 300.0;

  Recipe recipe;

  RecipeDetail({this.recipe});

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
          _navigateToRecipeSteps(context, recipe);
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
            icon: Icon(Icons.arrow_back,),
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
          background: Image.network(
            recipe.coverUrl,
            fit: BoxFit.cover,
          )),
    );
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
          recipe.name,
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
            " Minutes: " + recipe.durationInMinutes.toString(),
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
        "Level: " + Utilities.getDifficultyLevelString(recipe.level),
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
                  recipe.summary,
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
                _getIngredients(recipe.ingredients)
              ],
            ),
          ),
        )
    );
  }

  Widget _getIngredients(List<Ingredient> ingredients){

    List<Row> ingredientsRows = new List<Row>();

    for(Ingredient ingredient in ingredients){
      ingredientsRows.add(new Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.check_box),
            ),
            Text(
              ingredient.name,
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

  }

  _navigateToRecipeSteps(BuildContext context, Recipe recipe) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecipeStepsPage(recipe: recipe)),
    );
  }

  Container _getGradient() {
    return new Container(
      margin: new EdgeInsets.only(top: 190.0),
      height: 110.0,
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: <Color>[
            new Color(0x00736AB7),
            new Color(0xFF736AB7)
          ],
          stops: [0.0, 0.9],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.0, 1.0),
        ),
      ),
    );
  }

}
