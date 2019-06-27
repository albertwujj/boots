import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:boots/backend/auth.dart';


final analytics = new FirebaseAnalytics();
var currentUserEmail;


void performSendMessage({String groupId, String messageText, File imageFile}) async {
  await ensureLoggedIn();
  CollectionReference messages_collection = Firestore.instance.collection("groups").document(groupId).collection("messages");
  if (imageFile == null) {
    sendMessage(messages_collection: messages_collection, messageText: messageText, imageUrl: null);
  } else {
    String imageUrl = await uploadImage(imageFile);
    sendMessage(messages_collection: messages_collection, messageText: messageText, imageUrl: imageUrl);
  }
}

void sendMessage({CollectionReference messages_collection, String messageText, String imageUrl}) {
  messages_collection.add({
    'text': messageText,
    'email': googleSignIn.currentUser.email,
    'imageUrl': imageUrl,
    'senderName': googleSignIn.currentUser.displayName,
    'senderPhotoUrl': googleSignIn.currentUser.photoUrl,
  });

  analytics.logEvent(name: 'send_message');
}

Stream<QuerySnapshot> messagesList({String groupId}) {
  CollectionReference messages_collection = Firestore.instance.collection("groups").document(groupId).collection("messages");
  return messages_collection.snapshots();
}

Future<String> uploadImage(File imageFile) async {
  await ensureLoggedIn();
  int timestamp = new DateTime.now().millisecondsSinceEpoch;
  StorageReference storageReference = FirebaseStorage
      .instance
      .ref()
      .child("img_" + timestamp.toString() + ".jpg");
  StorageUploadTask uploadTask =
  storageReference.putFile(imageFile);
  StorageTaskSnapshot initialRef = await uploadTask.onComplete;
  String downloadUrl = await initialRef.ref.getDownloadURL();
  return downloadUrl;
}
