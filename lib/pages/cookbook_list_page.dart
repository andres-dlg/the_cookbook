import 'package:flutter/material.dart';
import 'package:the_cookbook/models/cookbook.dart';
import 'package:the_cookbook/pages/recipe_list_page.dart';

class CookbookList extends StatelessWidget {

  final List<Cookbook> cookbooks;

  CookbookList(this.cookbooks);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _gridViewItemBuilder(context)
    );
  }

  Widget _gridViewItemBuilder(BuildContext context) {
    return GridView.count(
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this would produce 2 rows.
      crossAxisCount: 2,
      // Generate as many Widgets as cookbooks are present on cookbooks array
      children: List.generate(this.cookbooks.length, (index) {
        return Center(
          child: _itemCard(context, this.cookbooks[index])
        );
      }),
    );
  }

  Widget _itemCard(BuildContext context, Cookbook cookbook) {
    return Card(
      child: Center(
        child: Stack(
          children: <Widget>[
            _itemThumnail(cookbook),
            Center(
              child: Container(
                color: Color.fromRGBO(0, 0, 0, 0.5),
              ),
            ),
            Center(
                child: _itemTitle(cookbook)
            ),
            Material(
                color: Colors.transparent,
                child: new InkWell(
                  onTap: () => _navigateToRecipeList(context, cookbook),
                ),
            )
          ],
        ),
      ),
    );
  }

  Widget _itemThumnail(Cookbook cookbook) {
    return SizedBox.expand(
      child: FadeInImage.assetNetwork(
          placeholder: 'assets/gifs/spinner.gif',
          image: cookbook.coverUrl,
          fit: BoxFit.cover
      ),
    );
  }

  Widget _itemTitle(Cookbook cookbook) {
    return Text(
      cookbook.name,
      style: TextStyle(
          color: Colors.white,
          fontFamily: 'Muli',
          fontWeight: FontWeight.bold,
          fontSize: 24.0
      ),
    );
  }

  //_displaySnackbar(BuildContext context, String name) {
  //  Scaffold.of(context).showSnackBar(new SnackBar(
  //    content: new Text(name),
  //  ));
  //}

  _navigateToRecipeList(BuildContext context, Cookbook cookbook) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecipeList(cookbook: cookbook)),
    );
  }

}



