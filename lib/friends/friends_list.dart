import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:boots/loading_list.dart';
import 'package:boots/database_helper.dart';
import 'package:boots/friends/add_friend.dart';


class FriendsScaffold extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Align(alignment: Alignment.center,
          child: LoadingListView(table: DatabaseTable.friends),
      ),
      Padding(padding: EdgeInsets.only(top:10.0, right:3.0),
        child: Column(
          children: [
            Align(alignment: Alignment.topRight,
            child: FlatButton(
              shape: CircleBorder(),
              color: Colors.green,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.blueAccent,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddFriend()),
                );
              },
              child: Icon(Icons.add_circle, size: 50,),
              )
            ),
          ]
          )
        )
      ]
    );
  }

}
