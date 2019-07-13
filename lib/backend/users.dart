import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:boots/backend/classes.dart';
import 'package:boots/auth.dart';


void createUser(String name) {
  Map<String, dynamic> entry = {
    UserKeys.handle: name,
    UserKeys.groupsList: <List<String>>[],
    UserKeys.postsList: <List<String>>[],
  };
  Firestore.instance.collection("Users").add(entry);
}


Future<List<DocumentSnapshot>> findUserSnaps({List<String> handles}) async {
  CollectionReference users = Firestore.instance.collection("Users");
  List<DocumentSnapshot> docs = (await users.getDocuments()).documents;
  List<DocumentSnapshot> matching = docs.where((DocumentSnapshot doc) => handles.contains(doc[UserKeys.handle])).toList();
  return matching;
}




