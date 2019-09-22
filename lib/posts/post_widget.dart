import 'package:boots/common_imports.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:boots/profile/profile_page.dart';


class InstaPost extends StatefulWidget {
  DocumentReference postRef;

  InstaPost({
    this.postRef,
  });

  @override
  State<StatefulWidget> createState() {
    return InstaPostState(postRef: postRef);
  }
}

class InstaPostState extends State<InstaPost> {
  DocumentReference postRef;
  PostEntry _postEntry;
  UserEntry _userEntry;

  InstaPostState({this.postRef});

  Widget posterInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            child: Row(
              children: <Widget>[
                circleProfile(),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "imthpk",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(userEntry: _userEntry)));
            },
          ),
          new IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: null,
          )
        ],
      ),
    );
  }

  Widget likeButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Icon(
                FontAwesomeIcons.heart,
              ),
              new SizedBox(
                width: 16.0,
              ),
              new Icon(
                FontAwesomeIcons.comment,
              ),
              new SizedBox(
                width: 16.0,
              ),
              new Icon(FontAwesomeIcons.paperPlane),
            ],
          ),
          new Icon(FontAwesomeIcons.bookmark)
        ],
      ),
    );
  }

  Widget likeStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        "Liked by pawankumar, pk and 528,331 others",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget postPicture() {
    return _postEntry.pictureUrl == null ? emptyWidget: Flexible(
      fit: FlexFit.loose,
      child: Image.network(_postEntry.pictureUrl),
    );
  }

  Widget addCommentBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Container(
            height: 40.0,
            width: 40.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: new NetworkImage(
                      "https://pbs.twimg.com/profile_images/916384996092448768/PF1TSFOE_400x400.jpg")),
            ),
          ),
          new SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: new TextField(
              decoration: new InputDecoration(
                border: InputBorder.none,
                hintText: "Add a comment...",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget postTime() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child:
      Text("1 Day Ago", style: TextStyle(color: Colors.grey)),
    );
  }

  Future<Widget> resolveRefs() async {
    PostEntry postEntry = PostEntry.fromDocSnap(await postRef.get());
    UserEntry userEntry = UserEntry.fromDocSnap(await postEntry.userRef.get());
    setState(() {
      _postEntry = postEntry;
      _userEntry = userEntry;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_userEntry == null) {
      resolveRefs();
      return emptyWidget;
    }
    else {

    }
  }
}

