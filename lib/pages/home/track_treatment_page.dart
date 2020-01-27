import 'dart:async';

import 'package:cf_tracker/user_info.dart';
import 'package:cf_tracker/utils/blinking_text.dart';
import 'package:cf_tracker/utils/config.dart';
import 'package:cf_tracker/utils/theme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrackTreatmentPage extends StatefulWidget {
  @override
  _TrackTreatmentPageState createState() => _TrackTreatmentPageState();
}

class _TrackTreatmentPageState extends State<TrackTreatmentPage> {

  DateTime treatmentStart = new DateTime.now();

  Stopwatch stopwatch = new Stopwatch();
  Stopwatch vest = new Stopwatch();
  Stopwatch t1 = new Stopwatch();
  Stopwatch t2 = new Stopwatch();
  Stopwatch t3 = new Stopwatch();

  String title = "Track Treatment";

  bool vestDone = false;
  bool t1Done = false;
  bool t2Done = false;
  bool t3Done = false;

  bool treatmentDone = false;

  void getTimer(Timer timer) {
    if (stopwatch.isRunning) {
      print(stopwatch.elapsed.inSeconds);
      setState(() {
        if (vest.isRunning && vest.elapsedMilliseconds >= 30000) {
          vestDone = true;
        }
        if (t1.isRunning && t1.elapsedMilliseconds >= 10000) {
          // First nebulizer done
          t1Done = true;
        }
        if (t2.isRunning && t2.elapsedMilliseconds >= 10000) {
          // second done
          t2Done = true;
        }
        if (t3.isRunning && t3.elapsedMilliseconds >= 10000) {
          // second done
          t3Done = true;
        }
      });
    }
  }

  void swap(int t) {
    setState(() {
      if (t == 1) {
        // Swap to second
        t1Done = false;
        t1.stop();
        t2.start();
        print("FINISHED T1");
        print(t1.elapsed.toString());
      }
      else if (t == 2) {
        // Swap to third
        t2Done = false;
        t2.stop();
        t3.start();
        print("FINISHED T2");
        print(t2.elapsed.toString());
      }
      else if (t == 3) {
        t3Done = false;
        t3.stop();
        print("FINISHED T3");
        print(t3.elapsed.toString());
        if (!vest.isRunning) {
          // Doen with everything
          stopwatch.stop();
          treatmentDone = true;
          print("FINISHED EVERYTHING");
          print(stopwatch.elapsed.toString());
        }
      }
      else if (t == 4) {
        vestDone = false;
        vest.stop();
        print("FINISHED VES");
        print(vest.elapsed.toString());
        if (!t3.isRunning) {
          // Doen with everything
          stopwatch.stop();
          treatmentDone = true;
          print("FINISHED EVERYTHING");
          print(stopwatch.elapsed.toString());
        }
      }
    });
  }

  void finish() {
    FirebaseDatabase.instance.reference().child("users").child(currUser.id).child("treatments").push().set({
      "treatment_start": treatmentStart.toString(),
      "vest": vest.elapsedMilliseconds,
      "t1": t1.elapsedMilliseconds,
      "t2": t2.elapsedMilliseconds,
      "t3": t3.elapsedMilliseconds,
      "treatment_end": DateTime.now().toString()
    });
    router.pop(context);
  }

  @override
  void initState() {
    super.initState();
    stopwatch.reset();
    vest.reset();
    t1.reset();
    t2.reset();
    t3.reset();
    stopwatch.start();
    vest.start();
    t1.start();
    new Timer.periodic(new Duration(milliseconds: 500), getTimer);
  }

