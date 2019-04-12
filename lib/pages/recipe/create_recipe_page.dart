import 'package:flutter/material.dart';
import 'package:the_cookbook/pages/recipe/create_recipe_cover_page.dart';
import 'package:the_cookbook/pages/recipe/create_recipe_steps_page.dart';

class CreateRecipe extends StatefulWidget {

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

  @override
  void initState() {

    coverPage = CreateRecipeCover(key: PageStorageKey('CoverPage'));
    stepsPage = CreateRecipeSteps(key: PageStorageKey('StepsPage'));

    _children = [coverPage,stepsPage];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: _children[_currentIndex],
        bucket: bucket,
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

}