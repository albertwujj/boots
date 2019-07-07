import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:boots/backend/classes.dart';


Future<String> createGroup({List<String> userHandles}) async {
  Map<String, dynamic> entry = {
    GroupKeys.userList: userHandles,
  };
  DocumentReference groupRef = await Firestore.instance.collection("Groups").add(entry);
  return groupRef.documentID;
}


