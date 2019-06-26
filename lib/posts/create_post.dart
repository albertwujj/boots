import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import 'package:boots/database_helper.dart';
import 'package:boots/upload_image.dart';


class CreatePost extends StatefulWidget {
  var changePage;
  CreatePost({this.changePage});

  @override
  State<StatefulWidget> createState() {
    return new _CreatePostState(changePage: this.changePage);
  }
}

class _CreatePostState extends State<CreatePost> {
  BuildContext context;
  final textController = TextEditingController();
  var changePage;
  File picture;

  _CreatePostState({this.changePage});

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
    ));
  }
  void submitPost() async {
    String body = textController.text;
    File picture = DatabaseHelper.currPicture;
    List<int> picture_bytes;
    picture_bytes = picture == null ? null: await picture.readAsBytes();
    Map<String, dynamic> post_entry = new Map<String, dynamic>();
    post_entry[DatabaseHelper.postBody] = body;
    post_entry[DatabaseHelper.postPicture] = picture_bytes;
    DatabaseHelper.insert(DatabaseTable.posts, post_entry);
    this.changePage(0);
  }

}

