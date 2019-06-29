
class User {
  static final name = "name";
  static final handle = "handle";
  static final googleId = "googleId";
  static final friendsList = "friendsList";
  static final groupList = "groupList";
  static final postsList = "postsList";
  static final pictureUrl = "pictureUrl";

  static final bioRef = "bioRef";
  static final isActive = "isActive";
}

class Group {
  static final id = "id";
  static final userList = "userList";

  static void addUser(Map<String, dynamic> entry, String userId) {
    entry[Group.userList].add(userId);
  }
}

class FriendEntry {
  static final friendName = "friendName";
  static final friendPicture = "friendPicture";
  static final groupId = "groupId";
}

class Post {
  static final postPicture = "postPicture";
  static final postBody = "postBody";
}
