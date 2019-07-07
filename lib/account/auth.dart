import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import 'package:boots/account/create_boots.dart';
import 'package:boots/globals.dart';
import 'package:boots/backend/classes.dart';
import 'package:boots/backend/users.dart';


class SignInMethods {
  static final String google = 'google';
}

class BootsAuth {
  static final BootsAuth instance = BootsAuth();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final googleLoginHandler = new GoogleSignIn();

  DocumentReference signedInRef;
  UserEntry signedInEntry;

  Future<DocumentReference> getSignedInRef() async {
    while (this.signedInRef == null) {
      await attemptSignIn();
    }

    return this.signedInRef;
  }
  Future<UserEntry> getSignedInEntry() async{
    DocumentSnapshot snap = await (await getSignedInRef()).get();
    return UserEntry.fromDocSnap(snap);
  }

  Future<void> bootsLogin(String uid) async {
    print('boots login');
    this.signedInRef = Firestore.instance.collection('Users').document(uid);
    DocumentSnapshot snap = await this.signedInRef.get();
    if (!snap.exists) {
      print('doc ref snap does not exist');
      await bootsRegister(this.signedInRef);
    } else {
      print('doc ref snap exists');
      print(snap.data[UserKeys.handle]);
    }
  }

  void bootsRegister(DocumentReference ref) async {
    print('registering user');
    Completer completer = new Completer();
    void addUser({String name, String handle}) {
      print("adding registering user");
      Map<String, dynamic> entry = getNewUserEntry(name: name, handle: handle);
      ref.setData(entry);
      completer.complete(true);
    }
    print('about to navigator push');
    Navigator.push(baseBuildContext, MaterialPageRoute(builder: (context) => CreateBoots(addUser: addUser,)));
    await completer.future;
  }

  Future<String> googleSignIn() async {
    GoogleSignInAccount googleUser = googleLoginHandler.currentUser;
    print('googleSignIn');

    while (googleUser == null) {
      try {
        googleUser = await googleLoginHandler.signInSilently();
        googleUser = await googleLoginHandler.signIn();
      } catch (e) {
        print('Google login exception $e');
      }
    }

    print('hello');
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );
    FirebaseUser user = await _firebaseAuth.signInWithCredential(credential);
    print('User signed in, user id: ${user?.uid}');
    return user?.uid;
  }

  Future<bool> attemptSignIn() async {
    print('attempting signin');
    final prefs = await SharedPreferences.getInstance();
    String signInUid = prefs.getString('SignInUid');
    print('yo $signInUid');
    while (signInUid == null) {
    signInUid = await googleSignIn();
    }
    await prefs.setString('SignInUid', signInUid);
    await bootsLogin(signInUid);
  }

  Future<String> emailLogin(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return user?.uid;
  }

  Future<String> emailRegister(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return user?.uid;
  }

  Future<String> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user?.uid;
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