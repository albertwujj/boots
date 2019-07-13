import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:boots/backend/users.dart';
import 'package:boots/backend/classes.dart';
import 'package:boots/auth.dart';


Future<String> createGroup({List<String> userHandles}) async {
  Map<String, dynamic> entry = {
    GroupKeys.userList: userHandles,
  };
  DocumentReference groupRef = await Firestore.instance.collection("Groups").add(entry);
  return groupRef.documentID;
}


Future<DocumentSnapshot> findDMGroup({List<String> groupsList, String handle1, String handle2}) async {
  for (String groupId in groupsList) {
    DocumentReference groupRef = Firestore.instance.collection("Groups").document(groupId);
    DocumentSnapshot groupSnap = await groupRef.get();
    Map<String, dynamic> groupEntry = groupSnap.data;
    List<dynamic> groupMembers = groupEntry[GroupKeys.userList];
    if (groupMembers.length == 2 && groupMembers.contains(handle1) && groupMembers.contains(handle2)) {
      return groupSnap;
    }
  }
  return null;
}

Future<DocumentSnapshot> findDMGroupFriend({String friendHandle}) async {
  UserEntry friendEntry = UserEntry.fromDocSnap((await findUserSnaps(handles: [friendHandle]))[0]);
  UserEntry signedInEntry = await BootsAuth.instance.getSignedInEntry();
  String signedInHandle = signedInEntry.handle;
  List<String> friendGroupsList = friendEntry.groupsList;
  return findDMGroup(groupsList: friendGroupsList, handle1: signedInHandle, handle2: friendHandle);

}


Future<DocumentSnapshot> findDMGroupSelf({String friendHandle}) async {
  UserEntry signedInEntry = await BootsAuth.instance.getSignedInEntry();
  String signedInHandle = signedInEntry.handle;
  List<String> signedInGroupsList = signedInEntry.groupsList;
  return findDMGroup(groupsList: signedInGroupsList, handle1: signedInHandle, handle2: friendHandle);
}
