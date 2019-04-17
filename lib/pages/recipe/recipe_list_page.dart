import 'package:flutter/material.dart';
import 'package:the_cookbook/models/cookbook.dart';
import 'package:the_cookbook/models/recipe.dart';
import 'package:the_cookbook/pages/recipe/create_recipe_page.dart';
import 'package:the_cookbook/pages/recipe/recipe_detail_page.dart';
import 'package:the_cookbook/utils/utilities.dart';

class RecipeList extends StatefulWidget {

  final Cookbook cookbook;

  RecipeList({this.cookbook});

  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {

  @override
  void initState() {
    // TODO: TRAER TODAS LAS RECIPES DEL COOKBOOK
    super.initState();
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
              MaterialPageRoute(builder: (context) => CreateRecipe(widget.cookbook.id)),
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
            Padding(
              padding: const EdgeInsets.only(left: 44.0),
              child: new Center(
                child: new Text(
                  title,
                  style: new TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Muli'),
                ),
              ),
            ),
          ],
        ),
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

