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


Future<List<DocumentSnapshot>> findUserSnaps(List<String> handles) async {
  CollectionReference users = Firestore.instance.collection("Users");
  List<DocumentSnapshot> docs = (await users.where(User.handle, isEqualTo: handles).getDocuments()).documents;
  List<DocumentSnapshot> matching = docs.where((DocumentSnapshot doc) => handles.contains(doc.data[User.handle]));
  return matching;
}
