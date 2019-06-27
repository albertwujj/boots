import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ui/firestore_ui.dart';

import 'package:boots/account/signedin.dart';
import 'package:boots/database_helper.dart';
import 'package:boots/upload_image.dart';
import 'package:boots/backend/classes.dart';


//Database

//UI
class AddFriend extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _AddFriendState();
  }
}

class _AddFriendState extends State<AddFriend> {
  BuildContext context;
  TextEditingController textController = TextEditingController();
  File picture;

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

    Map<String, dynamic> group = {
      Group.userList: <String>[signedInUserId, ]
    };

    groups = Firestore.instance.collection("groups").add()

    Map<String, dynamic> friend_entry = new Map<String, dynamic>();
    friend_entry[FriendEntry.friendName] = name;
    friend_entry[FriendEntry.friendPicture] = picture_bytes;


    friend_entry[FriendEntry.groupId] = ;
    DatabaseHelper.insert(DatabaseTable.friends, friend_entry);
    print('friend added');
    Navigator.pop(this.context);
  }
}