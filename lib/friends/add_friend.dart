import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:boots/backend/classes.dart';
import 'package:boots/account/signedin.dart';

void addFriend(String friendHandle) async {
  Map<String, dynamic> signedInEntry = await getSignedInEntry();
  signedInEntry[User.friendsList].add(friendHandle);
  signedInRef.updateData(signedInEntry);
}