import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';


enum DatabaseTable {
  posts,
  friends,
}
String _enumToTable(DatabaseTable table_enum){
  switch (table_enum) {
    case DatabaseTable.posts:
      return DatabaseHelper.postTable;
    case DatabaseTable.friends:
      return DatabaseHelper.friendTable;
  }
}

class DatabaseHelper {


  static final postTable = 'posts_table';

  static final postId = '_id';
  static final postPicture = 'picture';
  static final postBody = 'body';


  static final friendTable = 'friends_table';

  static final friendId = '_id';
  static final friendPicture = 'picture';
  static final friendName = 'body';
  static final friendNumber = 'number';

  static File currPicture;


  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  static Future<DocumentReference> insert(DatabaseTable table, Map<String, dynamic> row) async {
    print('inserting row');
    CollectionReference collection = Firestore.instance.collection(_enumToTable(table));
    return collection.add(row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  static Future<List<Map<String, dynamic>>> queryAllRows(DatabaseTable table) async {
    print('querying rows');
    CollectionReference collection = Firestore.instance.collection(_enumToTable(table));
    QuerySnapshot quer = await collection.getDocuments();
    List<DocumentSnapshot> documents = quer.documents;
    final rows = <Map<String, dynamic>>[];
    documents.forEach((DocumentSnapshot doc) {rows.add(doc.data);});
    return rows;
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  static int queryRowCount() {
    return 20;
  }

}
