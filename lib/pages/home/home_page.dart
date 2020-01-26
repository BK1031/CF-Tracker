import 'dart:convert';
import 'package:cf_tracker/utils/config.dart';
import 'package:cf_tracker/utils/theme.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../user_info.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        new CupertinoSliverNavigationBar(
          backgroundColor: mainColor,
          largeTitle: new Text("Home", style: TextStyle(color: Colors.white),),
          actionsForegroundColor: Colors.white,
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            new Container(
              padding: EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    flex: 5,
                    child: new Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                      color: currCardColor,
                      elevation: 6.0,
                      child: new InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        onTap: () {
                          router.navigateTo(context, '/attendance', transition: TransitionType.cupertino);
                        },
                        child: new Container(
                          height: 100,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  new Padding(padding: EdgeInsets.all(4.0)),
                  new Expanded(
                    flex: 3,
                    child: new Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                      color: currCardColor,
                      elevation: 6.0,
                      child: new InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        onTap: () {
                        },
                        child: new Container(
                          height: 100,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new Text(
                                "0",
                                style: TextStyle(fontSize: 35.0, color: darkMode ? Colors.grey : Colors.black54),
                              ),
                              new Text(
                                "Announcements",
                                style: TextStyle(fontSize: 13.0, color: currTextColor),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
