import 'dart:async';
import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';


final googleSignIn = new GoogleSignIn();
final auth = FirebaseAuth.instance;
String currentUserEmail;
final analytics = new FirebaseAnalytics();


Future<Null> ensureLoggedIn() async {


  GoogleSignInAccount signedInUser = googleSignIn.currentUser;
  print('ensuring logged in');
  /// try signing in
  signedInUser = await googleSignIn.signInSilently();
  signedInUser = await googleSignIn.signIn();
  print(signedInUser);
  analytics.logLogin();


  currentUserEmail = signedInUser.email;

  if (await auth.currentUser() == null) {
    GoogleSignInAuthentication googleAuth =
    await signedInUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    await auth.signInWithCredential(credential);
  }
}

Future signOut() async {
  await auth.signOut();
  googleSignIn.signOut();
}

