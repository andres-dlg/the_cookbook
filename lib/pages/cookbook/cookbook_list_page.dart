import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:the_cookbook/models/cookbook.dart';
import 'package:the_cookbook/pages/recipe/recipe_list_page.dart';
import 'package:the_cookbook/pages/cookbook/cookbook_presenter.dart';

class CookbookList extends StatelessWidget {

  CookbookPresenter cookbookPresenter;

  CookbookList(this.cookbookPresenter);

  displayRecord() {
    cookbookPresenter.updateScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _gridViewItemBuilder(context)
    );
  }

  Widget _gridViewItemBuilder(BuildContext context) {
    return FutureBuilder<List<Cookbook>>(
      future: cookbookPresenter.getCookbooks(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        List<Cookbook> cookbooks = snapshot.data;
        return snapshot.hasData
            ? GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this would produce 2 rows.
              crossAxisCount: 2,
              // Generate as many Widgets as cookbooks are present on cookbooks array
              children: List.generate(cookbooks.length, (index) {
                return Center(
                    child: _itemCard(context, cookbooks[index])
                );
              }),
            )
            : new Center(child: new CircularProgressIndicator());
      },
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    tooltip: "Delete",
                    icon: Icon(Icons.delete),
                    onPressed: (){ _deleteCookbook(context, cookbook); },
                    color: Colors.white,
                  ),
                ),
              ]
            )
          ],
        ),
      ),
    );
  }

  Widget _itemThumnail(Cookbook cookbook) {
    var thumb;
    if(cookbook.coverBase64Encoded == "DEFAULT"){
      thumb = SizedBox.expand(
          child: Image.asset(
            "assets/images/food_pattern.png",
            fit: BoxFit.cover,
          )
      );
    }else{
      Uint8List _bytesImage;
      _bytesImage = Base64Decoder().convert(cookbook.coverBase64Encoded);
      thumb = SizedBox.expand(
          child: Image.memory(_bytesImage)
      );
    }
    return thumb;
    /*return SizedBox.expand(
      child: FadeInImage.assetNetwork(
          placeholder: 'assets/gifs/spinner.gif',
          image: Image.memory(_bytesImage),
          fit: BoxFit.cover
      ),
    );*/
  }

  Widget _itemTitle(Cookbook cookbook) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        cookbook.name,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontFamily: 'Muli',
            fontWeight: FontWeight.bold,
            fontSize: 24.0
        ),
      ),
    );
  }

  _displaySnackbar(BuildContext context, String name) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(name),
    ));
  }

  _navigateToRecipeList(BuildContext context, Cookbook cookbook) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecipeList(cookbook: cookbook)),
    );
  }

  _deleteCookbook(BuildContext context, Cookbook cookbook) async {
    Future<int> res = cookbookPresenter.delete(cookbook);
    res.then((result) {
      if(result == 1){
        _displaySnackbar(context, "Cookbook deleted");
      }else{
        _displaySnackbar(context, "Some error occured");
      }
    });
  }

}



