import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:boots/database_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:boots/loading_list.dart';
import 'package:boots/posts/create_post.dart';
import 'package:boots/posts/get_posts.dart';
import 'package:boots/friends/friends_list.dart';
import 'package:boots/backend/storage.dart';
import 'package:boots/account/auth.dart';
import 'package:boots/globals.dart';
import 'package:boots/backend/classes.dart';
import 'package:boots/backend/users.dart';


final Widget emptyWidget = new Container(width: 0, height: 0);
class MainBloc extends StatesRebuilder {
}

void main() async {
  DocumentReference uche = Firestore.instance.collection('Users').document('Uche');
  uche.setData(getNewUserEntry(name: 'Uche', handle: 'uchekl'));

  runApp(new BootsApp());
}


class BootsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Lime',
      home: BlocProvider(
        bloc: MainBloc(),
        child: NavigationBootsApp(),
      )
    );
  }
}

class NavigationBootsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    baseBuildContext = context;
    return MainPage();
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
              new LoadingListView(pageRequest: postsPageRequest, widgetFromEntry: postsWidgetFromEntry),
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
    BootsAuth.instance.getSignedInRef();
    _pageController = new PageController();
  }

  @override
  void dispose(){
    super.dispose();
    _pageController.dispose();
  }
}

