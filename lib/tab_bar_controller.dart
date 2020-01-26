import 'dart:io';
import 'package:cf_tracker/pages/home/home_page.dart';
import 'package:cf_tracker/pages/settings/settings_page.dart';
import 'package:cf_tracker/user_info.dart';
import 'package:cf_tracker/utils/theme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabBarController extends StatefulWidget {
  @override
  _TabBarControllerState createState() => _TabBarControllerState();
}

class _TabBarControllerState extends State<TabBarController> {

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final databaseRef = FirebaseDatabase.instance.reference();

  int currTab = 0;
  Widget _homeBody = new HomePage();
  Widget _settingsBody = new SettingsPage();
  Widget body;

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings)
    {
      print("Settings registered: $settings");
    });
  }

  void onTabTapped(int index) {
    setState(() {
      currTab = index;
      if (currTab == 0) {
        body = _homeBody;
      }
      else if (currTab == 1) {
        body = _settingsBody;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    firebaseCloudMessaging_Listeners();
    _firebaseMessaging.subscribeToTopic("ALL_DEVICES");
    _firebaseMessaging.subscribeToTopic(currUser.id);
    databaseRef.child("users").child(currUser.id).child("fcm").set(_firebaseMessaging.getToken());
    onTabTapped(0);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: currBackgroundColor,
      body: body,
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: currTab,
        backgroundColor: currCardColor,
        fixedColor: mainColor,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        unselectedItemColor: darkMode ? Colors.grey : Colors.black54,
        onTap: onTabTapped,
        items: <BottomNavigationBarItem>[
          new BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text("Home")
          ),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.settings),
              title: new Text("Settings")
          ),
        ],
      ),
    );
  }
}
