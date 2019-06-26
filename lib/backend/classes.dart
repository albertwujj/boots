
class User {
  static final id = "id";
  static final handle = "handle";
  static final googleId = "googleId";
  static final groupList = "groupList";
  static final postsList = "postsList";

  /// TODO
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

