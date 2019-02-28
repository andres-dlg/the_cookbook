import 'package:flutter/material.dart';
import 'package:the_cookbook/models/cookbook.dart';
import 'package:the_cookbook/models/recipe.dart';
import 'package:the_cookbook/utils/utilities.dart';

class RecipeList extends StatelessWidget {

  final Cookbook cookbook;

  RecipeList({this.cookbook});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cookbook.name),
      ),
      body: ListView.builder(
        itemCount: this.cookbook.recipes == null ? 0 : this.cookbook.recipes.length,
        itemBuilder: (context, index) {
          return _renderRecipeCard(context, this.cookbook.recipes[index]);
        }
      )
    );
  }

  Widget _renderRecipeCard(BuildContext context, Recipe recipe) {
    return Card(
      child: InkWell(
        onTap: () => {},
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
          recipe.coverUrl,
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

}

