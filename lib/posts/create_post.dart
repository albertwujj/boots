import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:boots/backend/classes.dart';
import 'package:boots/auth.dart';
import 'package:boots/database_helper.dart';
import 'package:boots/select_image.dart';
import 'package:boots/backend/storage.dart';

class NewPostPicture {
  static File picture;
}

class CreatePost extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreatePostState();
  }
}

class CreatePostState extends State<CreatePost> {

  var changePage;
  CreatePostState({this.changePage});
  BuildContext context;
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(body: new GestureDetector(
      onTap: () { print('Tapped out of field'); FocusScope.of(context).requestFocus(new FocusNode()); },
      child: Stack(children: <Widget>[
        Column(mainAxisAlignment:MainAxisAlignment.start, children: <Widget>[
          SizedBox(height: 100),
          FlatButton(
            color: Colors.white,
            textColor: Colors.green,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.black,
            padding: EdgeInsets.all(8.0),
            splashColor: Colors.blueAccent,
            onPressed: () => optionsDialogBox(context),
            child: Icon(Icons.picture_in_picture, size: 140,),
          ),

          SizedBox(height: 60),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Body',),
            maxLines: 5,
            textInputAction: TextInputAction.done,
            onSubmitted: (String _) { FocusScope.of(context).requestFocus(new FocusNode()); },
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
      )
      )
    );
  }

  void submitPost() async {
    String body = textController.text;
    File picture = NewPostPicture.picture;
    String pictureUrl = picture == null ? null : await uploadImage(picture);
    PostEntry postEntry = PostEntry(pictureUrl: pictureUrl, body: body, likes: 0);
    DocumentReference postRef = await Firestore.instance.collection('Posts').add(postEntry.toDict());
    BootsAuth.instance.signedInRef.updateData({
      UserKeys.postsList: (BootsAuth.instance.signedInSnap)[UserKeys.postsList] + [postRef.documentID],
    });
    BootsAuth.instance.signedInSnap = await BootsAuth.instance.signedInRef.get();
    this.changePage(0);
  }
}

