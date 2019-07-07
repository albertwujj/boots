import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:boots/backend/classes.dart';
import 'package:boots/account/auth.dart';


void createUser(String name) {
  Map<String, dynamic> entry = {
    UserKeys.handle: name,
    UserKeys.groupsList: <List<String>>[],
    UserKeys.postsList: <List<String>>[],
  };
  Firestore.instance.collection("Users").add(entry);
}


Map<String, dynamic> getNewUserEntry({String name, String handle}) {
  return {
    UserKeys.name: name,
    UserKeys.handle: handle,
    UserKeys.requesters: <String>['fuck'],
    UserKeys.friendsList: <String>[],
    UserKeys.groupsList: <String>[],
    UserKeys.postsList: <String>[],
    UserKeys.pictureUrl: null,
  };
}

Future<List<DocumentSnapshot>> findUserSnaps({List<String> handles}) async {
  CollectionReference users = Firestore.instance.collection("Users");
  List<DocumentSnapshot> docs = (await users.getDocuments()).documents;
  List<DocumentSnapshot> matching = docs.where((DocumentSnapshot doc) => handles.contains(doc[UserKeys.handle])).toList();
  return matching;
}


Future<DocumentReference> findDMGroup({String friendHandle}) async {
  UserEntry signedInEntry = await BootsAuth.instance.getSignedInEntry();
  String signedInHandle = signedInEntry.handle;
  List<String> groupsList = signedInEntry.groupsList;

  for (String groupId in groupsList) {
    DocumentReference groupRef = Firestore.instance.collection("Groups").document(groupId);
    DocumentSnapshot groupSnap = await groupRef.get();
    Map<String, dynamic> groupEntry = groupSnap.data;
    List<dynamic> groupMembers = groupEntry[GroupKeys.userList];
    if (groupMembers.length == 2 && groupMembers.contains(friendHandle) && groupMembers.contains(signedInHandle)) {
      return groupRef;
    }
  }
  print('COULD NOT FIND DM GROUP FOR SIGNED IN $signedInHandle AND FRIEND $friendHandle !!!');
  return null;
}


