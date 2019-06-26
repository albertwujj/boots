import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:boots/backend/classes.dart';


void createUser(String name) {
  Map<String, dynamic> entry = {
    User.handle: name,
    User.groupList: <List<String>>[],
    User.postsList: <List<String>>[],
  };
  Firestore.instance.collection("Users").add(entry);
}

