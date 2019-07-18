import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:image_picker/image_picker.dart';

import 'package:boots/database_helper.dart';
import 'package:boots/posts/create_post.dart';

class PictureBloc extends StatesRebuilder {
  File picture;
  void setPicture(File picture) {
    this.picture = picture;
    rebuildStates();
  }
}

void openCamera(BuildContext context) async {
  File picture = await ImagePicker.pickImage(
    source: ImageSource.camera,
  );
  NewPostPicture.picture = picture;
  Navigator.pop(context);
}

void openGallery(BuildContext context) async{

  File picture = await ImagePicker.pickImage(
    source: ImageSource.gallery,
  );
  NewPostPicture.picture = picture;
  Navigator.pop(context);
}

Future<void> optionsDialogBox(BuildContext context) async {
  await showDialog(context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              GestureDetector(
                child: new Text('Take a picture'),
                onTap: () => openCamera(context),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
              ),
              GestureDetector(
                child: new Text('Select from gallery'),
                onTap: () => openGallery(context),
              ),
              ],
              ),
            ),
        );
      }
    );
}

