import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:the_cookbook/database/database_helper.dart';
import 'package:the_cookbook/localization/app_translations.dart';
import 'package:the_cookbook/models/cookbook.dart';
import 'package:the_cookbook/pages/cookbook/recipe/recipe_list_page.dart';
import 'package:the_cookbook/pages/cookbook/cookbook_presenter.dart';
import 'package:the_cookbook/utils/image_picker_and_cropper.dart';

// ignore: must_be_immutable
class CookbookList extends StatefulWidget {

  CookbookPresenter cookbookPresenter;

  CookbookList(this.cookbookPresenter);

  @override
  _CookbookListState createState() => _CookbookListState();

}

class _CookbookListState extends State<CookbookList> {

  void _select(String choice, Cookbook cookbook) {
    if(choice == 'Edit'){
      _showEditDialog(cookbook);
    }else if(choice == 'Delete'){
      _showDeleteDialog(context, cookbook);
    }
  }

  @override
  void initState(){
    super.initState();
  }

  displayRecord() {
    widget.cookbookPresenter.updateScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _gridViewItemBuilder(context),
    );
  }

  Widget _gridViewItemBuilder(BuildContext context) {
    return FutureBuilder<List<Cookbook>>(
      future: widget.cookbookPresenter.getCookbooks(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        List<Cookbook> cookbooks = snapshot.data;
        return _renderMainScreen(snapshot.hasData, cookbooks);

      },
    );
  }

  _renderMainScreen(bool hasData, List<Cookbook> cookbooks){

    if(!hasData){

      return Center(child: CircularProgressIndicator(),);

    }else if(hasData && cookbooks.length == 0){
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: new Image.asset('assets/images/recipes-book.png',color: Colors.black26,),
              iconSize: 112,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48.0),
              child: Text(
                AppTranslations.of(context).text("key_create_new_cookbook_text"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Muli',
                ),
              ),
            ),
          ]
      );
    }else{
      return GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this would produce 2 rows.
        crossAxisCount: 2,
        // Generate as many Widgets as cookbooks are present on cookbooks array
        children: List.generate(cookbooks.length, (index) {
          return Center(
              child: _itemCard(context, cookbooks[index])
          );
        }),
      );
    }
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
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert,color: Colors.white,),
                    elevation: 1,
                    onCanceled: () {
                      print('You have not chossed anything');
                    },
                    tooltip: AppTranslations.of(context).text("key_menu"),
                    onSelected: (value) => _select(value,cookbook),
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'Edit',
                        child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text(AppTranslations.of(context).text("key_edit"), style: TextStyle(fontFamily: 'Muli')),
                        ),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem<String>(
                        value: 'Delete',
                        child: ListTile(
                          leading: Icon(Icons.delete),
                          title: Text(AppTranslations.of(context).text("key_delete"), style: TextStyle(fontFamily: 'Muli')),
                        ),
                      )
                    ]
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

  _navigateToRecipeList(BuildContext context, Cookbook cookbook) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecipeList(cookbook: cookbook)),
    );
  }

  _deleteCookbook(BuildContext context, Cookbook cookbook) async {
    widget.cookbookPresenter.delete(cookbook);
  }

  void _showEditDialog(Cookbook cookbook) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          content: new MyDialogContent(this, cookbook),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, Cookbook cookbook) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(AppTranslations.of(context).text("key_dialog_delete_cookbook_title")),
          content: new Text(AppTranslations.of(context).text("key_dialog_delete_cookbook_text")),
          actions: <Widget>[
            new FlatButton(
              child: new Text(AppTranslations.of(context).text("key_dialog_delete_accept")),
              onPressed: () {
                _deleteCookbook(context, cookbook);
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(AppTranslations.of(context).text("key_dialog_delete_cancel")),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// ignore: must_be_immutable
class MyDialogContent extends StatefulWidget {

  Cookbook cookbook;
  _CookbookListState _coookbookListState;

  MyDialogContent(this._coookbookListState, this.cookbook);

  @override
  State<StatefulWidget> createState() {
    return _MyDialogContentState();
  }

}

class _MyDialogContentState extends State<MyDialogContent> {

  bool save = false;
  bool isError = false;

  //CONTROLLERS
  final _textEditingController = TextEditingController();

  ImagePickerAndCropper imagePickerAndCropper;

  @override
  void initState(){

    _textEditingController.text = widget.cookbook.name;

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
    var thumb;
    if(widget.cookbook.coverBase64Encoded == "DEFAULT"){
      thumb = SizedBox.expand(
          child: Image.asset(
            "assets/images/food_pattern.png",
            fit: BoxFit.cover,
          )
      );
    }else{
      Uint8List _bytesImage;
      _bytesImage = Base64Decoder().convert(widget.cookbook.coverBase64Encoded);
      thumb = SizedBox.expand(
          child: Image.memory(
            _bytesImage,
            fit: BoxFit.cover,
          )
      );
    }
    return thumb;

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
      List<int> imageBytes = file.readAsBytesSync();
      widget.cookbook.coverBase64Encoded = base64Encode(imageBytes);
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
        AppTranslations.of(context).text("key_tooltip_update_cookbook_button"),
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
          labelText:  AppTranslations.of(context).text("key_create_new_cookbook_label"),
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
                      _updateCookbook();
                      widget._coookbookListState.displayRecord();
                    }
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future _updateCookbook() async  {
    if(_textEditingController.text.trim().isEmpty){
      setState(() {
        isError = true;
      });
    }else{
      var db = new DatabaseHelper();
      widget.cookbook.name = _textEditingController.text.trim();
      await db.updateCookbook(widget.cookbook).whenComplete((){
        Navigator.of(context).pop();
      });
    }
  }

}



