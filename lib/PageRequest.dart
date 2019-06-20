import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:boots/DatabaseHelper.dart';

final dbHelper = DatabaseHelper.instance;

Future<List<Map<String, dynamic>>> pageRequest (int page, int pageSize) async {
  var rows = await dbHelper.queryAllRows();
  return rows.sublist(0, pageSize);
}


class Post {
  final String title;
  final String text;

  Post({this.title, this.text});
}

