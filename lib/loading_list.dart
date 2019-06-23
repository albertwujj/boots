import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:boots/posts/insta_post.dart';
import 'package:boots/database_helper.dart';
import 'package:boots/main.dart';
import 'package:boots/friends/friend_entry.dart';


Widget postsWidgetAdapter (Map<String, dynamic> t) {
  var picture_bytes = t[DatabaseHelper.postPicture];
  Image picture = picture_bytes == null ? null: Image.memory(picture_bytes);

  Widget ret = InstaPost(
    postBody: t[DatabaseHelper.postBody],
    postPicture: picture,
  );
  return ret;
}


Widget friendsWidgetAdapter (Map<String, dynamic> t) {
  var picture_bytes = t[DatabaseHelper.postPicture];

  Widget ret = FriendRow(
    friendName: t[DatabaseHelper.friendName],
    friendPicture: picture_bytes,
  );

  return ret;
}


class LoadingListView extends StatefulWidget {

  DatabaseTable table;

  /// The number of elements requested for each page
  final int pageSize;

  /// The number of "left over" elements in list which
  /// will trigger loading the next page
  final int pageThreshold;

  /// [PageView.reverse]
  final bool reverse;

  LoadingListView( {
    this.table,
    this.pageSize: 50,
    this.pageThreshold:10,
    this.reverse: false,
  });

  @override
  State<StatefulWidget> createState() {
    return new _LoadingListViewState(table: this.table);
  }
}

class _LoadingListViewState extends State<LoadingListView> {

  /// Contains all fetched elements ready to display!
  List<Map<String, dynamic>> objects = [];
  /// A Future returned by loadNext() if there
  /// is currently a request running
  /// or null, if no request is performed.
  Future request;
  var table;
  var widgetAdapter;

  _LoadingListViewState({DatabaseTable table}) {
    this.table = table;
    switch (this.table) {
      case DatabaseTable.posts:
        this.widgetAdapter = postsWidgetAdapter;
        break;
      case DatabaseTable.friends:
        this.widgetAdapter = friendsWidgetAdapter;
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


