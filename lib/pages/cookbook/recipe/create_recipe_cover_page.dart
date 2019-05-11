import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_cookbook/localization/app_translations.dart';
import 'package:the_cookbook/models/Ingredient.dart';
import 'package:the_cookbook/models/recipe.dart';
import 'package:the_cookbook/pages/cookbook/recipe/recipe_presenter.dart';
import 'package:the_cookbook/pages/cookbook/recipe/step/step_presenter.dart';
import 'package:the_cookbook/storage/create_recipe_storage.dart';
import 'package:the_cookbook/utils/image_picker_and_cropper.dart';
import 'package:the_cookbook/utils/separator.dart';

// ignore: must_be_immutable
class CreateRecipeCover extends StatefulWidget{

  Function callback;
  Recipe recipe;
  Uint8List _bytesImage;
  var tempBgPhoto;

  bool isNewRecipe;

  CreateRecipeCover(this.callback, {Key key, PageStorageBucket bucket, this.recipe, this.isNewRecipe}) : super(key: key);

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

  ImagePickerAndCropper imagePickerAndCropper;

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
    if(widget.recipe == null || widget.isNewRecipe){

      widget.recipe = new Recipe(0, "", "", "DEFAULT", "", 0, 0);

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

      _textMinutesController.text = widget.recipe.durationInMinutes.toString() != "987654321" ? widget.recipe.durationInMinutes.toString() : null;

      _textRecipeNameController.text = widget.recipe.name;
      PageStorage.of(context).writeState(context, widget.recipe.name.trim(), identifier: "recipeName");

      _textSummaryController.text = widget.recipe.summary != "null" ? widget.recipe.summary : "";

      if(CreateRecipeStorage.getIngredients().length==0){

        recipePresenter.getIngredients(widget.recipe.cookbookId, widget.recipe.recipeId).then((ingredientList){

          widget.recipe.ingredients = ingredientList;

          for(Ingredient ingredient in ingredientList){
            _addTextField(text: ingredient.description);
            //this.widget.callback();
          }

        });

      }else{

        List<TextFieldAndController> tempList = new List<TextFieldAndController>();
        tempList.addAll(CreateRecipeStorage.getIngredients());

        for(TextFieldAndController tf in tempList){
          CreateRecipeStorage.deleteIngredient(tf);
          //this.widget.callback();
        }

        for(TextFieldAndController tf in tempList){
          _addTextField(text: tf.getTextField.controller.text);
          //this.widget.callback();
        }

      }

      stepPresenter.getSteps(widget.recipe.cookbookId, widget.recipe.recipeId).then((stepsList){
        widget.recipe.steps = stepsList;
        for(int i = 0; i<stepsList.length; i++){
          CreateRecipeStorage.setStep(stepsList[i]);
          if(stepsList[i].photoBase64Encoded == "DEFAULT"){
            CreateRecipeStorage.setStepImage(i, null);
          }else{
            Uint8List _bytesImage;
            _bytesImage = Base64Decoder().convert(stepsList[i].photoBase64Encoded);
            CreateRecipeStorage.setStepImage(i, File.fromRawPath(_bytesImage));
          }
        }
      });

    }

    super.initState();

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

  void updatePage(File croppedFile){
    setState(() {
      newPhoto = true;
      List<int> imageBytes = croppedFile.readAsBytesSync();
      widget.recipe.coverBase64Encoded = base64Encode(imageBytes);
      widget.tempBgPhoto = widget.recipe.coverBase64Encoded;
      PageStorage.of(context).writeState(context, widget.recipe.coverBase64Encoded, identifier: "bgPhoto");
    });
  }

  List<String> menuItems;
  List<DropdownMenuItem<String>> _dropDownMenuItems;

  void initMenuItems(){
    menuItems = <String>[
      AppTranslations.of(context).text("key_recipe_level_easy"),
      AppTranslations.of(context).text("key_recipe_level_medium"),
      AppTranslations.of(context).text("key_recipe_level_hard"),
    ];

    _dropDownMenuItems = menuItems
        .map( (String value) => DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    )
    ).toList();

