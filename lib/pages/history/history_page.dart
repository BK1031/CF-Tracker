import 'dart:convert';
import 'package:cf_tracker/utils/config.dart';
import 'package:cf_tracker/utils/theme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';
import '../../user_info.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> with RouteAware {

  CalendarController _calendarController = CalendarController();
  Map<DateTime, List<dynamic>> events = new Map();
  List _selectedEvents = new List();

  getEvents() {
    setState(() {
      events[DateTime.now()] = [
        "Respiratory Treatment – 3:16 PM",
        "Breakfast – 4:44 PM",
        "Lunch – 3:49 PM",
        "Dinner – 5:11 PM"
      ];
    });
  }

  @override
  void initState() {
    super.initState();
    getEvents();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  Widget _buildEventList() {
    return Column(
      children: _selectedEvents
          .map((event) => Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.8),
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ListTile(
          title: Text(event.toString()),
          onTap: () => print('$event tapped!'),
        ),
      ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        new CupertinoSliverNavigationBar(
          backgroundColor: mainColor,
          largeTitle: new Text("History", style: TextStyle(color: Colors.white),),
          actionsForegroundColor: Colors.white,
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            new TableCalendar(
              calendarController: _calendarController,
              events: events,
              onDaySelected: _onDaySelected,
            ),
            _buildEventList(),
          ]),
        ),
      ],
    );
  }
}
