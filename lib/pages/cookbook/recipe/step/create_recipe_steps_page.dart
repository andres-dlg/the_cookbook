import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_cookbook/utils/separator.dart';
import 'package:the_cookbook/models/step.dart' as RecipeStep;
import 'package:the_cookbook/storage/create_recipe_storage.dart';

// ignore: must_be_immutable
class CreateRecipeSteps extends StatefulWidget{

  PageStorageBucket bucket;

  CreateRecipeSteps({Key key, this.bucket}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CreateRecipeStepsState();
  }

}

class _CreateRecipeStepsState extends State<CreateRecipeSteps>{

  List<RecipeStep.Step> _steps;

  Map<int,File> _stepImages;

  //var _image;

  var _currentPage = 0;

  PageController _pageController;

  void initState() {

    _currentPage = 0;

    _pageController = PageController(viewportFraction: 0.9);

    _steps = CreateRecipeStorage.getSteps();

    _stepImages = CreateRecipeStorage.getStepImages();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getImage(int itemIndex) async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    _cropImage(image, itemIndex);
  }

  Future _cropImage(File imageFile, itemIndex) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      ratioX: 1.0,
      ratioY: 1.0,
      maxWidth: 512,
      maxHeight: 512,
    );

    setState(() {
      CreateRecipeStorage.setStepImage(itemIndex,croppedFile);
      print("Cropped file: " + croppedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding:CreateRecipeStorage.getSteps().length > 0 ? const EdgeInsets.only(top: 128.0, left: 320) : const EdgeInsets.all(0),
        child: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.pinkAccent,
          onPressed: () {_createNewStep();},
        ),
      ),
      floatingActionButtonLocation: CreateRecipeStorage.getSteps().length > 0 ? FloatingActionButtonLocation.startTop : FloatingActionButtonLocation.endFloat,
      body: Container(
          key: PageStorageKey('scrollStepsPosition'),
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

  Widget _renderCarousel(BuildContext context) {
    return PageView.builder(
      // store this controller in a State to save the carousel scroll position
      controller: _pageController,
      itemCount: CreateRecipeStorage.getSteps().length,
      itemBuilder: (BuildContext context, int itemIndex) {
        return _buildCarouselItem(context, _currentPage, itemIndex);
      },
    );
  }

  Widget _buildCarouselItem(BuildContext context, int carouselIndex, int itemIndex) {
    return Container(
      child: _renderStepSlide(context, CreateRecipeStorage.getStep(itemIndex), itemIndex),
    );
  }

  Widget _renderStepSlide(BuildContext context, RecipeStep.Step step, int itemIndex) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, bottom: 16.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 4.0),
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
                _renderStepPhoto(context, itemIndex),
                //new Separator(width: 64.0, heigth: 1.0, color: Colors.cyan),
                _renderStepDescription(step, itemIndex)
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

  Widget _renderStepPhoto(BuildContext context, int itemIndex){
    return Container(
      height: 248,
      child: Stack(
        children: <Widget>[
          _renderBackgroundImage(itemIndex),
          _renderBackgroundOpacity(),
          _renderCameraButton(itemIndex)
        ],
      ),
    );
  }

  Widget _renderCameraButton(int itemIndex){
    return Center(
      child: Material(
        type: MaterialType.transparency,
        color: Colors.transparent,
        child: IconButton(
          icon: Icon(Icons.camera_alt),
          color: Colors.white,
          iconSize: 64.0,
          tooltip: "Pick cover Image",
          onPressed: () { getImage(itemIndex); },
        ),
      ),
    );
  }

  Widget _renderBackgroundImage(int itemIndex) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: CreateRecipeStorage.getStepImage(itemIndex) == null ?
        Image.asset(
          "assets/images/food_pattern.png",
          fit: BoxFit.cover,
        ) :
        Image.file(
          CreateRecipeStorage.getStepImage(itemIndex),
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

  Widget _renderStepDescription(RecipeStep.Step step, int itemIndex){
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            "Description",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24.0,
              fontFamily: 'Muli',
            ),
            textAlign: TextAlign.center,
          ),
        ),
        new Separator(width: 64.0, heigth: 1.0, color: Colors.cyan),
        TextField(
          controller: TextEditingController(text: CreateRecipeStorage.getStep(itemIndex).description),
          keyboardType: TextInputType.multiline,
          maxLines: null,
          maxLength: 1000,
          decoration: InputDecoration(
            hintText: "Write here!!"
          ),
          onChanged: (value){
            CreateRecipeStorage.getStep(itemIndex).description = value;
          },
        ),
      ],
    );
  }

  void _createNewStep() {

    var nextStep = CreateRecipeStorage.getSteps().length + 1;

    RecipeStep.Step newStep = new RecipeStep.Step(0, "Step $nextStep", "", "DEFAULT", stepId: 1);

    CreateRecipeStorage.setStep(newStep);

    setState(() {
      _pageController.animateToPage(
          nextStep,
          duration: Duration(milliseconds: 500),
          curve: Curves.linear);
    });

  }

}

