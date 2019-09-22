import 'package:boots/common_imports.dart';

import 'package:states_rebuilder/states_rebuilder.dart';

import 'package:boots/ui_helpers/pictures.dart';
import 'package:boots/messages/message_screen.dart';


Future<List<UserEntry>> loadFriendsEntries() async {
  DocumentReference signedInRef = await BootsAuth.instance.signedInRef;
  DocumentSnapshot signedInSnap = await signedInRef.get();
  print('signedinSnap $signedInSnap');
  UserEntry entry = UserEntry.fromDocSnap(signedInSnap);
  List<String> friendHandles = entry.followingList;
  print('friendListSize ${friendHandles.length}');
  List<DocumentSnapshot> friendsSnaps = await Users.findUserSnaps(handles: friendHandles);
  friendsSnaps.sort((a, b) => a[UserKeys.handle].compareTo(b[UserKeys.handle])); // sort alphabetically
  List<UserEntry> friendEntries = friendsSnaps.map((DocumentSnapshot docsnap) => UserEntry.fromDocSnap(docsnap)).toList();
  print('friend entries length ${friendEntries.length}');
  return friendEntries;
}

class FriendsScaffold extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FriendsScaffoldState();
  }
}

class FriendsScaffoldState extends State<FriendsScaffold> {

  List<UserEntry> _friendEntries;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadFriendsEntries().then((friendEntries){
      if (this.mounted) {
        setState(() {
          _friendEntries = friendEntries;
        });
      }
    });
  }

  Widget widgetFromEntry({UserEntry friendEntry}) {
    String friendName = friendEntry.name;
    String friendHandle = friendEntry.handle;
    String friendPictureUrl = friendEntry.dpUrl;

    return GestureDetector(
      onTap: () async {
        CollectionReference messages = (await findDMGroupSelf(friendHandle: friendHandle)).reference.collection(GroupKeys.messages);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatScreen(messagesCollection: messages, groupName: friendName)),
        );
      },
      child: ListTile(
        leading: Container(
          child: circleProfile(pictureUrl: friendPictureUrl),
          width: 75,
          height: 75,
        ),
        title: Text(friendName),
        subtitle: Text(friendHandle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Align(alignment: Alignment.center,
        child: ListView.builder(
          itemBuilder: (_, i) {
            UserEntry friendEntry = this._friendEntries[i];
            return widgetFromEntry(friendEntry: friendEntry);
          },
          itemCount: this._friendEntries?.length ?? 0,
        )
      ),
      Padding(padding: EdgeInsets.only(top:10.0, right:3.0),
        child: Column(
          children: [
            Align(alignment: Alignment.topRight,
            child: FlatButton(
              shape: CircleBorder(),
              color: Colors.green,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.blueAccent,
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: FriendsSearchDelegate(),
                );
              },
              child: Icon(Icons.add_circle, size: 50,),
              )
            ),
          ]
          )
        )
      ]
    );
  }
}
