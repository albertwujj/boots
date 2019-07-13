import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

import 'package:boots/ui_helpers/primary_button.dart';
import 'package:boots/backend/classes.dart';
import 'package:boots/auth.dart';
import 'package:boots/ui_helpers/primary_button.dart';


Widget padded({Widget child}) {
  return new Padding(
    padding: EdgeInsets.symmetric(vertical: 8.0),
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
        await BootsAuth.instance.completeRegister();
        Navigator.pushNamed(context, 'home');
      }
      catch (e) {
        print('add user exception');
        print(e);
      }
    }
  }

  Widget emailTextField() {
    return padded(child: new TextFormField(
      key: new Key('email'),
      decoration: new InputDecoration(labelText: 'Email'),
      autocorrect: false,
      validator: (val) => val.isEmpty ? 'name can\'t be empty.' : null,
      onSaved: (val) => _email = val,
    ));
  }
  Widget passwordTextField() {
    return padded(child: new TextFormField(
      key: new Key('password'),
      obscureText: true,
      decoration: new InputDecoration(labelText: 'Password'),
      autocorrect: false,
      validator: (val) => val.length < 6 ? 'password must be 6 or more characters' : null,
      onSaved: (val) => _password = val,
    ));
  }

  Widget formSubmitButton(BuildContext context) {
    return PrimaryButton(
      key: new Key('register'),
      text: 'Register',
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
        body: SingleChildScrollView(child: new Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              Card(
                  child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Container(
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
                                )
                            )
                        ),
                      ])
              ),
              Row(children: [
                GoogleSignInButton(onPressed: () async {
                  try {
                    await BootsAuth.instance.googleSignIn();
                  }
                  catch (e) {
                    //TODO: handle google register in exception
                  }
                  await BootsAuth.instance.completeRegister();
                  Navigator.pushNamed(
                      context, 'home');
                },),
              ]),
            ]
            )
        ))
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
        BootsAuth.registeringEntry = UserEntry.fromDetails(name: this._name, handle: this._handle);
      }
      catch (e) {
        print('submit exception');
        print(e);
      }
      Navigator.push(context, MaterialPageRoute(builder: (context) => AuthConnect()));
    }
  }

  Widget nameTextField() {
    return padded(child: new TextFormField(
      key: new Key('name'),
      decoration: new InputDecoration(labelText: 'Your Name'),
      autocorrect: false,
      validator: (val) => val.isEmpty ? 'Name can\'t be empty.' : null,
      onSaved: (val) => _name = val,
    ));
  }
  Widget handleTextField() {
    return padded(child: new TextFormField(
      key: new Key('handle'),
      decoration: new InputDecoration(labelText: 'Unique Username'),
      autocorrect: false,
      validator: (val) => val.isEmpty ? 'Username can\'t be empty.' : null,
      onSaved: (val) => _handle = val,
    ));
  }

  Widget formSubmitButton(BuildContext context) {
    return PrimaryButton(
      key: new Key('login'),
      text: 'Login',
      height: 44.0,
      onPressed: () { validateAndSubmit(context); },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(''),
        ),
        backgroundColor: Colors.grey[300],
        body: new SingleChildScrollView(child: new Container(
            padding: const EdgeInsets.all(16.0),
            child: new Column(
                children: [
                  new Card(
                      child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Container(
                                padding: const EdgeInsets.all(16.0),
                                child: new Form(
                                    key: BootsDetailsState.formKey,
                                    child: new Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        nameTextField(),
                                        handleTextField(),
                                        formSubmitButton(context),
                                      ]
                                    )
                                )
                            ),
                          ])
                  ),
                ]
            )
        ))
    );
  }

}


