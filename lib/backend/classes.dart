
class User {
  static final id = "id";
  static final name = "name";
  static final isActive = "isActive";
  static final groupList = "groupList";
  static final postsList = "postsList";
  static final bioRef = "bioRef";
}

class Group {
  static final id = "id";
  static final userList = "userList";

  static void addUser(Map<String, dynamic> entry, String userId) {
    entry[Group.userList].add(userId);
  }

}

