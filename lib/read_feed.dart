import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:boots/page_request.dart';
import 'package:boots/widget_adapter.dart';


class LoadingListView extends StatefulWidget {


  /// The number of elements requested for each page
  final int pageSize;

  /// The number of "left over" elements in list which
  /// will trigger loading the next page
  final int pageThreshold;

  /// [PageView.reverse]
  final bool reverse;

  LoadingListView( {
    this.pageSize: 50,
    this.pageThreshold:10,
    this.reverse: false,
  });

  @override
  State<StatefulWidget> createState() {
    return new _LoadingListViewState();
  }
}

class _LoadingListViewState extends State<LoadingListView> {

  /// Contains all fetched elements ready to display!
  List<Map<String, dynamic>> objects = [];
  /// A Future returned by loadNext() if there
  /// is currently a request running
  /// or null, if no request is performed.
  Future request;

  @override
  initState() {
    super.initState();
    this.lockedLoadNext();
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
    List<Map<String, dynamic>> fetched = await pageRequest(0, widget.pageSize);
    setState(() {
      this.objects = fetched;
      print(this.objects.length);
    });

    return true;
  }

  Future loadNext() async {
    int page = (objects.length / widget.pageSize).floor();
    List<Map<String, dynamic>> fetched = await pageRequest(page, widget.pageSize);

    if(mounted) {
      this.setState(() {
        objects.addAll(fetched);
      });
    }
  }

  void lockedLoadNext() {
    print('locked load next');
    if (this.request == null) {
      this.request = loadNext().then((x) {
        this.request = null;
      });
    }
  }

  Widget itemBuilder(BuildContext context, int index) {

    /// here we go: Once we are entering the threshold zone, the loadLockedNext()
    /// is triggered.
    if (index + widget.pageThreshold > objects.length) {
      lockedLoadNext();
    }

    return widgetAdapter != null ? widgetAdapter(objects[index])
        : new Container();
  }
}


