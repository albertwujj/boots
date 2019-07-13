import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import 'package:boots/auth.dart';
import 'package:boots/ui_helpers/pictures.dart';
import 'package:boots/backend/classes.dart';
import 'package:boots/backend/groups.dart';
import 'package:boots/backend/users.dart';


class SearchFriendBloc extends StatesRebuilder {
  List<DocumentSnapshot> results;
  Future<void> setQuery(String query) async {
    CollectionReference users = Firestore.instance.collection("Users");
    List<DocumentSnapshot> matchingDocs = (await users.where(UserKeys.handle, isEqualTo: query).getDocuments()).documents;
    this.results = matchingDocs;
    if (StatesRebuilder.listeners(this).length != 0) {
      rebuildStates();
    }
  }

  UserEntry getFriendEntry({int index}) {
    return UserEntry.fromDocSnap(results[index]);
  }

  Future<void> addFriend({int index}) async {

    DocumentSnapshot friendSnap = this.results[index];
    UserEntry friendEntry = UserEntry.fromDocSnap(friendSnap);
    String friendHandle = friendEntry.handle;

    UserEntry signedInEntry = await BootsAuth.instance.getSignedInEntry();
    String signedInHandle = signedInEntry.handle;

    Map<String, dynamic> signedInUpdate = {
      UserKeys.friendsList: signedInEntry.friendsList + [friendHandle]
    };
    String addedGroupId;
    if (friendEntry.friendsList.contains(signedInHandle)) {
      DocumentSnapshot groupSnap = await findDMGroupFriend(friendHandle: friendHandle);
      addedGroupId = groupSnap.documentID;

    } else {
      addedGroupId  = await createGroup(userHandles: [signedInHandle, friendHandle]);
    }
    signedInUpdate[UserKeys.groupsList] = signedInEntry.groupsList + [addedGroupId];

  }
}

class FriendsSearchDelegate extends SearchDelegate {
  SearchFriendBloc bloc = SearchFriendBloc();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
            ),
          )
        ],
      );
    }

    //Add the search term to the searchBloc.
    //The Bloc will then handle the searching and add the results to the searchResults stream.
    //This is the equivalent of submitting the search term to whatever search service you are using
    this.bloc.setQuery(query);

    return StateBuilder(blocs: [this.bloc],
      builder: (_, __) {
        return ListView.builder(
          itemBuilder: (_, i) {

            UserEntry userEntry = this.bloc.getFriendEntry(index: i);
            String handle = userEntry.handle;
            String pictureUrl = userEntry.pictureUrl;
            String name = userEntry.name;

            return GestureDetector(
              onTap: () {
                this.bloc.addFriend(index: i);
                this.close(context, null);
              },
              child: ListTile(
                leading: Container(
                  child: circleProfile(pictureUrl: pictureUrl),
                  width: 75,
                  height: 75,
                ),
                title: Text(name),
                subtitle: Text(handle),
              ),
            );
          },
          itemCount: this.bloc.results?.length ?? 0,
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    return Column();
  }
}
