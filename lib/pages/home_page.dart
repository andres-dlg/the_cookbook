import 'package:flutter/material.dart';
import 'package:the_cookbook/pages/cookbook_list_page.dart';
import 'package:the_cookbook/pages/favourites_list_page.dart';
import 'package:the_cookbook/mocks/mock_cookbook.dart';

class Home extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }

}

class _HomeState extends State<Home> {

  int _currentIndex = 0;
  final List<Widget> _children = [
    CookbookList(MockCookbook.FetchAll()),
    FavouritesList(Colors.deepOrange),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _renderAppBar(),
      body: _children[_currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.create),
        tooltip: "Create cookbook",
        onPressed: () {},
      ),
      bottomNavigationBar: _renderBottomAppBar(_currentIndex)
    );
  }

  Widget _renderAppBar(){
    return AppBar(
      title: Center(
        child: Text(
          'THE COOKBOOK',
          style: TextStyle(
              fontFamily: 'Muli',
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );

  }

  Widget _renderBottomAppBar(int _currentIndex) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _renderCookbooksButton(),
          _renderFavouritesButton()
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _renderCookbooksButton () {
    return Expanded(
      child: new InkWell(
        onTap: () => onTabTapped(0),
        child: new Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.library_books),
              disabledColor: _currentIndex == 0 ? Colors.blueAccent :
                                                  Colors.black,
            ),
            Text(
              "Cookbooks",
              style: TextStyle(
                  fontFamily: 'Muli',
                  fontWeight: FontWeight.bold,
                  color: _currentIndex == 0 ? Colors.blueAccent :
                                              Colors.black
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderFavouritesButton () {
    return Expanded(
      child: new InkWell(
        onTap: () => onTabTapped(1),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              "Favourites",
              style: TextStyle(
                  fontFamily: 'Muli',
                  fontWeight: FontWeight.bold,
                  color: _currentIndex == 1 ? Colors.blueAccent : Colors.black
              ),
            ),
            IconButton(
              icon: Icon(Icons.star),
              disabledColor: _currentIndex == 1 ? Colors.blueAccent : Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}