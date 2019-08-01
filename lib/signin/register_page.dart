import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:boots/ui_helpers/primary_button.dart';
import 'package:boots/backend/classes.dart';
import 'package:boots/auth.dart';
import 'package:boots/backend/storage.dart';
import 'package:boots/ui_helpers/pictures.dart';


Widget padded(Widget child, {double amount: 8.0}) {
  return new Padding(
    padding: EdgeInsets.symmetric(vertical: amount),
    child: child,
  );
}

class AuthConnect extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return AuthConnectState();
  }
}

class AuthConnectState extends State<AuthConnect> {

  static final formKey = new GlobalKey<FormState>();
  String _email;
  String _password;

  bool validateAndSave() {
    final form = AuthConnectState.formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit(BuildContext context) async {
    if (validateAndSave()) {
      try {
        await BootsAuth.instance.emailRegister(email: this._email, password: this._password);
        Navigator.push(context, MaterialPageRoute(builder: (context) => BootsDetails()));
      }
      catch (e) {
        print('add user exception');
        print(e);
      }
    }
  }

  Widget emailTextField() {
    return TextFormField(
      key: new Key('email'),
      decoration: new InputDecoration(labelText: 'Email'),
      autocorrect: false,
      validator: (val) => val.isEmpty ? 'name can\'t be empty.' : null,
      onSaved: (val) => _email = val,
    );
  }
  Widget passwordTextField() {
    return TextFormField(
      key: new Key('password'),
      obscureText: true,
      decoration: new InputDecoration(labelText: 'Password'),
      autocorrect: false,
      validator: (val) => val.length < 6 ? 'password must be 6 or more characters' : null,
      onSaved: (val) => _password = val,
    );
  }

  Widget formSubmitButton(BuildContext context) {
    return PrimaryButton(
      key: new Key('AuthConnectSubmit'),
      text: 'Continue registration',
      height: 44.0,
      onPressed: () { validateAndSubmit(context); },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      backgroundColor: Colors.grey[300],
      body:
        Padding(padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Card(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: new Form(
                  key: AuthConnectState.formKey,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      emailTextField(),
                      passwordTextField(),
                      formSubmitButton(context),
                    ],
                  ),
                ),
              ),
            ),
            Row(children: [
              GoogleSignInButton(onPressed: () async {
                try {
                  await BootsAuth.instance.googleSignIn();
                }
                catch (e) {
                  //TODO: handle google register in exception
                }
                Navigator.push(context, MaterialPageRoute(builder: (context) => BootsDetails()));
              }),
            ]),
            PrimaryButton(
              key: Key('LoginInstead'),
              text: 'Login Instead',
              height: 44.0,
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
              },
            ),
          ],
        ),
      )
    );
  }
}

class BootsDetails extends StatefulWidget {
  final addUser;
  BootsDetails({this.addUser});

  @override
  State<StatefulWidget> createState() {
    return BootsDetailsState();
  }
}

class BootsDetailsState extends State<BootsDetails> {

  BuildContext context;
  static final formKey = new GlobalKey<FormState>();
  String _name;
  String _handle;
  File _picture;

  Widget wrapTextField(Widget textField, {String name}) {
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
        textField,
      ],
    );
  }

  bool validateAndSave() {
    final form = BootsDetailsState.formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit(BuildContext context) async {
    if (validateAndSave()) {
      try {
        String dpUrl = await uploadImage(_picture);
        BootsAuth.instance.signedInRef.setData(
            UserEntry.fromDetails(name: _name, handle: _handle, dpUrl: dpUrl)
                .toDict());
        BootsAuth.instance.signedInSnap =
        await BootsAuth.instance.signedInRef.get();
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('HasReg', true);
        Navigator.pushNamedAndRemoveUntil(
            context, 'home', (Route<dynamic> route) => false);
      }
      catch (e) {
        print('submit exception');
        print(e);
      }
    }
  }

  Widget nameTextField() {
    return TextFormField(
      key: new Key('name'),
      decoration: new InputDecoration(labelText: 'Display Name'),
      autocorrect: false,
      validator: (val) => val.isEmpty ? 'Name can\'t be empty.' : null,
      onSaved: (val) => _name = val,
    );
  }

  Widget handleTextField() {
    return TextFormField(
      key: new Key('handle'),
      decoration: new InputDecoration(labelText: 'Unique Username'),
      autocorrect: false,
      validator: (val) => val.isEmpty ? 'Username can\'t be empty.' : null,
      onSaved: (val) => _handle = val,
    );
  }

  Widget formSubmitButton(BuildContext context) {
    return PrimaryButton(
      key: new Key('BootsDetailsSubmit'),
      text: 'Finish registration',
      height: 44.0,
      onPressed: () {
        validateAndSubmit(context);
      },
    );
  }

  void openCamera(BuildContext context) async {
    Navigator.pop(context);
    File pictureFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    pictureFile = await ImageCropper.cropImage(sourcePath: pictureFile.path);
    setState(() {
      _picture = pictureFile;
    });
  }

  void openGallery(BuildContext context) async{
    Navigator.pop(context);
    File pictureFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    pictureFile = await ImageCropper.cropImage(sourcePath: pictureFile.path);
    setState(() {
      _picture = pictureFile;
    });
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

  Widget profilePhoto() {
    return fileCircleProfile(file: _picture);
  }

  Widget profilePhotoButton(BuildContext context) {
    return FlatButton(
      onPressed: () {
        changeProfilePhoto(context);
      },
      child: Text(
        "Change Photo",
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 20.0,
          fontWeight: FontWeight.bold
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text(''),
        ),
        backgroundColor: Colors.grey[300],
        body:
        Card(
          child: Container(
              padding: const EdgeInsets.all(16.0),
              child: new Form(
                  key: BootsDetailsState.formKey,
                  child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        profilePhoto(),
                        profilePhotoButton(context),
                        wrapTextField(nameTextField(), name:'Display Name'),
                        padded(handleTextField()),
                        padded(formSubmitButton(context), amount: 15.0),
                      ]
                  )
              )
          ),
        )
    );
  }
}