  @override
  void dispose() {
    stopwatch.stop();
    vest.stop();
    t1.stop();
    t2.stop();
    t3.stop();
    stopwatch.reset();
    vest.reset();
    t1.reset();
    t2.reset();
    t3.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new CupertinoNavigationBar(
        middle: new Text("Track Treatment", style: TextStyle(color: Colors.white)),
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
              color: mainColor,
              elevation: 6.0,
              child: new AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: vestDone ? 200 : 75,
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Text(
                          "${vest.elapsed.inMinutes.remainder(60)}m ${(vest.elapsed.inSeconds.remainder(60))}s",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 35.0
                          ),
                        ),
                        new Text(
                          "Vest",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w200,
                              fontSize: 35.0
                          ),
                        )
                      ],
                    ),
                    new Visibility(
                      visible: vestDone,
                      child: new Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            new BlinkingText(
                              "Finished Vest!",
                              TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35
                              ),
                            ),
                            new Padding(padding: EdgeInsets.all(8.0)),
                            Container(
                              width: double.infinity,
                              child: new CupertinoButton(
                                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                                child: new Text("DONE"),
                                color: accentColor,
                                onPressed: () {
                                  swap(4);
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            new Padding(padding: EdgeInsets.all(4.0)),
            new Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
              color: currCardColor,
              elevation: 6.0,
              child: new Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.all(8.0),
                      child: new Text("Nebulizer", style: TextStyle(color: currTextColor, fontWeight: FontWeight.bold, fontFamily: "Product Sans"),),
                    ),
                    new ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      child: new AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: t1Done ? 200 : 65,
                        color: t1.isRunning ? accentColor : currCardColor,
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Text(
                                  "${t1.elapsed.inMinutes.remainder(60)}m ${(t1.elapsed.inSeconds.remainder(60))}s",
                                  style: TextStyle(
                                      color: t1.isRunning ? Colors.white : currTextColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 35.0
                                  ),
                                ),
                                new Text(
                                  "Albuterol",
                                  style: TextStyle(
                                      color: t1.isRunning ? Colors.white : currTextColor,
                                      fontWeight: FontWeight.w200,
                                      fontSize: 35.0
                                  ),
                                )
                              ],
                            ),
                            new Visibility(
                              visible: t1Done,
                              child: new Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    new BlinkingText(
                                      "Time to Swap",
                                      TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 35
                                      ),
                                    ),
                                    new Padding(padding: EdgeInsets.all(8.0)),
                                    Container(
                                      width: double.infinity,
                                      child: new CupertinoButton(
                                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                                        child: new Text("SWAP"),
                                        color: mainColor,
                                        onPressed: () {
                                          swap(1);
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    new Padding(padding: EdgeInsets.all(4.0)),
                    new ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      child: new AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: t2Done ? 200 : 65,
                        color: t2.isRunning ? accentColor : currCardColor,
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Text(
                                  "${t2.elapsed.inMinutes.remainder(60)}m ${(t2.elapsed.inSeconds.remainder(60))}s",
                                  style: TextStyle(
                                      color: t2.isRunning ? Colors.white : currTextColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 35.0
                                  ),
                                ),
                                new Text(
                                  "Hptn Saline",
                                  style: TextStyle(
                                      color: t2.isRunning ? Colors.white : currTextColor,
                                      fontWeight: FontWeight.w200,
                                      fontSize: 35.0
                                  ),
                                )
                              ],
                            ),
                            new Visibility(
                              visible: t2Done,
                              child: new Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    new BlinkingText(
                                      "Time to Swap",
                                      TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 35
                                      ),
                                    ),
                                    new Padding(padding: EdgeInsets.all(8.0)),
                                    Container(
                                      width: double.infinity,
                                      child: new CupertinoButton(
                                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                                        child: new Text("SWAP"),
                                        color: mainColor,
                                        onPressed: () {
                                          swap(2);
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    new Padding(padding: EdgeInsets.all(4.0)),
                    new ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      child: new AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: t3Done ? 200 : 65,
                        color: t3.isRunning ? accentColor : currCardColor,
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Text(
                                  "${t3.elapsed.inMinutes.remainder(60)}m ${(t3.elapsed.inSeconds.remainder(60))}s",
                                  style: TextStyle(
                                      color: t3.isRunning ? Colors.white : currTextColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 35.0
                                  ),
                                ),
                                new Text(
                                  "Pulmozyme",
                                  style: TextStyle(
                                      color: t3.isRunning ? Colors.white : currTextColor,
                                      fontWeight: FontWeight.w200,
                                      fontSize: 35.0
                                  ),
                                )
                              ],
                            ),
                            new Visibility(
                              visible: t3Done,
                              child: new Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    new BlinkingText(
                                      "Finished!",
                                      TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 35
                                      ),
                                    ),
                                    new Padding(padding: EdgeInsets.all(8.0)),
                                    Container(
                                      width: double.infinity,
                                      child: new CupertinoButton(
                                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                                        child: new Text("DONE"),
                                        color: mainColor,
                                        onPressed: () {
                                          swap(3);
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            new Padding(padding: EdgeInsets.all(4.0)),
            new Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
              color: accentColor,
              elevation: 6.0,
              child: new AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: treatmentDone ? 200 : 0,
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Text(
                          "${stopwatch.elapsed.inMinutes.remainder(60)}m ${(stopwatch.elapsed.inSeconds.remainder(60))}s",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 35.0
                          ),
                        ),
                        new Text(
                          "Total Time",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w200,
                              fontSize: 35.0
                          ),
                        )
                      ],
                    ),
                    new Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          new BlinkingText(
                            "Finished Treatment!",
                            TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 30
                            ),
                          ),
                          new Padding(padding: EdgeInsets.all(8.0)),
                          Container(
                            width: double.infinity,
                            child: new CupertinoButton(
                              borderRadius: BorderRadius.all(Radius.circular(16.0)),
                              child: new Text("DONE"),
                              color: mainColor,
                              onPressed: () {
                                finish();
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
