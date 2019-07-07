import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';


Future<String> uploadImage(File imageFile) async {
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
