import 'dart:math';
import 'package:flutter/widgets.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:boots/auth.dart';
import 'package:boots/backend/users.dart';
import 'package:boots/posts/post_widget.dart';


Widget postsWidgetFromEntry(DocumentReference postRef) {
  Widget ret = InstaPost(
    postRef: postRef,
  );
  return ret;
}


Future<List<dynamic>> toPostEntriesList(List<String> postIds) async {
  List posts = [];
  for (String postId in postIds) {
    DocumentReference postRef = Firestore.instance.collection('Posts').document(postId);
    posts.add(postRef);
  }
  return posts;
}


Future<List<dynamic>> postsPageRequest ({int page, int pageSize}) async {
  DocumentReference signedInRef = BootsAuth.instance.signedInRef;
  DocumentSnapshot signedInSnap = await signedInRef.get();
  if (!signedInSnap.exists) {
    print('postsPageRequest - signedInRef does not have entry');
    return [];
  }
  UserEntry signedInEntry = UserEntry.fromDocSnap(signedInSnap);
  List<String> friendHandles = signedInEntry.followingList;
  print('requesting post from old.friends $friendHandles');
  List<DocumentSnapshot> friendSnaps = await Users.findUserSnaps(handles: friendHandles);
  List<UserEntry> friendEntries = friendSnaps.map((docSnap) => UserEntry.fromDocSnap(docSnap)).toList();
  List<String> postIds = [];
  for (UserEntry friendEntry in friendEntries) {
    postIds.addAll(friendEntry.postsList);
  }
  List<dynamic> posts = await toPostEntriesList(signedInEntry.postsList);
  return posts.sublist(page*pageSize + 0, min(page*pageSize + pageSize, posts.length));
}


