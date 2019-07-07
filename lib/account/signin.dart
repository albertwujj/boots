import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

import 'package:boots/account/auth.dart';
import 'package:boots/ui_helpers/primary_button.dart';


class LoginPage extends StatefulWidget {
  var addUser;

  LoginPage({addUser}) {
    print('create boots init');
    this.addUser = addUser;
  }

  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}


class LoginPageState extends State<LoginPage> {

  BuildContext context;
  static final formKey = new GlobalKey<FormState>();
  String _name;
  String _handle;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        widget.addUser(name: this._name, handle: this._handle);

      }
      catch (e) {
        print('validate and save exception');
        print(e);
      }
    }
    Navigator.pop(context);
  }

  List<Widget> bootsAccTextFields() {
    return [
      padded(child: new TextFormField(
        key: new Key('email'),
        decoration: new InputDecoration(labelText: 'Email'),
        autocorrect: false,
        validator: (val) => val.isEmpty ? 'name can\'t be empty.' : null,
        onSaved: (val) => _name = val,
      )),
      padded(child: new TextFormField(
        key: new Key('password'),
        obscureText: true,
        decoration: new InputDecoration(labelText: 'Password'),
        autocorrect: false,
        validator: (val) => val.isEmpty ? 'password can\'t be empty.' : null,
        onSaved: (val) => _handle = val,
      )),
    ];
  }

  Widget padded({Widget child}) {
    return new Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }

  List<Widget> submitWidgets() {
    return [PrimaryButton(
      key: new Key('login'),
      text: 'Login',
      height: 44.0,
      onPressed: validateAndSubmit,
    )];
  }


  @override
  Widget build(BuildContext context) {
    print('building whoops');
    this.context = context;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(''),
      ),
      backgroundColor: Colors.grey[300],
      body: new SingleChildScrollView(child: new Container(
        padding: const EdgeInsets.all(16.0),
        child: new Column(children: [
          new Card(
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Container(
                  padding: const EdgeInsets.all(16.0),
                  child: new Form(
                    key: formKey,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: bootsAccTextFields() + submitWidgets(),
                    )
                  )
                ),
              ])
          ),
          Row(children: [
            GoogleSignInButton(onPressed: BootsAuth.instance.googleBootsSignIn,),
          ]),
        ]
        )
      ))
    );
  }

}


