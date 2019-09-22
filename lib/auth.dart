import 'package:boots/common_imports.dart';

import 'package:states_rebuilder/states_rebuilder.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';



class BootsAuth {
  static final BootsAuth instance = BootsAuth();
  static final _firebaseAuth = FirebaseAuth.instance;



}

class UIDSharedPreferences {
  SharedPreferences _sharedPreferences;
  UIDSharedPreferences() {
    SharedPreferences.getInstance().then((sp) {
      _sharedPreferences = sp;
    });
  }

  void UIDexists(){
    if UIDexists
  }

}

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class CreateOrLoginBloc extends StatesRebuilder {
  Future<bool> checkSavedLogin() async {
    ///TODO: Fill out function
    SharedPreferences sharedPreferences = await BootsAuth.getSharedPreferences();

  }

}

class RegisterBloc {

}

class BootsAutsh {


  final googleLoginHandler = new GoogleSignIn.standard();
  DocumentReference signedInRef;
  DocumentSnapshot signedInSnap;

  UserEntry get signedInEntry {
    return UserEntry.fromDocSnap(signedInSnap);
  }
  Future<void> updateSnap() async {
    this.signedInSnap = await this.signedInRef.get();
  }

  Future<bool> attemptSavedSignIn() async {
    final prefs = await SharedPreferences.getInstance();
    String savedUid = prefs.getString('SignInUid');
    if (savedUid == null) {
      return false;
    }
    await bootsLogin(savedUid);
    return true;
  }

  Future<bool> hasRegisteredBefore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('HasReg') == true;
  }

  Future<void> bootsLogin(String uid) async {
    this.signedInRef = Firestore.instance.collection('Users').document(uid);
    await updateSnap();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('SignInUid', uid);
  }

  Future<String> googleSignIn() async {
    print('BootsAuth googleSignIn');
    //google signin
    GoogleSignInAccount googleUser = googleLoginHandler.currentUser;
    try {
      googleUser = await googleLoginHandler.signInSilently();
      print('signinsilently');
      googleUser = await googleLoginHandler.signIn();

      //firebase signin
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      FirebaseUser user = (await _firebaseAuth.signInWithCredential(credential)).user;
      print('User google signed in, user id: ${user?.uid}');
      await bootsLogin(user.uid);
      return user.uid;

    } catch (e) {
      print('Google login exception $e');
    }

  }

  Future<String> emailLogin({String email, String password}) async {
    FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user;
    print('User logged in with email, user id: ${user?.uid}');
    await bootsLogin(user.uid);
    return user.uid;
  }

  Future<String> emailRegister({String email, String password}) async {
    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;
    print('User registered with email, user id: ${user?.uid}');
    await bootsLogin(user.uid);
    return user.uid;
  }

  Future<void> signOut() async {
    print('signing out');
    /// TODO: sign out of all account services
    googleLoginHandler.signOut();
    _firebaseAuth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('SignInUid');
  }
}
