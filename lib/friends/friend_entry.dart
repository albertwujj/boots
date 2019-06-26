import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:boots/main.dart';
import 'package:boots/messaging/message_screen.dart';


class FriendRow extends StatelessWidget {
  String friendName;
  List<int> friendPicture;
  String groupId;

  FriendRow({String friendName, List<int> friendPicture, String groupId} ) {
    this.friendName = friendName;
    this.friendPicture = friendPicture;
    this.groupId = groupId;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatScreen(groupId: this.groupId)),
        );
      },
      child: Column(children: [
        Padding(padding: EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              this.friendPicture == null ? new SizedBox(width: 100.0, height: 100.0) : new Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          image: MemoryImage(this.friendPicture),
                          fit: BoxFit.fill,
                      )
                  )),
              new SizedBox(
                width: 25.0,
              ),
              new Text(this.friendName,
                  textScaleFactor: 1.5),
            ],
          )
        ),
        Divider(),
       ]
      )
    );
  }
}
