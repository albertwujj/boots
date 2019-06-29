import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:boots/backend/users.dart';


String signedInUserId;
DocumentReference signedInRef;

Future<DocumentSnapshot> getSignedInSnap() async {
  return await signedInRef.get();
}

Future<Map<String, dynamic>> getSignedInEntry() async {
  return (await signedInRef.get()).data;
}