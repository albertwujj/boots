import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:boots/posts/insta_post.dart';
import 'package:boots/database_helper.dart';
import 'package:boots/main.dart';



Widget postsWidgetAdapterOld (Map<String, dynamic> t) {
  String pictureUrl = t[DatabaseHelper.postPicture];
  Widget ret = InstaPost(
    postBody: t[DatabaseHelper.postBody] ?? "",
    postPictureUrl: pictureUrl,
  );
  return ret;
}


Future<List<Map<String, dynamic>>> pageRequest (DatabaseTable table, int page, int pageSize) async {
  List<Map<String, dynamic>> rows = await DatabaseHelper.queryAllRows(table);
  return rows.sublist(0, min(pageSize, rows.length));
}

class LoadingListViewOld extends StatefulWidget {

  DatabaseTable table;

  /// The number of elements requested for each page
  final int pageSize;

  /// The number of "left over" elements in list which
  /// will trigger loading the next page
  final int pageThreshold;

  /// [PageView.reverse]
  final bool reverse;

  LoadingListViewOld( {
    this.table,
    this.pageSize: 50,
    this.pageThreshold:10,
    this.reverse: false,
  });

  @override
  State<StatefulWidget> createState() {
    return new _LoadingListViewOldState(table: this.table);
  }
}

class _LoadingListViewOldState extends State<LoadingListViewOld> {

  /// Contains all fetched elements ready to display!
  List<Map<String, dynamic>> objects = [];
  /// A Future returned by loadNext() if there
  /// is currently a request running
  /// or null, if no request is performed.
  Future request;
  var table;
  var widgetAdapter;

  _LoadingListViewOldState({DatabaseTable table}) {
    this.table = table;
    switch (this.table) {
      case DatabaseTable.posts:
        this.widgetAdapter = postsWidgetAdapterOld;
        break;
      case DatabaseTable.friends:
        this.widgetAdapter = postsWidgetAdapterOld;
        break;
    }
  }

  @override
  initState() {
    super.initState();
    this.lockedLoadNext();
  }

  Widget itemBuilder(BuildContext context, int index) {

    /// here we go: Once we are entering the threshold zone, the loadLockedNext()
    /// is triggered.
    if (index + widget.pageThreshold > objects.length) {
      lockedLoadNext();
    }


    return this.widgetAdapter(this.objects[index]);
  }

  @override
  Widget build(BuildContext context) {
    ListView listView = new ListView.builder(
        itemBuilder: itemBuilder,
        itemCount: objects.length,
        reverse: widget.reverse
    );
    return new RefreshIndicator(
        onRefresh: onRefresh,
        child: listView
    );

  }
  Future onRefresh() async {
    print('refresh');
    this.request?.timeout(const Duration());
    List<Map<String, dynamic>> fetched = await pageRequest(this.table, 0, widget.pageSize);
    setState(() {
      this.objects = fetched;
      print(this.objects.length);
    });

    return true;
  }

  Future loadNext() async {
    int page = (objects.length / widget.pageSize).floor();
    List<Map<String, dynamic>> fetched = await pageRequest(this.table, page, widget.pageSize);

    if(mounted) {
      this.setState(() {
        objects.addAll(fetched);
      });
    }
  }

  void lockedLoadNext() {
    if (this.request == null) {

      this.request = loadNext().then((x) {
        this.request = null;
      });
    }
  }
}