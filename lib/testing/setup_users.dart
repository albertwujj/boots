import 'package:boots/common_imports.dart';

class TestingSetupUsers {
  static String route;

  static Future<DocumentReference> addDummyUser(String prefix) async {
    String uid;
    try {
      uid = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: '1984$prefix@gmail.com', password: '1984$prefix')).user.uid;
    } catch (e) {
      print(e.code);
      uid = (await FirebaseAuth.instance.createUserWithEmailAndPassword(email: '1984$prefix@gmail.com', password: '1984$prefix')).user.uid;
    }

    String subHandle = '1984${prefix}';
    UserEntry entry = UserEntry.fromDetails(name: '${prefix}missive', handle: subHandle, bio: '${prefix}', location: 'Lagos', dpUrl: null);

    await Firestore.instance.collection('Users').document(uid).setData(entry.toDict());
    return Firestore.instance.collection('Users').document(uid);
  }

  static Future<void> setupEntire() async {
    await TestingSetupUsers.addDummyUser('Sub');
    BootsAuth.instance.signedInRef = await TestingSetupUsers.addDummyUser('Dom');
    BootsAuth.instance.updateSnap();
    TestingSetupUsers.route = 'home';
  }
}