import 'dart:io';

import 'package:cf_tracker/utils/blinking_text.dart';
import 'package:cf_tracker/utils/config.dart';
import 'package:cf_tracker/utils/theme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../user_info.dart';

class TrackStoolPage extends StatefulWidget {
  @override
  _TrackStoolPageState createState() => _TrackStoolPageState();
}

class _TrackStoolPageState extends State<TrackStoolPage> {

  double rating = 0;
  int change = 0;

  Widget responseWidget;

  _TrackStoolPageState() {
    responseWidget = new Container();
  }

  @override
  void initState() {
    super.initState();
    FirebaseDatabase.instance.reference().child("endDayTests").child(currUser.id).onChildChanged.listen((Event event) {
      print(event.snapshot.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new CupertinoNavigationBar(
        middle: new Text("Track Stools", style: TextStyle(color: Colors.white)),
        previousPageTitle: "Home",
        actionsForegroundColor: Colors.white,
        backgroundColor: mainColor,
      ),
      backgroundColor: currBackgroundColor,
      body: new SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: new Column(
          children: <Widget>[
            new Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
              color: currCardColor,
              elevation: 6.0,
              child: new Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8.0),
                  child: new Column(
                    children: <Widget>[
                      new ListTile(
                        title: new Text("Enzymes Count For Today"),
                        trailing: new Text("8", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                      ),
                    ],
                  )
              ),
            ),
            new Padding(padding: EdgeInsets.all(4.0)),
            new Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
              color: currCardColor,
              elevation: 6.0,
              child: new Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.all(16.0),
                        child: new Text("Stool Rating", style: TextStyle(color: mainColor, fontWeight: FontWeight.bold, fontFamily: "Product Sans"),),
                      ),
                      new ListTile(
                        title: new Text("How would you rate your stools for today?\n\n(0 – Greasy, 5 – Good, 10 – Constipated"),
                      ),
                      new Padding(padding: EdgeInsets.all(8.0)),
                      new Center(
                        child: new Text(
                          rating.toInt().toString(),
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                        ),
                      ),
                      new Slider.adaptive(
                        onChanged: (value) {
                          setState(() {
                            rating = value;
                          });
                        },
                        value: rating,
                        min: 0,
                        max: 10,
                        divisions: 10,
                      )
                    ],
                  )
              ),
            ),
            new Padding(padding: EdgeInsets.all(4.0)),
            new Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
              color: currCardColor,
              elevation: 6.0,
              child: new Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.all(16.0),
                        child: new Text("Other Details", style: TextStyle(color: mainColor, fontWeight: FontWeight.bold, fontFamily: "Product Sans"),),
                      ),
                      new Theme(
                        data: ThemeData(accentColor: accentColor, primaryColor: accentColor),
                        child: new TextField(
                          decoration: InputDecoration(
                              icon: new Icon(Icons.directions_walk),
                              labelText: "Exercise",
                              hintText: "Enter your exercise minutes for today"
                          ),
                          autocorrect: false,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      new Theme(
                        data: ThemeData(accentColor: accentColor, primaryColor: accentColor),
                        child: new TextField(
                          decoration: InputDecoration(
                              icon: new Icon(Icons.format_color_fill),
                              labelText: "Water",
                              hintText: "Enter your water oz intake for today"
                          ),
                          autocorrect: false,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  )
              ),
            ),
            new Padding(padding: EdgeInsets.all(8.0)),
            new Container(
              height: 50.0,
              width: double.infinity,
              child: new CupertinoButton(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                child: new Text("Calculate"),
                color: mainColor,
                onPressed: () async {
                  FirebaseDatabase.instance.reference().child("endDayTests").child(currUser.id).set({
                    "Enzyme_Difference": 8 - 10,
                    "Oz_of_Water": 43,
                    "Exercise_Length": 45,
                    "Stool_Rating": (rating - 5) / 5
                  });
                  setState(() {
                    responseWidget = Container(height: 35.0, child: CircularProgressIndicator());
                  });
                  await Future.delayed(const Duration(seconds: 5));
                  FirebaseDatabase.instance.reference().child("endDayTests").child(currUser.id).onChildAdded.listen((Event event) {
                    print(event.snapshot.value);
                    if (event.snapshot.value == 1) {
                      setState(() {
                        responseWidget = new Text("You need to take more enzymes");
                      });
                    }
                    else {
                      setState(() {
                        responseWidget = new Text("You need to take more enzymes");
                      });
                    }
                  });
                },
              ),
            ),
            responseWidget
          ],
        ),
      ),
    );
  }
}
