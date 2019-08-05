import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:boots/backend/classes.dart';


class SignInMethods {
  static final String google = 'google';
}

class BootsAuth {

  static final BootsAuth instance = BootsAuth();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final googleLoginHandler = new GoogleSignIn();
  static UserEntry registeringEntry;
  DocumentReference signedInRef;
  DocumentSnapshot signedInSnap;
  UserEntry get signedInEntry {
    return UserEntry.fromDocSnap(signedInSnap);
  }

  Future<String> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    String signInUid = prefs.getString('SignInUid');
    print('isLoggedIn with uid $signInUid');
    return signInUid;
  }

  Future<bool> hasRegisteredBefore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('HasReg') == true;
  }

  Future<void> bootsLogin(String uid) async {
    this.signedInRef = Firestore.instance.collection('Users').document(uid);
    this.signedInSnap = await this.signedInRef.get();
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
    } catch (e) {
      print('Google login exception $e');
    }
    while (googleUser == null) {

    }

    //firebase signin
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );
    FirebaseUser user = await _firebaseAuth.signInWithCredential(credential);
    print('User google signed in, user id: ${user?.uid}');
    await bootsLogin(user.uid);
    return user.uid;
  }

  Future<String> emailLogin({String email, String password}) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    print('User email logged in, user id: ${user?.uid}');
    await bootsLogin(user.uid);
    return user.uid;
  }

  Future<String> emailRegister({String email, String password}) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    print('User email registered, user id: ${user?.uid}');
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
