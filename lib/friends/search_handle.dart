import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import 'package:boots/account/signedin.dart';
import 'package:boots/backend/classes.dart';
import 'package:boots/ui_helpers/pictures.dart';


class SearchFriendBloc extends StatesRebuilder {
  List<DocumentSnapshot> results;
  Future<void> setQuery(String query) async {
    CollectionReference users = Firestore.instance.collection("Users");
    List<DocumentSnapshot> matching_docs = (await users.where(User.handle, isEqualTo: query).getDocuments()).documents;
    this.results = matching_docs;
    rebuildStates();
  }

  List<Map<String, dynamic>> getResults() {
    return results == null ? [] : results.map((docsnap) => docsnap.data).toList();
  }
}

class CustomSearchDelegate extends SearchDelegate {
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

  void addFriend(Map<String, dynamic> friendEntry) async {
    String friendHandle = friendEntry[User.handle];
    List<String> friendsList = (await signedInRef.get()).data[User.friendsList];
    friendsList.add(friendHandle);
    signedInRef.updateData({
      User.friendsList: friendsList,
    });
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
        List<Map<String, dynamic>> usersEntries = this.bloc.getResults();
        return ListView.builder(
          itemBuilder: (_, i) {
            return GestureDetector(
              onTap: () {
                
              },
              child: ListTile(
                leading: circleImage(
                  pictureUrl: usersEntries[i][User.pictureUrl],
                  width: 75,
                  height: 75,
                ),
                title: Text(User.name),
                subtitle: Text(User.handle),
              ),
            );
          },
          itemCount: usersEntries.length,
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
