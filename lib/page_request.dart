import 'dart:async';
import 'dart:math';

import 'package:boots/database_helper.dart';


final dbHelper = DatabaseHelper.instance;

Future<List<Map<String, dynamic>>> pageRequest (int page, int pageSize) async {
  List<Map<String, dynamic>> rows = await dbHelper.queryAllRows();
  return rows.sublist(0, min(pageSize, rows.length));
}


class Post {
  final String title;
  final String text;

  Post({this.title, this.text});
}

