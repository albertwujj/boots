import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:boots/DatabaseHelper.dart';
import 'package:boots/PageRequest.dart';
import 'package:boots/WidgetAdapter.dart';

final dbHelper = DatabaseHelper.instance;

void main() async {
  Map<String, dynamic> row = {
    DatabaseHelper.postTitle : 'Boots app is releasing!',
    DatabaseHelper.postBody  : 'We are releasing Boots App, a new GPS/social media app for Nigerians during '
        'their required paramilitary year that will help people find companions, make friends, and stay safe.'
  };
  for (var i = 0; i < 100; i++) {
    await dbHelper.insert(row);
  }

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

typedef Future<List<Map<String, dynamic>>> PageRequest (int page, int pageSize);
typedef Widget WidgetAdapter (Map<String, dynamic> t);

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
              new LoadingListView(),
              new LoadingListView(),
              new LoadingListView(),
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


