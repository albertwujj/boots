import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:boots/messages/message_screen.dart';
import 'package:boots/database_helper.dart';
import 'package:boots/backend/classes.dart';
import 'package:boots/ui_helpers/pictures.dart';



class FriendRow extends StatelessWidget {
  String friendName;
  String friendPictureUrl;
  String groupId;

  FriendRow({
    this.friendName,
    this.friendPictureUrl,
    this.groupId,
  });

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
              this.friendPictureUrl == null ? SizedBox(height: 100.0, width: 100.0) :
              circleImage(pictureUrl: this.friendPictureUrl, height: 100.0, width: 100.0),

              SizedBox(
                width: 25.0,
              ),
              Text(this.friendName,
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
