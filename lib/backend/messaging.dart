import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:boots/auth.dart';
import 'package:boots/backend/classes.dart';
import 'package:boots/backend/storage.dart';


final analytics = new FirebaseAnalytics();
var currentUserEmail;


void performSendMessage({CollectionReference messagesCollection, String messageText, File imageFile}) async {


  UserEntry senderEntry = await BootsAuth.instance.getSignedInEntry();

  if (imageFile == null) {
    sendMessage(messagesCollection: messagesCollection, messageText: messageText, imageUrl: null,
    senderEntry: senderEntry);
  } else {
    String imageUrl = await uploadImage(imageFile);
    sendMessage(messagesCollection: messagesCollection, messageText: messageText, imageUrl: imageUrl,
    senderEntry: senderEntry);
  }
}

void sendMessage({CollectionReference messagesCollection, String messageText, String imageUrl,
  UserEntry senderEntry}) {
  messagesCollection.add({
    'text': messageText,
    'email': currentUserEmail,
    'imageUrl': imageUrl,
    'senderName': senderEntry.handle,
    'senderPhotoUrl': senderEntry.pictureUrl,
  });
  analytics.logEvent(name: 'send_message');
}

