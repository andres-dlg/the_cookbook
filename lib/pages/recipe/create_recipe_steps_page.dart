import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_cookbook/utils/separator.dart';
import 'package:the_cookbook/models/step.dart' as RecipeStep;

class CreateRecipeSteps extends StatefulWidget{

  const CreateRecipeSteps({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CreateRecipeStepsState();
  }

}

class _CreateRecipeStepsState extends State<CreateRecipeSteps>{

  List<RecipeStep.Step> _steps = [];

  var _image;

  @override
  void initState() {

    RecipeStep.Step step = new RecipeStep.Step(
        title: "Step 1",
        description: "BBBBBBBBBBBBBBBBBBB"
    );

    _steps.add(step);

    super.initState();
  }

  @override
  void dispose() {
    _steps = [];
    super.dispose();
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
      print("Cropped file: " + _image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.blueAccent,
      body: Container(
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
        height: MediaQuery.of(context).size.height,
        child: _renderCarousel(context)
      )
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

  Widget _renderCarousel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: DefaultTabController(
          length: _steps.length,
          child: Builder(
            builder: (BuildContext context) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  TabPageSelector(),
                  Expanded(
                    child: IconTheme(
                        data: IconThemeData(
                          size: 128.0,
                          color: Theme.of(context).accentColor
                        ),
                        child: TabBarView(children: _renderSteps())),
                  )
                ],
              ),
            ),
          )
      )
    );
  }

  Widget _renderStepSlide(BuildContext context, RecipeStep.Step step) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 3.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.5),
              offset: Offset(0.0, 3.0),
              blurRadius: 2.0,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                _renderStepTitle(step),
                new Separator(width: 64.0, heigth: 1.0, color: Colors.cyan),
                _renderStepPhoto(context),
                new Separator(width: 64.0, heigth: 1.0, color: Colors.cyan),
                _renderStepDescription(step)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderStepTitle(RecipeStep.Step step){
    return Text(
      step.title,
      style: TextStyle(
        color: Colors.black,
        fontSize: 24.0,
        fontFamily: 'Muli',
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _renderStepPhoto(BuildContext context){
    return Container(
      height: 248,
      child: Stack(
        children: <Widget>[
          _renderBackgroundImage(),
          _renderBackgroundOpacity(),
          _renderCameraButton()
        ],
      ),
    );
  }

  Widget _renderStepDescription(RecipeStep.Step step){
    return TextField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      maxLength: 1000,
      onChanged: (value){
        setState(() {
          //PageStorage.of(context).writeState(context, value, identifier: "recipeSummary");
        });
      },
    );
  }

  List<Widget> _renderSteps() {
    List<Widget> slides = [];
    for(RecipeStep.Step step in _steps){
      slides.add(_renderStepSlide(context, step));
    }
    return slides;
  }

}

