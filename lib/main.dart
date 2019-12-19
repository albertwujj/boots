import 'common_imports.dart';

import 'package:states_rebuilder/states_rebuilder.dart';

import 'package:boots/loading_list.dart';
import 'package:boots/posts/get_posts.dart';
import 'package:boots/posts/add_post.dart';
import 'package:boots/ui/primary_button.dart';
import 'package:boots/profile/profile_page.dart';
import 'package:boots/testing/setup_users.dart';


void main() async {
  await TestingSetupUsers.setupEntire();
  runApp(BootsApp());
}

class DetectLoginBloc extends StatesRebuilder {
  bool loggedInFunc(){
    return false;
  }
}

class BootsApp extends StatelessWidget {

  Widget build(BuildContext context) {
    return Injector(
      inject: [Inject(()=>Counter())],
      builder: (context) {
        final counterModel = Injector.get<Counter>();
      }
        MaterialApp(
          home: BlocProvider(
          bloc: FirstBloc(),
          child: CreateVLoginScreen(),
        )
    );
  }
}


class CreateVLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider<DetectLoginBloc>.of(context);

    return Column(
      children: [
        PrimaryButton(""),
        PrimaryButton(),
      ]
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
                title: Text("old.friends")
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

