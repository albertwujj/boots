import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import 'package:boots/auth.dart';
import 'package:boots/backend/classes.dart';
import 'package:boots/backend/storage.dart';
import 'package:boots/ui_helpers/pictures.dart';


class EditProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EditProfilePageState();
  }
}

class EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  File _picture;

  applyChanges() async {
    await BootsAuth.instance.signedInRef.updateData({
      UserKeys.name: nameController.text,
      UserKeys.bio: bioController.text,
    });
    if (_picture != null) {
      await BootsAuth.instance.signedInRef.updateData({
        UserKeys.dpUrl: await uploadImage(_picture),
      });
    }
    BootsAuth.instance.signedInSnap = await BootsAuth.instance.signedInRef.get();
  }

  void openCamera(BuildContext context) async {
    _picture = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    Navigator.pop(context);

  }

  void openGallery(BuildContext context) async{
    _picture = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    Navigator.pop(context);
  }

  Future<void> changeProfilePhoto(BuildContext context) async {
    await showDialog(context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                GestureDetector(
                  child: new Text('Take a picture'),
                  onTap: () => openCamera(context),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                  child: new Text('Select from gallery'),
                  onTap: () {
                    openGallery(context);
                  },
                ),
                ],
              ),
            ),
        );
      }
    );
  }

  Widget buildTextField({String name, TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Text(
            name,
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: name,
          ),
        ),
      ],
    );
  }

  Widget dpPhoto() {
    return _picture == null ?
    circleProfile(
      pictureUrl: BootsAuth.instance.signedInEntry.dpUrl,
      radius: 50.0,
    ) :
    fileCircleProfile(
      file: _picture,
      radius: 50.0,
    );
  }

  Widget body(BuildContext context) {
    UserEntry userEntry = BootsAuth.instance.signedInEntry;

    nameController.text = userEntry.name;
    bioController.text = userEntry.bio;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: dpPhoto(),
        ),
        FlatButton(
            onPressed: () {
              changeProfilePhoto(context);
            },
            child: Text(
              "Change Photo",
              style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            )
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              buildTextField(name: "Name", controller: nameController),
              buildTextField(name: "Bio", controller: bioController),
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: MaterialButton(
              onPressed: () {_logout(context);},
              child: Text("Logout"),
            )
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: body(context),
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(
                Icons.check,
                color: Colors.white,
              ),
              onPressed: () async {
                await applyChanges();
                Navigator.maybePop(context);
              }
            )
          ]
        ),
      );
  }

  void _logout(BuildContext context) async {
    BootsAuth.instance.signOut();
    Navigator.pop(context);
  }
}
