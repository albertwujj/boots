import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:states_rebuilder/states_rebuilder.dart';

import 'package:boots/loading_list.dart';
import 'package:boots/posts/get_posts.dart';
import 'package:boots/posts/create_post.dart';
import 'package:boots/auth.dart';
import 'package:boots/signin/login_page.dart';
import 'package:boots/signin/register_page.dart';
import 'package:boots/profile/profile_page.dart';
import 'package:boots/friends/friends_list.dart';


final Widget emptyWidget = new Container(width: 0, height: 0);
class MainBloc extends StatesRebuilder {
}

void main() async {
  runApp(BootsApp());
}

class BootsApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BootsAppState();
  }
}


class BootsAppState extends State<BootsApp> {

  String route;

  @override
  Widget build(BuildContext context) {

    if (route == null) {
      BootsAuth.instance.isLoggedIn().then((uid) async {
        if (uid != null) {
          await BootsAuth.instance.bootsLogin(uid);
          setState(() {
            this.route = 'home';
          });
        } else {
          BootsAuth.instance.hasRegisteredBefore().then((hasReg) {
            if (hasReg) {
              setState(() {
                this.route = 'login';
              });
            } else {
              setState(() {
                this.route = 'register';
              });
            }
          });
        }
      });
      return Container();
    }
    else {
      return MaterialApp(
        title: 'Lime',
        initialRoute: this.route,
        routes: {
          'login': (context) => LoginPage(),
          'register': (context) => AuthConnect(),
          'home': (context) =>
              BlocProvider(bloc: MainBloc(), child: MainPage()),
        },
      );
    }
  }
}

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MainPageState();
  }
}

enum MainPages {
  feed, friends
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

    return Scaffold(
        body: PageView(
          children: [
            Scaffold(
              body: LoadingListView(pageRequest: postsPageRequest, widgetFromEntry: postsWidgetFromEntry),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.lightGreen,
                child: Icon(Icons.add_box),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePost()));
                }
              ),
            ),
            FriendsScaffold(),
            ProfilePage(),
          ],
          /// Specify the page controller
          controller: _pageController,
          onPageChanged: onPageChanged,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.insert_photo),
                title: Text("feed")
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.people),
                title: Text("friends")
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text("profile"),
            ),
          ],

          /// Will be used to scroll to the next page
          /// using the _pageController
          onTap: navigationTapped,
          currentIndex: _page,
        ),
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

