import 'package:cf_tracker/user_info.dart';
import 'package:cf_tracker/utils/config.dart';
import 'package:cf_tracker/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final databaseRef = FirebaseDatabase.instance.reference();

  Widget loginWidget = new Padding(padding: EdgeInsets.all(20.0));

  Color maleButtonColor = mainColor;
  Color femaleButtonColor = Colors.white;
  Color maleButtonTextColor = Colors.white;
  Color femaleButtonTextColor = Colors.black;

  String _firstName = "";
  String _lastName = "";
  String _email = "";
  String _password = "";
  String _confirm = "";
  String _gender = "MALE";

  _RegisterPageState() {
    loginWidget = new RaisedButton(child: new Text("Create Account"), onPressed: register, color: mainColor, textColor: Colors.white);
  }

  void accountErrorDialog(String error) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return CupertinoAlertDialog(
          title: new Text("Account Creation Error", style: TextStyle(fontFamily: "Product Sans"),),
          content: new Text(
            "There was an error creating your CF Tracker Account: $error",
            style: TextStyle(fontFamily: "Product Sans", fontSize: 14.0),
          ),
          actions: <Widget>[
            new CupertinoDialogAction(
              child: new Text("Got it"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void register() async {
    setState(() {
      loginWidget = Container(child: CircularProgressIndicator(), height: 15.0, width: 15.0,);
    });
    if (_firstName == "" || _lastName == "") {
      print("Name cannot be empty");
      accountErrorDialog("Name cannot be empty");
    }
    else if (_password != _confirm) {
      print("Password don't match");
      accountErrorDialog("Passwords do not match");
    }
    else if (_email == "") {
      print("Email cannot be empty");
      accountErrorDialog("Email cannot be empty");
    }
    else {
      try {
        AuthResult user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
        print("Signed in! ${user.user.uid}");

        currUser.email = _email;
        currUser.id = user.user.uid;
        currUser.firstName = _firstName;
        currUser.lastName = _lastName;
        currUser.gender = _gender;

        databaseRef.child("users").child(currUser.id).update({
          "firstName": currUser.firstName,
          "lastName": currUser.lastName,
          "email": currUser.email,
          "gender": currUser.gender
        });

      }
      catch (error) {
        print("Error: ${error}");
        accountErrorDialog(error.toString());
      }
    }
    setState(() {
      loginWidget = new RaisedButton(child: new Text("Create Account"), onPressed: register, color: mainColor, textColor: Colors.white);
    });
  }

  void firstNameField(input) {
    _firstName = input;
  }

  void lastNameField(input) {
    _lastName = input;
  }

  void emailField(input) {
    _email = input;
  }

  void passwordField(input) {
    _password = input;
  }

  void confirmField(input) {
    _confirm = input;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: new NestedScrollView(
        headerSliverBuilder: (context, isScrolled) {
          return <Widget>[
            new CupertinoSliverNavigationBar(
              largeTitle: new Text("Welcome", style: TextStyle(color: Colors.white)),
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
                  new Text("Create your CF Tracker Account below!", style: TextStyle(fontFamily: "Product Sans",), textAlign: TextAlign.center,),
                  new Theme(
                    data: ThemeData(accentColor: accentColor, primaryColor: accentColor),
                    child: new TextField(
                      decoration: InputDecoration(
                          icon: new Icon(Icons.person),
                          labelText: "First Name",
                          hintText: "Enter your first name",
                      ),
                      autocorrect: true,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      onChanged: firstNameField,
                    ),
                  ),
                  new Theme(
                    data: ThemeData(accentColor: accentColor, primaryColor: accentColor),
                    child: new TextField(
                      decoration: InputDecoration(
                          icon: new Icon(Icons.person),
                          labelText: "Last Name",
                          hintText: "Enter your last name"
                      ),
                      autocorrect: true,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      onChanged: lastNameField,
                    ),
                  ),
                  new Theme(
                    data: ThemeData(accentColor: accentColor, primaryColor: accentColor),
                    child: new TextField(
                      decoration: InputDecoration(
                          icon: new Icon(Icons.email),
                          labelText: "Email",
                          hintText: "Enter your email"
                      ),
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
                      onChanged: emailField,
                    ),
                  ),
                  new Padding(padding: EdgeInsets.all(4.0)),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        width: (MediaQuery.of(context).size.width / 2) - 50,
                        child: new FlatButton(
                          child: new Text("MALE"),
                          textColor: maleButtonTextColor,
                          color: maleButtonColor,
                          onPressed: () {
                            setState(() {
                              _gender = "MALE";
                              maleButtonColor = mainColor;
                              maleButtonTextColor = Colors.white;
                              femaleButtonColor = Colors.white;
                              femaleButtonTextColor = Colors.black;
                            });
                            print(_gender);
                          },
                        ),
                      ),
                      new Container(
                        width: (MediaQuery.of(context).size.width / 2) - 50,
                        child: new FlatButton(
                          child: new Text("FEMALE"),
                          color: femaleButtonColor,
                          textColor: femaleButtonTextColor,
                          onPressed: () {
                            setState(() {
                              _gender = "FEMALE";
                              femaleButtonColor = mainColor;
                              femaleButtonTextColor = Colors.white;
                              maleButtonColor = Colors.white;
                              maleButtonTextColor = Colors.black;
                            });
                            print(_gender);
                          },
                        ),
                      )
                    ],
                  ),
                  new Theme(
                    data: ThemeData(accentColor: accentColor, primaryColor: accentColor),
                    child: new TextField(
                      decoration: InputDecoration(
                          icon: new Icon(Icons.lock),
                          labelText: "Password",
                          hintText: "Enter a password"
                      ),
                      autocorrect: false,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.none,
                      obscureText: true,
                      onChanged: passwordField,
                    ),
                  ),
                  new Theme(
                    data: ThemeData(accentColor: accentColor, primaryColor: accentColor),
                    child: new TextField(
                      decoration: InputDecoration(
                          icon: new Icon(Icons.lock),
                          labelText: "Confirm Password",
                          hintText: "Confirm your password"
                      ),
                      autocorrect: false,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.none,
                      obscureText: true,
                      onChanged: confirmField,
                    ),
                  ),
                  new Padding(padding: EdgeInsets.all(16.0)),
                  loginWidget,
                  new Padding(padding: EdgeInsets.all(8.0)),
                  new FlatButton(
                    child: new Text(
                      "Already have an account?",
                      style: TextStyle(
                        color: mainColor,
                      ),
                    ),
                    splashColor: mainColor,
                    onPressed: () {
                      router.navigateTo(context,'/login', transition: TransitionType.fadeIn, clearStack: true);
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