import 'package:boots/common_imports.dart';


class UserKeys {
  static final name = "name";
  static final handle = "handle";
  static final location = "location";
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
  final String location;
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
        this.location,
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
      UserKeys.location: this.location,
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
      location: document[UserKeys.location],
      bio: document[UserKeys.bio],
      dpUrl: document[UserKeys.dpUrl],
      requesters: document[UserKeys.requesters].cast<String>(),
      followingList: document[UserKeys.followingList].cast<String>(),
      friendsList: document[UserKeys.friendsList].cast<String>(),
      groupsList: document[UserKeys.groupsList].cast<String>(),
      postsList: document[UserKeys.postsList].cast<String>(),
    );
  }

  factory UserEntry.fromDetails({String name, String handle, String location, String dpUrl, String bio}) {
    return UserEntry(
      name: name,
      handle: handle,
      location: location,
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

class Users {
  static Future<List<UserEntry>> getAllUsersEntries() async {
    return (await Firestore.instance.collection('Users').getDocuments()).documents.map((snap) => UserEntry.fromDocSnap(snap)).toList();
  }

  static Future<void> addUser({UserEntry userEntry, String uid}) async {
    await Firestore.instance.collection("Users").document(uid).setData(userEntry.toDict());
  }

  static Future<List<DocumentSnapshot>> findUserSnaps({List<String> handles}) async {
    CollectionReference users = Firestore.instance.collection("Users");
    List<DocumentSnapshot> docs = (await users.getDocuments()).documents;
    List<DocumentSnapshot> matching = docs.where((DocumentSnapshot doc) =>
        handles.contains(doc[UserKeys.handle])).toList();
    return matching;
  }
}