import 'package:boots/common_imports.dart';
import 'package:flutter/cupertino.dart';

import 'package:boots/ui_helpers/pictures.dart';


var currentUserEmail;

class ChatMessageListItem extends StatelessWidget {
  final DocumentSnapshot messageSnapshot;
  final Animation animation;

  ChatMessageListItem({this.messageSnapshot, this.animation});

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor:
      new CurvedAnimation(parent: animation, curve: Curves.decelerate),
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          children: currentUserEmail == messageSnapshot.data['email']
              ? getSentMessageLayout()
              : getReceivedMessageLayout(),
        ),
      ),
    );
  }

  List<Widget> getSentMessageLayout() {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text(messageSnapshot.data['senderName'],
                style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: messageSnapshot.data['imageUrl'] != null
                  ? new Image.network(
                messageSnapshot.data['imageUrl'],
                width: 250.0,
              )
                  : new Text(messageSnapshot.data['text']),
            ),
          ],
        ),
      ),
      new Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
              margin: const EdgeInsets.only(left: 8.0),
              child: circleProfile(pictureUrl: messageSnapshot.data['senderPhotoUrl']),
          )
        ],
      ),
    ];
  }

  List<Widget> getReceivedMessageLayout() {
    return <Widget>[
      new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: const EdgeInsets.only(right: 8.0),
              child: circleProfile(pictureUrl: messageSnapshot.data['senderPhotoUrl']),
          )
        ],
      ),
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(messageSnapshot.data['senderName'],
                style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: messageSnapshot.data['imageUrl'] != null
                  ? new Image.network(
                messageSnapshot.data['imageUrl'],
                width: 250.0,
              )
                  : new Text(messageSnapshot.data['text']),
            ),
          ],
        ),
      ),
    ];
  }
}
