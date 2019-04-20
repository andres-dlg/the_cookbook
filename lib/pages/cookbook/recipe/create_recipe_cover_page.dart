import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_cookbook/models/Ingredient.dart';
import 'package:the_cookbook/models/recipe.dart';
import 'package:the_cookbook/pages/cookbook/recipe/recipe_presenter.dart';
import 'package:the_cookbook/pages/cookbook/recipe/step/step_presenter.dart';
import 'package:the_cookbook/storage/create_recipe_storage.dart';
import 'package:the_cookbook/utils/separator.dart';

// ignore: must_be_immutable
class CreateRecipeCover extends StatefulWidget{

  Function callback;
  Recipe recipe;
  Uint8List _bytesImage;
  var tempBgPhoto;

  CreateRecipeCover(this.callback, {Key key, PageStorageBucket bucket, this.recipe}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CreateRecipeCoverState();
  }

}

class _CreateRecipeCoverState extends State<CreateRecipeCover> implements RecipeContract, StepContract{

  var _selectedDiffulty;

  var newPhoto = false;

  RecipePresenter recipePresenter;
  StepPresenter stepPresenter;

  //TEXT CONTROLLERS
  final _textRecipeNameController = TextEditingController();
  final _textMinutesController = TextEditingController();
  final _textSummaryController = TextEditingController();

  //SCROLL CONTROLLER

