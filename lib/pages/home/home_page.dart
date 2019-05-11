import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:the_cookbook/database/database_helper.dart';
import 'package:the_cookbook/localization/app_translations.dart';
import 'package:the_cookbook/models/cookbook.dart';
import 'package:the_cookbook/pages/cookbook/cookbook_list_page.dart';
import 'package:the_cookbook/pages/home/favourites_list_page.dart';
import 'package:the_cookbook/pages/cookbook/cookbook_presenter.dart';
import 'package:the_cookbook/pages/home/settings_page.dart';
import 'package:the_cookbook/utils/image_picker_and_cropper.dart';

class Home extends StatefulWidget {

  Function callback;

  Home({this.callback});

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }

}

class _HomeState extends State<Home> implements CookbookContract {

  CookbookPresenter cookbookPresenter;

  @override
  void initState() {
    super.initState();
    cookbookPresenter = new CookbookPresenter(this);
  }

  int _currentIndex = 0;

  displayRecord() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 5000));
    return Scaffold(
      appBar: _renderAppBar(),
      body: _currentIndex == 0 ? CookbookList(cookbookPresenter) : FavouritesList(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.create),
        tooltip: AppTranslations.of(context).text("key_tooltip_create_cookbook_button"),
        onPressed: () {
          _showDialog();
        },
      ),
      bottomNavigationBar: _renderBottomAppBar(_currentIndex)
    );
  }

  Widget _renderAppBar(){
    final String title = "The Cookbook";
    final double barHeight = 60.0;
    final double statusbarHeight = MediaQuery
        .of(context)
        .padding
        .top;
    return PreferredSize(
      child: Container(
        padding: new EdgeInsets.only(top: statusbarHeight),
        height: statusbarHeight + barHeight,
        child: Stack(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Center(
                  child: new Text(
                    title,
                    style: new TextStyle(fontSize: 40.0, color: Colors.white, fontFamily: 'Cookie'),
                  ),
                ),
              ],
            ),
            Material(
              type: MaterialType.transparency,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new Center(
                    child: IconButton(
                      tooltip: AppTranslations.of(context).text("key_settings"),
                      icon: Icon(Icons.settings),
                      color: Colors.white, onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage(callback: widget.callback)));
                      },
                    ),
                  ),
                ],
              ),
            )
          ]
        ),
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
      ),
      preferredSize: new Size(
        MediaQuery.of(context).size.width,
        150.0
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
              icon: new Container(
                width: 24,
                height: 24,
                child: Image(
                  image: _currentIndex == 0 ? AssetImage("assets/images/cookbook.png") : AssetImage("assets/images/recipes-book.png"),
                ),
              ),
              color: _currentIndex == 0 ? Colors.blueAccent : Colors.black,
              disabledColor: _currentIndex == 0 ? Colors.blueAccent : Colors.black,
            ),
            Text(
              AppTranslations.of(context).text("key_cookbooks_tab_name"),
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
              AppTranslations.of(context).text("key_favourites_tab_name"),
              style: TextStyle(
                  fontFamily: 'Muli',
                  fontWeight: FontWeight.bold,
                  color: _currentIndex == 1 ? Colors.blueAccent : Colors.black
              ),
            ),
            IconButton(
              icon: _currentIndex == 1 ? Icon(Icons.star) : Icon(Icons.star_border),
              color: _currentIndex == 1 ? Colors.yellow : Colors.black,
              disabledColor: _currentIndex == 1 ? Colors.yellow : Colors.black,
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
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          content: new MyDialogContent(this),
        );
      },
    );
  }

  @override
  void screenUpdate() {
    setState(() {});
  }

}


// https://www.didierboelens.com/2018/05/hint-5-how-to-refresh-the-content-of-a-dialog-via-setstate/
// ignore: must_be_immutable
class MyDialogContent extends StatefulWidget {

  _HomeState _homeState;

  MyDialogContent(this._homeState);

  @override
  State<StatefulWidget> createState() {
    return _MyDialogContentState();
  }

}

class _MyDialogContentState extends State<MyDialogContent> {

  File _image;
  bool save = false;
  bool isError = false;
  ImagePickerAndCropper imagePickerAndCropper;

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

  //CONTROLLERS
  final _textEditingController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _textEditingController.dispose();
    super.dispose();
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
              tooltip: AppTranslations.of(context).text("key_tooltip_pick_image"),
              onPressed: () {
                imagePickerAndCropper = new ImagePickerAndCropper();
                imagePickerAndCropper.showDialog(context, callback);
              },
            ),
          ),
        )
    );
  }

  void callback(int option){
    if(option != null && option == 1){
        imagePickerAndCropper.getImageFromCamera().then((file)=>{
          updatePage(file)
      });
    }else if(option != null && option == 2){
      imagePickerAndCropper.getImageFromGallery().then((file)=>{
        updatePage(file)
      });
    }
  }

  void updatePage(File file){
    setState(() {
      _image = file;
    });
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
        AppTranslations.of(context).text("key_create_new_cookbook_title"),
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
        controller: _textEditingController,
        textAlign: TextAlign.center,
        cursorColor: Colors.white,
        autofocus: true,
        maxLength: 30,
        style: TextStyle(
            color: Colors.white,
            fontFamily: 'Muli',
            fontSize: 20.0,
            fontWeight: FontWeight.bold
        ),
        decoration: InputDecoration(
          labelText: AppTranslations.of(context).text("key_create_new_cookbook_label"),
          labelStyle: TextStyle(
              color: Colors.white,
              fontFamily: 'Muli',
              fontSize: 20.0,
              fontWeight: FontWeight.bold
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: isError? BorderSide(color: Colors.red):BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _renderButtons() {
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
                    tooltip: AppTranslations.of(context).text("key_create_new_cookbook_close"),
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
              child: Container(
                child: IconButton(
                    icon: Icon(Icons.save,  color: Colors.white,),
                    tooltip: AppTranslations.of(context).text("key_create_new_cookbook_save"),
                    onPressed: () {
                      _saveCookbook();
                      widget._homeState.displayRecord();
                    }
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future _saveCookbook() async  {
    if(_textEditingController.text.trim().isEmpty){
      setState(() {
        isError = true;
      });
    }else{
      String base64Image = "DEFAULT";
      if(_image != null){
        List<int> imageBytes = _image.readAsBytesSync();
        base64Image = base64Encode(imageBytes);
      }
      var db = new DatabaseHelper();
      var cookbook = new Cookbook(_textEditingController.text, base64Image);
      await db.saveCookbook(cookbook).whenComplete((){
        Navigator.of(context).pop();
      });

    }
  }

}