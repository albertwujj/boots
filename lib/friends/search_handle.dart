import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ui/firestore_ui.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import 'package:boots/account/signedin.dart';
import 'package:boots/database_helper.dart';
import 'package:boots/upload_image.dart';
import 'package:boots/backend/classes.dart';


class SearchBloc extends StatesRebuilder {
  List<DocumentSnapshot> results;
  void setQuery(String query) async {
    CollectionReference users = Firestore.instance.collection("Users").orderBy(User.handle);
    List<DocumentSnapshot> matching_docs = (await users.where(User.handle, isEqualTo: query).getDocuments()).documents;
    this.results = matching_docs;
  }

  List<Map<String, dynamic>> getResults() {
    List<Map<String, dynamic>> users = [];
    results.forEach((DocumentSnapshot docsnap) {
      users.add(docsnap.data);
    });
    return users;
  }
}

class CustomSearchDelegate extends SearchDelegate {
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
    final bloc = BlocProvider.of<SearchBloc>(context);

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
    bloc.setQuery(query);
    List<Map<String, dynamic>> queryResults = bloc.getResults();

    Widget itemBuilder(BuildContext context, int index) {

    }
    return Column(
      children: <Widget>[
        ListView(children: [

        ])


      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    return Column();
  }
}
