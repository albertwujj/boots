import 'package:cloud_firestore/cloud_firestore.dart';

class UserKeys {
  static final name = "name";
  static final handle = "handle";
  static final bio = "bio";
  static final dpUrl = "pictureUrl";
  static final requesters = "requesters";
  static final followingList = "followingList";
  static final friendsList = "friendsList";
  static final groupsList = "groupList";
  static final postsList = "postsList";


}


class UserEntry {
  final String name;
  final String handle;
  final String bio;
  final String dpUrl;
  final List<String> requesters;
  final List<String> followingList;
  final List<String> friendsList;
  final List<String> groupsList;
  final List<String> postsList;


  const UserEntry(
      {
        this.name,
        this.handle,
        this.bio,
        this.dpUrl,
        this.requesters,
        this.followingList,
        this.friendsList,
        this.groupsList,
        this.postsList,
      });

  Map<String, dynamic> toDict() {
    return {
      UserKeys.name: this.name,
      UserKeys.handle: this.handle,
      UserKeys.bio: this.bio,
      UserKeys.dpUrl: this.dpUrl,
      UserKeys.requesters: this.requesters,
      UserKeys.followingList: this.followingList,
      UserKeys.friendsList: this.friendsList,
      UserKeys.groupsList: this.groupsList,
      UserKeys.postsList: this.postsList,
    };
  }

  factory UserEntry.fromDocSnap(DocumentSnapshot docSnap) {
    Map<String, dynamic> document = docSnap.data;
    return UserEntry(
      name: document[UserKeys.name],
      handle: document[UserKeys.handle],
      bio: document[UserKeys.bio],
      dpUrl: document[UserKeys.dpUrl],
      requesters: document[UserKeys.requesters].cast<String>(),
      followingList: document[UserKeys.followingList].cast<String>(),
      friendsList: document[UserKeys.friendsList].cast<String>(),
      groupsList: document[UserKeys.groupsList].cast<String>(),
      postsList: document[UserKeys.postsList].cast<String>(),
    );
  }

  factory UserEntry.fromDetails({String name, String handle, String dpUrl, String bio}) {
    return UserEntry(
      name: name,
      handle: handle,
      bio: bio ?? "An enigma",
      dpUrl: dpUrl,
      requesters: <String>[],
      followingList: <String>[],
      friendsList: <String>[],
      groupsList: <String>[],
      postsList: <String>[],
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
