import 'package:cloud_firestore/cloud_firestore.dart';

class UserKeys {
  static final name = "name";
  static final handle = "handle";
  static final requesters = "requesters";
  static final friendsList = "friendsList";
  static final groupsList = "groupList";
  static final postsList = "postsList";
  static final pictureUrl = "pictureUrl";

}


class UserEntry {
  final String name;
  final String handle;
  final List<String> requesters;
  final List<String> friendsList;
  final List<String> groupsList;
  final List<String> postsList;
  final String pictureUrl;

  const UserEntry(
      {this.name,
        this.handle,
        this.requesters,
        this.friendsList,
        this.groupsList,
        this.postsList,
        this.pictureUrl,
      });

  Map<String, dynamic> toDict() {
    return {
      UserKeys.name: this.name,
      UserKeys.handle: this.handle,
      UserKeys.requesters: this.requesters,
      UserKeys.friendsList: this.friendsList,
      UserKeys.groupsList: this.groupsList,
      UserKeys.postsList: this.postsList,
      UserKeys.pictureUrl: this.pictureUrl,
    };
  }
  factory UserEntry.fromDocSnap(DocumentSnapshot docSnap) {
    Map<String, dynamic> document = docSnap.data;
    return UserEntry(
      name: document[UserKeys.name],
      handle: document[UserKeys.handle],
      requesters: document[UserKeys.requesters].cast<String>(),
      friendsList: document[UserKeys.friendsList].cast<String>(),
      groupsList: document[UserKeys.groupsList].cast<String>(),
      postsList: document[UserKeys.postsList].cast<String>(),
      pictureUrl: document[UserKeys.pictureUrl],
    );
  }
}


class GroupKeys {
  static final id = "id";
  static final userList = "userList";
  static final messages = "messages";

  static void addUser(Map<String, dynamic> entry, String userId) {
    entry[GroupKeys.userList].add(userId);
  }
}

class PostKeys {
  static final pictureUrl = "picture";
  static final body = "body";
  static final likes = "likes";
}

class PostEntry {
  final String pictureUrl;
  final String body;
  final int likes;

  PostEntry({
    this.pictureUrl,
    this.body,
    this.likes,
  });

  factory PostEntry.fromDocSnap(DocumentSnapshot docSnap) {
    Map<String, dynamic> document = docSnap.data;
    return PostEntry(
      pictureUrl: document[PostKeys.pictureUrl],
      body: document[PostKeys.body],
      likes: document[PostKeys.likes],
    );
  }
  Map<String, dynamic> toDict() {
    return {
      PostKeys.pictureUrl: this.pictureUrl,
      PostKeys.body: this.body,
      PostKeys.likes: this.likes,
    };
  }
}
