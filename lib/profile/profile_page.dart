import 'package:boots/common_imports.dart';

import 'package:boots/profile/edit_profile_page.dart';


class ProfilePage extends StatefulWidget {
  UserEntry userEntry;

  ProfilePage({this.userEntry});

  @override
  State<StatefulWidget> createState() {
    return ProfilePageState(userEntry: userEntry);
  }
}

class ProfilePageState extends State<ProfilePage> {

  UserEntry _userEntry;
  String _name;
  String _following;
  String _friends;
  String _posts;

  ProfilePageState({UserEntry userEntry}){
    if (userEntry == null) {
      userEntry = BootsAuth.instance.signedInEntry;
    }
    _userEntry = userEntry;
    _name = _userEntry.name;
    _following = _userEntry.followingList.length.toString();
    _friends = _userEntry.friendsList.length.toString();
    _posts = _userEntry.postsList.length.toString();
  }

  Widget _buildEditButton() {
    return FlatButton(
      child: Text('Edit profile'),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage()));
      },
    );
  }

  Widget _buildStatItem(String label, String count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        Container(
            margin: const EdgeInsets.only(top: 4.0),
            child: Text(
              label,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400),
            ))
      ],
    );
  }

  Widget serviceLocation() {
    return Text(_userEntry.location);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 40.0,
                        backgroundColor: Colors.grey,
                        backgroundImage:
                        _userEntry.dpUrl == null ?
                        AssetImage('assets/default_profile.jpg') : NetworkImage(_userEntry.dpUrl),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                _buildStatItem("Posts", _posts),
                                _buildStatItem("Following", _following),
                                _buildStatItem("Friends", _friends),
                              ],
                            ),
                            Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  _buildEditButton(),
                                ]
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        _userEntry.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        _userEntry.location,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 1.0),
                    child: Text(_userEntry.bio ?? 'An enigma'),
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }
}
