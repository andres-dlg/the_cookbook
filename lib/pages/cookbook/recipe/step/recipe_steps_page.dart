import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:the_cookbook/localization/app_translations.dart';
import 'package:the_cookbook/models/recipe.dart';
import 'package:the_cookbook/models/step.dart' as RecipeStep;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:the_cookbook/pages/cookbook/recipe/step/step_presenter.dart';
import 'package:the_cookbook/utils/separator.dart';

// ignore: must_be_immutable
class RecipeStepsPage extends StatefulWidget  {

  Recipe recipe;

  RecipeStepsPage({this.recipe});

  @override
  _RecipeStepsPageState createState() => _RecipeStepsPageState();
}

class _RecipeStepsPageState extends State<RecipeStepsPage> implements StepContract{

  StepPresenter recipePresenter;

  @override
  void initState() {
    recipePresenter = new StepPresenter(this);
    recipePresenter.getSteps(widget.recipe.cookbookId, widget.recipe.recipeId).then((stepsList){
      widget.recipe.steps = stepsList;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          body: Stack(
            children: <Widget>[
              _renderBody(context),
              _renderBackButton(context)
            ],
          )
      ), onWillPop: () {
      Navigator.pop(context);
      //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    },
    );
  }

  Widget _renderBody(BuildContext context) {
    if(widget.recipe.steps!=null && widget.recipe.steps.length>0){
      return Container(
        decoration: new BoxDecoration(
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
        child: _renderCarousel(context),
      );
    }else{
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: new BoxDecoration(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                Icons.local_pizza,
              color: Colors.white,
              size: 128,
            ),
            Text(
              AppTranslations.of(context).text("key_recipe_no_step"),
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Muli',
                color: Colors.white,
              ),
            ),
          ]
        ),
      );
    }
  }

  Widget _renderBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0, left: 8.0),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 0.3),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }


  Widget _renderCarousel(BuildContext context) {
    return CarouselSlider(
      height: MediaQuery.of(context).size.height,
      aspectRatio: 16/9,
      viewportFraction: .925,
      enlargeCenterPage: true,
      items: widget.recipe.steps.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return _renderStepSlide(context, i);
          },
        );
      }).toList(),
    );
  }


  Widget _renderStepSlide(BuildContext context, RecipeStep.Step step) {
    return Padding(
      padding: const EdgeInsets.only(top: 36.0, bottom: 16.0),
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
                _renderStepPhoto(context, step),
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
      "${AppTranslations.of(context).text("key_recipe_step")} ${step.title}",
      style: TextStyle(
        color: Colors.black,
        fontSize: 24.0,
        fontFamily: 'Muli',
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _renderStepPhoto(BuildContext context, RecipeStep.Step step){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 248,
      child: step.photoBase64Encoded == null || step.photoBase64Encoded.trim().isEmpty ?
      Image.asset(
        "assets/images/food_pattern.png",
        fit: BoxFit.cover,
      ) :
      _itemThumnail(step)
    );
  }

  Widget _itemThumnail(RecipeStep.Step step) {
    var thumb;
    if(step.photoBase64Encoded == "DEFAULT"){
      thumb = SizedBox.expand(
          child: Image.asset(
            "assets/images/food_pattern.png",
            fit: BoxFit.cover,
          )
      );
    }else{
      Uint8List _bytesImage;
      _bytesImage = Base64Decoder().convert(step.photoBase64Encoded);
      thumb = SizedBox.expand(
          child: Image.memory(
            _bytesImage,
            fit: BoxFit.cover,
          )
      );
    }
    return thumb;
  }

  Widget _renderStepDescription(RecipeStep.Step step){
    return Text(
        step.description != null && step.description.isNotEmpty ? step.description : AppTranslations.of(context).text("key_recipe_step_no_description"),
        style: TextStyle(
            fontSize: 18.0,
            fontFamily: 'Muli'
        )
    );
  }

  @override
  void screenUpdate() {
    setState(() {});
  }
}
