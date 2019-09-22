import 'package:boots/common_imports.dart';

import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

import 'package:boots/signin/register_page.dart';
import 'package:boots/ui_helpers/primary_button.dart';


Widget padded({Widget child}) {
  return new Padding(
    padding: EdgeInsets.symmetric(vertical: 8.0),
    child: child,
  );
}

class LoginPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {

  static final formKey = new GlobalKey<FormState>();
  String _email;
  String _password;

  bool validateAndSave() {
    final form = LoginPageState.formKey.currentState;
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
        Navigator.pushNamed(context, 'home');
      }
      catch (e) {
        //TODO: handle email login exception
        //ERROR_USER_NOT_FOUND
        print('email login exception, not allowing submit');

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
      key: new Key('login'),
      text: 'Login',
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
                                key: LoginPageState.formKey,
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
                  await BootsAuth.instance.googleSignIn();
                  if (BootsAuth.instance.signedInSnap.exists) {
                    Navigator.pushNamed(context, 'home');
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder:
                        (context) => BootsDetails(addUser: () async {})));
                  }
                }),
              ]),
              PrimaryButton(
                key: Key('goRegister'),
                text: 'Register a new account',
                height: 33.0,
                onPressed: () {Navigator.pushNamed(context, 'register');},
              ),
            ]
            )
        ))
    );
  }
}


