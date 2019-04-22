import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_cookbook/utils/separator.dart';

class ImagePickerAndCropper{

  int option;

  void showDialog(BuildContext context, void Function(int) callback){
    _showModalBottomSheet(context, callback);
  }

  void _showModalBottomSheet(BuildContext context, void Function(int) callback) {
    showModalBottomSheet<void>(context: context, builder: (BuildContext context) {
      return Container(
        child: Padding(
            padding: const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 32.0, top: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Choose source",
                  style: TextStyle(
                      fontSize: 20
                  ),
                ),
                Center(child: new Separator(width: 64.0, heigth: 1.0, color: Colors.cyan,)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.camera,
                            size: 32,
                          ),
                          onPressed: (){
                            option = 1;
                            callback(option);
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          "Camera",
                          style: TextStyle(
                              fontSize: 18
                          ),
                        )
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.photo_library,
                            size: 32,
                          ),
                          onPressed: (){
                            option = 2;
                            callback(option);
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          "Gallery",
                          style: TextStyle(
                              fontSize: 18
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            )
        ),
      );
    });
  }

  Future<File> getImageFromCamera() async {

    File futureImage = await ImagePicker.pickImage(source: ImageSource.camera).then((pickedImage)=>(
        _cropImage(pickedImage)
    ));
    return futureImage;
  }

  Future<File> getImageFromGallery() async {
    File futureImage = await ImagePicker.pickImage(source: ImageSource.gallery).then((pickedImage)=>(
        _cropImage(pickedImage)
    ));
    return futureImage;
  }

  Future<File> _cropImage(File pickedImage){
    return ImageCropper.cropImage(
      sourcePath: pickedImage.path,
      ratioX: 1.0,
      ratioY: 1.0,
      maxWidth: 512,
      maxHeight: 512,
    );
  }

}