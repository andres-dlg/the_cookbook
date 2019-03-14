import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
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
    Future.delayed(Duration(milliseconds: 5000));
    return Scaffold(
      appBar: _renderAppBar(),
      body: _children[_currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.create),
        tooltip: "Create cookbook",
        onPressed: () {
          _showDialog();
        },
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
                                                  Colors.black, onPressed: () {},
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
              disabledColor: _currentIndex == 1 ? Colors.blueAccent : Colors.black, onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          //title: new Text("Alert Dialog title"),
          content: new MyDialogContent(),//_renderDialogBody(),
          /*actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Save"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],*/
        );
      },
    );
  }

}


// https://www.didierboelens.com/2018/05/hint-5-how-to-refresh-the-content-of-a-dialog-via-setstate/
class MyDialogContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyDialogContentState();
  }
}

class _MyDialogContentState extends State<MyDialogContent> {

  File _image;

  getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    _cropImage(image);
  }

  Future _cropImage(File imageFile) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      ratioX: 1.0,
      ratioY: 1.0,
      maxWidth: 512,
      maxHeight: 512,
    );

    setState(() {
      _image = croppedFile;
      print("Cropped file: "+ _image.path);
    });
  }

  @override
  void initState(){
    super.initState();
  }

  _getContent(){
    return Container(
      width: 400.0,
      height: 400.0,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _renderBackgroundImage(),
          _renderBackgroundOpacity(),
          _renderCameraButton(),
          _renderForegroundDialogContent()

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getContent();
  }

  Widget _renderBackgroundImage() {
    return Container(
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
    );
  }

  Widget _renderBackgroundOpacity() {
    return Container(
      color: Color.fromRGBO(0, 0, 0, 0.5),
    );
  }

  Widget _renderCameraButton() {
    return Center(
        child: Container(
          width: 128,
          height: 128,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            //color: Colors.red,
          ),
          child: Material(
            type: MaterialType.transparency,
            child: IconButton(
              icon: Icon(Icons.camera_alt),
              color: Colors.white,
              iconSize: 64.0,
              onPressed: () { getImage(); },
            ),
          ),
        )
    );
  }

  Widget _renderForegroundDialogContent() {

    return Column(
      children: <Widget>[
        _renderDialogTitle(),
        Expanded(child: Container()),
        _renderTextFormField(),
        _renderButtons(),

      ],
    );
  }

  Widget _renderDialogTitle() {
    return Center(
      heightFactor: 2,
      child: Text(
        "Create new cookbook",
        style: TextStyle(
            color: Colors.white,
            fontFamily: 'Muli',
            fontSize: 20.0,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _renderTextFormField() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16.0),
      child: TextFormField(
        textAlign: TextAlign.center,
        cursorColor: Colors.white,
        autofocus: true,
        style: TextStyle(
            color: Colors.white,
            fontFamily: 'Muli',
            fontSize: 20.0,
            fontWeight: FontWeight.bold
        ),
        decoration: InputDecoration(
          labelText: 'Cookbook name',
          labelStyle: TextStyle(
              color: Colors.white,
              fontFamily: 'Muli',
              fontSize: 20.0,
              fontWeight: FontWeight.bold
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }

  _renderButtons() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap:() { Navigator.of(context).pop(); },
              child: Container(
                child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white,),
                    onPressed: null
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap:() {},
              child: Container(
                child: IconButton(
                    icon: Icon(Icons.save,  color: Colors.white,),
                    onPressed: null
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

}