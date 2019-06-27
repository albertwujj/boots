import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:boots/database_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import 'package:boots/loading_list.dart';
import 'package:boots/posts/create_post.dart';
import 'package:boots/friends/friends_list.dart';


final Widget emptyWidget = new Container(width: 0, height: 0);

Future<List<Map<String, dynamic>>> pageRequest (DatabaseTable table, int page, int pageSize) async {
  List<Map<String, dynamic>> rows = await DatabaseHelper.queryAllRows(table);
  return rows.sublist(0, min(pageSize, rows.length));
}


void main() async {

  CollectionReference messages = Firestore.instance.collection('rooms').document('roomA').collection('messages');
  messages.add({DatabaseHelper.postBody: 'fuck. yes.'});

  QuerySnapshot quer = await messages.getDocuments();
  List<DocumentSnapshot> doc = quer.documents;
  print(doc.take(1).single.data[DatabaseHelper.postBody]);

  runApp(new BootsApp());
}

class MainBloc extends StatesRebuilder {
}


class BootsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Lime',
      home: BlocProvider(
        bloc: MainBloc(),
        child: MainPage(),
      )
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

  void changePage(int page) {
    this._pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new PageView(
            children: [
              new LoadingListView(table: DatabaseTable.posts),
              new CreatePost(changePage: changePage),
              new FriendsScaffold(),
            ],

            /// Specify the page controller
            controller: _pageController,
            onPageChanged: onPageChanged,
        ),
        bottomNavigationBar: new BottomNavigationBar(
          items: [
            new BottomNavigationBarItem(
                icon: new Icon(Icons.insert_photo),
                title: new Text("feed")
            ),
            new BottomNavigationBarItem(
                icon: new Icon(Icons.add),
                title: new Text("create")
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

