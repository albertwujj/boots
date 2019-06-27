import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:boots/messages/message_screen.dart';
import 'package:boots/database_helper.dart';
import 'package:boots/backend/classes.dart';


Widget friendsWidgetAdapter (Map<String, dynamic> t) {
  var picture_bytes = t[FriendEntry.friendPicture];

  Widget ret = FriendRow(
    friendName: t[FriendEntry.friendName],
    friendPictureBytes: picture_bytes,
    groupId: t[FriendEntry.groupId];
  );

  return ret;
}

class FriendRow extends StatelessWidget {
  String friendName;
  List<int> friendPictureBytes;
  String groupId;

  FriendRow({String friendName, List<int> friendPictureBytes, String groupId} ) {
    this.friendName = friendName;
    this.friendPictureBytes = friendPictureBytes;
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
              this.friendPictureBytes == null ? new SizedBox(width: 100.0, height: 100.0) : new Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          image: MemoryImage(this.friendPictureBytes),
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
