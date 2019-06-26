import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ui/firestore_ui.dart';
import 'package:firestore_ui/animated_firestore_list.dart';

import 'package:boots/messaging/message_item.dart';
import 'package:boots/backend/messaging.dart';
import 'package:boots/backend/auth.dart';


var _scaffoldContext;

class ChatScreen extends StatefulWidget {
  String groupId;
  ChatScreen({
    this.groupId
  });
  @override
  ChatScreenState createState() {
    return new ChatScreenState(groupId: this.groupId);
  }
}

class ChatScreenState extends State<ChatScreen> {
  String groupId;
  ChatScreenState({
    this.groupId;
  });

  final TextEditingController _textEditingController =
  new TextEditingController();
  File imageFile;
  bool _isComposingText = false;
  bool get _isComposingMessage {
    return (this.imageFile != null || _isComposingText);
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.lightGreen,
          title: new Text("Missing Person 1"),
          elevation:
          Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.exit_to_app), onPressed: () {
                  signOut();
                  Scaffold
                      .of(_scaffoldContext)
                      .showSnackBar(new SnackBar(content: new Text('User logged out')));
                })
          ],
        ),
        body: new Container(
          child: new Column(
            children: <Widget>[
              new Flexible(
                child: messagesDisplay()
              ),
              new Divider(height: 1.0),
              new Container(
                decoration:
                new BoxDecoration(color: Theme.of(context).cardColor),
                child: _buildTextComposer(),
              ),
              new Builder(builder: (BuildContext context) {
                _scaffoldContext = context;
                return new Container(width: 0.0, height: 0.0);
              })
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? new BoxDecoration(
              border: new Border(
                  top: new BorderSide(
                    color: Colors.grey[200],
                  )))
              : null,
        ));
  }

  Widget messagesDisplay() {
    return FirestoreAnimatedList(
      query: messagesList(),
      padding: const EdgeInsets.all(8.0),
      reverse: false,
      //comparing timestamp of messages to check which one would appear first
      itemBuilder: (_, DocumentSnapshot messageSnapshot,
          Animation<double> animation, int index) {
        return new ChatMessageListItem(
          messageSnapshot: messageSnapshot,
          animation: animation,
        );
      },
    );
  }

  CupertinoButton getIOSSendButton() {
    return new CupertinoButton(
      child: new Text("Send"),
      onPressed: _isComposingText
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
    );
  }

  IconButton getDefaultSendButton() {
    return new IconButton(
      icon: new Icon(Icons.send),
      onPressed: _isComposingText
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(
          color: _isComposingText
              ? Theme.of(context).accentColor
              : Theme.of(context).disabledColor,
        ),
        child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            children: <Widget>[
              new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: new IconButton(
                    icon: new Icon(
                      Icons.photo_camera,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: () async{
                      this.imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
                    }),
              ),
              new Flexible(
                child: new TextField(
                  controller: _textEditingController,
                  onChanged: (String messageText) {
                    setState(() {
                      _isComposingText = messageText.length > 0;
                    });
                  },
                  onSubmitted: _textMessageSubmitted,
                  decoration:
                  new InputDecoration.collapsed(hintText: "Send a message"),
                ),
              ),
              new Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? getIOSSendButton()
                    : getDefaultSendButton(),
              ),
            ],
          ),
        ));
  }

  Future<Null> _textMessageSubmitted(String text) async {
    _textEditingController.clear();

    setState(() {
      _isComposingText = false;
    });

    if (this.imageFile != null) {
      performSendMessage(messageText: "", imageFile: this.imageFile);
    }
    if (text != null && text != "") {
      performSendMessage(messageText: text, imageFile: null);
    }
    this.imageFile = null;
  }
}

