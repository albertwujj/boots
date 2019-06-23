import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import 'package:boots/database_helper.dart';
import 'package:boots/upload_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


DatabaseHelper dbhelper = DatabaseHelper.instance;


class AddFriend extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _AddFriendState();
  }
}

class _AddFriendState extends State<AddFriend> {
  BuildContext context;
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Material(
        child: Stack(children: <Widget>[
          Align(alignment: Alignment.topCenter,
            child: Column(children: <Widget>[
              SizedBox(height: 100),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.blueAccent,
                onPressed: () => optionsDialogBox(context),
                child: Icon(Icons.person_add, size: 100,),
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',),
                maxLines: 2,
                textInputAction: TextInputAction.done,
                onSubmitted: (String _) {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                controller: this.textController,
              )

            ],),
          ),
          Align(alignment: Alignment.bottomCenter,
              child: Padding(padding: EdgeInsets.only(bottom: 20),
                  child: FlatButton(
                    color: Colors.lightGreen,
                    child: Text(
                      'Make post',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: submitFriend,
                  )
              )
          ),
        ]
        )
    );
  }
  void submitFriend() async {
    String name = this.textController.text;
    File picture = DatabaseHelper.currPicture;
    List<int> picture_bytes;
    print(DatabaseHelper.currPicture);
    picture_bytes = picture == null ? null: await picture.readAsBytes();

    Map<String, dynamic> friend_entry = new Map<String, dynamic>();
    friend_entry[DatabaseHelper.postBody] = name;
    friend_entry[DatabaseHelper.postPicture] = picture_bytes;
    dbhelper.insert(DatabaseTable.friends, friend_entry);
    Navigator.pop(this.context);
  }
}