import 'package:cloud_firestore/cloud_firestore.dart';


class PostKeys {
  static final pictureUrl = "picture";
  static final body = "body";
  static final likes = "likes";
  static final userRef = "userRef";
}

class PostEntry {
  final String pictureUrl;
  final String body;
  final int likes;
  final DocumentReference userRef;

  PostEntry({
    this.pictureUrl,
    this.body,
    this.likes,
    this.userRef,
  });

  factory PostEntry.fromDocSnap(DocumentSnapshot docSnap) {
    Map<String, dynamic> document = docSnap.data;
    return PostEntry(
      pictureUrl: document[PostKeys.pictureUrl],
      body: document[PostKeys.body],
      likes: document[PostKeys.likes],
      userRef: document[PostKeys.userRef],
    );
  }
  Map<String, dynamic> toDict() {
    return {
      PostKeys.pictureUrl: this.pictureUrl,
      PostKeys.body: this.body,
      PostKeys.likes: this.likes,
      PostKeys.userRef: this.userRef,
    };
  }
}