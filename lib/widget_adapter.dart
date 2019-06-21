import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:boots/database_helper.dart';
import 'package:boots/instaUI/insta_list.dart';


final dbHelper = DatabaseHelper.instance;

Widget widgetAdapter (Map<String, dynamic> t) {
  var picture_bytes = t[DatabaseHelper.postPicture];
  Image picture = picture_bytes == null ? null: Image.memory(picture_bytes);

  Widget ret = InstaList(
    postBody: t[DatabaseHelper.postBody],
    postPicture: picture,
  );
  return ret;
}


