import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:boots/backend/classes.dart';

class LoadingListView extends StatefulWidget {

  final pageRequest;
  final widgetFromEntry;

  /// The number of elements requested for each page
  final int pageSize;
  /// The number of "left over" elements in list which
  /// will trigger loading the next page
  final int pageThreshold;
  /// [PageView.reverse]
  final bool reverse;

  LoadingListView( {
    this.pageRequest,
    this.widgetFromEntry,
    this.pageSize: 50,
    this.pageThreshold:10,
    this.reverse: false,
  });

  @override
  State<StatefulWidget> createState() {
    return new _LoadingListViewState(
        pageRequest: this.pageRequest,
        widgetFromEntry: this.widgetFromEntry,
    );
  }
}

class _LoadingListViewState extends State<LoadingListView> {

  /// Contains all fetched elements ready to display!
  List<dynamic> entries = [];
  /// A Future returned by loadNext() if there
  /// is currently a request running
  /// or null, if no request is performed.
  Future request;
  final pageRequest;
  final widgetFromEntry;

  _LoadingListViewState({this.pageRequest, this.widgetFromEntry});

  @override
  initState() {
    super.initState();
    this.lockedLoadNext();
  }

  Widget itemBuilder(BuildContext context, int index) {

    /// here we go: Once we are entering the threshold zone, the loadLockedNext()
    /// is triggered.
    if (index + widget.pageThreshold > entries.length) {
      lockedLoadNext();
    }

    return widgetFromEntry != null ? widgetFromEntry(entries[index])
        : new Container();
  }

  @override
  Widget build(BuildContext context) {
    ListView listView = new ListView.builder(
        itemBuilder: itemBuilder,
        itemCount: entries.length,
        reverse: widget.reverse
    );
    return new RefreshIndicator(
        onRefresh: onRefresh,
        child: listView
    );
  }

  Future onRefresh() async {
    this.request?.timeout(const Duration());
    List<dynamic> fetched = await this.pageRequest(page: 0, pageSize: widget.pageSize);
    setState(() {
      this.entries = fetched;
    });

    return true;
  }

  Future loadNext() async {
    int page = (entries.length / widget.pageSize).floor();
    List<dynamic> fetched = await this.pageRequest(page: page, pageSize: widget.pageSize);

    if(mounted) {
      this.setState(() {
        entries.addAll(fetched);
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


