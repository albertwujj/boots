import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import 'package:boots/friends/friend_row.dart';
import 'package:boots/friends/search_handle.dart';
import 'package:boots/account/signedin.dart';
import 'package:boots/loading_list.dart';
import 'package:boots/backend/classes.dart';
import 'package:boots/backend/users.dart';


class FriendsListBloc extends StatesRebuilder {
  Future<List<Map<String, dynamic>>> getFriendsEntries() async {
    Map<String, dynamic> entry = await getSignedInEntry();
    List<String> friendHandles = entry[User.friendsList];
    List<DocumentSnapshot> friendsSnaps = await findUserSnaps(friendHandles);
    friendsSnaps.sort((a, b) => a[User.handle].compareTo(b[User.handle]));
    return friendsSnaps.map((DocumentSnapshot docsnap) => docsnap.data);
  }
}


class FriendsScaffold extends StatelessWidget {

  final bloc = FriendsListBloc();

  @override
  Widget build(BuildContext context) {

    Widget widgetFromEntry(Map<String, dynamic> entry) {
      return FriendRow(
          friendName: entry[User.name],
          friendPictureUrl: entry[User.pictureUrl],
          groupId: entry[FriendEntry.groupId],
        );
    }

    return Stack(children: <Widget>[
      Align(alignment: Alignment.center,
          child: LoadingListView(
            pageRequest: this.bloc.getFriendsEntries,
            widgetFromEntry: widgetFromEntry,
          ),
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
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(),
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
