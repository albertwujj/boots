import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';


void main(){

  runApp(new BootsApp());
}

class BootsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Lime',
      home: new MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {

  /// This controller can be used to programmatically
  /// set the current displayed page
  PageController _pageController;
  int _page = 0;

  void onPageChanged(int page){
    setState((){
      this._page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new PageView(
            children: [
              new Container(color: Colors.red),
              new Container(color: Colors.blue),
              new Container(color: Colors.grey)
            ],

            /// Specify the page controller
            controller: _pageController,
            onPageChanged: onPageChanged,
        ),
        bottomNavigationBar: new BottomNavigationBar(
          items: [
            new BottomNavigationBarItem(
                icon: new Icon(Icons.add),
                title: new Text("trends")
            ),
            new BottomNavigationBarItem(
                icon: new Icon(Icons.location_on),
                title: new Text("feed")
            ),
            new BottomNavigationBarItem(
                icon: new Icon(Icons.people),
                title: new Text("community")
            )
          ],

          /// Will be used to scroll to the next page
          /// using the _pageController
          onTap: navigationTapped,
          currentIndex: _page,
        )

    );

  }

  /// Called when the user presses on of the
  /// [BottomNavigationBarItem] with corresponding
  /// page index
  void navigationTapped(int page){

    // Animating to the page.
    // You can use whatever duration and curve you like
    _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
  }

  @override
  void dispose(){
    super.dispose();
    _pageController.dispose();
  }
}

typedef Future<List<T>> PageRequest<T> (Database database, int page, int pageSize);
typedef Widget WidgetAdapter<T>(T t);

class LoadingListView<T> extends StatefulWidget {

  /// Abstraction for loading the data.
  /// This can be anything: An API-Call,
  /// loading data from a certain file or database,
  /// etc. It will deliver a list of objects (of type T)
  final PageRequest<T> pageRequest;

  /// Used for building Widgets out of
  /// the fetched data
  final WidgetAdapter<T> widgetAdapter;

  /// The number of elements requested for each page
  final int pageSize;

  /// The number of "left over" elements in list which
  /// will trigger loading the next page
  final int pageThreshold;

  /// [PageView.reverse]
  final bool reverse;

  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      title: 'Lime',
      home: new MainPage(),
    );
  }


  LoadingListView(this.pageRequest, {
    this.pageSize: 50,
    this.pageThreshold:10,
    @required this.widgetAdapter,
    this.reverse: false,
  });

  @override
  State<StatefulWidget> createState() {
    return new _LoadingListViewState();
  }
}


class _LoadingListViewState<T> extends State<LoadingListView<T>> {

  /// Contains all fetched elements ready to display!
  List<T> objects = [];
  /// A Future returned by loadNext() if there
  /// is currently a request running
  /// or null, if no request is performed.
  Future request;

  // reference to our single class that manages the database

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
    this.request?.timeout(const Duration());
    List<T> fetched = await widget.pageRequest(database, 0, widget.pageSize);
    setState(() {
      this.objects = fetched;
    });

    return true;
  }

  @override
  void initState() {
    super.initState();
    this.lockedLoadNext();
  }
  Future loadNext() async {
    int page = (objects.length / widget.pageSize).floor();
    List<T> fetched = await widget.pageRequest(database, page, widget.pageSize);

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


  Widget itemBuilder(BuildContext context, int index) {

    /// here we go: Once we are entering the threshold zone, the loadLockedNext()
    /// is triggered.
    if (index + widget.pageThreshold > objects.length) {
      lockedLoadNext();
    }

    return widget.widgetAdapter != null ? widget.widgetAdapter(objects[index])
        : new Container();
  }
}


