import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ui/firestore_ui.dart';
import 'package:firestore_ui/animated_firestore_list.dart';

import 'package:boots/auth.dart';
import 'package:boots/messages/message_item.dart';
import 'package:boots/backend/messaging.dart';


var _scaffoldContext;



class ChatScreen extends StatefulWidget {
  CollectionReference messagesCollection;
  String groupName;
  ChatScreen({
    this.messagesCollection,
    this.groupName,
  });
  @override
  ChatScreenState createState() {
    return new ChatScreenState(messagesCollection: this.messagesCollection, groupName: this.groupName);
  }
}

class ChatScreenState extends State<ChatScreen> {
  CollectionReference messagesCollection;
  String groupName;
  ChatScreenState({
    this.messagesCollection,
    this.groupName,
  });

  final TextEditingController _textEditingController =
  new TextEditingController();
  File imageFile;
  bool _isComposingText = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.lightGreen,
          title: new Text(this.groupName),
          elevation:
          Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.exit_to_app), onPressed: () {
                  BootsAuth.instance.signOut();
                  Scaffold
                      .of(_scaffoldContext)
                      .showSnackBar(new SnackBar(content: new Text('User logged out')));
                })
          ],
        ),
        body: new Container(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.end,
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
      query: this.messagesCollection.snapshots(),
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
                      File chosenImage = await ImagePicker.pickImage(source: ImageSource.gallery);
                      setState(() {
                        imageFile = chosenImage;
                        _isComposingText = true;
                      });

                    }),
              ),
              new Flexible(
                child: new TextField(
                  controller: _textEditingController,
                  onChanged: (String messageText) {
                    setState(() {
                      _isComposingText = messageText.length > 0 || imageFile != null;
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
    if (this.imageFile != null) {
      performSendMessage(messagesCollection: this.messagesCollection, messageText: "", imageFile: this.imageFile);
    }
    if (text != null && text != "") {
      performSendMessage(messagesCollection: this.messagesCollection, messageText: text, imageFile: null);
    }
    setState(() {
      _isComposingText = false;
      imageFile = null;
    });
    _textEditingController.clear();
  }
}

