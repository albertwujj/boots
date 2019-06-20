import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:boots/DatabaseHelper.dart';

final dbHelper = DatabaseHelper.instance;

Widget widgetAdapter (Map<String, dynamic> t) {
  Widget ret = ListView(
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    padding: const EdgeInsets.all(8.0),
    children: <Widget>[
      Container(
        height: 50,
        color: Colors.lightGreen[600],
        child: Center(child: Text(t[DatabaseHelper.postTitle])),
      ),
      Container(
        height: 50,
        color: Colors.lightGreen[500],
        child: Center(child: Text(t[DatabaseHelper.postBody])),
      ),
    ],
  );
  return ret;
}

