import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:the_cookbook/database/database_helper.dart';
import 'package:the_cookbook/models/recipe.dart';
import 'package:the_cookbook/pages/recipe/create_recipe_cover_page.dart';
import 'package:the_cookbook/pages/recipe/create_recipe_steps_page.dart';
import 'package:the_cookbook/storage/create_recipe_storage.dart';

class CreateRecipe extends StatefulWidget {

  int cookbookId;

  CreateRecipe(this.cookbookId);

  @override
  State<StatefulWidget> createState() {
    return _CreateRecipeState();
  }

}

class _CreateRecipeState extends State<CreateRecipe>{

  int _currentIndex = 0;
  CreateRecipeCover coverPage;
  CreateRecipeSteps stepsPage;
  List<Widget> _children;

  final PageStorageBucket bucket = PageStorageBucket();

  final PageStorageKey mykey = new PageStorageKey("CreateRecipePageKey");

  @override
  void initState() {

    coverPage = CreateRecipeCover(this.callback ,key: PageStorageKey('CoverPage'), bucket: bucket);
    stepsPage = CreateRecipeSteps(key: PageStorageKey('StepsPage'), bucket: bucket);

    _children = [coverPage,stepsPage];

    super.initState();
  }

  void callback() {
    setState(() {});
  }

  @override
  void dispose() {
    CreateRecipeStorage.getSteps().clear();
    CreateRecipeStorage.getStepImages().clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: bucket.readState(context,identifier: "recipeName") != null &&
          !(bucket.readState(context,identifier: "recipeName").toString().trim().isEmpty) ?
      FloatingActionButton(
        onPressed: () {
            if(_validateFields()){
              _saveRecipe();
            }else{
              print("Complete all required fields");
            }
          },
        child: Icon(Icons.save)
      ) :
      null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      body: PageStorage(
        child: _children[_currentIndex],
        bucket: bucket,
        key: mykey,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 10.0
            )
          ]
        ),
        child: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.restaurant),
              title: new Text('Cover'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.format_list_numbered),
              title: new Text('Steps'),
            ),
          ],
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  bool _validateFields() {
    if(bucket.readState(context,identifier: "recipeName").toString().trim().isEmpty || bucket.readState(context,identifier: "recipeName") == null) {
      return false;
    }else{
      return true;
    }
  }

  void _saveRecipe() async {
    var db = new DatabaseHelper();
    var recipe = new Recipe(
        widget.cookbookId,
        bucket.readState(context,identifier: "recipeName").toString().trim(),
        bucket.readState(context,identifier: "recipeSummary").toString().trim().isEmpty ? "" : bucket.readState(context,identifier: "recipeSummary").toString().trim(),
        _encodeBgPhoto(),
        bucket.readState(context,identifier: "selectedDifficulty").toString().trim(),
        int.parse(bucket.readState(context,identifier: "selectedMinutes").toString().trim()),
    );
    int res = await db.saveRecipe(recipe).whenComplete((){
      Navigator.pop(context);
    });
  }

  String _encodeBgPhoto() {
    String base64Image = "DEFAULT";
    var _image = bucket.readState(context,identifier: "bgPhoto");
    if(bucket.readState(context,identifier: "bgPhoto") != null){
      List<int> imageBytes = _image.readAsBytesSync();
      base64Image = base64Encode(imageBytes);
    }
    return base64Image;
  }

}