import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:boots/main.dart';


class FriendRow extends StatelessWidget {
  String friendName;
  List<int> friendPicture;

  FriendRow({String friendName, List<int> friendPicture} ) {
    this.friendName = friendName;
    this.friendPicture = friendPicture;
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          this.friendPicture == null ? emptyWidget : new Container(
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
              textScaleFactor: 1.5)
        ],
      )
    );
  }
}
