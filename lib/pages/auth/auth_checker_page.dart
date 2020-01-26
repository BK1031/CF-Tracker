import 'package:cf_tracker/utils/config.dart';
import 'package:cf_tracker/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../user_info.dart';

class AuthCheckerPage extends StatefulWidget {
  @override
  _AuthCheckerPageState createState() => _AuthCheckerPageState();
}

class _AuthCheckerPageState extends State<AuthCheckerPage> {

  Future<void> checkAuth() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("darkMode")) {
      prefs.setBool("darkMode", darkMode);
    }
    darkMode = prefs.getBool("darkMode");
    if (darkMode) {
      setState(() {
        currBackgroundColor = darkBackgroundColor;
        currCardColor = darkCardColor;
        currDividerColor = darkDividerColor;
        currTextColor = darkTextColor;
      });
    }
    else {
      setState(() {
        currBackgroundColor = lightBackgroundColor;
        currCardColor = lightCardColor;
        currDividerColor = lightDividerColor;
        currTextColor = lightTextColor;
      });
    }
    if (user != null) {
      // User logged
      print("User logged!");
      print(user.uid);
      currUser.id = user.uid;
      await FirebaseDatabase.instance.reference().child("users").child(currUser.id).once().then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          var userInfo = snapshot.value;
          currUser.email = userInfo["email"];
          currUser.firstName = userInfo["firstName"];
          currUser.lastName = userInfo["lastName"];
          currUser.gender = userInfo["gender"];
          print("");
          print("------------ USER DEBUG INFO ------------");
          print("NAME: ${currUser.firstName} ${currUser.lastName}");
          print("EMAIL: ${currUser.email}");
          print("-----------------------------------------");
          print("");
          router.navigateTo(context, '/home', replace: true, transition: TransitionType.fadeIn);
        }
        else {
          FirebaseAuth.instance.signOut();
          router.navigateTo(context, '/register', replace: true, transition: TransitionType.fadeIn);
        }
      });
    }
    else {
      router.navigateTo(context, '/register', replace: true, transition: TransitionType.fadeIn);
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseDatabase.instance.reference().child("testing").push().set("Hello world");
    checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        color: currBackgroundColor,
        child: Center(
          child: new Text("Loading..."),
        ),
      ),
    );
  }
}
