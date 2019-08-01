import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:boots/auth.dart';


Widget circleProfile({String pictureUrl, double radius: 50.0}) {

  ImageProvider image = pictureUrl == null ?
    AssetImage('assets/default_profile.jpg') :
    NetworkImage(pictureUrl);

  return CircleAvatar(
    radius: radius,
    backgroundImage: image,
  );
}

Widget fileCircleProfile({File file, double radius: 50.0}) {
  ImageProvider image = file == null ?
    AssetImage('assets/default_profile.jpg') :
    FileImage(file);

  return CircleAvatar(
    radius: radius,
    backgroundImage: image,
  );
}