    if(AppTranslations.of(context).currentLanguage=="es" && widget.recipe.level.isNotEmpty){
      _selectedDiffulty = _levelInSpanish(widget.recipe.level);
    }
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    initMenuItems();
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
          tooltip: AppTranslations.of(context).text("key_tooltip_pick_image"),
          onPressed: () {
            imagePickerAndCropper = new ImagePickerAndCropper();
            imagePickerAndCropper.showDialog(context, callback);
          },
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
                          AppTranslations.of(context).text("key_recipe_how_hard"),
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
          labelText: AppTranslations.of(context).text("key_recipe_name_hint"),
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
                child: Container(
                  width: 24,
                  height: 24,
                  child: Image(
                    image: _renderLevelImage(widget.recipe.level)
                  ),
                ),
              ),
              Text(
                "${AppTranslations.of(context).text("key_recipe_level")}:",
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
            value: _selectedDiffulty != "null" ? _selectedDiffulty : null,
            hint: Text(AppTranslations.of(context).text("key_recipe_level_hint")),
            onChanged: (newSelectedDifficulty) {
              setState(() {
                String newLevel = newSelectedDifficulty;
                if(AppTranslations.of(context).currentLanguage=="es"){
                  newLevel = _levelInEnglish(newSelectedDifficulty);
                }
                PageStorage.of(context).writeState(context, newLevel, identifier: "selectedDifficulty");
                this._selectedDiffulty = newSelectedDifficulty;
                widget.recipe.level = newLevel;
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
                child: Container(
                  width: 24,
                  height: 24,
                  child: Image(
                    image: AssetImage("assets/images/clock.png"),
                  ),
                ),
              ),
              Text(
                "${AppTranslations.of(context).text("key_recipe_minutes_large")}:",
                style: TextStyle(
                  fontFamily: 'Muli',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),

              ),
            ],
          ),
          Container(
            width: 70.0,
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
                    AppTranslations.of(context).text("key_recipe_summary"),
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
                        AppTranslations.of(context).text("key_recipe_ingredients"),
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
                          setState(() {
                            _addTextField();
                          });
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
      autofocus: controller.text.isEmpty? false : false,
      decoration: InputDecoration(
        counterText: "",
        //hintText: AppTranslations.of(context).text("key_step_description_hint"),
        suffixIcon: IconButton(icon: Icon(Icons.delete), onPressed: (){
          deleteTextField(ValueKey(keytext));
        })
      ),
    );
    TextFieldAndController textFieldAndController = new TextFieldAndController(textField,controller);
    CreateRecipeStorage.setIngredient(textFieldAndController);
    //if (!this.mounted) return;
    //setState(() {
      //_scrollController.animateTo(_scrollController.position.maxScrollExtent+48.0, duration: Duration(milliseconds: 200), curve: Curves.linearToEaseOut);
    //});
  }

  List<Widget> _renderTextFields() {
    List<Widget> _textFields = new List<Widget>();
    for(TextFieldAndController tf in CreateRecipeStorage.getIngredients()){
      _textFields.add(tf.textField);
    }
    return _textFields;
  }

  void deleteTextField(ValueKey<int> valueKey) {
    TextFieldAndController tempTf;
    for(TextFieldAndController tf in CreateRecipeStorage.getIngredients()){
      if(tf.textField.key == valueKey){
        tempTf = tf;
        break;
      }
    }

    CreateRecipeStorage.deleteIngredient(tempTf);
    setState(() {});

  }

  @override
  void setState(fn) {
    widget.callback();
    super.setState(fn);
  }


  @override
  void screenUpdate() {
    setState(() {});
  }

  _renderLevelImage(String level) {
    if(level.toLowerCase()=="easy"){
      return AssetImage("assets/images/level_easy.png");
    }else if(level.toLowerCase()=="medium"){
      return AssetImage("assets/images/level_medium.png");
    }else if(level.toLowerCase()=="hard"){
      return AssetImage("assets/images/level_hard.png");
    }else{
      return AssetImage("assets/images/level_none.png");
    }
  }

  _levelInEnglish(String level) {
    if(level.toLowerCase()=="fácil"){
      return "Easy";
    }else if(level.toLowerCase()=="medio"){
      return "Medium";
    }else if(level.toLowerCase()=="difícil"){
      return "Hard";
    }
  }

  _levelInSpanish(String level) {
    if(level.toLowerCase()=="easy"){
      return "Fácil";
    }else if(level.toLowerCase()=="medium"){
      return "Medio";
    }else if(level.toLowerCase()=="hard"){
      return "Difícil";
    }
  }

}

class TextFieldAndController{

  TextFormField textField;
  TextEditingController controller;

  TextFieldAndController(this.textField, this.controller);

  TextFormField get getTextField => textField;

}