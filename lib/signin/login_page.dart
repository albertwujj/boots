import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

import 'package:boots/auth.dart';
import 'package:boots/ui_helpers/primary_button.dart';
import 'package:boots/signin/boots_details.dart';


Widget padded({Widget child}) {
  return new Padding(
    padding: EdgeInsets.symmetric(vertical: 8.0),
    child: child,
  );
}

class SignInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignInPageState();
  }
}
class SignInPageState extends State<SignInPage> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) {

    return isLogin ?
    Scaffold(body:
      Column(children: <Widget>[
        FlatButton(
            child: Text('Register'),
            onPressed: () {
              setState(() {
                this.isLogin = false;
              });
            },
        ),
        GoogleSignInButton(onPressed:
          //login
          () async {
            try {
              await BootsAuth.instance.googleSignIn();
            }
            catch (e) {
              //TODO: handle google register in exception
            }
            Navigator.pushNamed(context, 'home');
          }
        ),

      ])
    ) :
    Scaffold(body:
      Column(children: <Widget>[
        FlatButton(
          child: Text('Login'),
          onPressed: () {
            setState(() {
              this.isLogin = true;
            });
          },
        ),
        GoogleSignInButton(onPressed:
        //login
          () async {
            try {
              await BootsAuth.instance.googleSignIn();
            }
            catch (e) {
              //TODO: handle google register in exception
            }
            Navigator.push(context, MaterialPageRoute(builder: (context) => BootsDetails()));
          }
        ),
      ])
    );
  }
}


class LoginForm extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {

  static final formKey = new GlobalKey<FormState>();
  String _email;
  String _password;

  bool validateAndSave() {
    final form = LoginFormState.formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit(BuildContext context) async {
    if (validateAndSave()) {
      try {
        String uid = await BootsAuth.instance.emailLogin(email: this._email, password: this._password);
        print('logged in with uid: $uid');
      }
      catch (e) {
        //TODO: handle email login exception
        print('email login exception');
        print(e);
      }
      Navigator.pushNamed(context, 'home');
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
      key: new Key('login'),
      text: 'Login',
      height: 44.0,
      onPressed: () { validateAndSubmit(context); },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: AuthRegisterFormState.formKey,
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              emailTextField(),
              passwordTextField(),
              formSubmitButton(context),
            ]
        )
    );
  }
}

class AuthRegisterForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AuthRegisterFormState();
  }
}

class AuthRegisterFormState extends State<AuthRegisterForm> {

  static final formKey = new GlobalKey<FormState>();
  String _email;
  String _password;

  bool validateAndSave() {
    final form = AuthRegisterFormState.formKey.currentState;
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
      key: new Key('authRegister'),
      text: 'Continue',
      height: 44.0,
      onPressed: () { validateAndSubmit(context); },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: AuthRegisterFormState.formKey,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          emailTextField(),
          passwordTextField(),
          formSubmitButton(context),
        ]
      )
    );

  }
}
