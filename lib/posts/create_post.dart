import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import 'package:states_rebuilder/states_rebuilder.dart';

import 'package:boots/backend/classes.dart';
import 'package:boots/database_helper.dart';
import 'package:boots/select_image.dart';


class CreatePost extends StatelessWidget {

  var changePage;
  CreatePost({this.changePage});
  BuildContext context;
  TextEditingController textController = TextEditingController();
  PictureBloc bloc = PictureBloc();

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return BlocProvider(bloc: this.bloc,
        child: Scaffold(body: new GestureDetector(
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
        ))
    );
  }

  void submitPost() async {
    String body = textController.text;
    File picture = this.bloc.picture;
    List<int> picture_bytes;
    picture_bytes = picture == null ? null: await picture.readAsBytes();
    Map<String, dynamic> post_entry = new Map<String, dynamic>();
    post_entry[Post.postBody] = body;
    post_entry[Post.postPicture] = picture_bytes;
    DatabaseHelper.insert(DatabaseTable.posts, post_entry);
    this.changePage(0);
  }
}