  @override
  void initState(){

    recipePresenter = new RecipePresenter(this);
    stepPresenter = new StepPresenter(null);

    //Fill form fields if another tab was selected and then returned to this.
    if(widget.recipe == null){

      var difficulty = PageStorage.of(context).readState(context, identifier: "selectedDifficulty");
      if(difficulty.toString().trim().isNotEmpty){
        _selectedDiffulty = difficulty;
      }

      var minutes = PageStorage.of(context).readState(context, identifier: "selectedMinutes");
      if(minutes.toString().trim().isNotEmpty){
        _textMinutesController.text = minutes;
      }

      var recipeName = PageStorage.of(context).readState(context, identifier: "recipeName");
      if(recipeName.toString().trim().isNotEmpty){
        _textRecipeNameController.text = recipeName;
      }

      var recipeSummary = PageStorage.of(context).readState(context, identifier: "recipeSummary");
      if(recipeSummary.toString().trim().isNotEmpty){
        _textSummaryController.text = recipeSummary;
      }

    }else{

      _selectedDiffulty = widget.recipe.level;

      _textMinutesController.text = widget.recipe.durationInMinutes.toString();

      _textRecipeNameController.text = widget.recipe.name;
      PageStorage.of(context).writeState(context, widget.recipe.name.trim(), identifier: "recipeName");

      _textSummaryController.text = widget.recipe.summary;

      recipePresenter.getIngredients(widget.recipe.cookbookId, widget.recipe.recipeId).then((ingredientList){

        widget.recipe.ingredients = ingredientList;

        for(Ingredient ingredient in ingredientList){
          _addTextField(text: ingredient.description);
          this.widget.callback();
        }

      });

      stepPresenter.getSteps(widget.recipe.cookbookId, widget.recipe.recipeId).then((stepsList){
        widget.recipe.steps = stepsList;
        for(int i = 0; i<stepsList.length; i++){
          CreateRecipeStorage.setStep(stepsList[i]);
          Uint8List _bytesImage;
          _bytesImage = Base64Decoder().convert(stepsList[i].photoBase64Encoded);
          CreateRecipeStorage.setStepImage(i, File.fromRawPath(_bytesImage));
        }
      });

    }

    super.initState();

  }

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
      newPhoto = true;
      List<int> imageBytes = croppedFile.readAsBytesSync();
      widget.recipe.coverBase64Encoded = base64Encode(imageBytes);
      widget.tempBgPhoto = widget.recipe.coverBase64Encoded;
      PageStorage.of(context).writeState(context, widget.recipe.coverBase64Encoded, identifier: "bgPhoto");
    });

  }

  static const menuItems = <String>[
    'Easy',
    'Medium',
    'Hard',
  ];

  final List<DropdownMenuItem<String>> _dropDownMenuItems = menuItems
      .map( (String value) => DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      )
    ).toList();


  @override
  void dispose() {
    _textRecipeNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        //controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            _renderAppBar(context)
          ];
        },
        body: _renderBody(context),
      );
  }

  SliverAppBar _renderAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 248.0,
      floating: false,
      leading: Icon(Icons.arrow_back_ios, color: Colors.transparent,),
      automaticallyImplyLeading: true,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
          /*background: Image.asset(
            "assets/images/food_pattern.png",
            fit: BoxFit.cover,
          )*/
          background: Container(
            child: Stack(
              children: <Widget>[
                _renderBackgroundImage(),
                _renderBackgroundOpacity(),
                _renderCameraButton()
              ],
            ),
          ),
      ),
    );
  }

  Widget _renderCameraButton(){
    return Center(
      child: Material(
        type: MaterialType.transparency,
        color: Colors.transparent,
        child: IconButton(
          icon: Icon(Icons.camera_alt),
          color: Colors.white,
          iconSize: 64.0,
          tooltip: "Pick cover Image",
          onPressed: () { getImage(); },
        ),
      ),
    );
  }

  Widget _renderBackgroundImage() {
    var thumb;
    if(widget.recipe == null || widget.recipe.coverBase64Encoded == "DEFAULT"){
      thumb = Container(
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
            "assets/images/food_pattern.png",
            fit: BoxFit.cover,
          )
      );
    }else{
      if(widget.recipe.coverBase64Encoded != widget.tempBgPhoto || newPhoto){
        newPhoto = false;
        widget.tempBgPhoto = widget.recipe.coverBase64Encoded;
        widget._bytesImage = Base64Decoder().convert(widget.recipe.coverBase64Encoded);
      }
      thumb = Container(
          width: MediaQuery.of(context).size.width,
          child: Image.memory(
            widget._bytesImage,
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

  Widget _renderBody(BuildContext context){
    return SingleChildScrollView(
      //controller: _scrollController,
      key: PageStorageKey('scrollPosition'),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _renderRecipeTitle(),
            Card(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 32.0),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Text(
                          "How hard is it?",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'Muli'
                          )
                      ),
                    ),
                    Center(child: new Separator(width: 64.0, heigth: 1.0, color: Colors.cyan,)),
                    _renderRecipeLevel(),
                    _renderRecipeMinute(),
                  ],
                ),
              ),
            ),
            Container(
              height: 16,
            ),
            _renderRecipeSummary(context),
            Container(
              height: 16,
            ),
            _renderRecipeIngredients(context)
          ],
        ),
      ),
    );
  }

  Widget _renderRecipeTitle() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0,left: 8.0,bottom: 16.0),
      child: TextField(
        controller: _textRecipeNameController,
        textAlign: TextAlign.center,
        maxLength: 30,
        style: TextStyle(
            fontFamily: 'Muli',
            fontSize: 20.0,
            fontWeight: FontWeight.bold
        ),
        decoration: InputDecoration(
          labelText: 'Recipe name *',
          labelStyle: TextStyle(
              fontFamily: 'Muli',
              fontSize: 20.0,
              fontWeight: FontWeight.bold
          ),
        ),
        onChanged: (value){
          setState(() {
            PageStorage.of(context).writeState(context, _textRecipeNameController.text, identifier: "recipeName");
            widget.recipe.name = value;
            this.widget.callback();
          });
        },
      ),
    );
  }

  Widget _renderRecipeLevel() {
    return Padding(
      padding: const EdgeInsets.only(left: 64.0, right: 64.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(Icons.signal_cellular_4_bar),
              ),
              Text(
                "Difficulty:",
                style: TextStyle(
                  fontFamily: 'Muli',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
          DropdownButton(
            style: TextStyle(
                fontFamily: 'Muli',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black
            ),
            value: _selectedDiffulty,
            hint: Text("Choose"),
            onChanged: (newSelectedDifficulty) {
              setState(() {
                PageStorage.of(context).writeState(context, newSelectedDifficulty, identifier: "selectedDifficulty");
                this._selectedDiffulty = newSelectedDifficulty;
                widget.recipe.level = newSelectedDifficulty;
              });
            },
            items: this._dropDownMenuItems,
          )
        ],
      ),
    );
  }

  Widget _renderRecipeMinute() {
    return Padding(
      padding: const EdgeInsets.only(left: 64.0, right: 64.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(Icons.access_time),
              ),
              Text(
                "Minutes:",
                style: TextStyle(
                  fontFamily: 'Muli',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),

              ),
            ],
          ),
          Container(
            width: 82.0,
            child: TextField(
              controller: _textMinutesController,
              maxLength: 3,
              keyboardType: TextInputType.number,
              style: TextStyle(
                  fontFamily: 'Muli',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold
              ),
              decoration: InputDecoration(
                counterText: "",
                hintText: "---",
                  enabledBorder: new UnderlineInputBorder(
                      borderSide: new BorderSide(
                          color: Colors.grey[200]
                      )
                  )
              ),
              onChanged: (value){
                setState(() {
                  PageStorage.of(context).writeState(context, value, identifier: "selectedMinutes");
                  widget.recipe.durationInMinutes = int.parse(value);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderRecipeSummary(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                    "Summary",
                    style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Muli'
                    )
                ),
              ),
              Center(child: new Separator(width: 64.0, heigth: 1.0, color: Colors.cyan,)),
              TextField(
                controller: _textSummaryController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                maxLength: 500,
                onChanged: (value){
                  setState(() {
                    PageStorage.of(context).writeState(context, value, identifier: "recipeSummary");
                    widget.recipe.summary = value;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderRecipeIngredients(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Center(
                    child: Text(
                      "Ingredients",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Muli'
                      )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Center(child: new Separator(width: 64.0, heigth: 1.0, color: Colors.cyan,)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FloatingActionButton(
                        mini: true,
                        child: Icon(Icons.add),
                        onPressed: () {
                          _addTextField();
                        },
                      )
                    ],
                  )
                ],
              ),
              Wrap(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: _renderTextFields()
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addTextField({String text}) {
    var rnd = new Random();
    var keytext = rnd.nextInt(999999999);
    TextEditingController controller;
    if(text==null){
      controller = new TextEditingController();
    }else{
      controller = new TextEditingController(text: text);
    }
    TextFormField textField = new TextFormField(
      key: ValueKey(keytext),
      controller: controller,
      maxLength: 40,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        counterText: "",
        hintText: "Type here",
        suffixIcon: IconButton(icon: Icon(Icons.delete), onPressed: (){
          deleteTextField(ValueKey(keytext));
        })
      ),
    );
    TextFieldAndController textFieldAndController = new TextFieldAndController(textField,controller);
    CreateRecipeStorage.setIngredient(textFieldAndController);
    setState(() {
      //_scrollController.animateTo(_scrollController.position.maxScrollExtent+48.0, duration: Duration(milliseconds: 200), curve: Curves.linearToEaseOut);
    });
  }

  List<Widget> _renderTextFields() {
    List<Widget> _textFields = new List<Widget>();
    for(TextFieldAndController tf in CreateRecipeStorage.getIngredients()){
      _textFields.add(tf.textField);
    }
    return _textFields;
  }

  void deleteTextField(ValueKey<int> valueKey) {
    for(TextFieldAndController tf in CreateRecipeStorage.getIngredients()){
      if(tf.textField.key == valueKey){
        CreateRecipeStorage.deleteIngredient(tf);
        setState(() {});
        break;
      }
    }
  }

  @override
  void screenUpdate() {
    setState(() {});
  }

}

class TextFieldAndController{

  TextFormField textField;
  TextEditingController controller;

  TextFieldAndController(this.textField, this.controller);

  TextFormField get getTextField => textField;

}