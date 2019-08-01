import 'dart:math';
import 'package:flutter/widgets.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:boots/auth.dart';
import 'package:boots/backend/classes.dart';
import 'package:boots/posts/insta_post.dart';
import 'package:boots/backend/users.dart';

Widget postsWidgetFromEntry(dynamic postEntry) {
  Widget ret = InstaPost(
    postBody: postEntry.body ?? "",
    postPictureUrl: postEntry.dpUrl,
  );
  return ret;
}

Future<List<dynamic>> toPostEntriesList(List<String> postIds) async {
  List posts = [];
  for (String postId in postIds) {
    DocumentReference postRef = Firestore.instance.collection('Posts').document(postId);
    DocumentSnapshot postSnap = await postRef.get();
    PostEntry postEntry = PostEntry.fromDocSnap(postSnap);
    posts.add(postEntry);
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
  print('requesting post from friends $friendHandles');
  List<DocumentSnapshot> friendSnaps = await findUserSnaps(handles: friendHandles);
  List<UserEntry> friendEntries = friendSnaps.map((docSnap) => UserEntry.fromDocSnap(docSnap)).toList();
  List<String> postIds = [];
  for (UserEntry friendEntry in friendEntries) {
    postIds.addAll(friendEntry.postsList);
  }
  List<dynamic> posts = await toPostEntriesList(signedInEntry.postsList);
  return posts.sublist(page*pageSize + 0, min(page*pageSize + pageSize, posts.length));
}


