import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_cookbook/pages/recipe/create_recipe_page.dart';
import 'package:the_cookbook/utils/separator.dart';

class CreateRecipeCover extends StatefulWidget{

  const CreateRecipeCover({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CreateRecipeCoverState();
  }

}

class _CreateRecipeCoverState extends State<CreateRecipeCover> {

  var _selectedDiffulty;

  var _image;

  //TEXT CONTROLLERS
  final _textRecipeNameController = TextEditingController();
  final _textMinutesController = TextEditingController();
  final _textSummaryController = TextEditingController();

  @override
  void initState(){

    //Fill form fields if another tab was selected and then returned to this.

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

    var bgPhoto = PageStorage.of(context).readState(context, identifier: "bgPhoto");
    if(bgPhoto != null){
      _image = bgPhoto;
    }

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
      _image = croppedFile;
      print("Cropped file: "+ _image.path);
      PageStorage.of(context).writeState(context, _image, identifier: "bgPhoto");
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
    // Clean up the controller when the Widget is disposed
    _textRecipeNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
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
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.3),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
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
    return Container(
        width: MediaQuery.of(context).size.width,
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

  Widget _renderBody(BuildContext context){
    return SingleChildScrollView(
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
          labelText: 'Recipe name',
          labelStyle: TextStyle(
              fontFamily: 'Muli',
              fontSize: 20.0,
              fontWeight: FontWeight.bold
          ),
        ),
        onChanged: (value){
          setState(() {
            PageStorage.of(context).writeState(context, _textRecipeNameController.text, identifier: "recipeName");
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
                hintText: "???",
                  enabledBorder: new UnderlineInputBorder(
                      borderSide: new BorderSide(
                          color: Colors.grey[200]
                      )
                  )
              ),
              onChanged: (value){
                setState(() {
                  PageStorage.of(context).writeState(context, value, identifier: "selectedMinutes");
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
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }

}