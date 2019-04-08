import 'package:flutter/material.dart';
import 'package:the_cookbook/models/cookbook.dart';
import 'package:the_cookbook/models/recipe.dart';
import 'package:the_cookbook/pages/recipe/recipe_detail_page.dart';
import 'package:the_cookbook/utils/utilities.dart';

class RecipeList extends StatelessWidget {

  final Cookbook cookbook;

  RecipeList({this.cookbook});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _renderAppBar(context),
      body: ListView.builder(
        itemCount: this.cookbook.recipes == null ? 0 : this.cookbook.recipes.length,
        itemBuilder: (context, index) {
          return _renderRecipeCard(context, this.cookbook.recipes[index]);
        }
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.create),
          tooltip: "Create recipe",
          onPressed: (){
          }
      ),
    );
  }

  Widget _renderAppBar(BuildContext context){
    final String title = cookbook.name;
    final double barHeight = 50.0;
    final double statusbarHeight = MediaQuery
        .of(context)
        .padding
        .top;
    return PreferredSize(
      child: Container(
        padding: new EdgeInsets.only(top: statusbarHeight),
        height: statusbarHeight + barHeight,
        child: Row(
          children: <Widget>[
            Material(
              color: Colors.transparent,
              child: new IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.blueAccent,
                  onPressed: () {
                    Navigator.of(context).pop(this);
                  }
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 72.0),
              child: new Center(
                child: new Text(
                  title,
                  style: new TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Muli'),
                ),
              ),
            ),
          ],
        ),
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [Colors.white, Colors.blueAccent],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.5, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp
          ),
        ),
      ),
      preferredSize: new Size(
          MediaQuery.of(context).size.width,
          150.0
      ),
    );
    /*return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        color: Colors.grey[500],
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Padding(
        padding: const EdgeInsets.only(right: 48.0),
        child: Center(
          child: Text(
            cookbook.name,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Muli',
            ),
          ),
        ),
      ),
    );*/
  }

  Widget _renderRecipeCard(BuildContext context, Recipe recipe) {
    return Card(
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
    );
  }

  Widget _renderRecipeThumbnail(Recipe recipe){
    return Container(
      width: 128.0,
      height: 128.0,
      child: Image.network(
          recipe.coverBase64Encoded,
          fit: BoxFit.cover
      ),
    );
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
            Utilities.getDifficultyLevelString(recipe.level),
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecipeDetail(recipe: recipe)),
    );
  }

}

