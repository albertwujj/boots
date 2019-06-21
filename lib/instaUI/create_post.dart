import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:boots/database_helper.dart';


DatabaseHelper dbhelper = DatabaseHelper.instance;

class CreatePost extends StatelessWidget {
  File picture;
  BuildContext context;
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Stack(children: <Widget>[
          Column(mainAxisAlignment:MainAxisAlignment.start, children: <Widget>[
            SizedBox(height: 100),
            FlatButton(
            color: Colors.green,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.blueAccent,
              onPressed: _optionsDialogBox,
              child: Icon(Icons.blur_circular, size: 100,),
            ),
            SizedBox(height: 60),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Body',),
              maxLines: 5,
              controller: this.textController,
            )
          ],
        ),
       Align(alignment: Alignment.bottomCenter,
            child: Padding(padding: EdgeInsets.only(bottom: 20),
              child: FlatButton(
                color: Colors.lightGreen,
                child: Text(
                  'Make post',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: submitPost,
              )
            )
        ),
      ]
    );
  }

  void submitPost() async {
    String body = textController.text;
    File picture = this.picture;
    List<int> picture_bytes;
    picture_bytes = picture == null ? null: await picture.readAsBytes();

    Map<String, dynamic> post_entry = new Map<String, dynamic>();
    post_entry[DatabaseHelper.postBody] = body;
    post_entry[DatabaseHelper.postPicture] = picture_bytes;
    dbhelper.insert(post_entry);
  }

  void openCamera() async{
    this.picture = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
  }

  void openGallery() async{
    this.picture = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
  }


  Future<void> _optionsDialogBox() {
    return showDialog(context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                GestureDetector(
                  child: new Text('Take a picture'),
                  onTap: openCamera,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                  child: new Text('Select from gallery'),
                  onTap: openGallery,
                ),
              ],
            ),
          ),
        );
      }
    );
  }

}

