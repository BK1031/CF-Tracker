import 'package:cf_tracker/user_info.dart';
import 'package:cf_tracker/utils/config.dart';
import 'package:cf_tracker/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String _email = "";
  String _password = "";

  final databaseRef = FirebaseDatabase.instance.reference();

  Widget loginWidget = new Padding(padding: EdgeInsets.all(20.0));

  TextEditingController _emailTextField;
  TextEditingController _passwordTextField;

  _LoginPageState() {
    loginWidget = new RaisedButton(child: new Text("Login"), onPressed: login, color: mainColor, textColor: Colors.white);
  }

  void errorDialog(String input) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return CupertinoAlertDialog(
          title: new Text("Login Error"),
          content: new Text(
            "The following error occured while trying to log you in: $input",
            style: TextStyle(fontSize: 14.0),
          ),
          actions: <Widget>[
            new CupertinoDialogAction(
              child: new Text("Got it"),
              onPressed: () {
                router.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void emailField(input) {
    _email = input;
  }

  void passwordField(input) {
    _password = input;
  }

  void login() async {
    setState(() {
      loginWidget = Container(child: CircularProgressIndicator(), height: 15.0, width: 15.0,);
    });
    try {
      AuthResult user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
      print("Signed in! ${user.user.uid}");
      router.navigateTo(context,'/check-auth', transition: TransitionType.fadeIn, clearStack: true);
    } catch (error) {
      print("Error: ${error}");
      errorDialog(error.toString());
    }
    setState(() {
      loginWidget = new RaisedButton(child: new Text("Login"), onPressed: login, color: mainColor, textColor: Colors.white);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: new NestedScrollView(
        headerSliverBuilder: (context, isScrolled) {
          return <Widget>[
            new CupertinoSliverNavigationBar(
              largeTitle: new Text("Login", style: TextStyle(color: Colors.white)),
              backgroundColor: mainColor,
            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: new Material(
            child: new SingleChildScrollView(
              child: new Column(
                children: <Widget>[
                  new Text("Login to your CF Tracker Account below!", textAlign: TextAlign.center,),
                  new Theme(
                    data: ThemeData(accentColor: accentColor, primaryColor: accentColor),
                    child: new TextField(
                      decoration: InputDecoration(
                        icon: new Icon(Icons.email),
                        labelText: "Email",
                        hintText: "Enter your email",
                      ),
                      autocorrect: false,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.none,
                      onChanged: emailField,
                    ),
                  ),
                  new Theme(
                    data: ThemeData(accentColor: accentColor, primaryColor: accentColor),
                    child: new TextField(
                      decoration: InputDecoration(
                          icon: new Icon(Icons.lock),
                          labelText: "Password",
                          hintText: "Enter your password"
                      ),
                      autocorrect: false,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.none,
                      obscureText: true,
                      onChanged: passwordField,
                    ),
                  ),
                  new Padding(padding: EdgeInsets.all(16.0)),
                  new AnimatedContainer(
                    child: loginWidget,
                    duration: new Duration(milliseconds: 300),
                  ),
                  new Padding(padding: EdgeInsets.all(8.0)),
                  new FlatButton(
                    child: new Text(
                      "Don't have an account?",
                      style: TextStyle(
                        color: mainColor,
                      ),
                    ),
                    onPressed: () {
                      router.navigateTo(context,'/register', transition: TransitionType.fadeIn, clearStack: true);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}