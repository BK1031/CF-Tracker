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
                    child: new Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                      color: currCardColor,
                      elevation: 6.0,
                      child: new InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        onTap: () {
                          router.navigateTo(context, '/home/treatment', transition: TransitionType.native);
                        },
                        child: new Container(
                          height: 100,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new Image.network(
                                "https://cdn4.iconfinder.com/data/icons/general-health/24/respirator-512.png",
                                height: 35,
                                color: accentColor,
                              ),
                              new Text(
                                "Track Treatment",
                                style: TextStyle(fontSize: 13.0, color: currTextColor),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  new Padding(padding: EdgeInsets.all(4.0)),
                  new Expanded(
                    child: new Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                      color: currCardColor,
                      elevation: 6.0,
                      child: new InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        onTap: () {
                          router.navigateTo(context, '/home/stools', transition: TransitionType.native);
                        },
                        child: new Container(
                          height: 100,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new Image.network(
                                "http://cdn.shopify.com/s/files/1/1061/1924/products/Poop_Emoji_7b204f05-eec6-4496-91b1-351acc03d2c7_grande.png?v=1571606036",
                                height: 35,
                                color: accentColor,
                              ),
                              new Text(
                                "Track Stools",
                                style: TextStyle(fontSize: 13.0, color: currTextColor),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            new Container(
              padding: EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                      color: currCardColor,
                      elevation: 6.0,
                      child: new InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        onTap: () {
                          router.navigateTo(context, '/home/meal', transition: TransitionType.native);
                        },
                        child: new Container(
                          height: 100,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new Icon(
                                Icons.fastfood,
                                size: 35,
                                color: accentColor,
                              ),
                              new Text(
                                "Add Meal",
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
