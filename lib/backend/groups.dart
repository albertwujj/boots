import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:boots/backend/classes.dart';
import 'package:boots/backend/auth.dart';


void createGroup(List<String> userIds) {
  Map<String, dynamic> entry = {
    Group.userList: userIds,
  };
  Firestore.instance.collection("Groups").add(entry);
}

